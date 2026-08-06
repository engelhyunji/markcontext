<%@page language="java" contentType="text/html; charset=euc-kr"%> 
<%@ page import='java.util.* , java.io.*, java.lang.*'%>
<%@include file="MaFpsCommon.jsp"%>
<%@include file="MaFunction.jsp"%>
<%
	String strParamDownURL = (String)session.getAttribute("strDownURL");
	String strParamCookie = (String)session.getAttribute("strCookie");
	String strParamPversion = (String)session.getAttribute("productversion");
	//String strSignature = "MARKANYEPS";

	strParamDownURL = MaBase64Utils.base64Encode( strParamDownURL.getBytes ("utf-8") );
	strParamCookie = MaBase64Utils.base64Encode( strParamCookie.getBytes ("utf-8") );
	//out.println("strParamDownURL" + strParamDownURL);
	//out.println("strParamCookie" + strParamCookie);
	//out.println("strParamPversion" + strParamPversion);

	int iTotal = 20;
	int iCnt =0;
	boolean bValidVersion = false;
	  
	while (true) {
	strParamPversion = (String)session.getAttribute("productversion");

	if (strParamPversion != null) {
		if (strParamPversion.indexOf(strSignature) >= 0) {
			String strTemp = replaceAll(strParamPversion, strSignature, "");
			int iServerVer = Integer.parseInt(strPVersion);
			int iSessionVer = Integer.parseInt(strTemp);
			if (iSessionVer >= iServerVer)
				bValidVersion = true;
			break;
		}
	}
	if (bValidVersion)
		break;
	iCnt++;
	if (iTotal <= iCnt)
		break;
	Thread.sleep(500);
	}

	if (!bValidVersion) //file delete
	{
		String[]result = strParamDownURL.split("fn=");
		if (result.length > 1) {
			String filePath = strDownFolder;
			String requestFileNameAndPath = strParamCookie + result[1];
			requestFileNameAndPath += ".matmp";

			File file = new File(filePath, requestFileNameAndPath);
			if (file.exists()) {
				file.delete ();
			}
		}
		response.sendRedirect(strSudongInstallURL);
	}
  
%>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr"/>
	<title>E-Certification</title>
	<style>
	.container {
		position: relative;
		margin: 0 auto;
	}
	#content{
		display: block;
		font-size: 11px;
		margin-top: 40px;
		text-align: center;
	}

	img{
		margin: 0 auto;
		display: block;
	}
	</style>
	</head>
	<body>
		<div class="container">
			<div id="content">
				<img src="<%=strImagePath%>/loading.gif"><br>
				<img src="<%=strImagePath%>/Ma_progressBar.gif"><br>
				<img src="<%=strImagePath%>/notice.png"><br>
			</div>
		</div>
	</body>
</html> 
<script src="<%=strJsWebHome%>/MaVerCheck.js" charset="euc-kr"></script> 
<script language="javascript">
		var vstrSudongInstallURL = "<%=strSudongInstallURL%>";
		var vSession = getCookie("JSESSIONID");
		var vstrSCookie = "<%=strParamCookie%>";
		var vpversion = "<%=strParamPversion%>";
		var vstrSDownURL = "<%=strParamDownURL%>";
		var iVersion  = "<%=strPVersion%>";
		var vstrApp = "<%=strApp%>"; 
		
		<%
		if(iQuickSet == 0){
		%>
			LaunchApp(vstrApp, "sockmeta");  
		<%
		}else if(iQuickSet == 1){
		%>
			setTimeout(function(){messageDataSend()},3000);
		<%
		}
		%>
			
		
</script> 
