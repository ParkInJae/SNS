
// 코드작성 할 때 , 경로 3개와 해당하는 메소드 3개가 필요하다고 생각했음
// 해당하는 경로 3개 
```
		1) onclick="location.href='<%= request.getContextPath() %>/user/mypage.do?uno=<%= vo.getUno() %>&type=written'"
   		2) onclick="location.href='<%= request.getContextPath() %>/user/mypage.do?uno=<%= vo.getUno() %>&type=bookmark'"
      		3) onclick="location.href='<%= request.getContextPath() %>/user/mypage.do?uno=<%= vo.getUno() %>'"
```
와 그에 상응하는 메소드 3개 
```
else if (comments[comments.length - 1].equals("followAddPage.do")) {
			followAddPage(request, response);
		}else if (comments[comments.length - 1].equals("followAddPage.do")) {
			myPageBookmark(request, response);

		}else if (comments[comments.length - 1].equals("followAddPage.do")) {
			myPageWrite(request, response);
		}
```
  를 생각했음
  
