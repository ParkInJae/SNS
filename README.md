
public class UserController {
	public UserController(HttpServletRequest request, HttpServletResponse response, String[] comments)
			throws ServletException, IOException {

		if (comments[comments.length - 1].equals("login.do")) {
			if (request.getMethod().equals("GET")) {
				login(request, response);
			} else if (request.getMethod().equals("POST")) {
				loginOk(request, response);
			}
		} else if (comments[comments.length - 1].equals("logout.do")) {
			logout(request, response);
		} else if (comments[comments.length - 1].equals("mypage.do")) {
			mypage(request, response);
		} else if (comments[comments.length - 1].equals("join.do")) {
			if (request.getMethod().equals("GET")) {
				join(request, response);
			} else if (request.getMethod().equals("POST")) {
				joinOk(request, response);
			}
		} else if (comments[comments.length - 1].equals("idCheck.do")) {
			idCheck(request, response);
		} else if (comments[comments.length - 1].equals("nickCheck.do")) {
			nickCheck(request, response);
		} else if (comments[comments.length - 1].equals("sendmail.do")) {
			sendmail(request, response);
		} else if (comments[comments.length - 1].equals("getcode.do")) {
			getcode(request, response);
		} else if (comments[comments.length - 1].equals("profileModify.do")) {
			if (request.getMethod().equals("GET")) {
				profileModify(request, response);
			} else if (request.getMethod().equals("POST")) {
				profileModifyOk(request, response);
			}
		} else if (comments[comments.length - 1].equals("findId.do")) {
			findId(request, response);
		} else if (comments[comments.length - 1].equals("findIdResult.do")) {
			if (request.getMethod().equals("POST")) {
				findIdResult(request, response);
			}
		} else if (comments[comments.length - 1].equals("findPw.do")) {
			if (request.getMethod().equals("GET")) {
				findPw(request, response);
			} else if (request.getMethod().equals("POST")) {
				findPwOk(request, response);
			}
		} else if (comments[comments.length - 1].equals("pwChange.do")) {
			if (request.getMethod().equals("POST")) {
				pwChangeOk(request, response);
			}
		} else if(comments[comments.length-1].equals("alramCount.do")) {
			if(request.getMethod().equals("GET")) {
				alramCount(request,response);
			}
		} else if(comments[comments.length-1].equals("alramList.do")) {
			if(request.getMethod().equals("GET")) {
				alramList(request,response);
			}
		} else if(comments[comments.length-1].equals("updateState.do")) {
			if(request.getMethod().equals("GET")) {
				updateState(request,response);
			}
		}else if (comments[comments.length - 1].equals("followAddPage.do")) {
			followAddPage(request, response);
		}else if (comments[comments.length - 1].equals("followAddPage.do")) {
			myPageBookmark(request, response);

		}else if (comments[comments.length - 1].equals("followAddPage.do")) {
			myPageWrite(request, response);
		}
	}
