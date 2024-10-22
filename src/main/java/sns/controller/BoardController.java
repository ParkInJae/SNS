package sns.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Enumeration;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import sns.util.DBConn;
import sns.vo.UserVO;


public class BoardController {
	public BoardController(HttpServletRequest request
			, HttpServletResponse response
			, String[] comments) throws ServletException, IOException {
		
		if(comments[comments.length-1].equals("write.do")) {
			if(request.getMethod().equals("GET")) {
				write(request,response);
			}else if (request.getMethod().equals("POST")) {
				writeOk(request,response);
			}
		
		}else if (comments[comments.length-1].equals("view.do")) {
			
		}
		
		
	}
	
	public void write(HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/board/write.jsp").forward(request, response);
	}
	
	public void writeOk(HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		/* String uploadPath = request.getServletContext().getRealPath("/upload"); */
		String uploadPath = "D:\\pij\\workspace\\SNS\\src\\main\\webapp\\upload";
		System.out.println("서버의 업로드 폴더 경로 : " + uploadPath);
		HttpSession session = request.getSession();
		UserVO loginUser = (UserVO)session.getAttribute("loginUser");
		int uno = Integer.parseInt(loginUser.getUno()); 
		
		int size = 10 * 1024 * 1024;
		MultipartRequest multi;
		try {
		    // 파일 업로드 처리
		    multi = new MultipartRequest(request, uploadPath, size, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			e.getStackTrace();
		    // 파일 업로드 실패 시 처리
		    response.sendRedirect(request.getContextPath());
		    return;
		}

		// input 타입에 파일이 여러개 존재하는 경우  
		Enumeration files = multi.getFileNames();
		/*
			// 파일이 input 타입에 한 개만 존재하는 경우 
			multi.getFilesystemName("attach");
		*/
		String filename = multi.getFilesystemName("attach");  // 원본 파일 이름
		String phyname = null;   // 서버에 저장될 파일 이름
		String title = multi.getParameter("title");
		String content = multi.getParameter("content");
		
		if (files.hasMoreElements()) {
		    String fileid = (String) files.nextElement();
		    filename = multi.getFilesystemName(fileid);  // 원본 파일 이름 가져오기

		    if (filename != null) {
		        System.out.println("업로드된 파일 이름: " + filename);
		        System.out.println("title:"+title);
		        System.out.println("content:"+content);
		        
		        // 물리 파일 이름 생성 (UUID 사용)
		        phyname = UUID.randomUUID().toString();  
		        
		        // 파일 경로 설정
		        String srcName = uploadPath + "/" + filename;  
		        String targetName = uploadPath + "/" + phyname;
		        
		        // 파일 이름 변경 (UUID로 저장)
		        File srcFile = new File(srcName);
		        File targetFile = new File(targetName);

		        boolean renamed = srcFile.renameTo(targetFile);
		        if (!renamed) {
		            System.out.println("파일 이름 변경 실패");
		        } else {
		            System.out.println("파일 이름 변경 성공: " + phyname);
		        }
		    }
		}
	
		if (phyname == null) phyname = "";
		if (filename == null) filename = "";
		
		Connection conn = null;			
		PreparedStatement psmt = null;
		
		Connection connAttach = null;			
		PreparedStatement psmtAttach = null;
		int resultAttach =0;
		try {
			conn = DBConn.conn();
			String sql = " INSERT INTO board (uno,title,content)"
					+ " VALUES(?,?,?)";
			// sql을 담고, 리턴 키를 받음
			psmt =conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
			psmt.setInt(1, uno);
			psmt.setString(2, title);
			psmt.setString(3, content);
			int result = psmt.executeUpdate();
			if(result>0) {
				//업데이트가 성공하면, getGeneratedKeys()를 통해서 키를 받아옴
				ResultSet rs = psmt.getGeneratedKeys();
				// 이때 getLong은 long타입이기 때문에 long타입의 변수를 생성해줘야함
				long key = 0L;
				if (rs.next()) {
				    key = rs.getLong(1);
				}
				String sql1 = " SELECT LAST_INSERT_ID() as bno";
				sql1 = " INSERT INTO attach (bno, pname, fname) VALUES (?, ?, ?)";
				// select last_insert_id()를 받아와서 , bno를 대입 
				psmtAttach =conn.prepareStatement(sql1);
				psmtAttach.setLong(1, key);  // 통해 받아온 키를 bno에 저장함,
				psmtAttach.setString(2, phyname);  // 물리파일 이름 (서버에 저장된 파일의 이름)
				psmtAttach.setString(3, filename); // 원본 파일 이름 (사용자가 업로드한 파일 이름)
				resultAttach = psmtAttach.executeUpdate();
				
				System.out.println("result::"+result);
				System.out.println("result::"+ resultAttach);
				
				/*
				 // redirect는 새로고침 하기 때문에 ,ajax의 목적인 페이지를
				    새로고침하지 않고 서버와 데이터를 주고 받는게 될 수 없음
				response.sendRedirect(request.getContextPath()+"index.jsp");*/
				response.setContentType("text/html;charset=UTF-8");
				PrintWriter out = response.getWriter();  
				out.print("success");  
				out.flush();
				out.close();      
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			response.setContentType("text/html;charset=UTF-8");
	        PrintWriter out = response.getWriter();   
            out.print("error");  
	        out.flush();
	        out.close();	
		}finally {
			try {
				DBConn.close(psmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
			
		
	}
	
	
	
}
