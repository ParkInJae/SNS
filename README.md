
코드작성 할 때 , 경로 3개와 해당하는 메소드 3개가 필요하다고 생각했음
아래는 해당하는 경로 3개 
```
		1) onclick="location.href='<%= request.getContextPath() %>/user/mypage.do?uno=<%= vo.getUno() %>&type=written'"
   		2) onclick="location.href='<%= request.getContextPath() %>/user/mypage.do?uno=<%= vo.getUno() %>&type=bookmark'"
      		3) onclick="location.href='<%= request.getContextPath() %>/user/mypage.do?uno=<%= vo.getUno() %>'"
```
위의 경로와 상응하는 메소드 3개를 생각했음
```
else if (comments[comments.length - 1].equals("mypage.do")) {
			mypage(request, response);
}
else if (comments[comments.length - 1].equals("mypage_bookmark.do")) {
			myPageBookmark(request, response);
}else if (comments[comments.length - 1].equals("mypage_written.do")) {
			myPageWrite(request, response);
}
```
그러나 위의 내용처럼 작성할 경우 , 너무 복잡하고 
  myPageBookmark와 myPageWrite를 쪼개서 user와 board와 follow에 대한 쿼리를 작성해야했음
  


  
📗 개선한 부분

```
else if (comments[comments.length - 1].equals("mypage_bookmark.do")) {
			myPageBookmark(request, response);
}else if (comments[comments.length - 1].equals("mypage_written.do")) {
			myPageWrite(request, response);
}
```
위의 코드를 삭제 후 header와 프로필 이미지를 클릭 했을 때 mypage.do에서 모든 처리를 하고 ,if문을 사용해서 
해당 조건에 따라서 정리를 했음 

정리 후 코드      
```
// 클릭했을 때 mypage로 이동 
onclick="location.href='<%= request.getContextPath() %>/user/mypage.do?uno=<%= vo.getUno() %>&type=written'"

// mypage.do 일 때 해당 mypage로 이동
else if (comments[comments.length - 1].equals("mypage.do")) {
			mypage(request, response);
		}
// mypage 메소드 
public void mypage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		UserVO loginUser = null;
		if(session.getAttribute("loginUser") != null && !session.getAttribute("loginUser").equals("")) {
			loginUser = (UserVO)session.getAttribute("loginUser");
		}
		String uno = request.getParameter("uno");
		String type = "bookmark";
		if(request.getParameter("type") != null && !request.getParameter("type").equals("")) {
			type = request.getParameter("type");
		}
		request.setCharacterEncoding("UTf-8");

		Connection conn = null; // DB 연결
		PreparedStatement psmt = null; // SQL 등록 및 실행. 보안이 더 좋음!
		ResultSet rs = null; // 조회 결과를 담음

		PreparedStatement psmtFollow = null;
		ResultSet rsFollow = null;
		// try 영역
		try {
			conn = DBConn.conn();
			String sql = "";
			if(loginUser != null) {
				sql = "select *,(select count(*) from follow f where f.uno = ? and tuno = ? ) as isfollow from user where uno=?"; 
				psmt = conn.prepareStatement(sql);
				psmt.setString(1, loginUser.getUno()); 
				psmt.setString(2, uno);
				psmt.setString(3, uno);
			}else {
				sql = "select * from user where uno=?";
				psmt = conn.prepareStatement(sql);
				psmt.setString(1, uno); 
			}
			rs = psmt.executeQuery();
			String isfollow="";
			// 수정할 부분
			if(rs.next()) {
				UserVO user = new UserVO();
				user.setUno(rs.getString("uno"));
				user.setUid(rs.getString("uid"));
				user.setUnick(rs.getString("unick"));
				user.setUemail(rs.getString("uemail"));
				user.setUstate(rs.getString("ustate"));
				user.setUauthor(rs.getString("uauthor"));
				user.setUrdate(rs.getString("urdate"));
				user.setPname(rs.getString("pname"));
				user.setFname(rs.getString("fname"));
				if(loginUser != null) {
					isfollow = rs.getString("isfollow");
					System.out.println("isfollow : " + isfollow);
					request.setAttribute("isfollow", isfollow);
				}
				request.setAttribute("user", user);
			}
			if(loginUser != null) {
				// 세션에 있는 uno와 일치하는 팔로우 테이블의 uno를 카운트를 조회한다
				String sqlFollow = " select count(*) as cnt from follow where tuno = ? ";
	
				psmtFollow = conn.prepareStatement(sqlFollow);
				psmtFollow.setInt(1, Integer.parseInt(uno));
	
				rsFollow = psmtFollow.executeQuery();
	
				int cnt = 0;
				if (rsFollow.next()) {
					cnt = rsFollow.getInt("cnt");
				}
				request.setAttribute("fcnt", cnt);
			}
			if(type.equals("bookmark")) {
				myPageBookmark(request, response);
			}else {
				myPageWrite(request, response);
			}
			
			request.getRequestDispatcher("/WEB-INF/user/mypage.jsp").forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				DBConn.close(rs, psmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
```
✴︎ 중요하다고 생각한 부분 (내가 처음에 생각했을 때 놓친 부분 )
1) mypage.jsp에서 및 usercontroller에서 loginUser가 null , type의 값이 null 일 때  유효성 검사를 할 생각을 하지 못했음 

```
// userController에서 UserVO가 null일 때의 유효성 검사

UserVO loginUser = null;
		if(session.getAttribute("loginUser") != null && !session.getAttribute("loginUser").equals("")) {
			loginUser = (UserVO)session.getAttribute("loginUser");
		}
		String uno = request.getParameter("uno");
		String type = "bookmark";
		if(request.getParameter("type") != null && !request.getParameter("type").equals("")) {
			type = request.getParameter("type");
		}

// mypage.jsp 에서의 불러오는 객체들에 대한 유효성 검사
%
UserVO login = null;
if(session.getAttribute("loginUser") != null){
	login = (UserVO)session.getAttribute("loginUser");
}
UserVO pageUser = null;
if(request.getAttribute("user") != null){
	pageUser = (UserVO)request.getAttribute("user");
}
System.out.println("pageUser=================================" +pageUser );
String pUno = "";
String pPname = "";
if(pageUser != null){
	pUno = pageUser.getUno();
	pPname = pageUser.getPname();
}
// 현재 보고있는 섹션을 페이지가 알 수 있도록 표시하기 위해 type 변수 선언 
String type = "bookmark";
if (request.getParameter("type") != null && !request.getParameter("type").equals("")) {
    type = request.getParameter("type");
}
ArrayList<BoardVO> board = null;
if(request.getAttribute("board") != null ){
	board = (ArrayList)request.getAttribute("board");
}
FollowVO vo = null;
if(request.getAttribute("follow") != null ){
	vo = (FollowVO)request.getAttribute("follow");
}
int cnt = 0;
if(request.getAttribute("fcnt") != null ){
	cnt = (Integer)request.getAttribute("fcnt");
}
%>

```

2) type의 값을 이용해서 문자열이 같을 때 해당하는 메소드로 보낼 수 있다는 생각을 하지 못했음 <br/>
아래 처럼 타입에 맞는 문자열을 이용해서 값을 보냈다면, 이미 생성된 메소드를 쪼갤 필요가 없었음.. 
```
if(type.equals("bookmark")) {
				myPageBookmark(request, response);
			}else {
				myPageWrite(request, response);
			}

```







