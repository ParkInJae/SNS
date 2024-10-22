<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/nav.jsp" %>


	<!-- header 검색창, 프로필이미지, 알림, 메시지 -->
	
	<!-- nav 인덱스페이지로 이동, 글쓰기버튼, 다크모드&라이트모드 전환, 관리자의 경우 신고내역확인 -->
	<!--웹페이지 본문-->
	<section>
        <div class="bcSpan">
            <span class="bUnderline" > 블랙리스트 </span>
            <span class="cUnderline" ><a href="<%= request.getContextPath() %>/admin/complainList.do" style="color: lightgray;"> 신고 게시글</a></span>
        </div>
        <div class="complainTable">
          
            <table class="inner_table">
                <thead>
                	<tr>
	                    <th>신고 번호</th>
	                    <th>닉네임</th>
	                    <th>이메일</th>
	                    <th>가입일</th>
	                    <th>신고 횟수</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>10</td>
                        <td>hong</td>
                        <td>hong@hong.com</td>
                        <td>10.14</td>
                        <td>100번</td>
                    </tr>
                    <tr>
                        <td>10</td>
                        <td>hong</td>
                        <td>hong@hong.com</td>
                        <td>10.14</td>
                        <td>100번</td>
                    </tr>
                    <tr>
                        <td>10</td>
                        <td>hong</td>
                        <td>hong@hong.com</td>
                        <td>10.14</td>
                        <td>100번</td>
                    </tr>
                    <tr>
                        <td>10</td>
                        <td>hong</td>
                        <td>hong@hong.com</td>
                        <td>10.14</td>
                        <td>100번</td>
                    </tr>
                    <tr>
                        <td>10</td>
                        <td>hong</td>
                        <td>hong@hong.com</td>
                        <td>10.14</td>
                        <td>100번</td>
                    </tr>
                </tbody>
            </table>
        </div>
	</section>