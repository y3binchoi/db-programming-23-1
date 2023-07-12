<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="io.sookmyung.dbprog.DBConnection" %>
<%
    Connection conn = null;
    try {
        conn = DBConnection.getConnection();
    } catch (SQLException | ClassNotFoundException e) {
        System.err.println("SQLException: " + e.getMessage());
    }
%>
<%
    int t_id = Integer.parseInt(request.getParameter("t_id"));
    int s_id = (int) session.getAttribute("id");
    String session_identity = (String) session.getAttribute("identity");

    Statement stmt = null;
    String mySQL = null;
    stmt = conn.createStatement();
    if (session_identity == "professor") mySQL = "delete from teach where t_id=" + t_id + "";
    else mySQL = "delete from enroll where t_id=" + t_id + " and s_id=" + s_id + "";

    int re = stmt.executeUpdate(mySQL);

    if (re != 0) {
%>

<script>
    alert("삭제되었습니다.");
    location.href = "delete.jsp";
</script>

<% } else { %>

<script>
    alert("오류가 발생했습니다.");
    location.href = "delete.jsp";
</script>

<%
    }
    stmt.close();
    conn.close();
%>