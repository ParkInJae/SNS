0️⃣  페이징 관련에서 겪었던  어려운 점  <br/>
 기존에 작성한 페이징util 객체를 불러와서 사용을 하는데 , 각각의 쿼리와 함께 사용해야하는 부분에서 혼동이 왔음 <br/><br/>
 
➡️ 기존에 작성한 코드 
```
public void blackList (HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		// controller 영역 
		PreparedStatement psmtTotal = null;
		ResultSet rsTotal = null;

		int nowPage = 1;
		
		if(request.getParameter("nowPage") != null)
		{
			nowPage = Integer.parseInt(request.getParameter("nowPage"));
			System.out.println("nowPage========================== " + nowPage);
		}	
		

		try{
			
			conn = DBConn.conn();
			// 페이징
			String sqlTotal =" SELECT COUNT(DISTINCT b.uno) as total "
					+"   FROM complaint_board c  "
					+"         LEFT JOIN board b ON c.bno = b.bno  "
					+"         GROUP BY b.uno  "
					+"         HAVING COUNT(b.uno) > 0; ";
		
			psmtTotal=conn.prepareStatement(sqlTotal);
			rsTotal = psmtTotal.executeQuery();
			
			//전체 게시글 갯수 담을 변수
			int total = 0; 
			
			if(rsTotal.next())
			{
				total = rsTotal.getInt("total");
			}
			PagingUtil paging = new PagingUtil(nowPage, total, 10);
			
			//데이터 출력에 필요한 게시글 데이터 조회 쿼리 영역
			
			/*
			 	서브쿼리 쓸 때 조심해야함 >> complaint_board c로 작성하면 sql문법 오류가 발생함
			 	(메인쿼리의 별칭은 서브쿼리의 별칭으로 사용할 수 없음 )
			 	서브쿼리 순서 >> 메인 쿼리가 먼저 실행 되고 뒤에 서브 쿼리의 순으로 진행이 됨
			 	메인쿼리 > 여러 테이블을 조인하고 별칭을 정의 
			 	서브 쿼리 > 현제 메인쿼리의 각 행에 대한 정보를 참조,
			 	b.bno는 각 행에 대한 내용 >>> 따라서 서브쿼리에서 사용할 수 있음
			 	그러나 별칭 c 는 각 행이 아닌 테이블 전체에 대한 내용이기 때문에 서브쿼리에 사용할 수 없음 
			 */
			
			String sql = "";
			sql = " select "
			+ "    b.uno, "
			+ "    (select unick from user where uno = b.uno) as nick,  "
			+ "    (select uemail from user where uno = b.uno) as email, "
			+ "    (select urdate from user where uno = b.uno) as rdate, "
			+ "    count(b.uno) as report_count,  "
			+ "    (select ustate from user where uno = b.uno) as state "
			+ " from complaint_board c left join board b on c.bno = b.bno group by b.uno having count(b.uno) > 0 ";
			 sql += " LIMIT ? , ?"; //limit 시작게시글번호(pagingUtil->start필드), 출력
			 /* 갯수(pagingUtil->perPage필드)*/	
			 System.out.println("sql" + sql);
			 
			 
			 System.out.println("paging.getStartPage()::::"+paging.getStart());
			 System.out.println("paging.getPerPage()::::"+paging.getPerPage());
			
			psmt = conn.prepareStatement(sql);
			psmt.setInt(1, paging.getStartPage());
			psmt.setInt(2, paging.getPerPage());
			rs = psmt.executeQuery();
			
			ArrayList <UserVO> list = new ArrayList<>();
			
			while(rs.next()){
				UserVO vo = new UserVO();
				vo.setUnick(rs.getString("nick"));
				vo.setUemail(rs.getString("email"));
				vo.setUrdate(rs.getString("rdate"));
				vo.setDeclaration(rs.getInt("report_count"));
				vo.setUstate(rs.getString("state"));
				vo.setUno(rs.getString("uno"));
				list.add(vo);
				}
			request.setAttribute("list", list);
			request.setAttribute("paging", paging);
			// board 작성한 
			request.getRequestDispatcher("/WEB-INF/admin/blackList.jsp").forward(request, response);
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			try {
				DBConn.close(rs,psmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
```
📗 개선한 부분
처음에는 getStartPage()를 psmt에 세팅하고 있어 오류가 발생하는 줄 모르고 , getStartPage()가 null이라서 받아오지 못한다고 생각하여 
```
	 System.out.println("paging.getStartPage()::::"+paging.getStart());
	 System.out.println("paging.getPerPage()::::"+paging.getPerPage());
```
코드를 통해서 콘솔로 확인하는데 콘솔창에 값을 나타내어, 문제점을 찾지 못하다가 
선생님에게 질문하여 문제점이 paging.getStartPage()은 1부터 시작을 해서 , 게시글이 11개여도 초기 시작인 0번째 인덱스를 생략하고 뽑아내는 논리적 오류가 있다는 것을 알게 되었고, 
<br/>
paging.getStartPage() 이 아니라 paging.getStart()로 작성해야했다는 것을 알고 수정하였다. 
<br/>



getStartPage()를 psmt에 세팅하고 있어서 
글의 개수가 10개를 초과했을 때 다음 페이지를 클릭해도 , 다음 페이지에 이전 페이지에 존재한 내용이 바뀌지 않고 그대로 나오는 이슈가 있었음 


➡️ 수정한 코드 
```
	 System.out.println("paging.getStartPage()::::"+paging.getStart());
	 System.out.println("paging.getPerPage()::::"+paging.getPerPage());
	
	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, paging.getStart());
	psmt.setInt(2, paging.getPerPage());
```

















1️⃣ userController와 mypage에서 겪었던 어려운 점<br/>

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

➡️ 정리 후 코드      
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







