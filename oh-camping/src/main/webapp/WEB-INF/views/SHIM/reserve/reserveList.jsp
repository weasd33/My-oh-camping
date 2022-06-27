<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link href="<c:url value="/resources/SHIM/css/reserve/main.css" />?6" rel="stylesheet">
<script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script type="text/javascript">

	$(document).ready(function() {
		getList();
	});
	
	/* 가격 format */
	function AddComma(num) {
		const regexp = /\B(?=(\d{3})+(?!\d))/g;
		return num.toString().replace(regexp, ',');
	}; 
	
	/* 객실 상태 format */
	function roomStatus(date, status) {
		var today = new Date();
		var year = today.getFullYear().toString().slice(2); // 년도
		var month = ('0' + (today.getMonth() + 1)).slice(-2); // 월
		var day = ('0' + today.getDate()).slice(-2); // 일
		
		var now = year + '/' + month + '/' + day; // 현재 날짜
		
		var stat = "";
		if((now <= date) && (status == 0)) {
			stat = "green'><b>예약 가능</b>";
		} else if(now <= date && status === 1) {
			stat = "blue'><b>예약 완료</b>";
		} else if(now > date && status === 1) {
			stat = "red'><b>사용 완료</b>";
		} else {
			stat = "black'><b>미사용</b>";
		}
		return stat;
	};
	
	/* 객실 전체 조회 */
	function getList() { 
		$.ajax({
			url: '/test/reserve/list.do',
			type: 'get',
			dataType: 'json',
			success: listView,
			error: function() {alert("Error..");}
		});
	};
	
	 /* 객실 전체 View */
	function listView(data) {
		var list = "";
		$.each(data, function(index, vo) {
			list += "<tr onclick=getCont(" + vo["room_no"] + ");>";
			list += "<td>" + vo["room_resdate"] + "</td>";
			list += "<td>" + vo["room_no"] + "</td>";
			list += "<td>" + vo["room_name"] + "</td>";
			list += "<td>" + vo["room_mpeople"] + "</td>";
			list += "<td>" + AddComma(vo["room_price"]) + "원</td>";
			list += "<td style='color:" + roomStatus(vo["room_resdate"], vo["room_possible"]) + "</td>";
			list += "</tr>";
		});
		$(".sales-tbody").html(list);
	};

	/* 객실,예약 상세 정보 */
	function getCont(no) {
		$.ajax({
			url: '/test/reserve/cont.do',
			data: {'room_no': no},
			type: 'get',
			dataType: 'json',
			success: contView,
			error: function() {alert("Error..");}
		});
	};
	
	/* 객실,예약 상세 정보 View */
	function contView(data) {
		var cont = "";
		cont += "<tr class='content-thead'><th>객실 번호</th>";
		cont += "<td>" + data.room_no + "</td></tr>";
		cont += "<tr class='content-thead'><th>객실 이름</th>";
		cont += "<td>" + data.room_name + "</td></tr>";
		cont += "<tr class='content-thead'><th>예약자명</th>";
		cont += "<td>" + data.mem_name + "</td></tr>";
		cont += "<tr class='content-thead'><th>아이디</th>";
		cont += "<td>" + data.mem_id + "</td></tr>";
		cont += "<tr class='content-thead'><th>이메일</th>";
		cont += "<td>" + data.mem_email + "</td></tr>";
		cont += "<tr class='content-thead'><th>전화번호</th>";
		cont += "<td>" + data.mem_phone + "</td></tr>";
		cont += "<tr class='content-thead'><th>인원 수</th>";
		cont += "<td>" + data.room_mpeople + "</td></tr>";
		cont += "<tr class='content-thead'><th>결제 가격</th>";
		cont += "<td>" + AddComma(data.room_price) + "원</td></tr>";
		cont += "<tr class='content-thead'><th>결제일</th>";
		cont += "<td>" + data.payment_orderdate + "</td></tr>";
		cont += "<tr class='content-thead'><th>사용일</th>";
		cont += "<td>" + data.room_resdate + "</td></tr>";
		cont += "<tr class='content-thead'><th>사용 여부</th>";
		cont += "<td>" + data.room_possible + "</td></tr>";
		
		$(".content-table").html(cont);
	};
	
</script>
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
			<div><a href="./ajax.do">예약 목록</a></div>
			<section id="section">
		<%-- ----------------------- 분류 부분 ----------------------- --%>
				<form action="<%=request.getContextPath() %>/reserve/list.do">
					<table class="table division-table">
						<tr>
							<th>객실 상태</th>
							<td class="radio">
								<input id="r1" type="radio" name="room_status" value="status1" checked/>
								<label for="r1">전체</label>
								<input id="r2" type="radio" name="room_status" value="status2" />
								<label for="r2">예약 가능</label>
								<input id="r3" type="radio" name="room_status" value="status3" />
								<label for="r3">예약 완료</label>
								<input id="r4" type="radio" name="room_status" value="status4" />
								<label for="r4">사용 완료</label>
								<input id="r5" type="radio" name="room_status" value="status5" />
								<label for="r5">미사용</label>
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