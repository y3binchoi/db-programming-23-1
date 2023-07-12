<%@ page contentType="text/html; charset=EUC-KR" %>
<html>
<head>
    <title>시간표 조회</title>

    <!-- tailwind -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.css" rel="stylesheet"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.js"></script>

</head>
<body>
<%@ include file="top.jsp" %>
<br>
<div class="p-4 sm:ml-64">
    <% if (session_id != null) { %>
    <div class="p-4 border-2 border-gray-200 border-dashed rounded-lg dark:border-gray-700 mt-14">

        <form method="post" action="timetable.jsp">

            <table align="center" style="margin-top:20">
                <tr>
                    <td align="center">
                        <%@ include file="timetable_list.jsp" %>
                    </td>
                </tr>
                <tr>

                    <%
                        String search_year = (String) session.getAttribute("timetable_year");
                        String search_semester = (String) session.getAttribute("timetable_semester");
                        String course_year_string = "<input type = \"text\" name=\"table_year\" " +
                                "class=\"bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500\"" +
                                "value=" + search_year + " required>&nbsp; ";
                        String course_semester_string = "<input type = \"text\" name=\"table_semester\" " +
                                "class=\"bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500\"" +
                                "value=" + search_semester + " required>&nbsp; ";
                    %>

                    <td>
                        <div class="flex">
                            <div class="flex item-center mb-4 gap-2">
                                <%=course_year_string %>
                            </div>
                            <div class="flex item-center mb-4 gap-2">
                                년도
                            </div>
                            <div class="flex item-center mb-4 gap-2">
                                <%=course_semester_string %>
                            </div>
                            <div class="flex item-center mb-4 gap-2">
                                학기
                            </div>
                            <div class="flex item-center mb-4 gap-2">
                                <input type="SUBMIT" value="조회"
                                       class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </form>
        <% } else { %>
        <table width="75%" align="center" height="100%">
            <tr>
                <td align="center">시간표 조회는 로그인한 후 사용하세요.</td>
            </tr>
        </table>
        <%
            }
        %>
    </div>
</div>
</body>
</html>