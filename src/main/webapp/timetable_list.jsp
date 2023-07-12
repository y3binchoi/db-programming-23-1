<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="UTF-8" %>
<%@ page import="io.sookmyung.dbprog.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>

    <!-- tailwind -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.css" rel="stylesheet"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.js"></script>

</head>
<body>
<%
    Connection conn = null;
    try {
        conn = DBConnection.getConnection();
    } catch (SQLException | ClassNotFoundException e) {
        System.err.println("SQLException: " + e.getMessage());
    }
%>
<%

    String year = request.getParameter("table_year");
    String semester = request.getParameter("table_semester");
    String student_id = "" + session.getAttribute("id"); ////user -> id

    GregorianCalendar cal = new GregorianCalendar();


    if (year == null && semester == null) {
        if (cal.get(GregorianCalendar.MONTH) < 4) {
            year = "" + cal.get(GregorianCalendar.YEAR);
            semester = "1";
        } else if (cal.get(GregorianCalendar.MONTH) >= 4 && cal.get(GregorianCalendar.MONTH) <= 9) {
            year = "" + cal.get(GregorianCalendar.YEAR);
            semester = "2";
        } else {
            year = "" + cal.get(GregorianCalendar.YEAR) + 1;
            semester = "1";
        }

    }


    request.setCharacterEncoding("utf-8");

    Statement stmt = conn.createStatement();
    String mySQL = "select t_time, t_hour, t_day, c_name from teach t, course c, enroll e where e.s_id=" + student_id + " and e.t_id=t.t_id and t.c_id=c.c_id and t_year=" + year + " and t_semester=" + semester;
    System.out.println("mySQL = " + mySQL);
    ResultSet rs = stmt.executeQuery(mySQL);

    int count = 0;
    int unit_count = 0;
    String timeline[][] = new String[15][9];
    String str = "<table class=\"w-full text-sm text-left text-gray-500 dark:text-gray-400\">";
//str +="<tr><td clospan=4> 수강 정보</td></tr>";

    str += "<thead class=\"text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400\">" +
            "<tr>" +
            "<th scope=\"col\" class=\"px-6 py-3\">시간</th>" +
            "<th scope=\"col\" class=\"px-6 py-3\">월</th>" +
            "<th scope=\"col\" class=\"px-6 py-3\">화</th>" +
            "<th scope=\"col\" class=\"px-6 py-3\">수</th>" +
            "<th scope=\"col\" class=\"px-6 py-3\">목</th>" +
            "<th scope=\"col\" class=\"px-6 py-3\">금</th>" +
            "<th scope=\"col\" class=\"px-6 py-3\">토</th>" +
            "</tr>" +
            "</thead>";

    int t = 0, d = 0, h = 0;
    
    while (t < 15) {

        timeline[t][0] = "<tr class=\"bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600\">";
        timeline[t][1] = "<td class=\"px-6 py-3\">" + (t + 8) + "</td>";
        timeline[t][2] = "<td class=\"px-6 py-3\"></td>";
        timeline[t][3] = "<td class=\"px-6 py-3\"></td>";
        timeline[t][4] = "<td class=\"px-6 py-3\"></td>";
        timeline[t][5] = "<td class=\"px-6 py-3\"></td>";
        timeline[t][6] = "<td class=\"px-6 py-3\"></td>";
        timeline[t][7] = "<td class=\"px-6 py-3\"></td>";
        timeline[t][8] = "</tr>";

        t = t + 1;
    }


    t = 0;
    int check = 0; //시간표 길이 조정용 변수
    String colorset[] = {"Pink", "HotPink", "Violet", "Tan", "Salmon", "Khaki", "DarkSeaGreen", "YellowGreen", "SkyBlue", "RosyBrown", "Crimson", "LightSalmon", "LightCoral", "PaleVioletRed", "Moccasin"};
    String course_name;
    Random random_color = new Random();
    int ran = random_color.nextInt(15);

    while (rs.next()) {

        t = rs.getInt("t_time") - 8;//시간으로 인덱스 설정
        h = rs.getInt("t_hour");
        course_name = rs.getString("c_name");
        ran = random_color.nextInt(10);//랜덤 색상
        check = t;
        if (rs.getInt("t_day") < 6) {
            d = rs.getInt("t_day") + 1;
            timeline[t][d] = "<td rowspan=" + h + " style=\"background-color:" + colorset[ran] + "\" height= \"20\" align=\"center\">" + course_name + "</td>";
            while (h > 1) {
                check = check + 1;
                timeline[check][d] = "";
                h = h - 1;
            }
        } else if (rs.getInt("t_day") == 6) {
            if (h % 2 == 0) h = h / 2;
            else h = h / 2 + 1;

            timeline[t][2] = "<td rowspan=" + h + " style=\"background-color:" + colorset[ran] + "\" height= \"20\" align=\"center\">" + course_name + "</td>";
            timeline[t][4] = "<td rowspan=" + h + " style=\"background-color:" + colorset[ran] + "\" height= \"20\" align=\"center\">" + course_name + "</td>";
            while (h > 1) {
                check = check + 1;
                timeline[check][2] = "";
                timeline[check][4] = "";
                h = h - 1;
            }
        } else if (rs.getInt("t_day") == 7) {
            if (h % 2 == 0) h = h / 2;
            else h = h / 2 + 1;

            timeline[t][3] = "<td rowspan=" + h + " style=\"background-color:" + colorset[ran] + "\" height= \"20\" align=\"center\">" + course_name + "</td>";
            timeline[t][5] = "<td rowspan=" + h + " style=\"background-color:" + colorset[ran] + "\" height= \"20\" align=\"center\">" + course_name + "</td>";
            while (h > 1) {
                check = check + 1;
                timeline[check][3] = "";
                timeline[check][5] = "";
                h = h - 1;
            }
        } else if (rs.getInt("t_day") == 8) {
            if (h % 2 == 0) h = h / 2;
            else h = h / 2 + 1;

            timeline[t][4] = "<td rowspan=" + h + " style=\"background-color:" + colorset[ran] + "\" height= \"20\" align=\"center\">" + course_name + "</td>";
            timeline[t][6] = "<td rowspan=" + h + " style=\"background-color:" + colorset[ran] + "\" height= \"20\" align=\"center\">" + course_name + "</td>";
            while (h > 1) {
                check = check + 1;
                timeline[check][4] = "";
                timeline[check][6] = "";
                h = h - 1;
            }
        }

    }

    for (int i = 0; i < 15; i++) {
        for (int j = 0; j < 9; j++) {
            str += timeline[i][j];
        }
    }

    str += "</table>";

    session.setAttribute("timetable_year", year);
    session.setAttribute("timetable_semester", semester);

    out.print(str);

    rs.close();
    stmt.close();
    conn.close();
%>


</body>
</html>