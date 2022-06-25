<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link href="<c:url value="/resources/SHIM/css/member/main.css" />?1" rel="stylesheet">
<script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>
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
			
			<c:set var="list" value="${List }" />
			<c:set var="paging" value="${Paging }" />
			<c:set var="sortKey" value="${sortKey }" />
			
			<section id="section">
				<div class="head">
		<%-- ----------------------- 정렬 부분 ----------------------- --%>
					<div class="sort_block">
						<select name="sort" class="sort">
						  <option selected>※정렬※</option>
						  <option value="id" ${sortKey == 'id' ? 'selected="selected"' : '' }>아이디</option>
						  <option value="name" ${sortKey == 'name' ? 'selected="selected"' : '' }>성 명</option>
						  <option value="email" ${sortKey == 'email' ? 'selected="selected"' : '' }>이메일</option>
						  <option value="joindate" ${sortKey == 'joindate' ? 'selected="selected"' : '' }>가입일</option>
						  <option value="conndate" ${sortKey == 'conndate' ? 'selected="selected"' : '' }>접속일</option>
						</select>
					</div>
		<%-- ----------------------- 검색 부분 ----------------------- --%>
					<form method="post" action="<%=request.getContextPath() %>/member_search.do">
						<%-- <input type="hidden" name="page" value="${paging.getPage() }"> --%>
						<div class="search">
							<select name="search">
							  <option value="id">아이디</option>
							  <option value="name">성 명</option>
							  <option value="email">이메일</option>
							</select>
							<div class="search_key_btn">
								<input class="search_key" type="search" name="keyword" placeholder="Search..." required/>
								<button class="search_btn" type="submit">
									<span class="icon-search"></span>
								</button>
							</div>
						</div>
					</form>
				</div>
		<%-- ----------------------- 목록 부분 ----------------------- --%>
				<table class="table table-hover">
					<tr class="thead">
						<th>아이디</th> <th>성 명</th>
						<th>이메일</th> <th>가입일</th> <th>최근 접속일</th> 
					</tr>
					<c:forEach items="${list }" var="dto">
						<tr class="detail-user" style="cursor:pointer;" 
							onClick="location.href='<%=request.getContextPath() %>/member_list.do?num=${dto.member_no }&page=${paging.getPage() }&sortKey=${sortKey }'">
							<td>${dto.mem_id }</td> 
							<td>${dto.mem_name }</td>
							<td>${dto.mem_email }</td> 
							<td>${dto.mem_regdate.substring(0, 10) }</td>
							<td>${dto.mem_condate.substring(0, 19) }</td>
						</tr>
					</c:forEach>
				</table>
		<%-- ----------------------- 페이징 부분 ----------------------- --%>		
				<nav class="paging" aria-label="Page navigation example">
					<ul class="pagination justify-content-center">
						<c:if test="${paging.getPage() > paging.getBlock() }">
							<li class="page-item">
								<a class="page-link" href="member_list.do?page=1&sortKey=${sortKey }">«</a>
							</li>
							<li class="page-item">
								<a class="page-link" href="member_list.do?page=${paging.getStartBlock() - 1 }&sortKey=${sortKey }">‹</a>
							</li>
						</c:if>		
						
						<c:forEach begin="${paging.getStartBlock() }" end="${paging.getEndBlock() }" var="i">
							<c:if test="${i == paging.getPage() }">
								<li class="page-item cur-page">
									<a class="page-link" href="member_list.do?page=${i }&sortKey=${sortKey }">${i }</a>
								</li>
							</c:if>
							<c:if test="${i != paging.getPage() }">
								<a class="page-link" href="member_list.do?page=${i }&sortKey=${sortKey }">${i }</a>
							</c:if>
						</c:forEach>
						
						<c:if test="${paging.getEndBlock() < paging.getAllPage() }">
							<li class="page-item"><a class="page-link" href="member_list.do?page=${paging.getEndBlock() + 1 }&sortKey=${sortKey }">›</a></li>
							<li class="page-item"><a class="page-link" href="member_list.do?page=${paging.getAllPage() }&sortKey=${sortKey }">»</a></li>
						</c:if>	
					</ul>
				</nav>	
			</section>
		</main>
	</div>	
	
	<%-- 회원 상세 정보 --%>
	<c:if test="${!empty detailList }">
		<jsp:include page="memberDetail.jsp" />
	</c:if>
	
<script type="text/javascript">

	$(function() {
		$(".sort").change(function() {
			var sortKey = $(this).val(); // 정렬 키
			var url = "member_list.do?sortKey="; // pathname + parameter
			
			location.href=url.concat(sortKey);
		});
	});
	
</script>	
</body>
</html>