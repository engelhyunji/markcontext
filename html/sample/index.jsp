<%@ page import="java.io.*"%>
<%@ page import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*" %>
<%@ page import="com.markany.futils.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>MarkAny Inc. </title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<script src="../js/MaVerCheck.js" charset="euc-kr"></script> 
<style type="text/css">
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"
 oncontextmenu="return false" ondragstart="return false" onselectstart="return false">
<table class="mook" width="100%" border="0" cellspacing="0" cellpadding="5" height="100%">
  <tr bgcolor="#6A645B"> 
    <td height="7" colspan="3"></td>
  </tr>
  <tr> 
    <td width="65%" height="111">&nbsp;</td>
  </tr>
  <tr bgcolor="#A69F97"> 
    <td height="1" colspan="3"></td>
  </tr>
  <tr> 
    <td background="../images/bg01.gif" ><br>

	<br></td>
    <td background="../images/bg01.gif" height="409" align="right" valign="top"><br>
      <br>
      <br>
      <img src="../images/logo02.gif" width="80" height="50"></td>
    <td background="../images/bg01.gif" height="409" valign="top"><br>
      <br>
      <br>
      <br>
      <table CLASS="MOOK" width="85%" border="0" cellspacing="0" cellpadding="0">        
        <tr>
          <td><br><b><font color="red">e-PageSAFER Test<br>for Mac Linux and Windows<br>Page.<br><p><br><br>
		  <!-- cjkang 20190404 민원용으로 추가 -->
			  Broker
			<select name="strBrokerOptions" id="strBrokerOptions" class="sel">
					<option value="0">X-set0</option>
					<option value="1">X-set1</option>
					<option value="2" selected="selected">O</option>					
			</select>
		  <br>
			  <a href="javascript:poptastic( './Sample.jsp?BrokerOptions=');" > Non ActiveX e-PageSafer 222</a><br><br><br>
			  <!--<a href="javascript:poptastic( './Sample_2.jsp?BrokerOptions=');" > SVG_sample Test</a><br>-->
			  <a href="javascript:poptastic( './Sample_Tld.jsp?BrokerOptions=');" > Non ActiveX e-PageSafer Test</a><br><br>
			  <!--<a href="javascript:poptastic( './Sample20220405.jsp?BrokerOptions=');" > Sample20220405.jsp </a>-->
			  <br><br>		       		  	
		  </td>
		    
        </tr>
      </table>
      <br>
      <br>
    </td>
  </tr>
  <tr bgcolor="#35455E"> 
    <td width="125" colspan="2">&nbsp;</td>
    <td CLASS="MIKI" valign="top" ><br>
      <font color="#FFFFFF">Copyright 2016 <a href="http://www.markany.com"><font color="#FFFFCC"><b>MarkAny</b></font></a> 
      INC.</font><br>
    </td>
  </tr>
</table>
<script>
	document.writeln("** navigator.userAgent :: " + navigator.userAgent);
	document.writeln("<br><br>** window.navigator.appName : " + window.navigator.appName);
	document.writeln("<br><br>** navigator.platform : " + navigator.platform);
</script>
</body>
</html>
<script language="javascript">
  var newwindow;
  function poptastic(url)
  {
	// cjkang 20190404 민원용으로 추가
	var BrokerOptions = document.getElementById("strBrokerOptions");
      BrokerOptions = BrokerOptions.options[BrokerOptions.selectedIndex].value;
  	newwindow=window.open(url+BrokerOptions,'popWinC','height=200,width=400,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no');
  	if (window.focus) {newwindow.focus()}
  }
</script>
