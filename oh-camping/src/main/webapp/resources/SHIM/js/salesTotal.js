$(document).ready(function() {
	getList();
});

/* 가격 format */
function AddComma(num) {
	const regexp = /\B(?=(\d{3})+(?!\d))/g;
	return num.toString().replace(regexp, ',');
}; 

function getList(radio_date, divide_room, sDate, eDate) {
	// 라디오 버튼 날짜
	if(radio_date != null) { var radio_date = radio_date; } else { var radio_date = $("input[name=radio_date]").val(); }
	// 객실 분류
	if(divide_room != null) { var divide_room = divide_room; } else { var divide_room = $("input[name=divide_room] option:selected").val(); }
	// 시작 날짜
	if(sDate != null) { var start_date = sDate; } else { var start_date = $("input[name=start_date]").val(); }
	// 끝 날짜
	if(eDate != null) { var end_date = eDate; } else { var end_date = $("input[name=end_date]").val(); }
	
	$.ajax({
		url: '/test/sales/list.do',
		data: {'radio_date': radio_date,
			   'divide_room': divide_room,
			   'start_date': start_date,
			   'end_date': end_date},
		type: 'get',
		dataType: 'json',
		success: salesView,
		error: function() {alert("Sales Error..")}
	});
};

function salesView(data) {
	if(data.totalList.length == 0) {
		swal("조회된 매출이 없습니다.", "", "warning");
	} else {
		var resAll = ""; // 목록 뷰
		var resTotal = ""; // 통계 뷰
		var allList = data.allList; // 매출 목록
		var total = data.total;
		var totalList = data.totalList; // 매출 통계
		var date = data.date; // 날짜
		var room = data.room; // 객실
		var sDate = data.sDate; // 시작 날짜
		var eDate = data.eDate; // 끝 날짜
		
		$.each(allList, function(index, vo) {
			resAll += "<tr><td>" + vo["room_resdate"] + "</td>";
			resAll += "<td>" + vo["room_name"] + "</td>";
			resAll += "<td>" + AddComma(vo["room_price"]) + "원</td></tr>";
		});
		$(".sales-tbody").empty();
		$(".sales-tbody").html(resAll);
		
		$.each(totalList, function(index, vo) {
			resTotal += "<tr class='content-tbody'>";				
			resTotal += "<td>" + vo["room_name"] + "</td>";				
			resTotal += "<td>" + vo["total_cnt"] + "회</td>";				
			resTotal += "<td>" + AddComma(vo["total_price"]) + "원</td>";				
			resTotal += "<td>" + vo["price_rate"] + "%</td>";	
			resTotal += "<td><hr class='rate-bar"+index+"' style='width: "+vo["price_rate"]+"%;'></td>";				
			resTotal += "</tr>";				
		});
		$(".stat-tbody").empty();
		$(".stat-tbody").html(resTotal);
		
		$(".total-money").empty();
		$(".total-money").html(AddComma(total));
	}
};

/* 라디오 버튼 기간 선택 */
$(function() {
	$("input[type=radio]").change(function() {
		var radio_date = $("input[name=radio_date]:checked").val();
		var divide_room = $("select[name=divide_room]").val();
		$("input[type='date']").val('');
		getList(radio_date, divide_room);
	});
});

/* 객실 분류 선택 */
$(function() {
	$(".divide_room").change(function() {
		var radio_date = $("input[name=radio_date]:checked").val();
		var sDate = $('.start_date').val();
		var eDate = $('.end_date').val();
		var divide_room = $("select[name=divide_room]").val();
		
		if((sDate.length == 0) ^ (eDate.length == 0)) {
			swal("기간 선택이 잘못되었습니다.", "", "warning");
		} else if ((sDate.length != 0) || (eDate.length != 0)) {
			getList(null, divide_room, sDate, eDate);
		} else {
			getList(radio_date, divide_room);
		}
	});
});

/* 기간 선택 */
function dateList() {
	var sDate = $('.start_date').val();
	var eDate = $('.end_date').val();
	var divide_room = $("select[name=divide_room]").val();
	
	if((sDate.length == 0) || (eDate.length == 0)) {
		swal("기간 선택이 잘못되었습니다.", "", "warning");
	} else {
		getList(null, divide_room, sDate, eDate);
	}
}