<%@ page import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*"%>
<%@ page import="com.markany.futils.*"%>
<%@ page import="com.markany.aes.MaUrlRdBase64"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	// 증명서 생성 시 필요한 데이터 정보 3가지 ( pdf파일경로, ozr파일경로, 가로세로파라미터 )
	String	strPdfDataType = request.getParameter("strPdfDataType");		  //가로세로여부 0-Portrait(세로),1-Landscape(가로) 
	String	strPrintOptions	= request.getParameter("strPrintOptions");
	String	strRtDataPath ="";
	String	strPdfFilePath ="";
	MaUrlRdBase64 maEncUtil = new MaUrlRdBase64();
	//********************* 샘플데이터 물리적 패스 ************************//
	
	if(strPdfDataType.equals("0")){
		strRtDataPath 		= "/home/tomcat/webapps/module/EPS/rt/Sample/sample0326.dat";   //data 파일경로
		strPdfFilePath 		= "/home/tomcat/webapps/module/EPS/rt/Sample/sample0326.pdf";   //pdf 파일경로
		
		
	}else{
		strRtDataPath 		= "/usr/local/apache/htdocs/FPS/NOAX_RT/Sample/gggg.dat";   //data 파일경로
		strPdfFilePath 		= "/usr/local/apache/htdocs/FPS/NOAX_RT/Sample/gggg.pdf";   //pdf 파일경로
	}
	strRtDataPath = maEncUtil.strUrlRdEncode( strRtDataPath );
	strPdfFilePath = maEncUtil.strUrlRdEncode( strPdfFilePath );
	  
	//String strMAConfigData	 				= new String("35^265^7^265^528^264^인터넷발급^사본^4^280^70^0^0^3^"); 
	//String strConfingEncodeData 			= MaBase64Utils.base64Encode(strMAConfigData.getBytes("utf-8"));

	// ** debug ** //
	//out.println(strCurrentPath);
	//out.println(strOzDataPath);
	//out.println(strPdfFilePath);
	
	/* 마크애니 뷰어 옵션 
	    // 미리보기 지원
		- 0 : view-manualprint-printerselect (default)
		      마크애니 뷰어로 미리보기가 가능하며, 인쇄버튼을 누르면 프린터선택창을 지원하는 옵션 (미리보기 후 인쇄선택버튼 눌러 인쇄가능)
		- 1 : view-manualprint-defaultprinter
      		마크애니 뷰어로 미리보기가 가능하며, 인쇄버튼을 누르면 기본프린터로 인쇄되는 옵션
		- 2 : view-autoprint-printerselect
		      마크애니 뷰어로 미리보기 되자마자, 프린터선택창이 바로 뜨는 옵션
		- 3 : view-autoprint-defaultprinter
      		마크애니 뷰어로 미리보기 되자마자, 기본프린터로 자동 인쇄되는 옵션
		- 4 : view
          마크애니 뷰어로 미리보기만 가능함 (인쇄버튼 없음)
		      
		  // 미리보기 지원안함    
		- 10: notView_autoPrint_printerselect
		      마크애니 뷰어가 뜨지않고, 프린터선택창이 바로 뜨는 옵션
		- 11: notView_autoPrint_defaultPrinter	
        	마크애니 뷰어가 뜨지않고, 기본프린터로 바로 출력되는 옵션
	*/
	
	%>	
	
	
<jsp:forward page="../jsp/MaFpsTail_Noax.jsp">
		<jsp:param name="RtData" value="<%=strRtDataPath%>"/>
		<jsp:param name="PdfFilePath" value="<%=strPdfFilePath%>"/>
		<jsp:param name="PdfDataType" value="<%=strPdfDataType%>"/>
		<jsp:param name="PrintOptions" value="<%=strPrintOptions%>"/>
		
</jsp:forward>
