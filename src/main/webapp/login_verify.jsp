<%@ page contentType="text/html;charset=UTF-8" %>
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
    int userId = Integer.parseInt(request.getParameter("id"));
    String userPwd = request.getParameter("pwd");

    Statement stmt = null;
    String query = null;
    String query2 = null;
    stmt = conn.createStatement();
    query = "select s_id,s_name,s_break from student " +
            "where s_id=" + userId + " and s_pwd='" + userPwd + "'";
    System.out.println("query = " + query);
    ResultSet rs = stmt.executeQuery(query);

    if (rs.next()) {
        String name = rs.getString("s_name");
        int id = rs.getInt("s_id");
        session.setAttribute("id", id);
        session.setAttribute("user", name);
        session.setAttribute("identity", "student");
        session.setAttribute("break", rs.getInt("s_break"));
        response.sendRedirect("index.jsp");
    } else {
        query2 = "select p_id,p_name from professor " +
                "where p_id=" + userId + " and p_pwd='" + userPwd + "'";
        System.out.println("query2 = " + query2);
        ResultSet rs2 = stmt.executeQuery(query2);
        if (rs2.next()) {
            String name = rs2.getString("p_name");
            int id = rs2.getInt("p_id");
            session.setAttribute("id", id);
            session.setAttribute("user", name);
            session.setAttribute("identity", "professor");
            response.sendRedirect("index.jsp");
        } else {
%>

<script>
    alert("일치하는 회원정보가 없습니다.");
    location.href = "login.jsp";
</script>

<%
        }
    }

    stmt.close();
    conn.close();
%>