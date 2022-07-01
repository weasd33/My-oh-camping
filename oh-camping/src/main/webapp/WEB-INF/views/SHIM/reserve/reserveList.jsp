<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link href="<c:url value="/resources/SHIM/css/reserve/main.css" />?17" rel="stylesheet">
<script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="<%=request.getContextPath() %>/resources/SHIM/js/reserveList.js?5"></script>
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
			<div>예약 목록</div>
			<section id="section">
		<%-- ----------------------- 분류 부분 ----------------------- --%>
				<table class="table division-table">
					<tr>
						<th>객실 상태</th>
						<td class="radio">
							<div class="tooltip">
								<input id="r1" type="radio" name="room_status" value="all_status" checked/>
								<label for="r1">전체</label> <span class="tooltiptext">2개월 전 ~ 2개월 후를 기본으로 합니다.</span>
							</div>
							<div class="tooltip">
								<input id="r2" type="radio" name="room_status" value="status1" />
								<label for="r2">예약 가능</label> <span class="tooltiptext">오늘 ~ 1개월 후를 기본으로 하며<br>시작 날짜가 오늘 이전일 수 없습니다.</span>
							</div>
							<div class="tooltip">
								<input id="r3" type="radio" name="room_status" value="status2" />
								<label for="r3">예약 완료</label> <span class="tooltiptext">오늘 ~ 1개월 후를 기본으로 하며<br>시작 날짜가 오늘 이전일 수 없습니다.</span>
							</div>
							<div class="tooltip">
								<input id="r4" type="radio" name="room_status" value="status3" />
								<label for="r4">사용 완료</label> <span class="tooltiptext">1개월 전 ~ 어제를 기본으로 하며<br>마지막 날짜가 어제 이후일 수 없습니다.</span>
							</div>
							<div class="tooltip">
								<input id="r5" type="radio" name="room_status" value="status4" />
								<label for="r5">미사용</label> <span class="tooltiptext">1개월 전 ~ 어제를 기본으로 하며<br>마지막 날짜가 어제 이후일 수 없습니다.</span>
							</div>
						</td>
						<th>객실 분류</th>
						<td class="room">
							<select id="divide_room" name="divide_room">
								<option value="all_room" selected>객실 전체</option>
								<option class="separator" disabled>∥계곡∥</option>
								<option value="계곡 1호">계곡 1호</option>
								<option value="계곡 2호">계곡 2호</option>
								<option value="계곡 3호">계곡 3호</option>
								<option value="계곡 4호">계곡 4호</option>
								<option value="계곡 5호">계곡 5호</option>
								<option class="separator" disabled>∥대형∥</option>
								<option value="대형 1호">대형 1호</option>
								<option value="대형 2호">대형 2호</option>
								<option value="대형 3호">대형 3호</option>
								<option value="대형 4호">대형 4호</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>기 간</th>
						<td>
							<input type="date" class="sDate"/>
							<span class="date-range">~</span> 
							<input type="date" class="eDate"/> 
							<input class="inquire-btn" type="button" onclick="getSortList()" value="조회" />
						</td>
					</tr>
				</table>
				<%-- ----------------------- 예약 목록  ----------------------- --%>
				<div class="sales-body">
					<table class="table table-hover sales-table">
						<thead>
							<tr class="sales-thead">
								<th>날 짜</th>
								<th>객실번호</th>
								<th>객실명</th>
								<th>총 원</th>
								<th>객실가격</th>
								<th>객실상태</th>
							</tr>
						</thead>
						<tbody class="sales-tbody" style="cursor:pointer;">
							<%-- Ajax 객실 List --%>
						</tbody>
					</table>
					<%-- ----------------------- 예약 상세 정보 ----------------------- --%>
					<div class="sales-content">
						<table class="table content-table">
						<%-- Ajax 예약 상세 List --%>
						</table>
					</div>
				</div>
			</section>
		</main>
	</div>		
	
</body>
</html>