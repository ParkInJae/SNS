<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/nav.jsp" %>
	<!--웹페이지 본문-->
	<section>
		<div class="profileModify">
			<div class="profileLeft">
				<label>
					<div class= "profileImg">
						<img src="./490_2342_3934.jpg" alt="고양이" 
						style="width: 350px;height: 350px; border-radius: 200px;">
					</div>
					<input type="file" style="display: none;">
				</label>
			</div>
			<div class="profileRight">
				<div class= "profileListDiv">
					<ul class= "profileListUl">
						<li>
							<img class="imgIconId" src="./id.png" alt="id" >
							<input class="profileList" type="text" placeholder="아이디">
						</li>
						<li>
							<img class="imgIconMail" src="./email.png" alt="id">
							<input class="profileList" type="text" placeholder="이메일">
						</li>
						<li>
							<img class="imgIconId" src="./id.png" alt="id">
							<input class="profileList" type="text" placeholder="닉네임">
						</li>
						<li>
							<img class="imgIconPhoto" src="./photo.png" alt="id">
							<input class="profileList" type="text" placeholder="프로필이미지 재선택">
						</li>
						<li>
							<img class="imgIconPw" src="./pw.png" alt="id">
							<input class="profileList" type="text" placeholder="비밀번호">
						</li><br>
						<li>
							<div class= "profileListBtn">
								<input class="profileBtnM" type="button" value="수정">
								&nbsp;&nbsp;
								<input class="profileBtnC" type="button" value="취소">
							</div>
						</li>
					</ul>
					<!-- <div class= "profileListBtn">
						<input class="profileBtnM" type="button" value="수정">
						&nbsp;&nbsp;
						<input class="profileBtnC" type="button" value="취소">
					</div> -->
				</div>
			</div>
		</div>
	</section>
