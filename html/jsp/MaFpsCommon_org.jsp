<%@ page import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*" %>
<%@ page import="com.markany.EPageSafer.*"%>
<%@ page import="com.markany.fps.*"%>
<%@ page import="com.markany.futils.*"%>
<%
	/**
	MaFpsCommon.jsp
	ePageSAFER의 서버, 클라이언트와 통신 및 옵션을 설정하기 위한 페이지입니다.
	각 연동의 설정, 미리보기 및 출력의 옵션을 설정 할 수 있습니다.
	추후 정책 및 환경이 변경될 경우 아래의 변수들을 변경하시면 됩니다.
	
	- 해당 페이지는 돋움체를 사용하여 정렬하였습니다. 
	*/
	//#############################		common value set	###############################	
	String  	strApp              			= "maepagesafer";
	String  	strPVersion     				= "25172"; // 
	String 		strSignature 					= "MARKANYEPS";
	//#############################		2D Bacode value set	###############################
	String		strMAServerIP 					= "127.0.0.1";
	int			iMAServerPort 					= 18000;
	int			iCellBlockCount 				= 16; 
	int			iCellBlockRow					= 2; 
	
	int 		iUseEncCookie					= 0; 	// 0 = 미사용, 1 = Enc 적용
	int 		iUse3DanBarcode					= 1;
	if(iUse3DanBarcode == 1){
		iCellBlockCount 				= 300;
		iCellBlockRow					= 120;
	}
	//#############################		client value set	###############################	
	String  	strProtocolName     			= request.getScheme()+"://";
	String 		strServerName					= request.getServerName();
	int			iServerPort						= request.getServerPort();
	String  	strDomain           			= strProtocolName+ strServerName +":"+ iServerPort;
	
  	//String strUserID            = (String)session.getAttribute("user_no");  	
	
	//#############################		setting the MA_FPSFM & setting the .matmp file  ############	
	int			iUseNas							= 1;		//1: FM이 필요없는 경우 0:FM이 필요한 경우
	int 		iQuickSet						= 2;		// 1 = QuickUrl 사용	, 2 = Service Check 사용
	//iUseNas:0인 경우 아래 설정을 사용해야함. 사용안할 경우라도 변수는 임의의 값으로 설정해야 함
	String		strFileServerIp					= InetAddress.getLocalHost().getHostAddress(); //   
	int 		iFileServerPort					= 18430;		
	
	//iUseNas:1인 경우 메타파일 임시폴더를 설정해야 함. 사용안할 경우라도 변수는 임의의 값으로 설정해야 함
	//*** strDownFolder: 물리적 경로사용 예)/usr/local/apache/htdocs/FPS/ibuuni/markany_noax 
	//String    strCurrentPath       			= pageContext.getServletContext().getRealPath(""); // Weblogic
	String  	strCurrentPath 					= getServletContext().getRealPath("") + "/EPS/html";
	//String  	strDownFolder       			= strCurrentPath + File.separator + "fn"; //metafile location		//log
	String  	strDownFolder       			= "/home/meta/fn";
	String    	strPrtDatDownFolder   			= strCurrentPath + File.separator + "bin" + File.separator;         

	//#############################		setting Install Page  ############	
	int		    iUseInstallPage			      	= 1;	//1: 수동설치 페이지 사용 0: exe 파일을 바로 다운로드
	String    	strInstallFilePath       		= strCurrentPath + "/bin/Setup_ePageSafer.exe";
	String    	strInstallFileName        		= "Setup_ePageSafer.exe";

	//#############################		setting the was file	###############################		
	String  	strContextPath            		= request.getContextPath();
	String  	strUrlHome						= "/module/EPS/html";
	String  	strJspHome						= strUrlHome +"/jsp";
	
	String  	strDownURL  	        		= strDomain + strJspHome+ "/Mafndown.jsp?fn=";  //metafile jsp //log
	String    	strPrtDatDownURL       			= strDomain + strJspHome+ "/Mafndown.jsp?prtdat=MaPrintInfoEPSmain.dat";//log  
	String    	strSessionCheck    				= strDomain + strJspHome+ "/MaSessionCheck.jsp";
	String    	strInstallCheck    				= strDomain + strJspHome+ "/MaSessionCheck_Install.jsp";
	String    	strIePopupURL    				= strDomain + strJspHome+ "/MaIePopup.jsp";
	String  	strSessionURL    				= strDomain + strJspHome+ "/MaSetInstall.jsp?param=" + strSignature + strPVersion;  
	String		registerCookieArr[]				= {"JSESSIONID"};
	//#############################		setting the was file 20160901	###############################		
	//String    strPcpFileDownURL          		= strDomain + strJspHome+ "/Mafndown.jsp?PcpFile=MaPatInfoB.dat";  //pattern

	//#############################		setting the web file	###############################	
	String    	strWebHome          			= strUrlHome;                     	
	String    	strJsWebHome          			= strWebHome + "/js";                     	//js 파일 웹 루트경로
	String		strImagePath					= strWebHome + "/images";  					//imamge 파일 웹 루트경로
	String		strSudongInstallURL				= strWebHome + "/html/Install_Page.html";	//수동설치 페이지 경로
	
	java.text.SimpleDateFormat toformatter = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
	String tototoday = toformatter.format(new java.util.Date());
	String		strPrintURL						= ""; 		// = new String("bak.jsp"); // printparam
	String  	strPrintParam					= ""; 			// = new String("?EndPrint=1"); // printurl

	String  	strSilentOption					= ""; //silent
	String  	strDataFileName					= "";

	//#############################		Client option set	###############################	
	String		PSSTRING						= "";
	String		PSSTRING2						= "";
	String		FAQURL							= "1";
	//String	CP2PARAM						= "1^100^50";
	String		CHARSET							= "UTF-8";
	String		LANGUAGE						= "1^1^"; 				// 0 사용안함, 1 사용^ 0 OS언어설정, 1 한국어, 2 영어, 3 일본어
	//String		TITLE									= "MarkAny Client";
	String		PRINTERDAT						= "";					//"MaPrintInfoEPSetc.dat";
	String		PRINTERVER						= "1^20200101"; 		// 자동업데이트여부(1)^데이타파일날짜
	String		PRINTERUPDATE					= MaBase64Utils.base64Encode( strPrtDatDownURL.getBytes("utf-8") );
	String		VIRTUAL							= "";  					//허용 가상 프로그램	all 허용 : Vk1fQUxMT1dBTEw=
	String 		strFunctionGubun				= "MA";  				// 기존 MA / 보이스바코드 옵션과 함께 OM이라는 옵션 추가 OM : HIDECD 옵션 적용
	String    	PAGEMARGIN           			= "0.25^0.25^0.25^0.25"; //PAGEMARGIN L^T^R^B
	String 		strScope				    	= "2";           		// 1 : binary, 2 : BASE64, 3 : compress binary, 4 : e-mail
	String 		strWidthHeight					= "1";     				// 1 : 세로문서 , 2 : 가로문서
	String 		strFolder				    	= iCellBlockCount + "^" + iCellBlockRow + "^"; // 2D CellCount:2D CellRow
	String		strErrorFilePath				= "";    				// not use
	String		strPrintCount			  		= "1"; 					// 인쇄가능한 횟수    

	//#############################		Add Client option set	###############################	
	String 		SHRINKTOFIT						= "1"; 					// 크기에 맞춰 출력
	String		FIXEDSIZE						= "0"; 					// 윈도우 사이즈 고정
	String		strPrtProtocol					= request.getScheme();  //
	String		PRTAFTEREXIT					= "0";  				// 출력 후 종료
	String		NO2DBARCODE						= "0";  				// 바코드 없이 출력
	String 		strCPParams						= ""; 					//복사방지마크 설정값 : 복사방지마크개수^CD1_X^CD1_Y^CD2_X^CD2_Y...(4^3^38^5^90^108^49^108^102)
	String		STNODATA			  			= "0";        			// Nodata일 경우 인쇄버튼 비활성화
	String		BUCLOSE			  				= "1";        			// 닫기버튼 추가 0 활성화 , 1 비활성화
	String		VIEWPAGE			  			= "0";        			// VIEWPAGE 옵션
	String		WINDOWSIZE			  			= "800^900";        	// 윈도우 사이즈 가로^세로
	String		ZOOMINCONTENT 			  		= "100";        		// 줌인 기능 테스트
	String 		strPrinterZoom 					= "^ZOOM=110.0"; 		//"^ZOOM=110.0"; 리눅스 기준
	String		CPFONTNAME						= "yN641bjFwffDvA==";	//휴먼매직체 //"yN641bXVsdnH7LXltvPAzg=="; //휴먼둥근헤드라인 "SFmw37DttfE="; //HY견고딕
	//#############################		Add Client option set 20171213	###############################	
	String		strPrintCountText				= "1";  					// 잔여 출력 횟수 표시 (기본:0 사용:1)
	String		strPRINTCOPIES					= strPrintCount;  			// 
	//#############################		Add Client option set 20170613	###############################	
	String		CBFONOFF						= "1";  				// 미사용 CBF 사용 여부 확인 (기본 : 1 , 미사용 : 0) 
	String		CBFPERMISSION					= "";  					// 미사용
	String		CBFDIRECTORY					= "";   				// CBF 추가 디렉토리 // C:\\MarkAny^C:\\test
	String		CBFPRPOCESS						= "";  					// CBF 예외 프로세스 // notepad.exe 
	//#############################		Add Client option set 201700627	###############################	
	String		strHIDECD						= "0";
	String 		SCREEN_AREA						= "1";					// 0 기본, 1 전체화면가리기
	String 		strHIDEPRINTPROGRESS			= "1";					// Fasoo PrintWaterMark 클릭 불가 시 
	if (strFunctionGubun.equals("OM")){
		// OM의 경우 복사방지마크를 감추는 옵션 여부를 true로 한다.
		strHIDECD							= "1";
	}	
	// WaterMark - Option
	String		strWmImagePath					= "/";
	String		strWmPosStartX					= "160";				/* 단위 : mm */
	String		strWmPosStartY					= "250";				/* 단위 : mm */
	String  	strWmPosEndX			  		= "0";					/* 0:마지막장 1:첫번째 장, 2:각장 */
	String  	strWmPosEndY				  	= "260";				/* not use */
	// 만약 strWmKey가 "0" 일경우, WaterMark를 지원하지 않음
	String  	strWmKey					    = "0";  				/* 마크애니마크애니 */
	
	// 2D Data
	String		str2dPosLajerX					= "100";				/* 단위 : mm */
	String		str2dPosLajerY					= "270";				/* 단위 : mm */
	String  	str2dPosInkX				  	= "0";					/* not use */
	
	String  	str2dPosInkY				  	= "0";					/* not use */	
	
	//#############################		CP, WM value	Set	###############################	
    String      WMPARAM							= "0^150^170^100";
    String      strCPParam						= "5GFl7G3CfUAqXZD27+9V3952rJhvngVP87k9SepkGfM7a7qJHvgkk6SDQcWPR5YwMF4zXg==";
	//"5GFl7G3CfUAqXZD27+9V3952rJhvngVP87k9SepkGfM7a7qJHvgkk6SDQcWPR5YwMF4xXg=="; // 등록 프린터 지원
	//"5GFl7G3CfUAqXZD27+9V3952rJhvngVP87k9SepkGfM7a7qJHvgkk6SDQcWPR5YwMF4zXg=="; // 모든 프린터 지원
	//35^255^8^255^528^264^인터넷발급^사본^1^280^82^0^0^3^ "5GFl7G3CfUAqXZD27+9V3952rJhvngVP87k9SepkGfM7a7qJHvgkk6SDQcWPR5YwMF4zXg=="
	//35^255^8^255^528^264^인터넷발급^사본^1^280^82^0^0^0^ "5GFl7G3CfUAqXZD27+9V3952rJhvngVP87k9SepkGfM7a7qJHvgkk6SDQcWPR5YwMF4wXg=="
	//1단 16 x 1
	//35^265^8^265^528^264^인터넷발급^사본^1^280^82^0^0^0^ "YXx8X05EkdN5ivPkRb9igRhOc+AJ7zFroB0qwkYzfW0QyA4NkWCG+TbDKsiCZg8cMF4wXg=="  // 등록 프린터 지원
	//35^265^8^265^528^264^인터넷발급^사본^1^280^82^0^0^2^ "YXx8X05EkdN5ivPkRb9igRhOc+AJ7zFroB0qwkYzfW0QyA4NkWCG+TbDKsiCZg8cMF4yXg=="  // 모든 프린터 지원
	//2단 15 x 2
	//40^254^8^254^528^264^인터넷발급^사본^1^280^82^0^0^0^ "r7QAAGFgrVmaLxIktIFQLlyMWBFmeeE20VgzUktM37bBf2HsVJNplUMScVoPcCahMF4wXg=="  // 등록 프린터 지원
	//40^254^8^254^528^264^인터넷발급^사본^1^280^82^0^0^2^ "r7QAAGFgrVmaLxIktIFQLlyMWBFmeeE20VgzUktM37bBf2HsVJNplUMScVoPcCahMF4yXg=="  // 모든 프린터 지원
	String      strCPSubParam           		= "0^8^255^528^264";	 	 //0^8^265^528^264
	// #1단 (0^8^265^528^264) #2단 (0^8^254^700^496) #원본+사본레이어 (1^8^265^528^528) #사본레이어만 ( 0^x^y^w^h) 
	
	String 		strUseTPVM 						= "";//PORTPROMPT
	if (!strUseTPVM.equals("")){
		strCPParam						= "YXx8X05EkdN5ivPkRb9igRhOc+AJ7zFroB0qwkYzfW0QyA4NkWCG+TbDKsiCZg8cMF4yXg=="; 
	}
	//#############################		Add Multi OS Set		###############################	
	String strCPLoc 							= ""; 						//w1^h1^w2^h2
	String strLowCPLoc 							= ""; 						//w1^h1^w2^h2
	String str2DBarcodeLoc						= ""; 						//w^h
	String strTableHeight 						= "970";
	String strStylesheet 						= "";
	String strWMParam 							= "";
	
	// \HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION
	String		strIEBrowserE						= "11"; // 08,09,10,11 // 20(IE11, CERT0),21(IE11, CERT1),22(IE07, CERT0),23(IE07, CERT1)
	
	//#############################		TagLib Set		###############################	
	//File    fileAMeta           				= File.createTempFile ("~Tmp", ".mark", new File(strDownFolder));
    //String  strOrgFileName      				= fileAMeta.getAbsolutePath();
	
%>
