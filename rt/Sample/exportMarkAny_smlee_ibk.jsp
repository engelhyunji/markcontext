<%@page import="com.clipsoft.clipreport.server.service.ClipReportForMarkVoice"%>
<%@page import="com.clipsoft.clipreport.export.option.PDFOption"%>
<%@page import="com.clipsoft.clipreport.oof.connection.OOFConnectionHTTP"%>
<%@page import="com.clipsoft.clipreport.oof.OOFFile"%>
<%@page import="com.clipsoft.clipreport.oof.OOFDocument"%>
<%@page import="com.clipsoft.clipreport.oof.connection.*"%>
<%@ page import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*" %>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="com.clipsoft.clipreport.server.service.ResultValue"%>
<%@page import="com.clipsoft.clipreport.server.service.ClipReportPDFForMark"%>
<%@page import="com.clipsoft.clipreport.server.service.ClipReportExport"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="Property.jsp"%>
<%
OOFDocument oof = OOFDocument.newOOF();
OOFFile file = oof.addFile("crf.root", "%root%/crf/CLIPtoDRM.crf");

OOFConnectionMemo conn = oof.addConnectionMemo("*", "<rexdataset><rexrow><ID><![CDATA[1]]></ID><FACTORY><![CDATA[Tokyo]]></FACTORY><ITEM><![CDATA[Washer]]></ITEM><PRODUCTION><![CDATA[89]]></PRODUCTION><BADNESS><![CDATA[20]]></BADNESS><STOCK><![CDATA[0]]></STOCK></rexrow><rexrow><ID><![CDATA[2]]></ID><FACTORY><![CDATA[London]]></FACTORY><ITEM><![CDATA[Refrigerator]]></ITEM><PRODUCTION><![CDATA[23]]></PRODUCTION><BADNESS><![CDATA[10]]></BADNESS><STOCK><![CDATA[36]]></STOCK></rexrow><rexrow><ID><![CDATA[3]]></ID><FACTORY><![CDATA[Paris]]></FACTORY><ITEM><![CDATA[TV]]></ITEM><PRODUCTION><![CDATA[36]]></PRODUCTION><BADNESS><![CDATA[3]]></BADNESS><STOCK><![CDATA[36]]></STOCK></rexrow><rexrow><ID><![CDATA[4]]></ID><FACTORY><![CDATA[Paris]]></FACTORY><ITEM><![CDATA[Refrigerator]]></ITEM><PRODUCTION><![CDATA[27]]></PRODUCTION><BADNESS><![CDATA[5]]></BADNESS><STOCK><![CDATA[78]]></STOCK></rexrow><rexrow><ID><![CDATA[5]]></ID><FACTORY><![CDATA[Paris]]></FACTORY><ITEM><![CDATA[Washer]]></ITEM><PRODUCTION><![CDATA[16]]></PRODUCTION><BADNESS><![CDATA[7]]></BADNESS><STOCK><![CDATA[132]]></STOCK></rexrow><rexrow><ID><![CDATA[6]]></ID><FACTORY><![CDATA[Tokyo]]></FACTORY><ITEM><![CDATA[TV]]></ITEM><PRODUCTION><![CDATA[68]]></PRODUCTION><BADNESS><![CDATA[9]]></BADNESS><STOCK><![CDATA[12]]></STOCK></rexrow><rexrow><ID><![CDATA[7]]></ID><FACTORY><![CDATA[Paris]]></FACTORY><ITEM><![CDATA[Video]]></ITEM><PRODUCTION><![CDATA[23]]></PRODUCTION><BADNESS><![CDATA[12]]></BADNESS><STOCK><![CDATA[78]]></STOCK></rexrow><rexrow><ID><![CDATA[8]]></ID><FACTORY><![CDATA[Tokyo]]></FACTORY><ITEM><![CDATA[Audio]]></ITEM><PRODUCTION><![CDATA[12]]></PRODUCTION><BADNESS><![CDATA[3]]></BADNESS><STOCK><![CDATA[63]]></STOCK></rexrow><rexrow><ID><![CDATA[9]]></ID><FACTORY><![CDATA[London]]></FACTORY><ITEM><![CDATA[Electric Fan]]></ITEM><PRODUCTION><![CDATA[78]]></PRODUCTION><BADNESS><![CDATA[27]]></BADNESS><STOCK><![CDATA[71]]></STOCK></rexrow><rexrow><ID><![CDATA[10]]></ID><FACTORY><![CDATA[Tokyo]]></FACTORY><ITEM><![CDATA[Electric Fan]]></ITEM><PRODUCTION><![CDATA[53]]></PRODUCTION><BADNESS><![CDATA[2]]></BADNESS><STOCK><![CDATA[23]]></STOCK></rexrow><rexrow><ID><![CDATA[11]]></ID><FACTORY><![CDATA[London]]></FACTORY><ITEM><![CDATA[Audio]]></ITEM><PRODUCTION><![CDATA[23]]></PRODUCTION><BADNESS><![CDATA[10]]></BADNESS><STOCK><![CDATA[56]]></STOCK></rexrow><rexrow><ID><![CDATA[12]]></ID><FACTORY><![CDATA[London]]></FACTORY><ITEM><![CDATA[TV]]></ITEM><PRODUCTION><![CDATA[89]]></PRODUCTION><BADNESS><![CDATA[25]]></BADNESS><STOCK><![CDATA[30]]></STOCK></rexrow><rexrow><ID><![CDATA[13]]></ID><FACTORY><![CDATA[Paris]]></FACTORY><ITEM><![CDATA[Air Conditioner]]></ITEM><PRODUCTION><![CDATA[9]]></PRODUCTION><BADNESS><![CDATA[2]]></BADNESS><STOCK><![CDATA[20]]></STOCK></rexrow><rexrow><ID><![CDATA[14]]></ID><FACTORY><![CDATA[Tokyo]]></FACTORY><ITEM><![CDATA[Air Conditioner]]></ITEM><PRODUCTION><![CDATA[2]]></PRODUCTION><BADNESS><![CDATA[0]]></BADNESS><STOCK><![CDATA[18]]></STOCK></rexrow></rexdataset>");
conn.addContentParamXML("*", "utf-8", "%dataset.xml.root%");

