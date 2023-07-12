<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="io.sookmyung.dbprog.DBConnection" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>수강 신청 입력</title>

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
        Integer s_break = (Integer) session.getAttribute("break");
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("SQLException: " + e.getMessage());
        }
    %>
    <%
        CallableStatement cstmt = null;
        Statement stmt = null;
        ResultSet resultSet;


        int s_id = session_id;

        // 검색을 위한 쿼리
        String searchTypeStr = request.getParameter("searchType");
        int searchType = 0;
        if (searchTypeStr != null) {
            searchType = Integer.parseInt(searchTypeStr);
        }
        String searchText = request.getParameter("searchText");
    %>
    <%
        int eYear = 0, eSemester = 0, enrollCount = 0, enrollUnit = 0;
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
        } catch (SQLException e) {
            System.err.println("SQLException: " + e.getMessage());
        }
    %>
    <div class="p-4 border-2 border-gray-200 border-dashed rounded-lg dark:border-gray-700 mt-14">
        <h2 class="text-4xl font-bold dark:text-white">
            <%=eYear%>년도 <%=eSemester%>학기 수강 신청 입력
        </h2>

        <br>
        <p class="mt-1 text-sm font-normal text-gray-500 dark:text-gray-400">
            총 <%=enrollCount%> 과목, 총 <%=enrollUnit%> 학점 신청하였습니다. 18학점까지 신청 가능합니다.
        </p>
        <br>
        <div>
            <form id="searchForm" action="insert.jsp" method="GET">
                <div class="flex ">
                    <div class="grid md:grid-cols-4 md:gap-6">
                        <div class="flex items-center mb-4">
                            <input type="radio" id="search-option-1" name="searchType" value="1"
                                   class="w-4 h-4 border-gray-300 focus:ring-2 focus:ring-blue-300 dark:focus:ring-blue-600 dark:focus:bg-blue-600 dark:bg-gray-700 dark:border-gray-600">
                            <label for="search-option-1"
                                   class="block ml-2 text-sm font-medium text-gray-900 dark:text-gray-300">
                                과목
                            </label>
                        </div>
                        <div class="flex items-center mb-4">
                            <input type="radio" id="search-option-2" name="searchType" value="2"
                                   class="w-4 h-4 border-gray-300 focus:ring-2 focus:ring-blue-300 dark:focus:ring-blue-600 dark:focus:bg-blue-600 dark:bg-gray-700 dark:border-gray-600">
                            <label for="search-option-2"
                                   class="block ml-2 text-sm font-medium text-gray-900 dark:text-gray-300">
                                학과
                            </label>
                        </div>
                        <div class="flex items-center mb-4">
                            <input type="radio" id="search-option-3" name="searchType" value="3"
                                   class="w-4 h-4 border-gray-300 focus:ring-2 focus:ring-blue-300 dark:focus:ring-blue-600 dark:focus:bg-blue-600 dark:bg-gray-700 dark:border-gray-600">
                            <label for="search-option-3"
                                   class="block ml-2 text-sm font-medium text-gray-900 dark:text-gray-300">
                                교수
                            </label>
                        </div>
                        <div></div>
                    </div>
                    <div class="grid md:grid-cols-2 md:gap-6">
                        <div class="relative z-0 w-full mb-6 group">
                            <input type="text" id="text" name="searchText"
                                   class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                   placeholder=" " required/>
                            <label for="text"
                                   class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                검색어
                            </label>

                        </div>
                        <div class="relative z-0 w-full mb-6 group">
                            <button type="submit"
                                    class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
                                검색
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
            <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
            <tr>
                <th scope="col" class="px-6 py-3">과목번호</th>
                <th scope="col" class="px-6 py-3">분반</th>
                <th scope="col" class="px-6 py-3">과목명</th>
                <th scope="col" class="px-6 py-3">주관학과</th>
                <th scope="col" class="px-6 py-3">강의시간</th>
                <th scope="col" class="px-6 py-3">강의실</th>
                <th scope="col" class="px-6 py-3">담당교수</th>
                <th scope="col" class="px-6 py-3">학점</th>
                <th scope="col" class="px-6 py-3">정원</th>
                <th scope="col" class="px-6 py-3">신청</th>
                <th scope="col" class="px-6 py-3">여석</th>
                <th scope="col" class="px-6 py-3">수강신청</th>
            </tr>
            </thead>
            <%
                String query = "select vt.t_start, vt.t_end, " +
                        "t.t_id, t.t_no, t.t_day, t.t_room, t.t_max, " +
                        "c.c_name, c.c_id, c.c_unit, d.d_name, p.p_name, " +
                        "(select count(*) from enroll ee where ee.t_id = t.t_id) t_count " +
                        "from vTeach vt " +
                        "join teach t on t.t_year = " + eYear + " and t.t_semester =  " + eSemester +
                        "and vt.t_id = t.t_id " +
                        "join course c on t.c_id = c.c_id " +
                        "join department d on c.d_id = d.d_id " +
                        "join professor p on t.p_id = p.p_id " +
                        "where t.t_id not in (select t_id from enroll where s_id = " + s_id + ")";
                System.out.println("query = " + query);
                if (searchText != null) {
                    switch (searchType) {
                        case 1: // 과목
                            query += "and c.c_id = " + searchText + "";
                            break;
                        case 2: // 학과
                            query += "and d.d_name like '%" + searchText + "%'";
                            break;
                        case 3: // 교수
                            query += "and p.p_name like '%" + searchText + "%'";
                            break;
                    }
                }

                String c_name, d_name, p_name, t_day, t_room, endTime;
                int t_id, c_id, t_no, c_unit, t_max, t_count, t_remain, hh, mm;
                float t_end;

                try {
                    stmt = conn.createStatement();
                    resultSet = stmt.executeQuery(query);
                    if (resultSet != null) {
                        while (resultSet.next()) {
                            t_id = resultSet.getInt("t_id");
                            c_name = resultSet.getString("c_name");
                            d_name = resultSet.getString("d_name");
                            p_name = resultSet.getString("p_name");
                            t_room = resultSet.getString("t_room");
                            c_id = resultSet.getInt("c_id");
                            t_no = resultSet.getInt("t_no");
                            c_unit = resultSet.getInt("c_unit");
                            t_max = resultSet.getInt("t_max");
                            t_count = resultSet.getInt("t_count");
                            t_remain = t_max - t_count;
                            switch (resultSet.getInt("t_day")) {
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
                            t_end = resultSet.getFloat("t_end");
                            hh = (int) t_end;
                            mm = (int) ((t_end - hh) * 60);
                            if (mm > 0) endTime = String.format("%02d:%02d", hh, mm);
                            else endTime = String.format("%02d:00", hh);
                            t_day += " " + resultSet.getInt("t_start") + ":00 ~ " + endTime;
            %>
            <tbody>
            <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
                <td class="px-6 py-4"><%=c_id%>
                </td>
                <td class="px-6 py-4"><%=t_no%>
                </td>
                <td class="px-6 py-4"><%=c_name%>
                </td>
                <td class="px-6 py-4"><%=d_name%>
                </td>
                <td class="px-6 py-4"><%=t_day%>
                </td>
                <td class="px-6 py-4"><%=t_room%>
                </td>
                <td class="px-6 py-4"><%=p_name%>
                </td>
                <td class="px-6 py-4"><%=c_unit%>
                </td>
                <td class="px-6 py-4"><%=t_max%>
                </td>
                <td class="px-6 py-4"><%=t_count%>
                </td>
                <td class="px-6 py-4"><%=t_remain%>
                </td>
                <% if (s_break == 0) {%>
                <td class="px-6 py-4">
                    <a href="insert_verify.jsp?t_id=<%=t_id%>"
                       class="font-medium text-blue-600 dark:text-blue-500 hover:underline">신청
                    </a>
                </td>
                <% } %>
            </tr>
            </tbody>

            <%
                        }
                    }

                    if (resultSet != null) resultSet.close();
                    if (cstmt != null) cstmt.close();
                    stmt.close();
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("SQLException: " + e.getMessage());
                }
            %>
        </table>
        <% } else { %>
        <table width="75%" align="center" height="100%">
            <tr>
                <td align="center">수강 신청은 로그인한 후 사용하세요.</td>
            </tr>
        </table>
        <%
            }
        %>
    </div>
</div>
</body>
</html>
