<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link href="<c:url value="/resources/SHIM/css/member/main.css" />?26" rel="stylesheet">
<script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="<%=request.getContextPath() %>/resources/SHIM/js/member.js?9"></script>
</head>
<body>
	<header class="header">
		<jsp:include page="../include/header.jsp" />
	</header>
		
	<div id="body">
		<aside>
			<jsp:include page="../include/aside.jsp" />
		</aside>
		
		<main id="main">
			<div>회원 목록</div>
			
			<section id="section">
				<div class="head">
		<%-- ----------------------- 정렬 부분 ----------------------- --%>
					<div class="sort_block">
						<select name="sort" class="sort">
						  <option value="null" selected>※정렬※</option>
						  <option value="no">번호</option>
						  <option value="id">아이디</option>
						  <option value="name">성 명</option>
						  <option value="email">이메일</option>
						</select>
					</div>
		<%-- ----------------------- 검색 부분 ----------------------- --%>
					<div class="search">
						<select class="search_option" name="search">
						  <option value="no">번호</option>
						  <option value="id">아이디</option>
						  <option value="name">성 명</option>
						  <option value="email">이메일</option>
						</select>
						<div class="search_key_btn">
							<input class="search_key" type="search" name="keyword" placeholder="Search..."
								onkeypress="if( event.keyCode == 13 ){search();}"/>
							<button class="search_btn" type="button" onclick="search();">
								<span class="icon-search"></span>
							</button>
						</div>
					</div>
				</div>
		<%-- ----------------------- 목록 부분 ----------------------- --%>
				<table class="table table-hover">
					<tr class="thead">
						<th>No.</th> <th>아이디</th> <th>성 명</th> <th>이메일</th>
					</tr>
					
					<%-- 회원 조회 --%>
					<tbody class="detail-user"></tbody>
				</table>
				<nav class="paging" aria-label="Page navigation example">
				
					<%-- 회원 페이징 --%>
					<ul class="list-page pagination justify-content-center"></ul>
				</nav>	
			</section>
		</main>
	</div>	
	<%-- ----------------------- 회원 상세 부분 ----------------------- --%>		
	<div class="card detail-modal">
	
		<%-- 회원 정보 --%>
		<div class="card-body"></div>
		
		<%-- 문의 내역 --%>
		<div class="inquiry"></div>
		
		<%-- 예약 내역 --%>
		<div class="reserve"></div>
		
		<%-- 회원 수정 --%>
		<div class="modify"></div>		
			
	</div>
</body>
</html>
