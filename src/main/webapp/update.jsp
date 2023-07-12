<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="io.sookmyung.dbprog.DBConnection" %>
<%@ page import="java.util.Objects" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>사용자 정보 수정</title>

    <!-- tailwind -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.css" rel="stylesheet"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.js"></script>

</head>
<body>
<%@ include file="top.jsp" %>
<br>
<%
    request.setCharacterEncoding("utf-8");
%>
<div class="p-4 sm:ml-64">
    <% if (session_id != null) {
        Connection conn = null;
        String query = "";
        Statement stmt = null;
        ResultSet rs = null;

        if (Objects.equals(session_identity, "student")) {
            query = "select s_id, s_pwd, s_name, s_address, s_break from student where s_id = " + session_id + "";
        } else {
            query = "select p.p_id , p.p_pwd, p.p_name, d.d_name " +
                    "from professor p " +
                    "join department d on p.d_id = d.d_id and p.p_id = " + session_id + "";
        }

        int user_id = 0, s_break = 0;
        String user_pwd = null, user_name = null, s_address = null, d_name = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);

            if (rs.next()) {
                if (Objects.equals(session_identity, "student")) {
                    user_id = rs.getInt("s_id");
                    user_pwd = rs.getString("s_pwd");
                    user_name = rs.getString("s_name");
                    s_address = rs.getString("s_address");
                    s_break = rs.getInt("s_break");
                } else {
                    user_id = rs.getInt("p_id");
                    user_pwd = rs.getString("p_pwd");
                    user_name = rs.getString("p_name");
                    d_name = rs.getString("d_name");
                }
            }

            stmt.close();
            conn.close();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("SQLException: " + e.getMessage());
        }
    %>
    <div class="p-4 border-2 border-gray-200 border-dashed rounded-lg dark:border-gray-700 mt-14">

        <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
            사용자 정보 수정
        </h5>
        <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">여기서 사용자 정보를 수정할 수 있습니다.</p>

        <div class=" p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">

            <form method="post" action="update_verify.jsp">
                <div class="grid gap-6 mb-6 md:grid-cols-2">
                    <div><% if (Objects.equals(session_identity, "student")) { %>학번<% } else { %>교번<% } %></div>
                    <%=user_id%>
                    <div>이름</div>
                    <%=user_name%>
                    <% if (Objects.equals(session_identity, "student")) { %>
                    <div>
                        재학상태
                    </div>
                    <div class="flex">
                        <div class="flex items-center mr-4">
                            <input <%if (s_break == 0) %>checked <%;%> id="break_no_0" type="radio" value="0"
                                   name="breakStatus"
                                   class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600">
                            <label for="break_no_0"
                                   class="ml-2 text-sm font-medium text-gray-900 dark:text-gray-300">재학</label>
                        </div>
                        <div class="flex items-center mr-4">
                            <input <%if (s_break == 1) %>checked <%;%> id="break_yes_1" type="radio" value="1"
                                   name="breakStatus"
                                   class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600">
                            <label for="break_yes_1"
                                   class="ml-2 text-sm font-medium text-gray-900 dark:text-gray-300">휴학</label>
                        </div>
                    </div>
                    <label for="s_address"
                           class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">주소</label>
                    <input type="text" id="s_address" value="<%=s_address%>" name="s_address"
                           class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
                    <% } else { %>
                    <div>학과</div>
                    <%=d_name%>
                    <% } %>
                    <label for="user_pwd"
                           class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">비밀번호</label>
                    <input type="password" id="user_pwd" value="<%=user_pwd%>" name="user_pwd"
                           class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
                </div>

                <input type="submit" value="변경사항 저장하기"
                       class="inline-flex items-center px-3 py-2 text-sm font-medium text-center text-white bg-blue-700 rounded-lg hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
            </form>
        </div>


        <%
        } else { %>
        <table width="75%" align="center" height="100%">
            <tr>
                <td align="center">사용자 정보 수정은 로그인한 후 사용하세요.</td>
            </tr>
        </table>
        <% } %>
    </div>
</div>
</body>
</html>
