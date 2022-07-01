$(document).ready(function() {
	getList();
	dateFormat();
});

/* 날짜 초기값 설정 */
function dateFormat() {
	
	var Today = new Date();
	var Year = Today.getFullYear().toString();
	var Month = ('0' + (Today.getMonth() + 1)).slice(-2);
	var Day = ('0' + Today.getDate()).slice(-2);
	var now = Year + '-' + Month + '-' + Day; // 오늘
	var eDay = ('0' + (Today.getDate() - 1)).slice(-2);
	var eNow = Year + '-' + Month + '-' + eDay; // 하루 전
	var nextMonth = ('0' + (Today.getMonth() + 2)).slice(-2); // 한달 후
	var nextDate = Year + '-' + nextMonth + '-' + Day; // 한달 후 날짜
	
	var prevMonth = ('0' + (Today.getMonth())).slice(-2); // 한달 전
	var prevDate = Year + '-' + prevMonth + '-' + Day; // 한달 전 날짜
	
	if($('#r1').is(':checked')) { // 전체
		var sMonth = ('0' + (Today.getMonth() - 1)).slice(-2);
		var eMonth = ('0' + (Today.getMonth() + 3)).slice(-2);
		
		var sDate = Year + '-' + sMonth + '-' + Day; // 시작 날짜
		var eDate = Year + '-' + eMonth + '-' + Day; // 끝 날짜
		
		// 2개월 전 ~ 2개월 후 초기값 설정
		$(".sDate").val(sDate);
		$(".eDate").val(eDate);
		
	} else if ($('#r2').is(':checked') || $('#r3').is(':checked')) { // 예약 가능 or 예약 완료
		// 시작 날짜는 오늘 날짜 마지막 날짜는 한달 후로 초기값 설정
		$(".sDate").val(now);
		$(".eDate").val(nextDate);
		
	} else if ($('#r4').is(':checked') || $('#r5').is(':checked')) { // 사용 완료 or 미사용
		// 시작 날짜는 한달 전으로 마지막 날짜를 하루 전으로 초기값 설정
		$(".sDate").val(prevDate);
		$(".eDate").val(eNow);
	}
	
	$(function() {
		$('input[type=date]').change(function() {
			if(($('#r2').is(':checked') || $('#r3').is(':checked')) && ($(".sDate").val() < now || $(".eDate").val() < now)) {
				alert('예약 가능 혹은 예약 완료 상태는 시작 날짜가 오늘 이전일 수 없습니다.');
				$(".sDate").val(now);
				$(".eDate").val(nextDate);
			} else if (($('#r4').is(':checked') || $('#r5').is(':checked')) && ($(".eDate").val() >= now || $(".sDate").val() >= now)) {
				alert('사용 완료 혹은 미사용 상태는 마지막 날짜가 하루 전날부터 가능합니다.');
				$(".sDate").val(prevDate);
				$(".eDate").val(eNow);
			}
		});
	});
};


// 객실 상태에 따른 기간 초기값 설정
$(function() {
	$('input[name=room_status]').change(function() {
		// 전체
		if($('#r1').is(':checked')) { dateFormat(); }
		// 예약 가능
		if($('#r2').is(':checked')) { dateFormat(); }
		// 예약 완료
		if($('#r3').is(':checked')) { dateFormat(); }
		// 사용 완료
		if($('#r4').is(':checked')) { dateFormat(); }
		// 미사용
		if($('#r5').is(':checked')) { dateFormat(); }
	});
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
	if(data.length == 0) {
		alert('예약 내역이 존재하지 않습니다.');
	} else {
		$.each(data, function(index, vo) {
			list += "<tr onclick=getCont(" + vo["room_no"] + ");>";
			list += "<td>" + vo["room_resdate"] + "</td>";
			list += "<td>" + vo["room_no"] + "</td>";
			list += "<td>" + vo["room_name"] + "</td>";
			list += "<td>" + vo["room_mpeople"] + "명</td>";
			list += "<td>" + AddComma(vo["room_price"]) + "원</td>";
			list += "<td style='color:" + roomStatus(vo["room_resdate"], vo["room_possible"]) + "</td>";
			list += "</tr>";
		});
		
		$(".sales-tbody").empty();
		$(".sales-tbody").html(list);
	}
};

/* 사용 여부 */
function contStatus(date, status) {
	var today = new Date();
	var year = today.getFullYear().toString().slice(2); // 년도
	var month = ('0' + (today.getMonth() + 1)).slice(-2); // 월
	var day = ('0' + today.getDate()).slice(-2); // 일
	
	var now = year + '/' + month + '/' + day; // 현재 날짜
	
	var stat = "";
	if(now <= date && status === 1) {
		stat = "사용 예정";
	} else if(now > date && status === 1) {
		stat = "사용 완료";
	}
	
	return stat;
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
	
	var room_resdate = data.room_resdate;
	room_resdate = room_resdate.replace(/^22/, '2022').replace(/[/]/g, '-');
	
	if(data.payment_orderdate != null) {
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
		cont += "<td>" + data.room_mpeople + "명</td></tr>";
		cont += "<tr class='content-thead'><th>결제 가격</th>";
		cont += "<td>" + AddComma(data.room_price) + "원</td></tr>";
		cont += "<tr class='content-thead'><th>결제일</th>";
		cont += "<td>" + data.payment_orderdate + "</td></tr>";
		cont += "<tr class='content-thead'><th>사용일</th>";
		cont += "<td>" + room_resdate + "</td></tr>";
		cont += "<tr class='content-thead'><th>사용 여부</th>";
		cont += "<td>" + contStatus(data.room_resdate, data.room_possible) + "</td></tr>";
		cont += "<tr class='content-thead'><th>요청 사항</th>";
		
		if(data.payment_request != null) {
			cont += "<td>" + data.payment_request + "</td></tr>";
		} else {
			cont += "<td>요청 사항이 없습니다.</td></tr>";
		}
		
		$(".content-table").empty();
		$(".content-table").html(cont);
	} else {
		alert('예약 내역이 존재하지 않습니다.');
	}
};

/* 예약 정렬 조회 */
function getSortList() {
	var room_status = $("input[name=room_status]:checked").val(); // 객실 상태
	var divide_room = $("#divide_room option:selected").val(); // 객실 분류
	var start_date = $(".sDate").val(); // 시작 날짜
	var end_date = $(".eDate").val(); // 끝 날짜

	$.ajax({
		url: '/test/reserve/sort.do',
		data: {'room_status': room_status,
			   'divide_room': divide_room,
			   'start_date': start_date,
			   'end_date': end_date},
		type: 'get',
		dataType: 'json',
		success: sortView,
		error: function() {alert("Error..");}
	});
};

function sortView(data) {
	var sort = "";
	if(data.length == 0) {
		alert('해당 기간에 예약 내역이 존재하지 않습니다.');
	} else {
		$.each(data, function(index, vo) {
			sort += "<tr onclick=getCont(" + vo["room_no"] + ");>";
			sort += "<td>" + vo["room_resdate"] + "</td>";
			sort += "<td>" + vo["room_no"] + "</td>";
			sort += "<td>" + vo["room_name"] + "</td>";
			sort += "<td>" + vo["room_mpeople"] + "명</td>";
			sort += "<td>" + AddComma(vo["room_price"]) + "원</td>";
			sort += "<td style='color:" + roomStatus(vo["room_resdate"], vo["room_possible"]) + "</td>";
			sort += "</tr>";
		});
		
		$(".sales-tbody").empty();
		$(".sales-tbody").html(sort);
	}
};