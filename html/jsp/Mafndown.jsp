<%@ page import='java.util.* , java.io.*'%>
<%@ include file="MaFpsCommon.jsp"%>
<%@ include file="MaFunction.jsp"%>
<%
	String requestFileNameAndPath = request.getParameter("fn");
	String requestFileServerIp = request.getParameter("fs");  
	String requestDatFile = request.getParameter("prtdat");

	String filePath = strDownFolder;
	int iPrtDatUpdate = 0;
	String strSID = session.getId();
	
	if(requestFileNameAndPath == null)
	{
		if(requestDatFile != null)
		{
			filePath = strPrtDatDownFolder;
			requestFileNameAndPath = "MaPrintInfoEPSmain.dat";
			iPrtDatUpdate = 1;
		}
	}
	else
	{
		//relativePathCheck();
		requestFileNameAndPath = safetyFileNameCheck(requestFileNameAndPath);
		if(requestFileNameAndPath.length() > 17 || !requestFileNameAndPath.matches("-?\\d+(\\.\\d+)?"))
			return;
		String strParamCookie = strSID;
		strParamCookie += requestFileNameAndPath + ".matmp";
	
		requestFileNameAndPath = strParamCookie;
	}
	
	InputStream in = null;
	OutputStream os = null;
	File file = null;
	int     iFileSize = 0;
	String  strOnlyFileName         = new String();
      
	//os = response.getOutputStream();
    // NAS를 사용하거나 프린터 파일 저해상도 파일을 받아올때
	if(iUseNas == 1 || requestFileNameAndPath == null)
	{ 
	try{
    //out.println(filePath);
    // 파일을 읽어 스트림에 담기
		file = new File(filePath, requestFileNameAndPath);
		
		if(file.isFile () )
		{  
			iFileSize = (int)file.length();
			strOnlyFileName = file.getName();
			if(iPrtDatUpdate != 1)
			{
				strOnlyFileName += ".matmp";
			}     
			out.clear();
			out = pageContext.pushBody();
			response.reset();
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setHeader("Pragma","no-cache;");
			response.setHeader("Expires", "-1;");
			response.setContentType("application/x-msdownload");
			response.setHeader("Content-Disposition", "attachment; fileName=" + strOnlyFileName+ ";");
			response.setContentLength((int)iFileSize);
		}
		
		in = new FileInputStream(file);
		os = response.getOutputStream();
		
		byte b[] = new byte[(int)file.length()+1];
		int leng = 0;
		
		while( (leng = in.read(b)) > 0 ){
		os.write(b,0,leng);
		}
		}catch (IOException e) { 
			System.out.println("matmprp_filedown buffer Error");
			//e.printStackTrace(System.err);
			return;
		}finally {
			if(in != null){
				in.close();
			}
			if(os != null){
				os.close();
			}
			if(requestDatFile == null && file != null){
				file.delete();
			}
		}
	}
	else {
		//strFileServerIp
		byte[] byteIP = MaBase64Utils.base64Decode( requestFileServerIp);
		strFileServerIp = new String(byteIP);
		
		
		// create instance
		masavefile clMaSaveFile = new masavefile();

		// Call Ma2DCode library
		try
		{
			String  strRet = clMaSaveFile.strGetMetaFile (
        			                strFileServerIp,
        			                iFileServerPort,
        			                requestFileNameAndPath,
        			                "",
                                    "" );

    		String	strRetCode = strRet.substring( 0, 5 );
    		String	strRetData = strRet.substring( 5 );
    		int		iRetCode = Integer.parseInt( strRetCode );

    		    		
    		// Success ...
	    	if( iRetCode == 0 )
	        {    
				out.clear();
				os = response.getOutputStream();
			    byte[] byteRetData = strRetData.getBytes();
	            os.write( byteRetData, 0, byteRetData.length  ); 

    	        //System.out.println( "[SUCESS]" );
    	    }
    	    else
    	    {
    	        //System.out.println( "[FAIL]" );
    	    }
		}
		catch (IOException e) { 
			System.out.println("matmprp_filedown buffer Error");
			//e.printStackTrace(System.err);
		}finally {
			if(os != null){
				os.close();
			}				
		}
	} 
%>