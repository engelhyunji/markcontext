<%@ page import='java.util.* , java.io.*'%>
<%@include file="MaFpsCommon.jsp"%>
<%@include file="MaFunction.jsp"%>

<%--
================================================================================
파일명(추정): Mafndown.jsp 또는 matmprp_filedown.jsp
역할:
  Viewer가 요청한 .matmprp 메타파일, PDF, 프린터 DAT 파일을 HTTP 응답으로 내려줍니다.

MaFpsTail_Noax.jsp와의 연결:
  MaFpsTail_Noax.jsp 저장 파일명 = sessionId + today + ".matmprp"
  Viewer 호출 URL             = Mafndown.jsp?fn=today
  이 JSP 다운로드 파일명      = session.getId() + fn + ".matmprp"

따라서 저장 시점과 다운로드 시점의 JSESSIONID가 같아야 같은 파일을 찾습니다.
================================================================================
--%>

<%
    /*
     * [1단계] 다운로드 대상 파일명과 기본 폴더를 준비합니다.
     *
     * strDownFolder:
     *   MaFpsCommon.jsp에서 설정된 .matmprp 메타파일 저장 폴더
     *
     * strPrtDatDownFolder:
     *   프린터 정보 .dat 파일 전용 폴더
     */
    String downloadFileName = null;
    String requestFileServerIp = null;
    String printDatName = null;
    String pdfFIleName = null;
    String metaFileName = null;
    String filePath = strDownFolder;
    boolean prtDatUpdateFlag = false;

    /*
     * [2단계] Viewer가 URL 쿼리스트링으로 보낸 파일 유형을 구분합니다.
     *
     * ?prtdat=MaPrintInfoEPSmain -> MaPrintInfoEPSmain.dat
     * ?fn=20260730142000123     -> <JSESSIONID>20260730142000123.matmprp
     * ?fnpdf=certificate       -> certificate.pdf
     */
    printDatName = request.getParameter("prtdat");
    metaFileName = request.getParameter("fn");
    pdfFIleName = request.getParameter("fnpdf");

    /*
     * MaFpsTail_Noax.jsp에서 메타파일을 저장할 때 앞에 붙인 세션 ID와
     * 같은 값을 얻기 위해 현재 HTTP 세션 ID를 읽습니다.
     *
     * Viewer는 MaFpsTail_Noax.jsp가 전달한 vstrSCookie를 사용해
     * "Cookie: JSESSIONID=<동일값>"을 이 요청에 포함해야 합니다.
     */
    String sessionId = session.getId();

    /*
     * [3단계] 요청 종류에 맞는 실제 서버 파일명을 계산합니다.
     * safetyFileNameCheck()는 ../ 같은 경로 조작 문자를 제거하기 위한 방어 함수입니다.
     */
    if (printDatName != null && !printDatName.equals("")) {
        filePath = strPrtDatDownFolder;
        downloadFileName = safetyFileNameCheck(printDatName) + ".dat";
        prtDatUpdateFlag = true;

    } else if (metaFileName != null && !metaFileName.equals("")) {
        /*
         * 핵심 연결:
         * MaFpsTail_Noax.jsp:
         *   strMetaFilePath = strSID + today + ".matmprp";
         *   strDownURL += today;
         *
         * 현재 JSP:
         *   sessionId + fn(today) + ".matmprp"
         */
        downloadFileName =
            sessionId + safetyFileNameCheck(metaFileName) + ".matmprp";

    } else if (pdfFIleName != null) {
        downloadFileName = safetyFileNameCheck(pdfFIleName) + ".pdf";
    }

    /*
     * [4단계] 스트림과 버퍼 변수를 준비합니다.
     *
     * bis: 서버 파일을 읽는 입력 스트림
     * bos: HTTP response 본문으로 쓰는 출력 스트림
     * 4096바이트: 한 번에 읽고 쓸 기본 청크 크기
     */
    BufferedInputStream bis = null;
    BufferedOutputStream bos = null;
    File file = null;
    int iFileSize = 0;
    int iReadFileBuffer = 4096;
    int iReadDataSize = 0;
    int iFinalReadFileBuffer = 0;

    /*
     * [5단계-A] iUseNas == 1
     * WAS가 접근 가능한 로컬/NAS 공유 폴더에서 파일을 직접 읽습니다.
     */
    if (iUseNas == 1) {
        try {
            file = new File(filePath, downloadFileName);

            if (file.isFile()) {
                iFileSize = (int) file.length();

                /*
                 * JSP가 앞서 만들던 HTML 응답을 버리고,
                 * 이제부터 순수 파일 다운로드 응답으로 다시 구성합니다.
                 */
                response.reset();

                /*
                 * Viewer/브라우저가 응답을 파일 첨부로 취급하도록 파일명을 설정합니다.
                 * lineCarriageEraser()는 CR/LF 헤더 삽입 공격을 방지하기 위한 함수입니다.
                 */
                response.setHeader(
                    "Content-Disposition",
                    "attachment; fileName="
                        + lineCarriageEraser(downloadFileName)
                        + ";"
                );
                response.setContentLength(iFileSize);

                /*
                 * 프린터 DAT가 아닌 메타/PDF 다운로드에는 바이너리 및 캐시 금지 헤더를 설정합니다.
                 */
                if (prtDatUpdateFlag == false) {
                    response.setHeader("Content-Transfer-Encoding", "binary");
                    response.setHeader("Pragma", "no-cache;");
                    response.setHeader("Expires", "-1;");
                    response.setContentType("application/x-msdownload");
                }

                /*
                 * 파일이 4096바이트보다 작으면 파일 크기만큼만 버퍼를 만듭니다.
                 */
                if (iReadFileBuffer > iFileSize) {
                    iFinalReadFileBuffer = iFileSize;
                } else {
                    iFinalReadFileBuffer = iReadFileBuffer;
                }

                /*
                 * 서버 파일 입력 스트림과 HTTP 응답 출력 스트림을 연결합니다.
                 */
                bis = new BufferedInputStream(new FileInputStream(file));
                bos = new BufferedOutputStream(response.getOutputStream());

                byte[] byteReadBuffer = new byte[iFinalReadFileBuffer];

                /*
                 * JSP 문자 출력용 out과 바이너리 response OutputStream을 함께 사용하면
                 * IllegalStateException 또는 응답 오염이 발생할 수 있으므로
                 * 기존 out 버퍼를 비운 뒤 별도 BodyContent로 치환합니다.
                 */
                out.clear();
                out = pageContext.pushBody();

                /*
                 * 파일 끝(-1)까지 4096바이트 단위로 읽어 HTTP 응답에 씁니다.
                 * 이 응답을 Viewer가 .matmprp/.pdf/.dat 데이터로 받습니다.
                 */
                while (true) {
                    iReadDataSize = bis.read(byteReadBuffer);

                    if (iReadDataSize < 0) {
                        break;
                    }

                    bos.write(byteReadBuffer, 0, iReadDataSize);
                }
            }

        } catch (IOException e) {
            System.out.println("matmprp_filedown buffer Error");
            // 운영 디버깅 시 로그 프레임워크로 예외 스택을 기록하는 편이 좋습니다.

        } finally {
            /*
             * 파일 핸들을 반드시 닫아 잠금과 자원 누수를 방지합니다.
             */
            if (bis != null) {
                bis.close();
            }

            if (bos != null) {
                bos.close();
            }

            /*
             * 원본은 다운로드 후 메타/PDF 삭제 코드를 주석 처리해 두었습니다.
             * 즉, 현재 이 블록에서는 다운로드 파일을 즉시 삭제하지 않습니다.
             */
            if (metaFileName != null || pdfFIleName != null) {
                // file.delete();
            }
        }

    } else {
        /*
         * [5단계-B] iUseNas != 1
         * WAS가 파일을 직접 읽지 않고 파일 서버 모듈(FPSFM 계열)에 요청합니다.
         *
         * MaFpsTail_Noax.jsp는 strDownURL에
         *   &fs=<Base64(strFileServerIp)>
         * 를 붙여 Viewer에 전달했습니다.
         */
        requestFileServerIp = request.getParameter("fs");

        /*
         * Base64는 암호화가 아니라 파일 서버 IP의 전송 인코딩입니다.
         */
        byte[] byteIP = MaBase64Utils.base64Decode(requestFileServerIp);
        strFileServerIp = new String(byteIP);

        /*
         * masavefile은 파일 서버 저장/조회 기능을 제공하는 MarkAny 라이브러리 클래스입니다.
         */
        masavefile clMaSaveFile = new masavefile();

        try {
            /*
             * 파일 서버 IP/포트와 앞에서 조립한 파일명을 전달하여 메타파일을 조회합니다.
             *
             * 반환값 규격:
             *   앞 5자리 = 결과 코드
             *   이후     = 반환 데이터
             */
            String strRet = clMaSaveFile.strGetMetaFile(
                strFileServerIp,
                iFileServerPort,
                downloadFileName,
                "",
                ""
            );

            String strRetCode = strRet.substring(0, 5);
            String strRetData = strRet.substring(5);
            int iRetCode = Integer.parseInt(strRetCode);

            bos = new BufferedOutputStream(response.getOutputStream());

            if (iRetCode == 0) {
                /*
                 * JSP 문자 출력 버퍼와 바이너리 응답 스트림의 충돌을 막습니다.
                 */
                out.clear();
                out = pageContext.pushBody();

                /*
                 * 주의:
                 * strRetData가 실제 임의 바이너리라면 기본 문자셋 getBytes()는 손상을 만들 수 있습니다.
                 * 다만 제품 라이브러리가 메타를 문자열/인코딩 형식으로 반환하는 규약이면 정상일 수 있습니다.
                 * 정확한 판단은 masavefile 반환 규격을 확인해야 합니다.
                 */
                byte[] byteRetData = strRetData.getBytes();
                bos.write(byteRetData, 0, byteRetData.length);
            }

        } catch (IOException e) {
            System.out.println("matmprp_filedown buffer Error");

        } finally {
            if (bos != null) {
                bos.close();
            }
        }
    }

    /*
     * [6단계] Viewer 다운로드가 끝난 뒤 RT 원본과 PDF 임시파일을 정리합니다.
     *
     * 이 경로들은 MaFpsTail_Noax.jsp에서 다음과 같이 세션에 저장했습니다.
     *   session.setAttribute("strRtDataFilePath", strRtData);
     *   session.setAttribute("strPdfFilePath", strPdfFilePath);
     */
    String strRtDataFilePath =
        (String) session.getAttribute("strRtDataFilePath");

    String strPdfFilePath =
        (String) session.getAttribute("strPdfFilePath");

    if (strRtDataFilePath != null) {
        deleteFile(strRtDataFilePath);
    }

    if (strPdfFilePath != null) {
        deleteFile(strPdfFilePath);
    }
%>
