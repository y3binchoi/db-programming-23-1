<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@ page import="io.sookmyung.dbprog.DBConnection" %>
<%
  Connection conn = null;

  CallableStatement cstmt;

  try {
    conn = DBConnection.getConnection();
    conn.setAutoCommit(false);


  } catch (SQLException | ClassNotFoundException e) {
    System.err.println("SQLException: " + e.getMessage());
  }
%>

<%@ include file="top.jsp" %>

<%
  request.setCharacterEncoding("utf-8");
  String sMessage = null;

  try {
    String countSQL = "select max(t_id) max_t from teach";
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery(countSQL);
    GregorianCalendar cal = new GregorianCalendar();

    int teachId = 0;
    while (rs.next()) {
      teachId = rs.getInt("max_t")+1;
    }


    int courseId = Integer.parseInt(request.getParameter("courseid"));
    int teachNo = Integer.parseInt(request.getParameter("teachno"));
    /*int teachYear=0;
    int teachSemester=0;




    if (teachYear == 0 && teachSemester == 0) {
        if (cal.get(GregorianCalendar.MONTH) < 4) {
        	teachYear = cal.get(GregorianCalendar.YEAR);
        	teachSemester = 1;
        } else if (cal.get(GregorianCalendar.MONTH) >= 4 && cal.get(GregorianCalendar.MONTH) <= 9) {
        	teachYear =  cal.get(GregorianCalendar.YEAR);
        	teachSemester = 2;
        } else {
        	teachYear = cal.get(GregorianCalendar.YEAR) + 1;
        	teachSemester = 1;
        }

    }*/


    int pId = session_id;
    int teachDay = Integer.parseInt(request.getParameter("teachday"));
    int teachTime = Integer.parseInt(request.getParameter("teachtime"));
    int teachHour = Integer.parseInt(request.getParameter("teachhour"));
    String teachRoom = request.getParameter("teachroom");
    //int teachUnit = Integer.parseInt(request.getParameter("teachunit"));
    int teachMax = Integer.parseInt(request.getParameter("teachmax"));

    PreparedStatement pstmt = null;


    cstmt = conn.prepareCall("{call BeforeUpdateTeach(?,?,?,?,?,?,?,?,?,?)}");
    cstmt.setInt(1, teachId);
    cstmt.setInt(2, courseId);
    cstmt.setInt(3, teachNo);
    cstmt.setInt(4, pId);
    cstmt.setInt(5, teachDay);
    cstmt.setInt(6, teachTime);
    cstmt.setInt(7, teachHour);
    cstmt.setString(8, teachRoom);
    cstmt.setInt(9, teachMax);

    cstmt.registerOutParameter(10, Types.VARCHAR);

    cstmt.execute();
    String result = cstmt.getString(10);

    //System.out.println(formPass + ", " + formAddr);

    //String sql = "insert into teach values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

       /* String sql = "insert into teach values("+teachId+","+courseId+ ","+ teachNo +","
        				+ teachYear +"," + teachSemester + "," + pId+ ","+ teachDay +"," + teachTime+","+ teachHour+
        				",'"+teachRoom +"',"+teachMax+")";*/



    //pstmt = conn.prepareStatement(sql);
        /*pstmt.setInt(1, teachId);
        pstmt.setInt(2, courseId);
        pstmt.setInt(3, teachNo);
        pstmt.setInt(4, teachYear);
        pstmt.setInt(5, teachSemester);
        pstmt.setInt(6, pId);
        pstmt.setInt(7, teachDay);
        pstmt.setInt(8, teachTime);
        pstmt.setInt(9, teachHour);
        pstmt.setString(10, teachRoom);
        pstmt.setInt(11, teachMax);*/
    //System.out.println(sql);
    // pstmt.executeUpdate();


%>
<script>
  alert("<%= result %>");
  location.href = "create.jsp";
</script>
<%

    conn.commit();
    cstmt.close();
    conn.close();


  } catch (SQLException ex) {

    /*if (ex.getErrorCode() == 20008) sMessage = "해당 시간에 이미 등록한 강의가 있습니다.";
    else if (ex.getErrorCode() == 20003) sMessage = "같은 시간에 해당 강의실에 배정된 강의가 있습니다.";
    else sMessage = "잠시 후 다시 시도하십시오";*/
    System.err.println("SQLException: " + ex.getMessage());}
%>