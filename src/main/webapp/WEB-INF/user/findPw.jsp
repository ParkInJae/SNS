<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/nav.jsp" %>
	<!--웹페이지 본문-->
	<section>
		<div class="find">
			<span class="findIdTop">
				<span class="findPw">
					아이디찾기
				</span>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<span class="findId">
					비밀번호찾기
				</span>
			</span>
			<div class="findIdBottom">
				<div class="findIdInput">
					<img class="profileIcon" src="./id.png" alt="id">
					<input class="findIdTextCon1" type="text" placeholder="아이디">
				</div>
				<div class="findEmailInput">
					<img class="photoIcon" src="./photo.png" alt="id">
					<input class="findIdTextCon1" type="text" placeholder="이메일">
					&nbsp;&nbsp;
					<input class="findIdTextCon2" type="button" value="인증하기">
				</div>
				<div class="findIdEmailBtn">
					<input class="findIdBtn" type="button" value="비밀번호찾기">
				</div>
			</div>
		</div>
	</section>
