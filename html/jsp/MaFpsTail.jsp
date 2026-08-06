<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*" %>
<%@ page import="com.markany.aes.MaUrlRdBase64"%>
<%@ page import="com.markany.futils.*"%>
<%@include file="MaFunction.jsp"%>
<div id='markanybody'></div>
<%
	//##################################### Make Meta start ##################################
	MaUrlRdBase64 maEncUtil = new MaUrlRdBase64();
	String strTmpAMetaData;
	maprestreambase64 clMaPreStreamBase64 = new maprestreambase64();
	String strMaPrestreamReturn = new String(clMaPreStreamBase64.strMaPrestreamByte(
                            				strMAServerIP,
                            				iMAServerPort,
											strFunctionGubun,
											strScope,
											strWidthHeight,
											strPrintCount,
											strFolder,
											byteReadHtmlData,
											iReadHtmlDataSize,
											strErrorFilePath ));
  	strTmpAMetaData = new String(strMaPrestreamReturn.substring(maprestreambase64.iRetCodeEndIdx));
  	String strRetCode = new String(strMaPrestreamReturn.substring(maprestreambase64.iRetCodeStartIdx, maprestreambase64.iRetCodeEndIdx));
  	int	iRetCode = Integer.parseInt(strRetCode);
		
	if (iRetCode != 0) {
		if (iRetCode == 1001 || iRetCode == 10001) {
			out.println("Error code : " + iRetCode + " 마크애니 데몬프로세스를 구동해주세요.");
		} else {
			out.println("Error code : " + iRetCode);
		}
		out.close();
		//return	
	}
	
	//##################################### Make Meta end ##################################
	int			iAMetaDataSize = strTmpAMetaData.length();
	String		strAMetaData = replaceAll( strTmpAMetaData, "\n", "\\n");
	String 		osversion = "";
	String 		strPath = "";
	String 		strAddData = "";
	int 		iRetBro = 0;
	String 		browsername = "";
	String 		browserversion = "";
	int 		iBrowserVer = 0;
	int 		iRetOsCheck = 0;
	boolean 	bLinuxSock = true;
	boolean 	bMacSock = true;
	

	
	String info = request.getHeader("User-Agent");
	if (info != null) {
		String browserInfoArr[] = getBrowserInfo(info);
		browsername = browserInfoArr[0];
		browserversion = browserInfoArr[1];
		iBrowserVer = Integer.parseInt(browserversion.trim());
	}
	
	if (info.indexOf("Windows") > 0) {
		iRetOsCheck = 1;
	} else if ((info.indexOf("Macintosh") > 0) || (info.indexOf("Linux") > 0)) {
		iRetOsCheck = 2;
	} else {
		iRetOsCheck = 3;
	}
	HttpSession session1 = request.getSession(false);
	if (session1 == null) {
		session1 = request.getSession(true);
	}
  
	String strSID = session.getId();
	String strCookie = "";
	Cookie[] cookies = request.getCookies();
	if (cookies != null) {
		for (int i = 0; i < cookies.length; i++) {   // 20180716
		//for( int i = cookies.length -1; i >=0; i--){
			for( int cN_i=0; cN_i<registerCookieArr.length; cN_i++){
				if( !cookies[i].getName().equals(registerCookieArr[cN_i]) ){
					continue;
				}
				strCookie += cookies[i].getName() + "="	+ cookies[i].getValue() + ";";
			}
			//break; // 20180716
		}
	}
	if (iRetOsCheck == 1) {
		strCookie = "Cookie: " + strCookie;
		//strCookie = "Cookie:JSESSIONID=" + strSID;
	}
	byte	byteCookieData[] = strCookie.getBytes ("utf-8"); 
	String	strBase64Cookie = "";
	// ----------------------------------------- Client Version Check --------------------------------------------
	int iSessionCheck = 0;
	String	strVersion = null;
	String pversion = (String)session.getAttribute("productversion");   
	
	if(pversion != null && pversion.indexOf("MARKANYEPS") >= 0)
	{
		strVersion = replaceAll( pversion, "MARKANYEPS", "");
		int iCurrent = Integer.parseInt(strPVersion);
		int iSession = Integer.parseInt(strVersion);
			  
		if(iSession >= iCurrent)
			iSessionCheck = 1;
	}
	// ----------------------------------------- OS Check --------------------------------------------
	

	if (iRetCode == 0) {
		if (iRetOsCheck == 1) {
			//############################################## Windows OS ##############################################
			strAddData = "";
			strAddData += "#META_SIZE=" + String.valueOf(iAMetaDataSize);
			
			strAddData += "#HIDEFRAME=" + HIDEFRAME;
			strAddData += "#HIDEPRINTPROGRESS=" + strHIDEPRINTPROGRESS;
			strAddData += "#NOSETPRTECO=" + NOSETPRTECO;
			strAddData += "#ZOOMINCONTENT=" + ZOOMINCONTENT;
			strAddData += "#FIXEDSIZE=" + FIXEDSIZE;
			strAddData += "#WINDOWSIZE=" + WINDOWSIZE;
			strAddData += "#PAGEMARGIN=" + PAGEMARGIN;
			strAddData += "#VIEWPAGE=" + VIEWPAGE;
			strAddData += "#LANGUAGE=" + LANGUAGE;
			strAddData += "#STNODATA=" + STNODATA;
			strAddData += "#BUCLOSE=" + BUCLOSE;
			strAddData += "#ICP=" + ICP;
			strAddData += "#PRINTTEXT=" + strPrintCountText;
			strAddData += "#PRINTTOTALNUM=" + PRINTTOTALNUM;
			strAddData += "#ENDURL=" + ENDURL;
			
			strAddData += "#PRINTERDAT=" + strDataFileName;
			strAddData += "#DEFAULTPRT=" + DEFAULTPRT;
			strAddData += "#PRINTERVER=" + PRINTERVER;
			strAddData += "#PRINTERUPDATE=" + PRINTERUPDATE;
			strAddData += "#PRINTCNT=" + strPrintCount;
			strAddData += "#PRINTCOPIES="+ strPRINTCOPIES;
			
			strAddData += "#PRINTINGENDPOPUP=" + PRINTINGENDPOPUP;
			strAddData += "#PRTAFTEREXIT=" + PRTAFTEREXIT;
			strAddData += "#AUTOCLOSE=" + AUTOCLOSE;

			strAddData += "#PRTURL=" + strPrintURL;
			strAddData += "#PRTPARAM=" + strPrintParam;
			strAddData += "#PRTFAILURL=" + PRTFAILURL;
			
			strAddData += "#CPPARAM=" + strCPParam;
			strAddData += "#NO2DBARCODE=" + NO2DBARCODE;
						
			strAddData += "#CPFONTNAME=" + CPFONTNAME;
			strAddData += "#CPSUBPARAM=" + strCPSubParam;
			strAddData += "#COPYPARAMS=" + strCPParams;
			strAddData += "#HIDECD=" + strHIDECD;
			
			strAddData += "#PSSTRING=" + PSSTRING;
			strAddData += "#PSSTRING2=" + PSSTRING2;
			strAddData += "#PSSTRING3=" + PSSTRING3;
			strAddData += "#PSUNDERBAR=" + PSUNDERBAR;
			
			strAddData += "#PRTPROTOCOL=" + strProtocolName;
			strAddData += "#PRTIP=" + strServerName;
			strAddData += "#PRTPORT=" + String.valueOf(iServerPort);
			strAddData += "#VIRTUAL=" + VIRTUAL;
			strAddData += "#SCREEN_AREA =" + SCREEN_AREA;
			
			//strAddData += "#CHARSET=" + CHARSET;
			//strAddData += "#QRENCDATA=" + QRENCDATA;
			
			// 내부용 옵션
			if (!strUseTPVM.equals("")){
				strAddData += "#SUPPORTPRTPORT=ZOX5/IFJv8PlAXajhzpfdlJPTVBU";
			}
			
			strAddData = replaceAll(strAddData, "\\n", "\n");
		}
		
		if (iRetOsCheck == 1 || iRetOsCheck == 2) { // url request
			//MD5, MD4, SHA-1, SHA-256, SHA-512 등 사용 가능.
			//String strUserID = "markany";
			//session.setAttribute("userid", strUserID);
			//String strHashID = Hash(strUserID, "MD5");
			java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHHmmssSSS");
			String strEncFileServerIP = MaBase64Utils.base64Encode(strFileServerIp.getBytes("euc-kr"));
			
			String today = formatter.format(new java.util.Date()); 				
			strPath = strSID + today + ".matmp";
			String filePath = strDownFolder + "/";//request.getRealPath(strDownFolder) + "/"; //파일을 생성할 전체경로
			filePath += strPath; //생성할 파일명을 전체경로에 결합
			strDownURL += today; //down url 

			if (iUseNas == 1) {
				BufferedWriter fw = null;
				try {
					fw=new BufferedWriter(new FileWriter(new File(filePath)));
					fw.write(strTmpAMetaData + strAddData); //fw.write(strAMetaData + strAddData); //파일에다 작성
					fw.flush();
				} catch (IOException e) { 
					System.out.println("markany_filewrite buffer Error");
					//e.printStackTrace(System.err);
				} finally {
					if (fw != null) {
						fw.close(); //파일핸들 닫기
					}
				}
			} else {
				masavefile clMaSaveFile = new masavefile();
				
				// FileSerevrIP 정보를 파라미터로 보냄
				strDownURL += "&fs=" +strEncFileServerIP;
				
				// Call Ma2DCode library
				try
				{
					strRetCode = clMaSaveFile.strSaveMetaFile (
											strFileServerIp,
											iFileServerPort,
											strPath,
											strTmpAMetaData + strAddData,
											"",
											"" );
					iRetCode = Integer.parseInt( strRetCode );
				}
				catch( UnsatisfiedLinkError e )
				{
					System.out.println("markany_filewrite buffer Error");
					//e.printStackTrace(System.err);
				}
			}
			session.setAttribute("strDownURL", strDownURL);
			session.setAttribute("strCookie", strCookie);
		}
	}
	String 	strBase64DownURL = "";
	String 	strBase64SessionURL = MaBase64Utils.base64Encode( strSessionURL.getBytes ("utf-8") );
	
	if (iUseEncCookie == 1) {
		strBase64Cookie = maEncUtil.strUrlRdEncode( strCookie);
		strBase64DownURL = maEncUtil.strUrlRdEncode( strDownURL);
	} else {
		strBase64Cookie = MaBase64Utils.base64Encode( byteCookieData );
		strBase64DownURL = MaBase64Utils.base64Encode( strDownURL.getBytes ("utf-8") );
	}
	if (iRetCode != 0) {
		if (iRetCode == 1001 || iRetCode == 10001) {
			out.println("Error code : " + iRetCode + " 마크애니 데몬프로세스를 구동해주세요.");
		} else if (iRetCode == 70007) {
			out.println("Error code : " + iRetCode + " 바코드 사이즈가 작습니다.");
		}
		//out.close();
		return;	
	}
	
	
	String LaunchRegistAppCommand = "";
	if (iQuickSet == 1) {
		LaunchRegistAppCommand = "quickurl";
	} else if (iQuickSet == 0 || iQuickSet == 2) {
		if (iSessionCheck == 0) {
			LaunchRegistAppCommand = "registapp";
		} else {
			LaunchRegistAppCommand = "sockmeta";
		}
	}
	//String strLang = "2";
