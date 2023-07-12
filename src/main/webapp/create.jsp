<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="io.sookmyung.dbprog.DBConnection" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>강의 개설</title>

  <!-- tailwind -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.css" rel="stylesheet"/>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.js"></script>

</head>
<body>
<%@ include file="top.jsp" %>
<br>
<%
  request.setCharacterEncoding("utf-8");
  Connection conn = null;
  try {
    conn = DBConnection.getConnection();
  } catch (SQLException | ClassNotFoundException e) {
    System.err.println("SQLException: " + e.getMessage());
  }
%>

<div class="p-4 sm:ml-64">
  <div class="p-4 border-2 border-gray-200 border-dashed rounded-lg dark:border-gray-700 mt-14">

    <div class="section_title">
      <h1>
        <span>강의 개설</span>
      </h1>
    </div>
    <div id="content" class="login">
      <div class="login_box">
        <form method="post" action="create_verify.jsp">
          <fieldset class="formLogin">
            <div width="40%">
              <h2>강의 개설을 위해 하단의 정보를 입력해주세요.</h2>
              <table class="inputTable">


                <%
                  if (session_id == null) {
                %>
                <script>
                  alert("로그인이 필요합니다.");
                  location.href = "login.jsp";
                </script>
                <%
                } else {
                  //String ver_pwd = "pwd1234";
                  String ver_pwd = request.getParameter("userPassword");
                  Statement stmt = null;
                  ResultSet rs = null;
                  String mySQL = null;
                  String col_name = null;
                  String col_addr = null;
                  //String col_break = null;
                  String col_department = null;
                  String col_pwd = null;

                  if (session_identity == "student") {
                    mySQL = "select s_name, s_address, s_break, s_pwd from student where s_id=" + session_id;
                    //+ " and s_pwd ='" + ver_pwd + "'";
                  } else if (session_identity == "professor") {
                    mySQL = "select p_name, d_id, p_pwd from professor where p_id=" + session_id;
                  }

                  stmt = conn.createStatement();
                  rs = stmt.executeQuery(mySQL);
                  if (rs != null) {

                    if (rs.next()) {

                      if (session_identity == "student") {
                        col_name = "s_name";
                        col_addr = "s_address";
                        //col_break = "s_break";
                        col_pwd = "s_pwd";
                      } else {
                        col_name = "p_name";
                        col_department = "d_id";
                        col_pwd = "p_pwd";
                      }
                      String addr = null;
                      String name = rs.getString(col_name);
                      String breakStatus = "3";
                      if (session_identity == "student") {
                        addr = rs.getString(col_addr);
                        //breakStatus = rs.getString(col_break);
                      }
                      ;
                      String passwd = rs.getString(col_pwd);

                %>

                <tbody>
                <tr>
                  <%
                    int id = session_id;
                  %>
                  <td>과목번호</td>
                  <td class="input"><input type="text"
                                           id="courseid" name="courseid" title="과목번호"
                                           class="formText formText_Tid"/></td>
                </tr>

                <tr>
                  <td colspan="3" class="blank02"></td>
                </tr>
                <tr>
                  <td>분반</td>
                  <td class="input"><input type="text" id="teachno"
                                           name="teachno" title="분반"
                                           class="formText formText_Tno"/></td>
                </tr>
                <tr>
                  <td colspan="3" class="blank02"></td>
                </tr>

                <tr>
                  <td>강의 요일</td>
                  <td class="input"><input type="text" id="teachday"
                                           name="teachday" title="강의 요일"
                                           class="formText formText_Tday"/></td>
                </tr>
                <tr>
                  <td colspan="3" class="blank02"></td>
                </tr>
                <tr>
                  <td>강의 시작 시간</td>
                  <td class="input"><input type="text" id="teachtime"
                                           name="teachtime" title="강의 시작 시간"
                                           class="formText formText_Ttime"/></td>
                </tr>
                <tr>
                  <td colspan="3" class="blank02"></td>
                </tr>
                <tr>
                  <td>강의 시간</td>
                  <td class="input"><input type="text" id="teachhour"
                                           name="teachhour" title="강의 시간"
                                           class="formText formText_Thour"/></td>
                </tr>
                <tr>
                  <td colspan="3" class="blank02"></td>
                </tr>
                <tr>
                  <td>강의실</td>
                  <td class="input"><input type="text" id="teachroom"
                                           name="teachroom" title="강의실"
                                           class="formText formText_Troom"/></td>
                </tr>
                <tr>
                  <td colspan="3" class="blank02"></td>
                </tr>
                <tr>
                  <td>수강 정원</td>
                  <td class="input"><input type="text" id="teachmax"
                                           name="teachmax" title="수강 정원"
                                           class="formText formText_Tmax"/></td>
                </tr>
                <tr>
                  <td colspan="3" class="blank02"></td>
                </tr>

                <tr>
                  <td colspan="3" class="blank02"></td>
                </tr>
                <tr>
                  <td colspan="3" class="blank02"></td>
                </tr>
                <tr>
                  <td colspan="3" class="blank02"></td>
                </tr>
                <tr>
                  <td colspan="4" align="center"><input type="submit"
                                                        value="강의 등록"></td>
                </tr>
                </tbody>
              </table>
            </div>
          </fieldset>
          </br> </br> </br> </br> </br> </br> </br> </br>

          <%
          } else {
          %>
          <script>
            alert("비밀번호가 틀립니다.");
            history.back();
          </script>
          <%
                }
              }
              stmt.close();
              conn.close();
            }
          %>
        </form>
      </div>
    </div>
  </div>
</div>
</body>
</html>