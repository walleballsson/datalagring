import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

//ready

public class lab3Main {
// connect to the database
    public static void main(String[] args) {
        // Load driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC driver loaded OK.");
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC driver not found on classpath.");
            return;
        }

        try (Scanner scanner = new Scanner(System.in)) {
            System.out.print("Enter database URL: ");
            String url = scanner.nextLine().trim();

            System.out.print("Enter database username: ");
            String user = scanner.nextLine().trim();

            System.out.print("Enter database password: ");
            String pass = scanner.nextLine().trim();

            try (Connection conn = DriverManager.getConnection(url, user, pass)) {
                conn.setAutoCommit(false);
                System.out.println("Connection OK.");

                menuLoop(conn, scanner);
            } catch (SQLException e) {
                System.out.println("Connection failed: " + e.getMessage());
            }
        }
    }
//print out the meinu and handle user choices
    private static void menuLoop(Connection conn, Scanner sc) {
        while (true) {
            System.out.println("\n=== MENU ===");
            System.out.println("Good Day Sar, what would you like to do today");
            System.out.println("1) Compute teaching cost (current year)");
            System.out.println("2) Increase students by 100 and recompute cost");
            System.out.println("3) Allocate / deallocate teaching load (4-instance rule)");
            System.out.println("4) Add \"Exercise\" activity and show its allocation");
            System.out.println("0) Nevermind i dont want to work today");
            System.out.print("Choice: ");

            String choice = sc.nextLine().trim();
            switch (choice) {
                case "1" -> computeTeachingCost(conn, sc);
                case "2" -> increaseStudentsAndRecompute(conn, sc);
                case "3" -> manageAllocation(conn, sc);
                case "4" -> addExerciseActivity(conn, sc);
                case "0" -> {
                    System.out.println("Bye Bye");
                    return;
                }
                default -> System.out.println("Sorry but me dont know what you want");
            }
        }
    }


// 1) Teaching cost

private static void computeTeachingCost(Connection conn, Scanner sc) {
    System.out.print("Enter course instance_id: ");
    String instanceId = sc.nextLine().trim();

    try {
        InstanceInfo info = fetchInstanceInfoForCurrentYear(conn, instanceId);
        if (info == null) {
            conn.rollback();
            System.out.println("No no no... that instance doesn't exist in the current year.");
            return;
        }

        double avgSalary = fetchAvgSalary(conn);
        double plannedCostKsek = (info.plannedHoursFactor * info.numStudents * avgSalary) / 1000.0;

        double actualCostKsek = fetchActualCostKsekForCurrentYear(conn, instanceId);

        conn.commit();

        System.out.println("\n--- Teaching cost ---");
        System.out.println("Course       : " + info.courseCode + " - " + info.courseName);
        System.out.println("Instance     : " + instanceId);
        System.out.println("Year/Period  : " + info.year + " / " + info.period);
        System.out.println("Students     : " + info.numStudents);
        System.out.printf("Planned cost : %.1f KSEK%n", plannedCostKsek);
        System.out.printf("Actual cost  : %.1f KSEK%n", actualCostKsek);

    } catch (SQLException e) {
        try { conn.rollback(); } catch (SQLException ignore) {}
        System.out.println("Error: " + e.getMessage());
    }
}

private static InstanceInfo fetchInstanceInfoForCurrentYear(Connection conn, String instanceId) throws SQLException {
    final String infoSql =
        "SELECT cl.course_code, cl.course_name, ci.study_year, ci.study_period, ci.num_students, " +
        "       IFNULL(SUM(pa.planned_hours * ta.factor), 0) AS phf " +
        "FROM course_instance ci " +
        "JOIN course_layout cl ON ci.course_id = cl.course_id " +
        "LEFT JOIN planned_activity pa ON pa.instance_id = ci.instance_id " +
        "LEFT JOIN teaching_activity ta ON ta.activity_id = pa.activity_id " +
        "WHERE ci.instance_id = ? AND ci.study_year = 2025 " +   
        "GROUP BY cl.course_code, cl.course_name, ci.study_year, ci.study_period, ci.num_students";

    try (PreparedStatement ps = conn.prepareStatement(infoSql)) {
        ps.setString(1, instanceId);

        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) return null;

            InstanceInfo info = new InstanceInfo();
            info.courseCode = rs.getString("course_code");
            info.courseName = rs.getString("course_name");
            info.year = rs.getInt("study_year");
            info.period = rs.getString("study_period");
            info.numStudents = rs.getInt("num_students");
            info.plannedHoursFactor = rs.getDouble("phf");
            return info;
        }
    }
}

