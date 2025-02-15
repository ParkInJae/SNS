package sns.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sns.util.DBConn;
import sns.vo.UserVO;

public class AdminController {
	public AdminController(HttpServletRequest request
			, HttpServletResponse response
			, String[] comments) throws ServletException, IOException {
		
		if(comments[comments.length-1].equals("blackList.do")) {
			if(request.getMethod().equals("GET")) {
				blackList(request,response);
			}
		}else if(comments[comments.length-1].equals("complainList.do")) {
			
			if(request.getMethod().equals("GET")) {
				complainList(request,response);
			}
		}
	}
		
		public void blackList (HttpServletRequest request
				, HttpServletResponse response) throws ServletException, IOException {
			request.getRequestDispatcher("/WEB-INF/admin/blackList.jsp").forward(request, response);
		}
		
		public void complainList (HttpServletRequest request
				, HttpServletResponse response) throws ServletException, IOException {
			request.getRequestDispatcher("/WEB-INF/admin/complainList.jsp").forward(request, response);
		}
		
		
	
}
