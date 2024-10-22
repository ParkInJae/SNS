<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ include file="/WEB-INF/include/nav.jsp" %>
<script>
	window.onload = function(){
		/* view 페이지 띄우는 모달 */
			// 모달 띄우기 버튼
		$(".listDiv").click(function() {
		    $("#modal").fadeIn(); // 모달 창 보이게 하기
		});
		
		$(window).click(function(event) {
		    if ($(event.target).is("#modal")) {
		        $("#modal").fadeOut(); // 모달 창 숨기기
		    }
		});
		
		/* 회원가입,로그인 페이지 띄우는 모달 */
			// 모달 띄우기 버튼
		$(".userHeader a").click(function() {
		    $("#user_modal").fadeIn(); // 모달 창 보이게 하기
		    var clickedId = $(this).attr('id');
		    if (clickedId === "join") {
		        $("#user_modalBody").html("<h2>회원가입</h2>"); // 회원가입 텍스트 넣기
		    } else if (clickedId === "login") {
		        $("#user_modalBody").html("<h2>로그인</h2>"); // 로그인 텍스트 넣기
		    }
		});
		
		
		$(window).click(function(event) {
		    if ($(event.target).is("#user_modal")) {
		        $("#user_modal").fadeOut(); // 모달 창 숨기기
		    }
		});
	}
	// index 페이지에 해당 글 번호에 대한 게시글을 불러오는게 필요함 
	// listDiv를 클릭했을 때 함수 () 실행 , script에서  ajax 사용해야함
</script>
<!--웹페이지 본문-->
<section class="scrollable">
	<div id="indexDiv">
           <!-- 1번째 줄 -->
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <!-- 2번째 줄 -->
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <!-- 3번째 줄 -->
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <!-- 4번째 줄 -->
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
           <div class="listDiv">
               <!-- 이미지 -->
           </div>
       </div> 
</section>
<!-- view 페이지 모달창 -->
<div id="modal" style="display:none;">
    <div class="modal-content">
        <div id="modalBody">
            <!-- 게시글 내용이 여기에 표시됨 -->
        </div>
    </div>
</div>
<!-- 회원가입,로그인 모달창 -->
<div id="user_modal" style="display:none;">
    <div class="user_modal-content">
        <div id="user_modalBody">
            <!-- 회원가입,로그인페이지 여기에 표시됨 -->
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/aside.jsp" %>