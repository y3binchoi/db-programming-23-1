<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="io.sookmyung.dbprog.DBConnection" %>
<%@ page import="java.util.Objects" %>
<%
    request.setCharacterEncoding("utf-8");
    Connection conn = null;
    try {
        conn = DBConnection.getConnection();
    } catch (SQLException | ClassNotFoundException e) {
        System.err.println("SQLException: " + e.getMessage());
    }
%>
<%
    String sMessage = null;
    String query = null;

    Integer session_id = (Integer) session.getAttribute("id");
    String session_identity = (String) session.getAttribute("identity");

    int userId = session_id;
    String userPwd = request.getParameter("user_pwd");
    String breakStatus = request.getParameter("breakStatus");
    String s_address = request.getParameter("s_address");
    System.out.println("userPwd = " + userPwd);
    System.out.println("breakStatus = " + breakStatus);
    System.out.println("s_address = " + s_address);
    try {
        PreparedStatement pstmt = null;
        if (Objects.equals(session_identity, "student")) {
            query = "UPDATE student set s_pwd=?,s_address=?,s_break=? where s_id =?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, userPwd);
            pstmt.setString(2, s_address);
            pstmt.setInt(3, Integer.parseInt(breakStatus));
            pstmt.setInt(4, userId);
        } else {
            query = "UPDATE professor set p_pwd=? where p_id =?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, userPwd);
            pstmt.setInt(2, userId);
        }
        pstmt.executeUpdate();
    } catch (SQLException ex) {

        if (ex.getErrorCode() == 20002) sMessage = "암호는 4자리 이상이어야 합니다";
        else if (ex.getErrorCode() == 20003) sMessage = "암호에 공란은 입력되지 않습니다.";
        else sMessage = "잠시 후 다시 시도하십시오";
%>
<script>
    alert("<%= sMessage %> ");
    location.href = "update.jsp";
</script>
<%
    }
%>
<script>
    alert("변경이 완료되었습니다.");
    location.href = "update.jsp";
</script>