//pdf 생성할 때 옵션
PDFOption option = new PDFOption();

// 바코드데이터 생성
ResultValue result = ClipReportPDFForMark.create(request, propertyPath, oof, option);
//서식 안에 2D바코드가 없어도 모든 페이지에 대한 바코드 데이터를 생성합니다.
//ResultValue result = ClipReportPDFForMark.createAllPage(request, propertyPath, oof, option);

int errorCode = result.getErrorCode();
//errorCode == 0 정상
//errorCode == 1 리포트 서버  오류
//errorCode == 2 oof 문서 오류
//errorCode == 3 리포트 엔진 오류
//errorCode == 4 결과물(document) 파일을 찾을 수 없을 때 오류
//errorCode == 5 pdf, dat 생성시 오류

//바코드로 만든 데이터 파일 위치
System.out.println(result.getDataFilePath());
System.out.println(result.getPdfFilePath());

//바코드가 들어갈 좌표
//result.getLeft();
//result.getTop();

//문서의 세로, 가로
//세로 0
//가로 1
//int paperOrientation = result.getPaperOrientation();


//음성 바코드 예제
//음성바코드에 들어갈 회사 이름 (설정하지 않을 경우 바코드 설정에 있는 내용을 설정됩니다.)
result.setVoiceComName("클립소프트");
//음성바코드의 x좌표
result.setVoiceX(160);
//음성바코드의 y좌표
result.setVoiceY(10);
//음성바코드의 넓이
result.setVoiceWidth(18);
//음성바코드의 높이
result.setVoiceHeight(18);
//음성바코드의 DPI(설정하지 않을 경우 바코드 설정에 있는 내용을 설정됩니다.)
result.setVoiceDPI(600);

//음성바코드 문자열 xml 반환한다.
//String voiceXmlString = ClipReportForMarkVoice.makeToXmlString(result);
//음성바코드 파일 경로를 반환
String voiceXmlFilePath = ClipReportForMarkVoice.makeToXmlFile(result);

//System.out.println(voiceXmlString);
System.out.println(voiceXmlFilePath);

//임시 저장 삭제
//ClipReportPDFForMark.delete(result);
%>