private static double fetchAvgSalary(Connection conn) throws SQLException {
    double avgSalary = 0;

    try (PreparedStatement ps = conn.prepareStatement("SELECT AVG(salary_hour) AS avg_sal FROM salary");
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) avgSalary = rs.getDouble("avg_sal");
    }

    return avgSalary;
}

private static double fetchActualCostKsekForCurrentYear(Connection conn, String instanceId) throws SQLException {
    final String actualSql =
        "SELECT IFNULL(SUM(w.work_hours * s.salary_hour), 0) AS ac " +
        "FROM workload w " +
        "JOIN salary s ON s.employee_id = w.employee_id " +
        "JOIN planned_activity pa ON w.planned_activity_id = pa.planned_activity_id " +
        "JOIN course_instance ci ON pa.instance_id = ci.instance_id " +
        "WHERE ci.instance_id = ? AND ci.study_year = 2025";      

    double ksek = 0;

    try (PreparedStatement ps = conn.prepareStatement(actualSql)) {
        ps.setString(1, instanceId);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) ksek = rs.getDouble("ac") / 1000.0;
        }
    }

    return ksek;
}

private static class InstanceInfo {
    String courseCode;
    String courseName;
    String period;
    int year;
    int numStudents;
    double plannedHoursFactor;
}


// 2) +100 students and recompute

private static void increaseStudentsAndRecompute(Connection conn, Scanner sc) {
    System.out.print("Enter course instance_id to modify: ");
    String instanceId = sc.nextLine().trim();

    try {
        int current = lockAndReadNumStudents(conn, instanceId);
        if (current < 0) {
            conn.rollback();
            System.out.println("Instance not found.");
            return;
        }

        updateNumStudents(conn, instanceId, current + 100);

        conn.commit();
        System.out.println("num_students updated from " + current + " to " + (current + 100));

        // run the same calc again
        computeTeachingCost(conn, sc);

    } catch (SQLException e) {
        try { conn.rollback(); } catch (SQLException ignore) {}
        System.out.println("Error: " + e.getMessage());
    }
}

private static int lockAndReadNumStudents(Connection conn, String instanceId) throws SQLException {
    final String sql =
        "SELECT num_students FROM course_instance " +
        "WHERE instance_id = ? FOR UPDATE";

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, instanceId);

        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) return -1;
            return rs.getInt("num_students");
        }
    }
}

private static void updateNumStudents(Connection conn, String instanceId, int newValue) throws SQLException {
    try (PreparedStatement ps = conn.prepareStatement(
            "UPDATE course_instance SET num_students = ? WHERE instance_id = ?")) {
        ps.setInt(1, newValue);
        ps.setString(2, instanceId);
        ps.executeUpdate();
    }
}


// 3) Allocate / deallocate (max 4 instances per period)

private static void manageAllocation(Connection conn, Scanner sc) {
    System.out.println("\nA) Allocate");
    System.out.println("D) Deallocate");
    System.out.print("Choice (A/D): ");
    String c = sc.nextLine().trim().toUpperCase();

    if ("A".equals(c)) allocate(conn, sc);
    else if ("D".equals(c)) deallocate(conn, sc);
    else System.out.println("Cancelled.");
}

