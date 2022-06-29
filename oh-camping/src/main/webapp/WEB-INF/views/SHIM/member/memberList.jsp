<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link href="<c:url value="/resources/SHIM/css/member/main.css" />?3" rel="stylesheet">
<script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="<%=request.getContextPath() %>/resources/SHIM/js/member.js"></script>
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
						  <option value="id" ${sortKey == 'id' ? 'selected="selected"' : '' }>아이디</option>
						  <option value="name" ${sortKey == 'name' ? 'selected="selected"' : '' }>성 명</option>
						  <option value="email" ${sortKey == 'email' ? 'selected="selected"' : '' }>이메일</option>
						  <option value="joindate" ${sortKey == 'joindate' ? 'selected="selected"' : '' }>가입일</option>
						  <option value="conndate" ${sortKey == 'conndate' ? 'selected="selected"' : '' }>접속일</option>
						</select>
					</div>
		<%-- ----------------------- 검색 부분 ----------------------- --%>
					<%-- <input type="hidden" name="page" value="${paging.getPage() }"> --%>
					<div class="search">
						<select class="search_option" name="search">
						  <option value="id">아이디</option>
						  <option value="name">성 명</option>
						  <option value="email">이메일</option>
						</select>
						<div class="search_key_btn">
							<input class="search_key" type="search" name="keyword" placeholder="Search..."/>
							<button class="search_btn" type="button">
								<span class="icon-search"></span>
							</button>
						</div>
					</div>
				</div>
		<%-- ----------------------- 목록 부분 ----------------------- --%>
				<table class="table table-hover">
					<tr class="thead">
						<th>아이디</th> <th>성 명</th>
						<th>이메일</th> <th>가입일</th> <th>최근 접속일</th> 
					</tr>
					<tbody class="detail-user">
					<%-- Ajax 회원 조회 --%>
					</tbody>
				</table>
		<%-- ----------------------- 페이징 부분 ----------------------- --%>		
				<nav class="paging" aria-label="Page navigation example">
					<ul class="pagination justify-content-center">
					<%-- Ajax 페이징 --%>
					</ul>
				</nav>	
			</section>
		</main>
	</div>	
	
		<%-- ----------------------- 회원 상세 부분 ----------------------- --%>		
		<div class="card detail-modal">
			<div class="card-body">
			<%-- Ajax 회원 상세 --%>
			</div>
		</div>
</body>
</html>