<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*"%>
<%@include file="../jsp/MaFpsCommon.jsp"%>
<%
	out = matostring.newInstance(out);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link href='https://epage.markany.com/module/EPS/zero/html/sample/print.css' rel="stylesheet" type="text/css" />
<style type="text/css">
<title>Payslip - Jan 2025</title>
<style>
    body {
      font-family: Arial, sans-serif;
      font-size: 14px;
      padding: 40px;
      line-height: 1.6;
    }
    .center {
      text-align: center;
    }
    .title {
      font-weight: bold;
      font-size: 18px;
    }
    .subtitle {
    font-weight: bold;
      font-size: 16px;
    }
    .row {
      display: flex;
      justify-content: space-between;
      margin-top: 30px;
    }
    .col {
      width: 48%;
    }
    .field {
      display: flex;
    }
    .label {
      width: 140px;
    }
    .sep {
      margin: 0 5px;
    }
    table {
      width: 100%;
      border: 1px solid #000;
      border-collapse: separate;
      border-spacing: 0;
      margin-top: 30px;
    }
    th, td {
      padding: 2px 3px;
      vertical-align: top;
    }
    tr:first-child th {
      border-bottom: 1px solid #000;
      background-color: #a5a5a5;
      text-align: left;
    }
    .netpay-row td {
      border-top: none;
    }
    .netpay-label {
      font-weight: bold;
    }
    .big-amount {
      margin-top: 30px;
      text-align: center;
    }
    .signature {
      display: flex;
      justify-content: space-between;
      margin-top: 60px;
    }
    .signature-box {
      width: 45%;
      text-align: center;
    }
    .signature-line {
      border-top: 1px solid #000;
      margin-top: 40px;
    }
    .footer {
      text-align: center;
      margin-top: 30px;
    }
    .line{
    	border-right: 1px solid #000;
    }
  </style>
</head>
<body>
	
  <div class="center">
    <div class="title">Payslip</div>
    <div class="subtitle">Demo Sdn Bhd</div>
    <div class="subtitle">Kuala Lumpur</div>
  </div>

  <div class="row">
    <div class="col">
      <div class="field"><div class="label" style="font-size:14px">Salary Month/Year</div><div class="sep" style="font-size:14px">:</div><div style="font-size:14px">January 2025</div></div>
    </div>
    <div class="col">
      <div class="field"><div class="label" style="font-size:14px">Employee Name</div><div class="sep" style="font-size:14px">:</div><div style="font-size:14px">James Bond</div></div>
      <div class="field"><div class="label" style="font-size:14px">Employee ID</div><div class="sep" style="font-size:14px">:</div><div style="font-size:14px">007</div></div>
      <div class="field"><div class="label" style="font-size:14px">EPF No</div><div class="sep" style="font-size:14px">:</div><div style="font-size:14px">12345678</div></div>
      <div class="field"><div class="label" style="font-size:14px">SOCSO No</div><div class="sep" style="font-size:14px">:</div><div style="font-size:14px">880102101234</div></div>
      <div class="field"><div class="label" style="font-size:14px">Income Tax No</div><div class="sep" style="font-size:14px">:</div><div style="font-size:14px">OG12345678910</div></div>
    </div>
  </div>

  <table>
  <colgroup>
    <col style="width: 30%;">
    <col style="width: 20%;">
    <col style="width: 30%;">
    <col style="width: 20%;">
  </colgroup>

  <tr>
    <th class="line" style="text-align:center;    font-size: 16px; border-left: 0px solid #000">Salary</th>
    <th class="line" style="text-align:center;    font-size: 16px;">Amount (RM)</th>
    <th class="line" style="text-align:center;    font-size: 16px;">Deductions</th>
    <th style="text-align:center;    font-size: 16px;">Amount (RM)</th>
  </tr>
  <tr>
    <td class="line" style="text-align:left;">Basic Salary</td><td class="line"  style="text-align:right;">8000</td>
    <td class="line" style="text-align:left;">MTD</td><td  style="text-align:right;">800</td>
  </tr>
  <tr>
    <td class="line"  style="text-align:left;">Allowance</td><td class="line" style="text-align:right;">500</td>
    <td class="line"  style="text-align:left;">EPF</td><td style="text-align:right;">880</td>
  </tr>
  <tr>
    <td class="line"  style="text-align:left;">Overtime</td><td class="line" style="text-align:right;">300</td>
    <td class="line"  style="text-align:left;">SOCSO</td><td style="text-align:right;">6.8</td>
  </tr>
  <tr>
    <td class="line"></td><td class="line"></td>
    <td class="line"  style="text-align:left;">EIS</td><td style="text-align:right;">9.9</td>
  </tr>
  <tr>
    <td class="line"></td><td class="line"></td>
    <td class="line"></td><td></td>
  </tr>
  <tr>
    <td class="line"  style="text-align:right;">Total Earnings</td><td class="line"  style="text-align:right;">8800</td>
    <td class="line"  style="text-align:right;">Total Deductions</td><td  style="text-align:right;">1696.7</td>
  </tr>
  <tr class="netpay-row">
    <td class="line"></td><td class="line"></td>
    <td class="line" style="text-align:right;">Net Pay</td><td style="text-align:right;">RM7103.3</td>
  </tr>
</table>

  <div class="big-amount">
    <div>7103.3</div>
    <div>Seven Thousand One Hundred And Three And Thirty</div>
  </div>

  <div class="signature">
    <div class="signature-box">
      Employer Signature
      <div class="signature-line"></div>
    </div>
    <div class="signature-box">
      Employee Signature
      <div class="signature-line"></div>
    </div>
  </div>

  <div class="footer">
    This is system generated payslip
  </div>
	<!-- MarkAny Page Gubun -->	
</body>
</html>
<%
    String	strHtmlData = out.toString();
    out = ((matostring) out).getOldJspWriter();
    
	byte	byteReadHtmlData[] = strHtmlData.getBytes ("euc-kr"); 
	int 	iReadHtmlDataSize = byteReadHtmlData.length;
	//cjkang 20190404 민원용으로 추가
	if(request.getParameter("BrokerOptions") != null){
		iQuickSet = Integer.parseInt(request.getParameter("BrokerOptions"));
	}
%> 
<%@include file="../jsp/MaFpsTail.jsp"%>
<script language="javascript">
function resize_window(){
      window.resizeTo(800,730);
  }
  window.onload = function() {
   //resize_window();
  }
</script>