private static void allocate(Connection conn, Scanner sc) {
    System.out.print("Employee ID: ");
    String employeeId = sc.nextLine().trim();

    System.out.print("Planned activity ID: ");
    String plannedActivityId = sc.nextLine().trim();

    System.out.print("Work hours: ");
    double hours = Double.parseDouble(sc.nextLine().trim());

    try {
        InstanceAndPeriod ip = findInstanceAndPeriod(conn, plannedActivityId);
        if (ip == null) {
            conn.rollback();
            System.out.println("Planned activity not found.");
            return;
        }

        // read the rule from the database (instead of hardcoding 4)
        int maxAllowed = fetchMaxInstancesPerPeriod(conn);

        // check the rule (FOR UPDATE so it’s safe)
        int effective = effectiveInstancesForEmployeeInPeriod(conn, employeeId, ip.period, ip.instanceId);
        if (effective > maxAllowed) {
            conn.rollback();
            System.out.println("ERROR: Teacher would exceed " + maxAllowed +
                               " course instances in period " + ip.period);
            return;
        }

        // upsert workload row (same behavior as your ON DUPLICATE KEY idea)
        upsertWorkload(conn, employeeId, plannedActivityId, hours);

        conn.commit();
        System.out.println("Allocation created for employee " + employeeId +
                           " on instance " + ip.instanceId + " in period " + ip.period);

    } catch (SQLException e) {
        try { conn.rollback(); } catch (SQLException ignore) {}
        System.out.println("Error: " + e.getMessage());
    }
}

private static class InstanceAndPeriod {
    String instanceId;
    String period;
}

private static InstanceAndPeriod findInstanceAndPeriod(Connection conn, String plannedActivityId) throws SQLException {
    final String sql =
        "SELECT ci.instance_id, ci.study_period " +
        "FROM planned_activity pa " +
        "JOIN course_instance ci ON pa.instance_id = ci.instance_id " +
        "WHERE pa.planned_activity_id = ?";

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, plannedActivityId);

        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) return null;

            InstanceAndPeriod out = new InstanceAndPeriod();
            out.instanceId = rs.getString("instance_id");
            out.period = rs.getString("study_period");
            return out;
        }
    }
}

private static int effectiveInstancesForEmployeeInPeriod(Connection conn, String employeeId, String period, String targetInstanceId)
        throws SQLException {

    int totalInstances = 0;
    int inThisInstance = 0;

    final String countSql =
        "SELECT COUNT(DISTINCT ci.instance_id) AS total_instances, " +
        "       SUM(CASE WHEN ci.instance_id = ? THEN 1 ELSE 0 END) AS in_this " +
        "FROM workload w " +
        "JOIN planned_activity pa ON w.planned_activity_id = pa.planned_activity_id " +
        "JOIN course_instance ci ON pa.instance_id = ci.instance_id " +
        "WHERE w.employee_id = ? AND ci.study_period = ? " +
        "FOR UPDATE";

    try (PreparedStatement ps = conn.prepareStatement(countSql)) {
        ps.setString(1, targetInstanceId);
        ps.setString(2, employeeId);
        ps.setString(3, period);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                totalInstances = rs.getInt("total_instances");
                inThisInstance = rs.getInt("in_this");
            }
        }
    }

    return totalInstances + (inThisInstance > 0 ? 0 : 1);
}
// 4 instance rule
private static int fetchMaxInstancesPerPeriod(Connection conn) throws SQLException {
    final String sql =
        "SELECT int_value FROM rule_config WHERE rule_key = 'MAX_INSTANCES_PER_PERIOD'";

    try (PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (!rs.next()) {
            throw new SQLException("Missing rule_config entry: MAX_INSTANCES_PER_PERIOD");
        }
        return rs.getInt("int_value");
    }
}

private static void upsertWorkload(Connection conn, String employeeId, String plannedActivityId, double hours) throws SQLException {
    try (PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO workload (employee_id, planned_activity_id, work_hours) " +
            "VALUES (?, ?, ?) " +
            "ON DUPLICATE KEY UPDATE work_hours = VALUES(work_hours)")) {
        ps.setString(1, employeeId);
        ps.setString(2, plannedActivityId);
        ps.setDouble(3, hours);
        ps.executeUpdate();
    }
}

private static void deallocate(Connection conn, Scanner sc) {
    System.out.print("Employee ID: ");
    String employeeId = sc.nextLine().trim();

    System.out.print("Planned activity ID to deallocate: ");
    String plannedActivityId = sc.nextLine().trim();

    try {
        int rows;

        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM workload WHERE employee_id = ? AND planned_activity_id = ?")) {
            ps.setString(1, employeeId);
            ps.setString(2, plannedActivityId);
            rows = ps.executeUpdate();
        }

        conn.commit();
        System.out.println("Rows deallocated: " + rows);

    } catch (SQLException e) {
        try { conn.rollback(); } catch (SQLException ignore) {}
        System.out.println("Error: " + e.getMessage());
    }
}



