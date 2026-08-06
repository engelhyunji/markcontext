<%@ page import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*" %>
<%@ page import="com.markany.EPageSafer.*"%>
<%@ page import="com.markany.fps.*"%>
<%@ page import="com.markany.futils.*"%>
<%
	/**
		MaFpsCommon.jsp
		ePageSAFER의 서버, 클라이언트와 통신 및 옵션을 설정하기 위한 페이지입니다.
		각 연동의 설정, 미리보기 및 출력 옵션을 설정할 수 있습니다.
		추후 정책 및 환경이 변경될 경우, 아래의 변수들을 변경하시면 됩니다.

		- 해당 페이지는 돋움체를 사용하여 정렬하였습니다. 
	*/
	
	//#############################		common value set	 ###############################
	String  	strApp              			= "maepagesafer";
	String  	strPVersion     				= "25223";
	String 		strSignature 					= "MARKANYEPS";
	
	//#############################		Bacode value set	 ###############################
	String		strMAServerIP 					= "0.0.0.0";
	int			iMAServerPort 					= 18077;
	out.println(iMAServerPort);
	int 		iUse3DanBarcode					= 1;
	int			iCellBlockCount 				= (iUse3DanBarcode == 1) ? 300 : 16; 
	int			iCellBlockRow					= (iUse3DanBarcode == 1) ? 120 : 2; 
	
	int 		iUseEncCookie					= 0;	// 0: 미사용, 1: Enc 적용
	
	//out.println("iCellBlockCount: " + iCellBlockCount);
	//out.println("iCellBlockRow: " + iCellBlockRow);
	
	//#############################		client value set	 ###############################
	String  	strProtocolName     			= request.getScheme();
	String 		strServerName					= request.getServerName();
	int			iServerPort						= request.getServerPort();
	String  	strDomain           			= strProtocolName + "://" + strServerName + ":" + iServerPort;
	
  	//out.println("strDomain: " + strDomain);
	
	//#############################		setting the MA_FPSFM & setting the .matmp file		#############################
	int			iUseNas							= 1;	// 0: FM이 필요한 경우, 1: FM이 필요없는 경우
	int 		iQuickSet						= 2;	// 1: QuickUrl 사용, 2: Service Check 사용
	
	//iUseNas = 0인 경우, 아래 설정 사용. 사용 안하더라도 변수는 임의의 값으로 설정해야 함.
	String		strFileServerIp					= InetAddress.getLocalHost().getHostAddress();	// 서버 IP
	int 		iFileServerPort					= 18430;										// MA_FPSFM 포트
	
	//iUseNas = 1인 경우, 메타파일 임시 폴더를 설정해야 함. 사용 안하더라도 변수는 임의의 값으로 설정해야 함.
	//[물리적 경로 예시] strDownFolder = /usr/local/apache/htdocs/FPS/ibuuni/markany_noax 
	String  	strCurrentPath 					= getServletContext().getRealPath("") + "html/html";
	String  	strDownFolder       			= strCurrentPath + File.separator + "fn";		// 메타파일 임시 폴더
	String    	strPrtDatDownFolder   			= strCurrentPath + File.separator + "bin" + File.separator;
	
	//out.println("strCurrentPath: " + strCurrentPath);
	out.println("strDownFolder: " + strDownFolder);
	
	//#############################		setting Install Page	 #############################
	int		    iUseInstallPage			      	= 1;	// 0: exe 파일 바로 다운로드, 1: 수동설치 페이지 사용
	String    	strInstallFileName        		= "Setup_ePageSafer.exe";
	String    	strInstallFilePath       		= strPrtDatDownFolder + strInstallFileName;
	
	//out.println("strInstallFilePath: " + strInstallFilePath);

	//#############################		setting the was file	 ###############################		
	String  	strUrlHome						= request.getContextPath() + "/EPS/html";
	String  	strJspHome						= strUrlHome +"/jsp";
	
	String  	strDownURL  	        		= strDomain + strJspHome+ "/Mafndown.jsp?fn=";  // metafile jsp
	String    	strPrtDatDownURL       			= strDomain + strJspHome+ "/Mafndown.jsp?prtdat=MaPrintInfoEPSmain.dat";  
	String    	strSessionCheck    				= strDomain + strJspHome+ "/MaSessionCheck.jsp";
	String    	strInstallCheck    				= strDomain + strJspHome+ "/MaSessionCheck_Install.jsp";
	String    	strIePopupURL    				= strDomain + strJspHome+ "/MaIePopup.jsp";
	String  	strSessionURL    				= strDomain + strJspHome+ "/MaSetInstall.jsp?param=" + strSignature + strPVersion;  
	String		registerCookieArr[]				= {"JSESSIONID"};
	
	//#############################		setting the web file	###############################	
	String    	strWebHome          			= strUrlHome;                     	
	String    	strJsWebHome          			= strWebHome + "/js";                     	// js 파일 웹 루트경로
	String		strImagePath					= strWebHome + "/images";  					// imamge 파일 웹 루트경로
	String		strSudongInstallURL				= strWebHome + "/html/Install_Page.html";	// 수동설치 페이지 경로
	
	String  	strSilentOption					= "";										// silent
	String  	strDataFileName					= "";										// 프린터 데이터 파일 이름
	
	//#############################		Client option set	 ###############################	
	String 		strFunctionGubun				= "MA";  										// 기본: MA, 보이스바코드: OM(HIDECD 옵션 적용)
	String 		strScope				    	= "2";           								// 1: binary, 2: BASE64, 3: compress binary, 4: e-mail
	String 		strWidthHeight					= "1";     										// 1: 세로문서 , 2: 가로문서
	String 		strFolder				    	= iCellBlockCount + "^" + iCellBlockRow + "^";	// 2D CellCount:2D CellRow
	String		strErrorFilePath				= "";    										// not use
	
	// UI 옵션
	String		HIDEFRAME						= "0";						// 뷰어 시각화 설정 (0: 뷰어 보임, 1: 뷰어 안 보임)
	String 		strHIDEPRINTPROGRESS			= "1";						// 출력 진행창 설정 (0: 출력 진행창 보임, 1: 출력 진행창 안 보임)
	String		NOSETPRTECO						= "0";						// 출력 진행창 설정 (0: 출력 진행창 안 보임, 1: 출력 진행창 보임)
	String		ZOOMINCONTENT 			  		= "100";        			// 줌인 기능 (기본: 100(%))
	String		FIXEDSIZE						= "0"; 						// 뷰어 크기 고정 여부 (0: 뷰어 크기 조절 가능, 1: 뷰어 크기 고정)
	String		WINDOWSIZE			  			= "800^900";				// 뷰어 크기 설정 (가로^세로)
	String    	PAGEMARGIN           			= "0.25^0.25^0.25^0.25"; 	// 문서 여백 설정 (왼쪽^위쪽^오른쪽^아래쪽)
	String		VIEWPAGE			  			= "0";						// 뷰잉 타입 설정 (0: 기본, 1, 2: 뷰어 상단에 페이지 번호와 다음 페이지로 넘기는 버튼 생성 (1: 출력 시 프린터 선택 창에서 전체 또는 현재 페이지 출력 선택 가능))
	String		LANGUAGE						= "1^1"; 					// 언어 설정: 사용 여부(0: 사용 X, 1: 사용)^언어(1: 한국어, 2:영어, 3:일본어)
	String		STNODATA			  			= "0";        				// 인쇄 버튼 활성화 여부 (0: 버튼 활성화, 1: 버튼 비활성화)
	String		BUCLOSE			  				= "1";        				// 뷰어 오른쪽 상단 닫기 버튼 생성 (0: 버튼 생성, 1: 없음)
	String		ICP								= "0";                      // = "MV5tYXJrYW55XmZvbnReMl4yMF4zMF4xMF4wXjBeMTBeMF4w";  // ICP 설정: 사용 여부(0: 사용 X, 1: 사용)^문구^폰트(적용 불가)^패턴^투명도^기울기^1번 텍스트 크기^1번 텍스트 x좌표^1번 텍스트 y좌표^2번 텍스트 크기^2번 텍스트 x좌표^2번 텍스트 y좌표 (1^markany^font^2^20^30^10^0^0^10^0^0)
	String		strPrintCountText				= "1";  					// 뷰어 상단에 발급 가능 매수 표시 (0: 표시 X, 1: 표시)
	String		PRINTTOTALNUM					= "";						// 현재 페이지/총 페이지 표시 여부 설정: 사용 여부(0: 사용 X, 1: 사용)^x좌표^y좌표
	String		ENDURL							= "";						// 뷰어 닫을 때 설정한 창 띄우기 (띄우고 싶은 url 입력)
	
	// 프린터
	String		DEFAULTPRT						= "";																// 기본 프린터로 출력 설정 (1: 인쇄 버튼 클릭 시 기본 프린터로 바로 출력)
	String		PRINTERVER						= "1^20200101"; 													// 프린터 데이터 파일 업데이트: 자동 업데이트 여부(0: 수동, 1: 자동)^데이터 파일 날짜
	String		PRINTERUPDATE					= MaBase64Utils.base64Encode(strPrtDatDownURL.getBytes("utf-8"));	// 프린터 데이터 파일 다운로드 (PRINTERVER 변수의 자동 업데이트 여부에 따라 업데이트)
	String		strPrintCount				  	= "1"; 																// 출력 가능 매수 설정 (원하는 매수 설정)   
	String		strPRINTCOPIES					= strPrintCount;  													// 한 번에 출력할 수 있는 매수 설정
	
	// 이벤트
	String		PRINTINGENDPOPUP				= "";								// 출력 확인용 팝업(페이지마다 팝업 뜸): 원하는 메시지 입력
	String		PRTAFTEREXIT					= "0";  							// 출력 후 뷰어 종료 (0: 사용자가 뷰어 직접 종료, 1: 뷰어 자동 종료)
	String		AUTOCLOSE						= "0";								// 출력 후 뷰어 자동 닫힘 설정 (0: 안함, 1: 자동 닫힘)
	String		strPrintURL						= "";                               // = strUrlHome + "/temp/test.jsp";	// 출력 확인 ex) strUrlHome + "/temp/test.jsp"
	String		strPrintParam				    = "";                               // = "?print=success";			    // 출력 확인 파라미터 ex) ?print=success
	String		PRTFAILURL						= "";								// 출력 실패 시 호출할 URL 설정: 원하는 URL 입력
	
	// 바코드
	String      strCPParam						= "5GFl7G3CfUAqXZD27+9V3952rJhvngVP87k9SepkGfM7a7qJHvgkk6SDQcWPR5YwMF4zXg==";	// 바코드 위치 및 지원 프린터 설정 (바코드 x좌표^바코드 y좌표^복사방지마크 x좌표^복사방지마크 y좌표^원본레이어문구^사본레이어문구^복사방지마크종류(0~3)^사본레이어폰트크기^원본레이어문구폰트크기^원본레이어문구내시작x좌표^원본레이어문구내시작y좌표^지원프린터설정)
	String		NO2DBARCODE						= "0";  																		// 바코드 없이 출력 (0: 바코드, 1: 바코드 X)
	
	// 복사방지마크
	String		CPFONTNAME						= "yN641bjFwffDvA==";				// 원본이 아닌 복사방지마크 폰트 설정 (휴먼매직체: yN641bjFwffDvA==, 휴먼둥근헤드라인: yN641bXVsdnH7LXltvPAzg==, HY견고딕: SFmw37DttfE=)
	String      strCPSubParam		           	= "0^8^255^528^264";				// 복사방지마크 크기 및 위치 설정: 사용 여부(0: 원본만 사용, 1: 같이 사용)^x좌표^y좌표^가로 픽셀 크기^세로 픽셀 크기
	String 		strCPParams						= "4^3^38^5^90^108^49^108^102";		// 복사방지마크 여러 개 출력 설정: 복사방지마크 개수^CD1_X^CD1_Y^CD2_X^CD2_Y...(strCPSubParam 사용 여부 1일 때만 출력)
	
	String		strHIDECD						= "0";								// 복사방지마크 출력 여부 (0: 출력, 1: 출력 X)
	
	// OM의 경우, 복사방지마크를 감추는 옵션을 true로 한다.
	if (strFunctionGubun.equals("OM")){
		strHIDECD = "1";
	}
	
	// 바코드 하단 문구 1,2,3: 사용 여부(0: 사용 X, 1: 사용)^x좌표^y좌표^텍스트 사이즈^폰트 사이즈^문구
	// 사용 여부^x좌표^y좌표^텍스트 사이즈^폰트 사이즈 생략 가능 및 생략 시 PSUNDERBAR 설정에 따라 문구 생성
	String		PSSTRING						= ""; // = "1^35^277^250^80^odhJZGVudGlmeSB0aGUgYXV0aGVudGljaXR5IG9mIGNlcnRpZmljYXRlIGZvciB2ZXJpZmljYXRpb24gd2l0aCB0aGUgd2Vic2l0ZS4oaHR0cDovL2NlcnQua29yY2hhbS5uZXQvc2VhcmNoKQ==";
	String		PSSTRING2						= ""; // = "1^35^280^250^80^MsXXvbrGrjLF1726xq4yxde9usauMsXXvbrGrjLF1726xq4yxde9usauMsXXvbrGrjLF1726xq4yxde9usauMsXXvbrGrg==";
	String		PSSTRING3						= ""; // = "M8XXvbrGrjPF1726xq4zxde9usauM8XXvbrGrjPF1726xq4zxde9usauM8XXvbrGrjPF1726xq4zxde9usauM8XXvbrGrg==";		// 문구만 입력 (위치 설정 불가): PSUNDERBAR 값 없으면, 복사방지마크 시작 위치에 문구 생성
	String		PSUNDERBAR						= "";																										// PSSTRING 위치 설정 (0: 복사방지마크 시작 위치에 문구 출력, 1: 바코드 시작 위치에 문구 출력)
	
	// 보안 옵션
	String		VIRTUAL							= "";  					// 허용할 가상 프로그램 설정	(모두 허용 : Vk1fQUxMT1dBTEw=)
	String 		SCREEN_AREA						= "1";					// 캡처 도구 사용 시 화면 가리기 (0: 뷰어만 가리기, 1: 전체 화면 가리기)
	
	// 내부용 옵션
	String 		strUseTPVM 						= "";                   // = "PORTPROMPT";	// PDF 저장 설정 (PORTPROMPT)
	if (!strUseTPVM.equals("")) {
		strCPParam	= "5GFl7G3CfUAqXZD27+9V3952rJhvngVP87k9SepkGfM7a7qJHvgkk6SDQcWPR5YwMF4yXg==";	// 35^255^8^255^528^264^인터넷발급^사본^1^280^82^0^0^2^
	}
	
	//#############################		사용 시 MaFpsTail.jsp에서 주석 해제 필요	 ###############################	
	//String		CHARSET							= "UTF-8";					// 문서 인코딩 설정 (UTF-8, EUC-KR...)
	// QR 코드: URL^x좌표^y좌표^가로 크기^세로 크기^dpi^옵션(1: 앞장만 찍음)^0^0^0^0
	//String		QRENCDATA						= ""; // = "aHR0cHM6Ly9lcGFnZS5tYXJrYW55LmNvbS9tb2R1bGUvRVBTL2luZGV4Lmh0bWxeMTkyXjdeMzAwXjMwMF4zMDBeMV4wXjBeMF4w";	// https://epage.markany.com/module/EPS/index.html^192^7^300^300^300^1^0^0^0^0
	
	//#############################		Add Multi OS Set	 ###############################	
	String strCPLoc 							= ""; 						//w1^h1^w2^h2
	String strLowCPLoc 							= ""; 						//w1^h1^w2^h2
	String str2DBarcodeLoc						= ""; 						//w^h
	String strTableHeight 						= "970";
	String strStylesheet 						= "";
	String strWMParam 							= "";
	
	// \HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION
	String		strIEBrowserE						= "11";                 // 08,09,10,11 // 20(IE11, CERT0),21(IE11, CERT1),22(IE07, CERT0),23(IE07, CERT1)
	
	//#############################		TagLib Set		###############################	
	//File    fileAMeta           				= File.createTempFile ("~Tmp", ".mark", new File(strDownFolder));
    //String  strOrgFileName      				= fileAMeta.getAbsolutePath();
	
%>
