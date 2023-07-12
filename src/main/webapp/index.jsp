<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SookQL 수강신청시스템</title>

    <!-- tailwind -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.css" rel="stylesheet"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.js"></script>

</head>
<body>
<%@ include file="top.jsp" %>
<br>
<div class="p-4 sm:ml-64">
    <div class="p-4 border-2 border-gray-200 border-dashed rounded-lg dark:border-gray-700 mt-14">
        <table>
            <% if (session_id != null) { %>
            <tr>
                <td align="center"><%=session.getAttribute("user")%>님 방문을 환영합니다.</td>
            </tr>
            <% } else { %>
            <tr>
                <td align="center">로그인 후 사용하세요.</td>
            </tr>
            <%
                }
            %>
        </table>
    </div>
</div>
</body>
</html>