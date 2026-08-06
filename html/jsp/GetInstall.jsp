<%@ page import='java.util.* , java.io.*'%>
<%@include file="MaFpsCommon.jsp"%>
<%
  out.println("<br>strDomain : "+strDomain+"<br>");
  out.println("<br>strContextPath : "+strContextPath+"<br>");
  out.println("<br>strUrlHome : "+strUrlHome+"<br>");
  out.println("<br>strCurrentPath : "+strCurrentPath+"<br>");
  out.println("<br>strDownFolder : "+strDownFolder+"<br>");
  out.println("<br>strPrtDatDownFolder : "+strPrtDatDownFolder+"<br>");
  out.println("<br>strDownURL : "+strDownURL+"<br>");
  out.println("<br>strPrtDatDownURL : "+strPrtDatDownURL+"<br>");
  
  
  String strPversion = (String)session.getAttribute("productversion");
  String strID = (String)session.getId();
  out.println("session id : " + strID);
  
  /*
  HttpSession session1 = request.getSession(false);
  if(session1 == null) {
    session1 = request.getSession(true);
  }
  */
  
  
  String strCookie = "";        
  Cookie[] cookies = request.getCookies();    
  
  if(cookies != null)
  {
    //out.println("cookie count : " + cookies.length);    
    for(int i = 0 ; i<cookies.length; i++){              
      strCookie =  cookies[i].getName() + "=" +  cookies[i].getValue() + ";";        
      out.println("<br>cookie : " + strCookie);    
    }
  }
  out.println("<br>product version : " + strPversion);
  
  String ls_name;
  String ls_value;
  
  Enumeration enum_app=session.getAttributeNames();
  if(enum_app != null)
  {
    while(enum_app.hasMoreElements()){
      ls_name=enum_app.nextElement().toString();
      ls_value=session.getAttribute(ls_name).toString();
      
      out.println("<br>session name : "+ls_name+"<br>");
      out.println("<br>session value : "+ls_value+"<br>");
    }
  }
%>
