<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="io.sookmyung.dbprog.DBConnection" %>
<%
    int s_id = (int) session.getAttribute("id");
    int t_id = Integer.parseInt(request.getParameter("t_id"));
%>
<%
    Connection conn = null;
    CallableStatement cstmt;
    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false);

        cstmt = conn.prepareCall("{call InsertEnroll(?,?,?)}");
        cstmt.setInt(1, s_id);
        cstmt.setInt(2, t_id);
        cstmt.registerOutParameter(3, Types.VARCHAR);

        cstmt.execute();
        String result = cstmt.getString(3);
%>
<script>
    alert("<%= result %>");
    location.href = "insert.jsp";
</script>
<%
        conn.commit();
        cstmt.close();
        conn.close();
    } catch (SQLException | ClassNotFoundException e) {
        System.err.println("SQLException: " + e.getMessage());
    }
%>