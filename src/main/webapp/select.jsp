<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="io.sookmyung.dbprog.DBConnection" %>
<%
    String title;
    if (session.getAttribute("identity") == "student") {
        title = "수강 신청 조회";
    } else {
        title = "개설 강의 조회";
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title><%=title%></title>

    <!-- tailwind -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.css" rel="stylesheet"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.js"></script>

</head>
<body>
<%@ include file="top.jsp" %>
<br>
<div class="p-4 sm:ml-64">
    <%
        if (session_id != null) {
    %>
    <%
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("SQLException: " + e.getMessage());
        }
    %>
    <%
        CallableStatement cstmt = null;
        Statement stmt, stmt1;
        ResultSet rs, rs1;

        int s_id = 0, p_id = 0;
        if (session_identity == "student")
            s_id = session_id;
        else
            p_id = session_id;

        String qYear = null;
        String qSemester = null;
    %>
    <%
        int eYear = 0, eSemester = 0, enrollCount = 0, enrollUnit = 0, courseCount = 0;
        try {
            String queryEnrollYear = "{? = call Date2EnrollYear(SYSDATE)}";
            cstmt = conn.prepareCall(queryEnrollYear);
            cstmt.registerOutParameter(1, Types.INTEGER);
            cstmt.execute();
            eYear = cstmt.getInt(1);
            String queryEnrollSemester = "{? = call Date2EnrollSemester(SYSDATE)}";
            cstmt = conn.prepareCall(queryEnrollSemester);
            cstmt.registerOutParameter(1, Types.INTEGER);
            cstmt.execute();
            eSemester = cstmt.getInt(1);

            qYear = request.getParameter("table_year");
            if (qYear != null) eYear = Integer.parseInt(qYear);
            qSemester = request.getParameter("table_semester");
            if (qSemester != null) eSemester = Integer.parseInt(qSemester);

            String queryTotalEnrollCount = "{? = call totalEnrollCount(?)}";
            cstmt = conn.prepareCall(queryTotalEnrollCount);
            cstmt.registerOutParameter(1, Types.INTEGER);
            cstmt.setInt(2, s_id);
            cstmt.execute();
            enrollCount = cstmt.getInt(1);
            String queryTotalEnrollUnit = "{? = call totalEnrollUnit(?)}";
            cstmt = conn.prepareCall(queryTotalEnrollUnit);
            cstmt.registerOutParameter(1, Types.INTEGER);
            cstmt.setInt(2, s_id);
            cstmt.execute();
            enrollUnit = cstmt.getInt(1);

            String queryCntCourse = "select count(*) cnt from teach where p_id=" + p_id + " and t_year=" + eYear + " and t_semester=" + eSemester;
            stmt1 = conn.createStatement();
            rs1 = stmt1.executeQuery(queryCntCourse);

            if (rs1 != null) {
                while (rs1.next()) {
                    courseCount = rs1.getInt("cnt");
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException: " + e.getMessage());
        }

    %>
    <div class="p-4 border-2 border-gray-200 border-dashed rounded-lg dark:border-gray-700 mt-14">
        <h2 class="text-4xl font-bold dark:text-white">
            <%=eYear%>년도 <%=eSemester%>학기 <%=title%>
        </h2>

        <br>
        <form method="post" action="select.jsp" method="get">
            <div class="flex">
                <div class="flex item-center mb-4 gap-2">
                    <input type="text" name="table_year"
                           class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                           value="<%=eYear%>" required>&nbsp;
                </div>
                <div class="flex item-center mb-4 gap-2">
                    년도
                </div>
                <div class="flex item-center mb-4 gap-2">
                    <input type="text" name="table_semester"
                           class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                           value="<%=eSemester%>" required>&nbsp;
                </div>
                <div class="flex item-center mb-4 gap-2">
                    학기
                </div>
                <div class="flex item-center mb-4 gap-2">
                    <input type="SUBMIT" value="조회"
                           class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
                </div>
            </div>
        </form>

        <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
            <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
            <tr>
                <th scope="col" class="px-6 py-3">과목번호</th>
                <th scope="col" class="px-6 py-3">분반</th>
                <th scope="col" class="px-6 py-3">과목명</th>
                <%if (session_identity == "student") {%>
                <th scope="col" class="px-6 py-3">주관학과</th>
                <%} %>
                <th scope="col" class="px-6 py-3">강의시간</th>
                <th scope="col" class="px-6 py-3">강의실</th>
                <%if (session_identity == "student") {%>
                <th scope="col" class="px-6 py-3">담당교수</th>
                <%} %>
                <th scope="col" class="px-6 py-3">학점</th>
                <th scope="col" class="px-6 py-3">정원</th>
                <th scope="col" class="px-6 py-3">신청</th>
                <%if (session_identity == "student") {%>
                <th scope="col" class="px-6 py-3">여석</th>
                <%} %>
            </tr>
            </thead>
            <%
                String query = "";
                if (session_identity == "student") {
                    query = "select vt.t_start, vt.t_end, " +
                            "t.t_id, t.t_no, t.t_day, t.t_room, t.t_max, " +
                            "c.c_name, c.c_id, c.c_unit, d.d_name,p.p_name,  " +
                            "(select count(*) from enroll ee where ee.t_id = t.t_id) t_count " +
                            "from vTeach vt " +
                            "join teach t on t.t_year = " + eYear + " and t.t_semester =  " + eSemester +
                            "and vt.t_id = t.t_id " +
                            "join course c on t.c_id = c.c_id " +
                            "join department d on c.d_id = d.d_id " +
                            "join professor p on t.p_id = p.p_id " +
                            "where t.t_id in (select t_id from enroll where s_id = " + s_id + ")";
                } else {
                    query = "select vt.t_start, vt.t_end, " +
                            "t.t_id, t.t_no, t.t_day, t.t_room, t.t_max, " +
                            "c.c_name, c.c_id, c.c_unit, " +
                            "(select count(*) from enroll ee where ee.t_id = t.t_id) t_count " +
                            "from vTeach vt " +
                            "join teach t on t.t_year = " + eYear + " and t.t_semester =  " + eSemester +
                            "and vt.t_id = t.t_id " +
                            "join course c on t.c_id = c.c_id " +
                            "join department d on c.d_id = d.d_id " +
                            "join professor p on t.p_id = p.p_id " +
                            "where p.p_id = " + p_id;
                }
                System.out.println("query = " + query);

                String c_name, d_name = "null", p_name = "null", t_day, t_room, endTime;
                int t_id, c_id, t_no, c_unit, t_max, t_count, t_remain = 0, hh, mm;
                float t_end;

                try {
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery(query);
                    if (rs != null) {
                        while (rs.next()) {
                            t_id = rs.getInt("t_id");
                            c_name = rs.getString("c_name");
                            t_room = rs.getString("t_room");
                            c_id = rs.getInt("c_id");
                            t_no = rs.getInt("t_no");
                            c_unit = rs.getInt("c_unit");
                            t_max = rs.getInt("t_max");
                            t_count = rs.getInt("t_count");
                            if (session_identity == "student") {
                                t_remain = t_max - t_count;
                                p_name = rs.getString("p_name");
                                d_name = rs.getString("d_name");
                            }
                            switch (rs.getInt("t_day")) {
                                case 1:
                                    t_day = "월요일";
                                    break;
                                case 2:
                                    t_day = "화요일";
                                    break;
                                case 3:
                                    t_day = "수요일";
                                    break;
                                case 4:
                                    t_day = "목요일";
                                    break;
                                case 5:
                                    t_day = "금요일";
                                    break;
                                case 6:
                                    t_day = "월,수";
                                    break;
                                case 7:
                                    t_day = "화,목";
                                    break;
                                case 8:
                                    t_day = "수,금";
                                    break;
                                default:
                                    t_day = "";
                                    break;
                            }
                            t_end = rs.getFloat("t_end");
                            hh = (int) t_end;
                            mm = (int) ((t_end - hh) * 60);
                            if (mm > 0) endTime = String.format("%02d:%02d", hh, mm);
                            else endTime = String.format("%02d:00", hh);
                            t_day += " " + rs.getInt("t_start") + ":00 ~ " + endTime;
            %>
            <tbody>
            <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
                <td class="px-6 py-4"><%=c_id%>
                </td>
                <td class="px-6 py-4"><%=t_no%>
                </td>
                <td class="px-6 py-4"><%=c_name%>
                </td>
                <%if (session_identity == "student") { %>
                <td class="px-6 py-4"><%=d_name%>
                </td>
                <%} %>
                <td class="px-6 py-4"><%=t_day%>
                </td>
                <td class="px-6 py-4"><%=t_room%>
                </td>
                <%if (session_identity == "student") { %>
                <td class="px-6 py-4"><%=p_name%>
                </td>
                <%} %>
                <td class="px-6 py-4"><%=c_unit%>
                </td>
                <td class="px-6 py-4"><%=t_max%>
                </td>
                <td class="px-6 py-4"><%=t_count%>
                </td>
                <%if (session_identity == "student") { %>
                <td class="px-6 py-4"><%=t_remain%>
                </td>
                <%} %>
            </tr>
            </tbody>

            <%
                        }
                    }

                    if (rs != null) rs.close();
                    if (cstmt != null) cstmt.close();
                    stmt.close();
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("SQLException: " + e.getMessage());
                }
            %>
        </table>
        <br>
        <%
            if (qYear == null && qSemester == null) {
        %>
        <table class="w-full border-b text-sm text-center text-gray-500 dark:text-gray-400">
            <tr class="border-b"></tr>
            <tr class="border-b">
                <%if (session_identity == "student") { %>
                <td class="bg-gray-50">과목 수</td>
                <td><%=enrollCount%>
                </td>
                <%} else { %>
                <td class="bg-gray-50">개설 과목 수</td>
                <td><%=courseCount%>
                </td>
                <%} %>
            </tr>
            <%if (session_identity == "student") { %>
            <tr class="border-b">
                <td class="bg-gray-50">신청 학점</td>
                <td><%=enrollUnit%>
                </td>
            </tr>
            <%} %>
        </table>
        <%
            }
        %>

        <% } else { %>
        <table width="75%" align="center" height="100%">
            <tr>
                <td align="center">수강 조회는 로그인한 후 사용하세요.</td>
            </tr>
        </table>
        <%
            }
        %>
    </div>
</div>
</body>
</html>