# MaFpsTail_Noax.jsp · MaVerCheck.js · MaXHRControl.js · Mafndown.jsp 연결 흐름

### MaVerCheck.js는 순서를 제어하고, MaXHRControl.js는 Broker와 실제 통신하며, Viewer가 Mafndown.jsp를 호출합니다.
### 전체 시스템에는 이 네 파일 외에도 공통 JSP, JAR, 데몬, Broker EXE, Viewer EXE가 필요합니다.
#### 핵심 소스 흐름은 네 파일로 연결되며, 외부 실행 구성요소로 MarkAny JAR, FPS/RD 데몬, Broker, RT Viewer가 함께 동작합니다.

## 1. 서버 처리

```text
발급/샘플 JSP
  └─ RtData, PdfFilePath, PdfDataType, PrintOptions, BrokerOptions 전달
       ↓
MaFpsTail_Noax.jsp
  ├─ RT/PDF 파일 존재 확인
  ├─ MaMakeCode 또는 MaFpsMake2DCode 호출
  ├─ FPS/RD 데몬에서 메타데이터 수신
  ├─ Viewer 출력 정책(strAddData) 결합
  └─ <JSESSIONID><today>.matmprp 저장
```

## 2. JSP에서 JavaScript로 값 전달

```text
strBase64Cookie      -> vstrSCookie
strBase64DownURL     -> vstrSDownURL
strBase64PDFDownURL  -> vstrSPDFDownURL
iUsePDF              -> viUsePDF
strApp               -> vstrApp
```

## 3. Broker 설치 확인과 Viewer 실행

```text
window load
  ↓
MaVerCheck.js.showPopup()
  ↓
MaXHRControl.js.maBrokerInit(maFun_InstallCheck, "getVersion", true)
  ↓
craeteBoekerCommand(chkFileArray)
  ↓
WebSocket 127.0.0.1:19877
  ↓
MaEPSBroker.exe [MaXHRControl.js]
  ↓ 설치/버전 결과
maBrokerController()
  ↓ callback
MaVerCheck.js.maFun_InstallCheck()
  ↓ maOnlyInstallFlag == true
maBrokerInit(maFun_execute, "executeBinary", false)
  ↓
craeteBoekerCommand(executeBinaryArray)
  ↓
MaEPSBroker.exe [MaXHRControl.js]가 ePageSaferRT.exe 실행
```

## 4. Viewer 다운로드

```text
Viewer 실행 파라미터
  ├─ Mafndown.jsp?fn=<today>
  ├─ Cookie: JSESSIONID=<세션ID>
  └─ PDF URL(viUsePDF 설정에 따라)

Viewer
  ↓ HTTP + 동일 JSESSIONID
Mafndown.jsp
  ↓
session.getId() + fn + ".matmprp"
  ↓
<JSESSIONID><today>.matmprp 파일 반환
```

## 5. 가장 중요한 파일명 결합

```text
MaFpsTail_Noax.jsp 저장:
  strMetaFilePath = sessionId + today + ".matmprp"

MaFpsTail_Noax.jsp가 JS/Viewer에 전달:
  strDownURL += today

Mafndown.jsp 다운로드:
  downloadFileName = session.getId() + request.getParameter("fn") + ".matmprp"
```

세션이 바뀌면 저장 파일명과 다운로드 파일명이 달라져 파일을 찾지 못합니다.



## 핵심
MaFpsTail_Noax.jsp는 RT 원본과 PDF를 입력받아 MarkAny Java 라이브러리를 통해 FPS 또는 RD 데몬에 메타데이터 생성을 요청합니다. 
반환된 메타데이터에는 Viewer의 인쇄 및 보안 정책을 추가하고, 세션 ID와 생성 시간을 조합한 .matmprp 파일로 저장합니다.

이후 JSP는 메타파일 다운로드 URL, PDF URL, JSESSIONID, Viewer 버전 및 실행 정보를 JavaScript 변수로 출력합니다. 
MaVerCheck.js는 설치 확인과 실행 순서를 제어하고, MaXHRControl.js는 해당 정보를 Broker 명령 JSON으로 변환하여 로컬 MaEPSBroker.exe와 WebSocket 통신을 수행합니다.

필수 프로그램이 모두 설치되어 있으면 executeBinary 명령으로 ePageSaferRT.exe가 실행됩니다. 
Viewer는 전달받은 URL과 JSESSIONID를 사용하여 Mafndown.jsp를 호출하고, 
Mafndown.jsp는 동일한 세션 ID와 fn 값을 조합하여 저장된 .matmprp 파일을 찾아 반환합니다. 
Viewer는 이 메타데이터와 PDF를 처리하여 2D 바코드와 보안 정책이 적용된 문서를 화면에 표시하거나 인쇄합니다.


## 3줄 요약
MaFpsTail_Noax.jsp는 데몬 메타 생성, .matmprp 저장, JavaScript 실행정보 생성까지 담당합니다.
MaVerCheck.js는 실행 순서를 제어하고, MaXHRControl.js는 Broker와 통신하여 Viewer EXE를 실행합니다.
Viewer와 Mafndown.jsp는 JSESSIONID + fn + .matmprp라는 동일한 파일명 규칙으로 연결됩니다.


## .matmprp 파일과 관련된 내용
FPS 또는 RD 데몬이 생성한 메타데이터는 MaFpsTail_Noax.jsp에서 Viewer 출력 정책과 결합된 뒤, 
세션 ID와 생성 시간을 파일명으로 사용하는 .matmprp 파일로 서버에 저장됩니다. 
이 저장 작업은 Broker 설치 확인과 Viewer 실행보다 먼저 수행됩니다. 
Viewer가 실행되면 Mafndown.jsp를 호출하여 저장된 .matmprp 파일을 다운로드하고, 
이를 해석하여 화면을 렌더링하고 인쇄합니다. 현재 코드에서는 .matmprp 삭제 코드가 주석 처리되어 있으므로 다운로드 및 인쇄 이후에도 서버에 남을 수 있으며, 
RT 원본 파일과 PDF 임시파일만 다운로드 요청 처리 후 삭제됩니다.

### 연동은 세가지 방식
1. JSP가 JS 파일을 브라우저에 로드합니다.
2. JSP가 서버에서 만든 값을 JavaScript 변수로 출력합니다.
3. 두 JS 파일이 같은 브라우저 전역 공간에서 함수와 변수를 공유합니다.

### Mafndown.jsp는 위 방식과 다릅니다.
4. 실행된 Viewer가 HTTP 요청으로 Mafndown.jsp를 별도로 호출합니다.

파일 로드만으로 끝나는 것이 아니라, 값 생성·함수 호출·콜백 전달·HTTP 요청까지 연결되어야 전체 흐름이 완성됩니다.