%>			
	<!DOCTYPE HTML>
	<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta charset="utf-8">
		<TITLE>::: 전자확인증 발급 :::</TITLE>
		<link rel="stylesheet" type="text/css" href="<%=strWebHome%>/css/MaCommon.css?version=20180112">
		<script src="<%=strJsWebHome%>/jquery-3.7.1.min.js" charset="utf-8"></script>
		<script src="<%=strJsWebHome%>/MaXHRControl.js?version=20230320" charset="utf-8"></script> 		
		<script src="<%=strJsWebHome%>/json2.js" charset="utf-8"></script>
		<script src="<%=strJsWebHome%>/MaVerCheck.js?version=20200604" charset="utf-8"></script>
		<script>
			// ***********************************************************************************//
			var viUseEncCookie				= "<%=iUseEncCookie%>";
			// ***********************************************************************************//
			var vstrSCookie					= "<%=strBase64Cookie%>";
			var vstrSessionCheck 			= "<%=strSessionCheck%>";
			var vstrSDownURL				= "<%=strBase64DownURL%>";
			var vstrSSessionURL				= "<%=strBase64SessionURL%>";
			var vstrSudongInstallURL    	= "<%=strSudongInstallURL%>";
			var vstrApp 					= "<%=strApp%>"; 
			var vstrIePopupURL 				= "<%=strIePopupURL%>";
			// ***********************************************************************************//		
			//var vstrCookie 					= "<%=strCookie%>";
			var iVersion  					= "<%=strPVersion%>";
			var viQuickSet					= "<%=iQuickSet%>";
			var viRetOsCheck				= "<%=iRetOsCheck%>";
			var vpversion 					= "<%=pversion%>";
			var resize_height 				= 950;	//default 450
			// ***********************************************************************************//
			var vstrIEBrowserE				= "<%=strIEBrowserE%>"; 
			// ***********************************************************************************//
			if (viQuickSet == 2 ){
				//var checkFileInfo_1 		= [iVersion			, 0x0026	, "y85/zv65HGcOkFXjRS2WVg=="	, "TWFya0FueVxtYWVwc3J0"			];
				var checkFileInfo_1 		= [iVersion			, 0x0026	, "ZVBhZ2VTYWZlci5leGU="	, "TWFya0FueVxtYWVwcw=="			];
				var chkFileArray 			= new Array(checkFileInfo_1);
				
				//var executeBinaryInfo_1		= [GetParamData(vstrApp)		, 0x0026	, "y85/zv65HGcOkFXjRS2WVg=="	, "TWFya0FueVxtYWVwc3J0"		];
				var executeBinaryInfo_1		= [GetParamData(vstrApp)		, 0x0026	, "ZVBhZ2VTYWZlci5leGU="	, "TWFya0FueVxtYWVwcw=="		];
				var executeBinaryArray 		= new Array(executeBinaryInfo_1);
				
				
			}else {
				if( viQuickSet === 1){
					resize_height -= 200;
				}
				window.name 				= 'popWinC';
				var browserName				= <%=iSessionCheck%>===1?'installCheckSuccess':get_browser();
				switch (browserName){
				case "installCheckSuccess":
					resize_height = 500;
					break;
				case "Opera":
					resize_height = 600;
					break;
				case "Safari":
					resize_height = 600;
					break;
				case "Chrome":
					resize_height = 950;
					break;
				case "MSIE":
				case "Edge":
					resize_height = 500;
					break;
				case "Firefox":
					resize_height = 650;
					break;
				}
			}
			window.resizeTo(650, resize_height); //550
		</script>
	</head>
