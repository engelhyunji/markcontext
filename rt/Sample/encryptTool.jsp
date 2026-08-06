<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.markany.aes.*" %>
<%!
    String getStrClientOption(HashMap clientOptionMap) {
        Iterator keys = clientOptionMap.keySet().iterator();
        String clientOption = "";
        while (keys.hasNext()) {
            String paramKey = (String) keys.next();
            String paramValue = (String) clientOptionMap.get(paramKey);
            if (paramValue != null && !paramValue.equals("")) {
                clientOption = clientOption + "#" + paramKey + "=" + paramValue;
            }
        }
        return clientOption;
    }
%>
<%
    request.setCharacterEncoding("UTF-8");

    // AJAX POST 요청
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        response.setContentType("application/json; charset=UTF-8");
        String mode = request.getParameter("mode");
        
        try {
            MaUrlRdBase64 maEncUtil = new MaUrlRdBase64();
            
            if ("decrypt".equals(mode)) {
                // 복호화 모드
                String encInput = request.getParameter("encInput");
                if (encInput == null || encInput.trim().isEmpty()) {
                    out.print("{\"error\":\"암호화된 문자열을 입력해주세요.\"}");
                    return;
                }
                String decResult = maEncUtil.strUrlRdDecode(encInput.trim());
                
                // #KEY=VALUE 형식을 파싱하여 보기 좋게 정리
                String formatted = "";
                if (decResult != null && decResult.contains("#")) {
                    String[] parts = decResult.split("#");
                    StringBuilder sb = new StringBuilder();
                    for (String part : parts) {
                        if (part.trim().isEmpty()) continue;
                        int eqIdx = part.indexOf("=");
                        if (eqIdx > 0) {
                            String k = part.substring(0, eqIdx);
                            String v = part.substring(eqIdx + 1);
                            sb.append(k).append(" = ").append(v).append("\n");
                        } else {
                            sb.append(part).append("\n");
                        }
                    }
                    formatted = sb.toString().trim();
                } else {
                    formatted = decResult != null ? decResult : "(null)";
                }
                
                String plainEscaped = (decResult != null ? decResult : "").replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
                String formattedEscaped = formatted.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
                out.print("{\"plain\":\"" + plainEscaped + "\",\"formatted\":\"" + formattedEscaped + "\"}");
            } else {
                // 암호화 모드
                String[] postKeys = request.getParameterValues("optKey");
                String[] postValues = request.getParameterValues("optValue");

                HashMap clientOptionMap = new HashMap();
                if (postKeys != null && postValues != null) {
                    for (int i = 0; i < postKeys.length; i++) {
                        String k = postKeys[i].trim();
                        String v = postValues[i].trim();
                        if (!k.isEmpty() && !v.isEmpty()) {
                            clientOptionMap.put(k, v);
                        }
                    }
                }

                String paramStr = getStrClientOption(clientOptionMap);
                String encResult = maEncUtil.strUrlRdEncode(paramStr);

                out.print("{\"plain\":\"" + paramStr.replace("\"", "\\\"") + "\",\"result\":\"" + encResult.replace("\"", "\\\"") + "\"}");
            }
        } catch (Exception e) {
            response.setStatus(500);
            String msg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"") : "Unknown error";
            out.print("{\"error\":\"" + msg + "\"}");
        }
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>ClientOption 암호화 도구</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', -apple-system, sans-serif;
            background: #f5f7fa;
            color: #333;
            min-height: 100vh;
            padding: 40px 20px;
        }
        .container {
            max-width: 860px;
            margin: 0 auto;
        }
        .card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            padding: 32px;
            margin-bottom: 20px;
        }
        h1 {
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #1a1a2e;
        }
        .subtitle {
            font-size: 13px;
            color: #888;
            margin-bottom: 24px;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 8px;
        }
        th {
            text-align: left;
            font-size: 12px;
            font-weight: 600;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 0 8px 4px;
        }
        td { padding: 0 4px; }
        input[type=text] {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 13px;
            transition: border-color 0.2s;
            outline: none;
        }
        input[type=text]:focus {
            border-color: #4a6cf7;
            box-shadow: 0 0 0 3px rgba(74,108,247,0.1);
        }
        input[type=text].desc-input {
            border-style: dashed;
            color: #888;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-primary {
            background: #4a6cf7;
            color: #fff;
        }
        .btn-primary:hover { background: #3b5de7; }
        .btn-secondary {
            background: #f0f2f5;
            color: #555;
        }
        .btn-secondary:hover { background: #e4e7ec; }
        .btn-remove {
            background: none;
            border: none;
            color: #ccc;
            font-size: 18px;
            cursor: pointer;
            padding: 6px 10px;
            border-radius: 6px;
            transition: all 0.2s;
        }
        .btn-remove:hover { color: #e74c3c; background: #fef0f0; }
        .actions {
            display: flex;
            gap: 10px;
            margin-top: 16px;
        }
        .result-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            padding: 24px 32px;
            margin-bottom: 12px;
        }
        .result-label {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #888;
            margin-bottom: 8px;
        }
        .result-value {
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 13px;
            word-break: break-all;
            line-height: 1.6;
            color: #1a1a2e;
            background: #f8f9fb;
            padding: 12px 16px;
            border-radius: 8px;
            position: relative;
        }
        .copy-btn {
            display: inline-block;
            margin-top: 10px;
            background: #4a6cf7;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 6px 14px;
            font-size: 12px;
            cursor: pointer;
        }
        .copy-btn:hover { background: #3b5de7; }
        .error-card {
            background: #fef0f0;
            border: 1px solid #fdd;
            border-radius: 12px;
            padding: 16px 24px;
            color: #c0392b;
            font-size: 13px;
        }
        .col-key { width: 20%; }
        .col-value { width: 35%; }
        .col-desc { width: 35%; }
        .col-action { width: 10%; text-align: center; }
        .desc-text { font-size: 12px; color: #888; }
        .opt-check { width: 18px; height: 18px; cursor: pointer; }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <h1>ClientOption 암호화</h1>
        <p class="subtitle">사용할 옵션을 체크하고 값을 설정한 후 암호화 버튼을 누르세요. 체크된 항목만 암호화됩니다.</p>

        <form id="encForm">
            <table id="optTable">
                <thead>
                    <tr>
                        <th style="width:5%"></th>
                        <th style="width:18%">Key</th>
                        <th style="width:30%">Value</th>
                        <th style="width:47%">Description</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><input type="checkbox" class="opt-check" checked /></td>
                        <td><input type="text" name="optKey" value="TITLE" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="MarkAny Client" /></td>
                        <td><span class="desc-text">뷰어 타이틀</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" checked /></td>
                        <td><input type="text" name="optKey" value="CAMBIARLLAVE" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="2" /></td>
                        <td><span class="desc-text">라이선스 체크 (2로 고정)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" checked /></td>
                        <td><input type="text" name="optKey" value="_MAKEY_" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="Z+xyEGDtFs/qQWRYysLkG0ZQRH39GPWAslclIpXpDIhlIjoiVU5MSU1JVEVEIn0=" /></td>
                        <td><span class="desc-text">라이선스 키 (WebDRM)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="HIDEPRTBUTTON" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="0" /></td>
                        <td><span class="desc-text">인쇄 버튼 숨김 (0:보임, 1:숨김)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="DEFAULTPRT" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="0" /></td>
                        <td><span class="desc-text">기본 프린터 사용 (0:선택, 1:기본)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="HIDEFRAME" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="0" /></td>
                        <td><span class="desc-text">미리보기 숨김 (0:보임, 1:숨김→바로출력)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="AUTOPRINT" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="0" /></td>
                        <td><span class="desc-text">자동 인쇄 (0:수동, 1:자동)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="AUTOCLOSE" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="0" /></td>
                        <td><span class="desc-text">자동 닫기 (0:안닫음)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="PRINTCNT" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="10" /></td>
                        <td><span class="desc-text">출력 제한 횟수</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="PRINTCOPIES" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="1" /></td>
                        <td><span class="desc-text">인쇄 매수</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="PAPERSIZE" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="9" /></td>
                        <td><span class="desc-text">용지 크기 (9:A4, 1:Letter)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="PRTTYPE" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="0" /></td>
                        <td><span class="desc-text">출력 방식 (0:기본, 1:BMP, 2:TIFF→PDF)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="PRTDLGOPT" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="5" /></td>
                        <td><span class="desc-text">다이얼로그 (0:이미지O, 1:이미지X, 5:부분출력)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="VIRTUAL" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="" /></td>
                        <td><span class="desc-text">가상 프로그램 허용 (all: Vk1fQUxMT1dBTEw=)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="RENDEROPTION" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="2" /></td>
                        <td><span class="desc-text">렌더러 (0:안씀, 2:기본, 3:사용)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="WMPARAM" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="0^150^170^100" /></td>
                        <td><span class="desc-text">워터마크 파라미터</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="HIDECD" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="" /></td>
                        <td><span class="desc-text">복사방지마크 없이</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="TRANSPARENCYIMG" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="0" /></td>
                        <td><span class="desc-text">투명이미지 처리 (0:체크, 1:안함)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="CONVERTIMAGEPRINT" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="0" /></td>
                        <td><span class="desc-text">PDF 이미지 처리</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="PRINTCALLURLOPT" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="0" /></td>
                        <td><span class="desc-text">Print CALL URL (0:출력후, 1:출력전, 2:출력전+리턴)</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="CPFONTNAME" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="" /></td>
                        <td><span class="desc-text">복사방지 폰트명</span></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="opt-check" /></td>
                        <td><input type="text" name="optKey" value="FAQURL" readonly style="background:#f8f9fb;" /></td>
                        <td><input type="text" name="optValue" value="1" /></td>
                        <td><span class="desc-text">FAQ URL</span></td>
                    </tr>
                </tbody>
            </table>
            <div class="actions">
                <button type="button" class="btn btn-secondary" onclick="checkAll(true)">전체 선택</button>
                <button type="button" class="btn btn-secondary" onclick="checkAll(false)">전체 해제</button>
                <button type="button" class="btn btn-secondary" onclick="addCustomRow()">+ 옵션 추가</button>
                <button type="button" class="btn btn-primary" onclick="doEncrypt()">암호화</button>
            </div>
        </form>
    </div>

    <div id="resultContainer"></div>

    <!-- 복호화 섹션 -->
    <div class="card" style="margin-top:20px;">
        <h1>ClientOption 복호화</h1>
        <p class="subtitle">암호화된 문자열을 입력하면 MaUrlRdBase64 디코딩 결과를 Key-Value 형태로 보여줍니다.</p>
        <div style="margin-bottom:12px;">
            <textarea id="decInput" rows="4" style="width:100%; padding:12px; border:1px solid #e0e0e0; border-radius:8px; font-family:Consolas,monospace; font-size:13px; resize:vertical;" placeholder="암호화된 문자열을 붙여넣으세요"></textarea>
        </div>
        <button type="button" class="btn btn-primary" onclick="doDecrypt()">복호화</button>
        <div id="decResultContainer" style="margin-top:16px;"></div>
    </div>
</div>

<script>
function checkAll(checked) {
    var boxes = document.querySelectorAll('.opt-check');
    for (var i = 0; i < boxes.length; i++) boxes[i].checked = checked;
}
function addCustomRow() {
    var tbody = document.querySelector('#optTable tbody');
    var row = document.createElement('tr');
    row.innerHTML = '<td><input type="checkbox" class="opt-check" checked /></td>'
        + '<td><input type="text" name="optKey" value="" /></td>'
        + '<td><input type="text" name="optValue" value="" /></td>'
        + '<td><span class="desc-text">(커스텀)</span> <button type="button" class="btn-remove" onclick="this.closest(\'tr\').remove()">&times;</button></td>';
    tbody.appendChild(row);
}
function doEncrypt() {
    var rows = document.querySelectorAll('#optTable tbody tr');
    var params = [];
    for (var i = 0; i < rows.length; i++) {
        var check = rows[i].querySelector('.opt-check');
        if (!check || !check.checked) continue;
        var key = rows[i].querySelector('input[name="optKey"]').value;
        var val = rows[i].querySelector('input[name="optValue"]').value;
        if (key) {
            params.push('optKey=' + encodeURIComponent(key));
            params.push('optValue=' + encodeURIComponent(val));
        }
    }
    if (params.length === 0) { alert('최소 하나의 항목을 체크하세요.'); return; }
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'encryptTool.jsp', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
    xhr.onload = function() {
        var container = document.getElementById('resultContainer');
        try {
            var data = JSON.parse(xhr.responseText);
            if (data.error) {
                container.innerHTML = '<div class="error-card"><strong>에러:</strong> ' + data.error + '</div>';
            } else {
                container.innerHTML =
                    '<div class="result-card"><div class="result-label">평문</div><div class="result-value">' + data.plain + '</div></div>' +
                    '<div class="result-card"><div class="result-label">암호화 결과</div><div class="result-value" id="encResult">' + data.result + '</div>' +
                    '<button class="copy-btn" onclick="copyResult()">복사</button></div>';
            }
        } catch (e) {
            container.innerHTML = '<div class="error-card"><strong>에러:</strong> 응답 파싱 실패<br/>' + xhr.responseText + '</div>';
        }
    };
    xhr.send(params.join('&'));
}
function copyResult() {
    var text = document.getElementById('encResult').textContent;
    navigator.clipboard.writeText(text).then(function() {
        var btn = document.querySelector('.copy-btn');
        btn.textContent = '완료';
        setTimeout(function() { btn.textContent = '복사'; }, 1500);
    });
}

function doDecrypt() {
    var encInput = document.getElementById('decInput').value;
    if (!encInput.trim()) { alert('암호화된 문자열을 입력하세요.'); return; }
    
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'encryptTool.jsp', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
    xhr.onload = function() {
        var container = document.getElementById('decResultContainer');
        try {
            var data = JSON.parse(xhr.responseText);
            if (data.error) {
                container.innerHTML = '<div class="error-card"><strong>에러:</strong> ' + data.error + '</div>';
            } else {
                var formatted = data.formatted.replace(/\\n/g, '\n');
                var plain = data.plain.replace(/\\n/g, '\n');
                
                // Key=Value를 테이블로 표시
                var lines = formatted.split('\n');
                var tableHtml = '<table style="width:100%; border-collapse:collapse; margin-top:8px;">';
                tableHtml += '<tr><th style="text-align:left; padding:8px; border-bottom:2px solid #eee; font-size:12px; color:#666;">Key</th><th style="text-align:left; padding:8px; border-bottom:2px solid #eee; font-size:12px; color:#666;">Value</th></tr>';
                for (var i = 0; i < lines.length; i++) {
                    if (!lines[i].trim()) continue;
                    var parts = lines[i].split(' = ');
                    var key = parts[0] || '';
                    var val = parts.slice(1).join(' = ') || '';
                    tableHtml += '<tr><td style="padding:6px 8px; border-bottom:1px solid #f0f0f0; font-family:Consolas,monospace; font-size:13px; font-weight:600; color:#4a6cf7;">' + key + '</td>';
                    tableHtml += '<td style="padding:6px 8px; border-bottom:1px solid #f0f0f0; font-family:Consolas,monospace; font-size:13px; word-break:break-all;">' + val + '</td></tr>';
                }
                tableHtml += '</table>';
                
                container.innerHTML =
                    '<div class="result-card"><div class="result-label">복호화 결과 (원문)</div><div class="result-value">' + plain + '</div></div>' +
                    '<div class="result-card"><div class="result-label">파싱 결과</div>' + tableHtml + '</div>';
            }
        } catch (e) {
            container.innerHTML = '<div class="error-card"><strong>에러:</strong> 응답 파싱 실패<br/>' + xhr.responseText + '</div>';
        }
    };
    xhr.send('mode=decrypt&encInput=' + encodeURIComponent(encInput));
}
</script>
</body>
</html>
