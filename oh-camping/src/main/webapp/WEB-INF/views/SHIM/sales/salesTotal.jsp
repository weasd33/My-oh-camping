<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>매출 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link href="<c:url value="/resources/SHIM/css/sales/main.css" />?17" rel="stylesheet">
<script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
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
			<div>매출 목록</div>
			<section id="section">
		<%-- ----------------------- 분류 부분 ----------------------- --%>
				<form action="<%=request.getContextPath() %>/sales/list.do">
					<table class="table division-table">
						<tr>
							<th>날 짜</th>
							<td class="radio">
								<input id="r1" type="radio" name="radio_date" value="all_date" checked/>
								<label for="r1">전체</label>
								<input id="r2" type="radio" name="radio_date" value="today"
									${date == 'today' ? 'checked="checked"' : '' } />
								<label for="r2">오늘</label>
								<input id="r3" type="radio" name="radio_date" value="week"
									${date == 'week' ? 'checked="checked"' : '' } />
								<label for="r3">7일</label>
								<input id="r4" type="radio" name="radio_date" value="month"
									${date == 'month' ? 'checked="checked"' : '' } />
								<label for="r4">1개월</label>
								<input id="r5" type="radio" name="radio_date" value="3month"
									${date == '3month' ? 'checked="checked"' : '' } />
								<label for="r5">3개월</label>
								<input id="r6" type="radio" name="radio_date" value="6month"
									${date == '6month' ? 'checked="checked"' : '' } />
								<label for="r6">6개월</label>
								<input id="r7" type="radio" name="radio_date" value="year"
									${date == 'year' ? 'checked="checked"' : '' } />
								<label for="r7">1년</label>
							</td>
							<th>객실 분류</th>
							<td class="room">
								<select name="divide_room">
									<option value="all_room" selected>객실 전체</option>
									<option class="separator" disabled>∥계곡∥</option>
									<option value="계곡 1호" ${room == '계곡 1호' ? 'selected="selected"' : '' }>계곡 1호</option>
									<option value="계곡 2호" ${room == '계곡 2호' ? 'selected="selected"' : '' }>계곡 2호</option>
									<option value="계곡 3호" ${room == '계곡 3호' ? 'selected="selected"' : '' }>계곡 3호</option>
									<option value="계곡 4호" ${room == '계곡 4호' ? 'selected="selected"' : '' }>계곡 4호</option>
									<option value="계곡 5호" ${room == '계곡 5호' ? 'selected="selected"' : '' }>계곡 5호</option>
									<option class="separator" disabled>∥대형∥</option>
									<option value="대형 1호" ${room == '대형 1호' ? 'selected="selected"' : '' }>대형 1호</option>
									<option value="대형 2호" ${room == '대형 2호' ? 'selected="selected"' : '' }>대형 2호</option>
									<option value="대형 3호" ${room == '대형 3호' ? 'selected="selected"' : '' }>대형 3호</option>
									<option value="대형 4호" ${room == '대형 4호' ? 'selected="selected"' : '' }>대형 4호</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>기 간</th>
							<td>
								<input type="date" name="start_date" value="${sDate }"/>
								<span class="date-range">~</span> 
								<input type="date" name="end_date" value="${eDate }"/> 
								<input class="inquire-btn" type="submit" value="조회" />
							</td>
						</tr>
					</table>
				</form>
				<%-- ----------------------- 목록 부분 ----------------------- --%>
				<div class="sales-body">
					<table class="table sales-table">
						<thead>
							<tr class="sales-thead">
								<th>날짜</th>
								<th>객실</th>
								<th>매출액</th>
							</tr>
						</thead>
						<tbody class="sales-tbody">
							<c:forEach var="dto" items="${allList }">
								<tr>
									<td>${dto.room_resdate }</td>
									<td>${dto.room_name }</td>
									<td><fmt:formatNumber value="${dto.room_price }" type="number"/>원</td>
								</tr>
							</c:forEach>
						</tbody>
						<tr>
							<td class="sales-total" colspan="3">
							총 매출 : <span class="total-money"></span>원
							</td>
						</tr>
					</table>
					<%-- ----------------------- 매출 통계 부분 ----------------------- --%>
					<div class="sales-content">
						<table class="table content-table">
							<tr class="content-thead">
								<th>객실</th>
								<th>예약 횟수</th>
								<th>매출액</th>
								<th>비율</th>
								<th>그래프</th>
							</tr>
							<c:forEach var="tDto" items="${totalList }" varStatus="i">
								<tr class="content-tbody">
									<td>${tDto.room_name }</td>
									<td>${tDto.total_cnt }회</td>
									<td><fmt:formatNumber value="${tDto.total_price }" />원</td>
									<td>${tDto.price_rate }%</td>
									<td><hr class="rate-bar${i.index }" style="width: ${tDto.price_rate }%;"></td>
								</tr>
							</c:forEach>
						</table>
					</div>
				</div>
			</section>
		</main>
	</div>		
	
<script type="text/javascript">

	/* 검색 목록이 없을 시 */
	$(function() {
		var totalList = '<c:out value="${totalList}" />';
		var allList = '<c:out value="${allList}" />';
		var total = '<c:out value="${total}" />';
		
		if(totalList === '[]' || allList === '[]' || total === 0) {
			swal("해당 날짜에 매출이 없습니다.", "", "warning").then(function() {
				history.back();
			});
		};
	});
	
	/* 총 매출 모션 */
	let total = document.querySelector('.total-money'), count = 0;
	
	let counting = setInterval(function() {
		
		if(count == '${total}') {
			clearInterval(counting);
            return false;
		}
		count += 100000;
		total.innerHTML = new Intl.NumberFormat().format(count);
	}, 1);

	/* 라디오 버튼 변화 시 기간 초기화 */
	$(function() {
		$("input[name='radio_date']").change(function() {
			$("input[type='date']").val('');
		});
	});
	
</script>
</body>
</html>