<%
	if( iQuickSet == 2 ){
%>
	<BODY LEFTMARGIN="0" TOPMARGIN="0" RIGHTMARGIN="0" bottommargin="0" marginwidth="0" marginheight="0">
		<div id="popLayer" style="display: none;">
			<h3>ePageSAFER</h3>
			<div id="installSection">
				<div id="ment">증명서의 안전한 출력을 위해 보안 프로그램의 설치체크 여부를 확인 중입니다.</div>
				<div id="progressbar">
					<img src="<%=strImagePath%>/loading_c.gif">
				</div>
			</div>
			<div id="btnSection">
			<!--
				<button id="btn_maInstall" class="btn-class" disabled onclick="javascript:location.href='<%=strWebHome%>/bin/Setup_ePageSafer.exe'">다운로드</button>
				<!--<button id="btn_maInstall" class="btn-class" disabled onclick="javascript:location.href='https://download.kbstar.com/package/com/markany/Setup_ePageSafer.exe'">다운로드</button>-->
			<!--	<button id="btn_closePopLayer" class="btn-class" onclick="javascript:closeWindow()">닫기</button>
				<img src="https://epage.markany.com/module/EPS/html/images/canari.png" style="width: 500px; display: block; margin: 10px auto;"><br> -->
			<button id="btn_maInstall" class="btn-class" disabled onclick="javascript:location.href='<%=strUrlHome%>/bin/Setup_ePageSafer.exe'">다운로드</button>
				<button id="btn_closePopLayer" class="btn-class" onclick="javascript:closeWindow()">닫기</button>
				<section id="guideSection">
					<h3 class="guide-title">※ 설치 후 브라우저 설정 안내</h3>
					<p class="guide-desc">
						프로그램 설치 후 정상적으로 동작하지 않을 경우, 아래 안내에 따라 브라우저 설정을 확인해 주세요.
					</p>
					<div class="guide-step">
						<div class="step-header">
							<span class="step-number">1</span>
							<span class="step-text" id="step1Text"></span>
						</div>
						<div class="step-image">
							<img class="guide-img" data-guide="guide_site_setting" src="<%=strImagePath%>/guide_site_setting_chrome.png" alt="사이트 설정 진입 안내 이미지" style="max-width: 60%;">
						</div>
					</div>
					<div class="guide-step">
						<div class="step-header">
							<span class="step-number">2</span>
							<span class="step-text" id="step2Text"></span>
						</div>
						<div class="step-image">
							<img class="guide-img" data-guide="guide_app_allow" src="<%=strImagePath%>/guide_app_allow_chrome.png" alt="기기에 있는 앱 허용 설정 안내 이미지">
						</div>
					</div>
				</section>
				<p class="guide-notice">※ 위 안내 이미지는 이해를 돕기 위한 예시이며, 실제 화면과 다를 수 있습니다.</p>
				<style>
					#guideSection {
						max-width: 1200px;
						margin: 30px auto 0;
						padding: 28px 32px;
						border: 1px solid #d0d0d0;
						border-radius: 8px;
						background-color: #fafafa;
						text-align: center;
					}
					.guide-title { font-size: 17px; color: #333; margin: 0 0 8px 0; }
					.guide-desc { font-size: 15px; color: #d32f2f; font-weight: bold; margin: 0 0 24px 0; line-height: 1.6; }
					.guide-step { margin-bottom: 28px; text-align: center; }
					.guide-step:last-child { margin-bottom: 0; }
					.step-header { display: inline-flex; align-items: center; justify-content: center; margin-bottom: 14px; }
					.step-number { display: inline-flex; align-items: center; justify-content: center; width: 28px; height: 28px; border-radius: 50%; background-color: #1a56db; color: #fff; font-size: 14px; font-weight: bold; margin-right: 10px; flex-shrink: 0; }
					.step-text { font-size: 16px; color: #333; line-height: 1.5; text-align: left; }
					.step-image { text-align: center; margin: 0 auto; }
					.step-image img { max-width: 70%; border: 1px solid #ddd; border-radius: 4px; box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08); }
					.guide-notice { text-align: center; font-size: 13px; color: #999; margin-top: 16px; }
				</style>
				<script>
					// 브라우저별 안내 이미지/텍스트 분기
					// Edge: _edge / 그 외(Chrome / Whale 등): _chrome
					(function () {
						var IMAGE_BASE = "<%=strImagePath%>/";
						var ua = navigator.userAgent;

						// Edge만 분기 (Whale은 Chrome 기준으로 _chrome 사용)
						var isEdge = /\bEdg(e|A|iOS)?\//i.test(ua);  // 신/구버전 Edge
						var suffix = isEdge ? "_edge" : "_chrome";

						// 안내 이미지 교체
						var images = document.querySelectorAll(".guide-img");
						for (var i = 0; i < images.length; i++) {
							var name = images[i].getAttribute("data-guide");
							images[i].src = IMAGE_BASE + name + suffix + ".png";
						}

						// 안내 텍스트 교체 (브라우저별 설정 경로가 달라 문구도 분기)
						var guideText = {
							_chrome: {
								step1: '브라우저 주소창 옆 아이콘을 클릭한 후, <strong>사이트 설정</strong>을 선택합니다.',
								step2: '<strong>기기에 있는 앱</strong> 항목을 찾아 <strong>허용</strong>으로 변경합니다.'
							},
							_edge: {
								step1: '브라우저 주소창 옆 아이콘을 클릭한 후, <strong>이 사이트에 대한 사용 권한</strong>을 선택합니다.',
								step2: '<strong>사이트에서 로컬 네트워크의 모든 장치에 연결하도록 요청할 수 있습니다.</strong>를 <strong>허용</strong>으로 변경합니다.'
							}
						};

						var texts = guideText[suffix];
						var step1 = document.getElementById("step1Text");
						var step2 = document.getElementById("step2Text");
						if (step1) step1.innerHTML = texts.step1;
						if (step2) step2.innerHTML = texts.step2;
					})();
				</script>
			</div>
		</div>
	</BODY>
	</HTML>
	<script>
		window.addEventListener('load', function() { showPopup(); }); //showPopup();
	</script>
<%
	}else {
%>	
	<BODY LEFTMARGIN="0" TOPMARGIN="0" RIGHTMARGIN="0" bottommargin="0" marginwidth="0" marginheight="0">
		<iframe id="hidpopWinC" name="hidpopWinC" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling="auto"></iframe>
		<div class="container">
			<div class="content">
				<div class="section" id="browserChkImgSection">
					<img id="browserChkImg">
				</div>
			</div>
			<div class="section">
				<p id="browserChkComment"></p>
			
					
				<div class="section" id="printBtnSection">
					<input type="button" onclick="location.href='<%=strJspHome%>/MaSessionCheck.jsp'" value="문서발급">
					<br><br>
					<!--<hr>
					<p>* 미설치, PC에 설치된 버전이 낮을 경우 문서발급을 누르시면 설치페이지로 이동합니다.</p>
					<hr>
					-->
				</div>
			</div>
		</div>
		<script>
		LaunchRegistApp(vstrApp, "<%=LaunchRegistAppCommand%>", vstrIePopupURL); 
		
		document.oncontextmenu		= document.body.oncontextmenu = function() {return false;}
		var browserChkImg			= document.getElementById("browserChkImg");
		var browserChkComment		= document.getElementById("browserChkComment");
		var printBtnSection			= document.getElementById("printBtnSection");
		var browserChkImgSection	= document.getElementById("browserChkImgSection");
	
		switch (browserName){
		case "installCheckSuccess":
			browserChkImgSection.innerHTML ='<img src="<%=strImagePath%>/loading.gif" id="browserChkImg"><br>'
											+'<img src="<%=strImagePath%>/Ma_progressBar.gif"><br>'
											+'<img src="<%=strImagePath%>/notice.png"><br>';
			printBtnSection.style.display = "none";
			break;
		case "Opera":
			browserChkImg.src = "<%=strImagePath%>/check_guide_opera.png";
			browserChkComment.innerHTML = 	'* 외부 프로토콜 요청 팝업이 보이실 경우 다음과 같이 진행해주십시오<br>'
											+ '<br> 1. [mareportsafer. 링크 항상 열기] 체크 합니다.'
											+ '<br> 2. [허용] 버튼을 누릅니다.';
			printBtnSection.style.display = "none";
			break;
		case "Safari":
			browserChkImg.src = "<%=strImagePath%>/check_guide_opera.png";
			browserChkComment.innerHTML = 	'* 외부 프로토콜 요청 팝업이 보이실 경우 다음과 같이 진행해주십시오<br>'
											+ '<br> 1. [mareportsafer. 링크 항상 열기] 체크 합니다.'
											+ '<br> 2. [허용] 버튼을 누릅니다.';
			printBtnSection.style.display = "none";
			break;
		case "Chrome":
			browserChkImg.src = "<%=strImagePath%>/check_guide_chrome.png";
			browserChkComment.innerHTML = 	'* 외부 프로토콜 요청 팝업이 보이실 경우 다음과 같이 진행해주십시오<br>'
											+ '<br> 1. [위와같은 유형의 모든 링크에 대해 내 선택을 기억합니다.] 체크 합니다.'
											+ '<br> 2. [어플리케이션 시작] 버튼을 누릅니다.';
			printBtnSection.style.display = "none";
			break;
		case "MSIE":
		case "Edge":
			browserChkImgSection.innerHTML ='<img src="<%=strImagePath%>/loading.gif" id="browserChkImg"><br>'
											+'<img src="<%=strImagePath%>/Ma_progressBar.gif"><br>'
											+'<img src="<%=strImagePath%>/notice.png"><br>';
			printBtnSection.style.display = "none";
			browserChkComment.innerHTML = 	'<br>1. 미설치 및 PC에 설치된 버전이 낮을 경우 10초 후 설치페이지로 이동합니다.'
											+ '<br> 2. Microsoft Internet Explorer 8 이하 버전인 경우 팝업 항상 허용을 눌러주십시오.';
			break;
		case "Firefox":
			browserChkImg.src = "<%=strImagePath%>/check_guide_firefox.png";
			printBtnSection.style.display = "none";
			browserChkComment.innerHTML = 	'* 프로그램 실행 팝업이 보이실 경우 다음과 같이 진행해주십시오<br>'
											+ '<br> 1. [mareportsafer 링크에 대한 선택 사항을 기억 합니다.] 체크 합니다.'
											+ '<br> 2. [확인] 버튼을 누릅니다.';
											//+ '<br> 3. [문서발급] 버튼을 눌러 발급을 계속 진행합니다.';
			break;
		}
		
		//if( browserName == 'Chrome' || browserName == 'Opera' || browserName == 'Safari'){
		if( browserName == 'Chrome' || browserName == 'Opera'){
			if( viQuickSet == "0"){ // Window 및 Linux는 QuickURL 처리가 완료 맥만 기존 SessionCheck로 동작 따라서 프린터 발급 버튼이 필요
				browserChkComment.innerHTML =  browserChkComment.innerHTML + '<br> 3. [문서발급] 버튼을 눌러 발급을 계속 진행합니다.';
				printBtnSection.style.display = "block";
			}else{
				browserChkComment.innerHTML =  browserChkComment.innerHTML + '<br><br> *미설치 혹은 업데이트가 필요한 경우 10초 후 수동설치 페이지로 이동합니다';
			}
		}
		</script>
	</BODY>
</HTML>		
<%
	}
%>