// 4) Add Exercise activity + allocate teacher + show it

private static void addExerciseActivity(Connection conn, Scanner sc) {
    try {
        String exerciseId = getOrCreateExerciseActivity(conn, sc);

        System.out.print("Enter planned_activity_id for this Exercise (new id): ");
        String plannedActivityId = sc.nextLine().trim();

        System.out.print("Enter course instance_id to attach Exercise to: ");
        String instanceId = sc.nextLine().trim();

        System.out.print("Enter employee_id (teacher) to allocate: ");
        String employeeId = sc.nextLine().trim();

        System.out.print("Enter planned hours for Exercise: ");
        double plannedHours = Double.parseDouble(sc.nextLine().trim());

        System.out.print("Enter work hours to allocate now: ");
        double workHours = Double.parseDouble(sc.nextLine().trim());

        // insert planned_activity 
        try (PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO planned_activity " +
            "(planned_activity_id, planned_hours, activity_id, instance_id) " +
            "VALUES (?, ?, ?, ?)")) {
        ps.setString(1, plannedActivityId);
        ps.setDouble(2, plannedHours);
        ps.setString(3, exerciseId);
        ps.setString(4, instanceId);
        ps.executeUpdate();
        }


        // insert workload allocation
        try (PreparedStatement ps = conn.prepareStatement(
                 "INSERT INTO workload (employee_id, planned_activity_id, work_hours) " +
                 "VALUES (?, ?, ?)")) {
            ps.setString(1, employeeId);
            ps.setString(2, plannedActivityId);
            ps.setDouble(3, workHours);
            ps.executeUpdate();
        }

        conn.commit();
        System.out.println("Exercise activity added and teacher allocated.");

        // show it
        System.out.println("\nExercise allocations for employee " + employeeId + ":");
        System.out.println("CourseCode | InstanceID | Period | Activity | PlannedH | WorkH");

        final String showSql =
            "SELECT cl.course_code, ci.instance_id, ci.study_period, " +
            "       ta.activity_name, pa.planned_hours, w.work_hours " +
            "FROM workload w " +
            "JOIN planned_activity pa ON w.planned_activity_id = pa.planned_activity_id " +
            "JOIN teaching_activity ta ON pa.activity_id = ta.activity_id " +
            "JOIN course_instance ci ON pa.instance_id = ci.instance_id " +
            "JOIN course_layout cl ON ci.course_id = cl.course_id " +
            "WHERE ta.activity_name = 'Exercise' AND w.employee_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(showSql)) {
            ps.setString(1, employeeId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    System.out.printf("%-10s | %-10s | %-6s | %-8s | %-8.1f | %-5.1f%n",
                            rs.getString("course_code"),
                            rs.getString("instance_id"),
                            rs.getString("study_period"),
                            rs.getString("activity_name"),
                            rs.getDouble("planned_hours"),
                            rs.getDouble("work_hours"));
                }
            }
        }

    } catch (SQLException e) {
        try { conn.rollback(); } catch (SQLException ignore) {}
        System.out.println("Error: " + e.getMessage());
    }
}

private static String getOrCreateExerciseActivity(Connection conn, Scanner sc) throws SQLException {
    String exerciseId = null;

    try (PreparedStatement ps = conn.prepareStatement(
            "SELECT activity_id FROM teaching_activity WHERE activity_name = 'Exercise'")) {
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) exerciseId = rs.getString("activity_id");
        }
    }

    if (exerciseId != null) return exerciseId;

    // create it if it doesn't exist
    System.out.print("Enter new activity_id (max 10 chars) for 'Exercise': ");
    exerciseId = sc.nextLine().trim();

    try (PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO teaching_activity (activity_id, activity_name, factor) " +
            "VALUES (?, 'Exercise', 1.00)")) {
        ps.setString(1, exerciseId);
        ps.executeUpdate();
    }

    System.out.println("Teaching activity 'Exercise' created with id " + exerciseId);
    return exerciseId;
}
}
