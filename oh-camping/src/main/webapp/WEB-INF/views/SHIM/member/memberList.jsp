<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link href="<c:url value="/resources/SHIM/css/member/main.css" />?25" rel="stylesheet">
<script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>
<%-- <script src="<%=request.getContextPath() %>/resources/SHIM/js/member.js?6"></script> --%>
<script type="text/javascript">

$(document).ready(function() {
	getList(1, "null");
});

/* 정렬 부분 */
$(function() {
	$(".sort").change(function() {
		/* 검색 옵션 초기화 */
		$(".search_option option:eq(0)").prop("selected", true);
		$(".search_key").val('');
		
		var sortKey = $(this).val(); // 정렬 키
		getList(1, sortKey);				
	});
});

/* 회원 전체 조회 */
function getList(page, sortKey) {
	if (sortKey == null) { var sortKey = "null"; }
	$.ajax({
		url: '/test/member_list.do',
		data: {
			'page': page,
			'sortKey': sortKey
		},
		type: 'get',
		dataType: 'json',
		success: listView,
		error: function() {alert("getList Error..");}
	});
};

function listView(data) {
	if(data.list.length == 0) {
		alert('조회된 회원이 없습니다.');
	} else {
		var res = "";
		var list = data.list;
		var page = data.page;
		var block = data.block;
		var startBlock = data.startBlock;
		var endBlock = data.endBlock;
		var allPage = data.allPage;
		var sortKey = data.sortKey;
		$.each(list, function(index, vo) {
			res += "<tr onclick='detailView(\"" + vo["member_no"] + "\")' style='cursor:pointer;'>";
			res += "<td>" + vo["member_no"] + "</td>";
			res += "<td>" + vo["mem_id"] + "</td>";
			res += "<td>" + vo["mem_name"] + "</td>";
			res += "<td>" + vo["mem_email"] + "</td>";
			res += "</tr>";
		});
		
		$(".detail-user").empty();
		$(".detail-user").html(res);
		
		/* 페이징 처리 */
		var paging = "";
		if(page > block) {
			paging += "<li class='page-item'><a class='page-link' onclick='getList(1, \""+sortKey+"\")'>«</a></li>";
			paging += "<li class='page-item'><a class='page-link' onclick='getList(\""+(startBlock-1)+"\", \""+sortKey+"\")'>‹</a></li>";
		}
		
		for(var i=startBlock; i<=endBlock; i++) {
			if(i == page) {
				paging += "<li class='page-item cur-page' aria-current='page'><a class='page-link' onclick='getList(\""+i+"\", \""+sortKey+"\")'>" + i + "</a></li>";
			} else {
				paging += "<a class='page-link' onclick='getList(\""+i+"\", \""+sortKey+"\")'>" + i + "</a>";
			}
		}
		
		if(endBlock < allPage) {
			paging += "<li class='page-item'><a class='page-link' onclick='getList(\""+(endBlock+1)+"\", \""+sortKey+"\")'>›</a></li>";
			paging += "<li class='page-item'><a class='page-link' onclick='getList(\""+allPage+"\", \""+sortKey+"\")'>»</a></li>";
		}
		
		$(".list-page").empty();
		$(".list-page").html(paging);
	}
};
/* 회원 전체 조회 - End */

/* 회원 상세 정보 */
function detailView(num) { /* 정보 클릭 시 보이기*/
	$.ajax({
		url: '/test/member_detail.do',
		data: { 'num': num },
		type: 'get',
		dataType: 'json',
		success: detailShow,
		error: function() {alert("Detail Error..");}
	});
};

function detailShow(data) {
	res = "";
	if(data == null) {
		alert('회원 정보가 존재하지 않습니다.');
	} else {
		res += "<div class='card-top'><h4 class='card-title'><span class='card-name'>" + data.mem_id + "</span><span class='title'>님 정보</span></h4>";
		res += "<span class='icon-cancel btn-cancel' onclick='viewHidden();'></span></div><hr class='card-line'>";
		res += "<table class='detail-table'>";
		res += "<tr><td><span class='icon-user-1 icon'>" + data.mem_name + "</span></td>";
		res += "<td><span class='icon-mail icon'>" + data.mem_email + "</span></td></tr>";		
		res += "<tr><td><span class='icon-lock'>＊＊＊＊</span></td>";
		res += "<td><span class='icon-phone icon'>" + data.mem_phone + "</span></td></tr>";
		res += "<tr><td colspan='2' class='card-btn'>";
		res += "<input class='btn-detail btn-inquiry' type='button' value='문의내역' onclick='inquiryList(1, \""+data.mem_id+"\");'/>";
		res += "<input class='btn-detail btn-reserve' type='button' value='예약내역' onclick='reserveList(1, \""+data.mem_id+"\");'/>";		
		res += "<input class='btn-detail btn-modify' type='button' value='정보수정' onclick='modifyMember(\""+data.member_no+"\")'/>";
		res += "<input class='btn-detail btn-delete' type='button' value='탈퇴'/>";
		res += "</td></tr></table>";
		
		$(".card-body").html(res);
		
		$('.detail-modal').css('visibility', 'visible');
		$("#aside").css({
			'filter': "blur(10px)",
			'pointer-events': "none"
		});
		$(".header").css({
			'filter': "blur(10px)",
			'pointer-events': "none"
		});
		$("#main").css({
			'filter': "blur(10px)",
			'pointer-events': "none",
		});
		
		$(".card-body").html(res);
	}
};

/* 날짜 포맷 22/01/01 -> 2022-01-01 */
function DateFormat(date) {
	return date.replace(/^22/, '2022').replace(/[/]/g, '-');
}

/* 객실 상태 format */
function roomStatus(date) {
	var today = new Date();
	var year = today.getFullYear().toString().slice(2); // 년도
	var month = ('0' + (today.getMonth() + 1)).slice(-2); // 월
	var day = ('0' + today.getDate()).slice(-2); // 일
	
	var now = year + '/' + month + '/' + day; // 현재 날짜
	
	var stat = "";
	if(now <= date) {stat = "사용예정"}
	else {stat = "사용완료"}
	
	return stat;
}

/* 가격 format */
function AddComma(num) {
	const regexp = /\B(?=(\d{3})+(?!\d))/g;
	return num.toString().replace(regexp, ',');
}; 

/* 해당 회원 예약 내역 */
function reserveList(page, mem_id) { 
	pwdCheck = 0;
	pwd2Check = 0;
	$.ajax({
		url: '/test/member_reserveList.do',
		data: { 
				'page': page,
				'mem_id': mem_id
			},
		type: 'get',
		dataType: 'json',
		success: getReserveList,
		error: function() {alert("Detail Error..");}
	});
};

function getReserveList(data) {
	var res = "";
	res += "<table class='table table-striped'>";
	res += "<thead class='reserve-head'><tr>";
	res += "<th>객실번호</th> <th>객실명</th> <th>사용일</th> <th>사용여부</th> <th></th>";
	res += "</tr></thead><tbody class='reserve-body'>";
	if(data.room_no == 0) {
		res += "<tr align='center'><td colspan='5'><div><b>예약 내역이 없습니다.</b></div></td></tr>";
		res += "</tbody></table>";
	} else {
		var list = data.list;
		var mem_id = data.mem_id;
		var page = data.page;
		var block = data.block;
		var startBlock = data.startBlock;
		var endBlock = data.endBlock;
		var allPage = data.allPage;
		$.each(list, function(index, vo) {
			res += "<tr>";
			res += "<td>"+ vo["room_no"] +"</td> <td>"+ vo["room_name"] +"</td>";
			res += "<td>"+ DateFormat(vo["room_resdate"]) +"</td> <td>"+roomStatus(vo["room_resdate"])+"</td>";
			res += "<td><input class='btn-detail cont-reserve' type='button' value='상세보기' onclick='reserveCont("+ page +", \"" + vo["room_no"] + "\", \"" + vo["mem_id"] + "\")'></td>";
			res += "</tr>";
		});
		res += "</tbody></table>";
		/* 예약 내역 페이징  */
		res += "<nav class='paging reserve-paging' aria-label='Page navigation example'>";
		res += "<ul class='reserve-page pagination justify-content-center'>";
		
		if(page > block) {
			res += "<li class='page-item'><a class='page-link' onclick='reserveList(1, \""+mem_id+"\")'>«</a></li>";
			res += "<li class='page-item'><a class='page-link' onclick='reserveList(\""+(startBlock-1)+"\", \""+mem_id+"\")'>‹</a></li>";
		}
		
		for(var i=startBlock; i<=endBlock; i++) {
			if(i == page) {
				res += "<li class='page-item cur-page' aria-current='page'><a class='page-link'>" + i + "</a></li>";
			} else {
				res += "<a class='page-link' onclick='reserveList(\""+i+"\", \""+mem_id+"\")'>" + i + "</a>";
			}
		}
		
		if(endBlock < allPage) {
			res += "<li class='page-item'><a class='page-link' onclick='reserveList(\""+(endBlock+1)+"\", \""+mem_id+"\")'>›</a></li>";
			res += "<li class='page-item'><a class='page-link' onclick='reserveList(\""+allPage+"\", \""+mem_id+"\")'>»</a></li>";
		}
		res += "</ul></nav>";
	}
	
	$(".inquiry").empty();
	$(".reserve").empty();
	$('.modify').empty();
	$(".reserve").html(res);
};

// 예약 상세내역
function reserveCont(page, room_no, mem_id) {
	$.ajax({
		url: '/test/member_reserveCont.do',
		data: { 
				'page': page,
				'room_no': room_no,
				'mem_id': mem_id
			},
		type: 'get',
		dataType: 'json',
		success: getReserveCont,
		error: function() {alert("Detail Error..");}
	});
};

function getReserveCont(data) {
	var list = data.list;
	var page = data.page; // 뒤로가기 시 원래 있던 곳으로 이동하기 위함
	var mem_id = data.mem_id;
	var res = "";
	if(data.length == 0) {
		alert('ReserveCont Error..');
	} else {
		res += "<table class='table table-striped'>";
		res += "<thead class='reserve-head'><tr>";
		res += "<th colspan='2'>예약 정보</th>  <th colspan='2'>결제 정보</th>";
		res += "</tr></thead>";
		res += "<tbody class='reserve-cont'><tr>";
		res += "<th>객실 번호</th> <td>"+list.room_no+"</td>";
		res += "<th>결제일</th> <td>"+list.payment_orderdate+"</td></tr>";
		res += "<tr><th>객실 이름</th> <td>"+list.room_name+"</td>";
		res += "<th>결제 가격</th> <td>"+AddComma(list.room_price)+"원</td></tr>";
		res += "<tr><th>인원 수</th> <td>"+list.room_mpeople+"명</td>";
		res += "<th>사용 여부</th> <td>"+roomStatus(list.room_resdate)+"</td></tr>";
		res += "<tr><th colspan='2'>요청사항:</th><th>사용일</th><td>"+DateFormat(list.room_resdate)+"</td></tr>";
		res += "<tr><td colspan='4'><div>";
		res += "<pre class='reserve-request'>"+list.payment_request+"</pre></div>";
		res += "<span class='icon-logout reserve-back-btn' onclick='reserveList("+page+", \""+mem_id+"\");'></span>";
		res += "</td></tr></tbody></table>";
		
		$(".inquiry").empty();
		$(".reserve").empty();
		$('.modify').empty();
		$(".reserve").html(res);
	}
};

/* 해당 회원 예약 내역  - End */

/* 해당 회원 문의 내역 */
function inquiryList(page, mem_id) {
	pwdCheck = 0;
	pwd2Check = 0;
	$.ajax({
		url: '/test/member_inquiryList.do',
		data: { 
				'page': page,
				'mem_id': mem_id
			},
		type: 'get',
		dataType: 'json',
		success: getInquiryList,
		error: function() {alert("Detail Error..");}
	});
}

function getInquiryList(data) {
	res = "";
	res += "<table class='table table-striped'>";
	res += "<thead class='inquiry-head'><tr>";
	res += "<th>No.</th> <th>유 형</th> <th>제 목</th><th>작성일</th> <th colspan='2'></th>";
	res += "</tr></thead><tbody class='inquiry-body'>";
	if(data.list.length == 0) {
		res += "<tr align='center'><td colspan='6'><div><b>문의 내역이 없습니다.</b></div></td></tr>";
		res += "</tbody></table>";
	} else {
		var list = data.list;
		var qa_userid = data.qa_userid;
		var page = data.page;
		var block = data.block;
		var startBlock = data.startBlock;
		var endBlock = data.endBlock;
		var allPage = data.allPage;
		$.each(list, function(index, vo) {
			res += "<tr><td>"+vo["qa_no"]+"</td> <td>"+vo["qa_type"]+"</td>";
			res += "<td>"+vo["qa_title"]+"</td> <td>"+DateFormat(vo["qa_date"])+"</td>";
			res += "<td><input class='btn-detail del-cont-inquiry' type='button' value='상세보기' onclick='inquiryCont("+ page +", \"" + vo["qa_no"] + "\", \"" + qa_userid + "\")'>";
			res += "<input class='btn-detail del-cont-inquiry' type='button' value='삭제' onclick='inquiryDel("+ page +", \"" + vo["qa_no"] + "\", \"" + qa_userid + "\")'></td></tr>";
		});
		res += "</tbody></table>";
		/* 문의 페이징 */
		res += "<nav class='paging reserve-paging' aria-label='Page navigation example'>";
		res += "<ul class='inquiry-page pagination justify-content-center'>";
		
		if(page > block) {
			res += "<li class='page-item'><a class='page-link' onclick='inquiryList(1, \""+qa_userid+"\")'>«</a></li>";
			res += "<li class='page-item'><a class='page-link' onclick='inquiryList(\""+(startBlock-1)+"\", \""+qa_userid+"\")'>‹</a></li>";
		}
		
		for(var i=startBlock; i<=endBlock; i++) {
			if(i == page) {
				res += "<li class='page-item cur-page' aria-current='page'><a class='page-link'>" + i + "</a></li>";
			} else {
				res += "<a class='page-link' onclick='inquiryList(\""+i+"\", \""+qa_userid+"\")'>" + i + "</a>";
			}
		}
		
		if(endBlock < allPage) {
			res += "<li class='page-item'><a class='page-link' onclick='inquiryList(\""+(endBlock+1)+"\", \""+qa_userid+"\")'>›</a></li>";
			res += "<li class='page-item'><a class='page-link' onclick='inquiryList(\""+allPage+"\", \""+qa_userid+"\")'>»</a></li>";
		}
		res += "</ul></nav>"; 
	}
	
	$(".inquiry").empty();
	$(".reserve").empty();
	$('.modify').empty();
	$(".inquiry").html(res);
}

function inquiryCont(page, qa_no, qa_userid) {
	$.ajax({
		url: '/test/member_inquiryCont.do',
		data: { 
				'page': page,
				'qa_no': qa_no,
				'qa_userid': qa_userid
			},
		type: 'get',
		dataType: 'json',
		success: getInquiryCont,
		error: function() {alert("inquiryCont Error..");}
	});
};

function getInquiryCont(data) {
	var list = data.list;
	var page = data.page;
	var id = data.qa_userid;
	res = "";
	if(data.list.qa_no == 0) {
		alert('getInquiryCont Error..');
	} else {
		res += "<table class='table table-striped'>";
		res += "<thead class='inquiry-head'><tr>";
		res += "<th>No.</th> <th>유 형</th> <th>제 목</th><th>작성일</th> <th colspan='2'></th>";
		res += "</tr></thead><tbody class='inquiry-body'><tr>";
		res += "<td>"+list.qa_no+"</td> <td>"+list.qa_type+"</td>";
		res += "<td>"+list.qa_title+"</td> <td>"+DateFormat(list.qa_date)+"</td>";
		res += "<td><input class='btn-detail del-cont-inquiry' type='button' value='삭제' onclick='inquiryDel("+ page +", \"" + list.qa_no + "\", \"" + id + "\")'></td></tr>";
		res += "<tr><td colspan='5'><div>";
		res += "<pre class='inquiry-cont'>"+list.qa_cont+"</pre></div>";
		res += "<span class='icon-logout inquiry-back-btn' onclick='inquiryList("+page+", \""+id+"\");'></span>";
		res += "</td></tr></tbody>";
		
		$(".inquiry").empty();
		$(".reserve").empty();
		$('.modify').empty();
		$(".inquiry").html(res);
	}
};

function inquiryDel(page, qa_no, id) {
	if(confirm("해당 문의 내역을 삭제하시겠습니까?")) {
		$.ajax({
			url: '/test/inquiry_delete.do',
			data: { 
					'page': page,
					'qa_no': qa_no,
					'qa_userid': id
				},
			type: 'get',
			dataType: 'json',
			success: function(data) { inquiryList(data.page, data.qa_userid) },
			error: function() {alert("inquiryDel Error..");}
		});
	} else {
		return;
	}
}

/* 해당 회원 문의 내역 - End */

function viewHidden() { /* 취소 클릭 시 숨기기 */
	$(".inquiry").empty();
	$(".reserve").empty();
	$('.modify').empty();
	$(".card-body").empty();
	$('.detail-modal').css('visibility', 'hidden');
	
	$("#aside").css({
		'filter': "blur(0px)",
		'pointer-events': "auto"
	});
	$(".header").css({
		'filter': "blur(0px)",
		'pointer-events': "auto"
	});
	$("#main").css({
		'filter': "blur(0px)",
		'pointer-events': "auto",
	});
};
/* 회원 상세 정보 - End*/

/* 검색 부분 */
function search() {
	/* 정렬 옵션 초기화 */
	$(".sort option:eq(0)").prop("selected", true);
	var search = $('.search_option').val();
	var keyword = $('.search_key').val();
	
	if(keyword == "") {
		alert("검색어를 입력해주세요.");
	} else {
		searchList(1, search, keyword);
	}
};

function searchList(page, search, keyword) {
	$.ajax({
		url: '/test/member_search.do',
		data: {
			'page': page,
			'search': search,
			'keyword': keyword
		},
		type: 'get',
		dataType: 'json',
		success: searchView,
		error: function() {alert("Search Error..");}
	});
};

function searchView(data) {
	if(data.list.length == 0) {
		alert('검색된 회원이 없습니다.');
		$(".search_key").val('');
	} else {
		var res = "";
		var list = data.list;
		var page = data.page;
		var block = data.block;
		var startBlock = data.startBlock;
		var endBlock = data.endBlock;
		var allPage = data.allPage;
		var search = data.search;
		var keyword = data.keyword;

		$.each(list, function(index, vo) {
			res += "<tr onclick='detailView(" + vo["member_no"] + ")' style='cursor:pointer;'>";
			res += "<td>" + vo["member_no"] + "</td>";
			res += "<td>" + vo["mem_id"] + "</td>";
			res += "<td>" + vo["mem_name"] + "</td>";
			res += "<td>" + vo["mem_email"] + "</td>";
			res += "</tr>";
		});
		
		$(".detail-user").empty();
		$(".detail-user").html(res);
		
		/* 페이징 처리 */
		var paging = "";
		if(page > block) {
			paging += "<li class='page-item'><a class='page-link' onclick='searchList(1, \""+search+"\", \""+keyword+"\")'>«</a></li>";
			paging += "<li class='page-item'><a class='page-link' onclick='searchList(\""+(startBlock-1)+"\", \""+sortKey+"\", \""+keyword+"\")'>‹</a></li>";
		}
		
		for(var i=startBlock; i<=endBlock; i++) {
			if(i == page) {
				paging += "<li class='page-item cur-page' aria-current='page'><a class='page-link' onclick='searchList(\""+i+"\", \""+search+"\", \""+keyword+"\")'>" + i + "</a></li>";
			} else {
				paging += "<a class='page-link' onclick='searchList(\""+i+"\", \""+search+"\", \""+keyword+"\")'>" + i + "</a>";
			}
		}
		
		if(endBlock < allPage) {
			paging += "<li class='page-item'><a class='page-link' onclick='searchList(\""+i+"\", \""+search+"\", \""+keyword+"\")'>›</a></li>";
			paging += "<li class='page-item'><a class='page-link' onclick='searchList(\""+i+"\", \""+search+"\", \""+keyword+"\")'>»</a></li>";
		}
		
		$(".list-page").empty();
		$(".list-page").html(paging);
	}
};
/* 검색 부분 - End*/

/* 회원 수정 */

// 유효성 체크 전역 변수
var idCheck = 1;
var pwdCheck = 0;
var pwd2Check = 0;
var email1Check = 1;
var email2Check = 1;
var phone1Check = 1;
var phone2Check = 1;
var phone3Check = 1;

// 아이디 유효성 검사
$(document).on("propertychange change keyup paste", '#id', function() {
	var idExp = /^[a-z0-9]{4,12}$/g;
	if(!idExp.test($('#id').val())) { 
		$('.id_success').empty();
		$('.id_fail').html('4~12자의 영문 소문자, 숫자만 사용 가능합니다.');
		idCheck = 0;
		modifyConfirm();
	} else {
		$('.id_fail').empty();
		$('.id_success').html('사용 가능한 아이디입니다.');
		idCheck = 1;
		modifyConfirm();
	}
	/* 이미 사용중인 아이디입니다. */ // 2022-07-05 할 일 사용중인 아이디 체크, 회원 정보 수정, 탈퇴
});
 
// 비밀번호 유효성 검사
$(document).on("propertychange change keyup paste", '#pwd', function() {
	var pwdExp = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*\W).{8,16}$/;
	if(!pwdExp.test($('#pwd').val())) {
		$('.pwd_success').empty();
		$('.pwd_fail').html('8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.');
		pwdCheck = 0;
		modifyConfirm();
	} else {
		$('.pwd_fail').empty();
		$('.pwd_success').html('사용 가능한 비밀번호입니다.');
		pwdCheck = 1;
		modifyConfirm();
	}
});

// 비밀번호 재확인 유효성 검사
$(document).on("propertychange change keyup paste", '#pwd2', function() {
	if(($('#pwd').val() != $('#pwd2').val()) ) {
		$('.pwd2_confirm').empty();
		$('.pwd2_confirm').html('<span class="icon-lock-open error_confirm"></span>');
		pwd2Check = 0;
		modifyConfirm();
	} else if (($('#pwd').val() == $('#pwd2').val()) && pwdCheck == 1){
		$('.pwd2_confirm').empty();
		$('.pwd2_confirm').html('<span class="icon-lock success_confirm"></span>');
		pwd2Check = 1;
		modifyConfirm();
	}
});

// 이메일 앞자리 유효성 검사
$(document).on("propertychange change keyup paste", '#email', function() {
	var emailExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*$/;
	if(!emailExp.test($('#email').val())) {
		$('.email_success').empty();
		$('.email_fail').html('올바른 이메일 형식이 아닙니다.');
		email1Check = 0;
		modifyConfirm();
	} else {
		$('.email_fail').empty();
		$('.email_success').html('사용 가능한 이메일입니다.');
		email1Check = 1;
		modifyConfirm();
	}
});

// 이메일 뒷자리 유효성 검사
$(document).on("propertychange change keyup paste", '#email2', function() {
	var email2Exp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	if(!email2Exp.test($('#email2').val())) {
		$('.email_success').empty();
		$('.email_fail').html('올바른 이메일 형식이 아닙니다.');
		email2Check = 0;
		modifyConfirm();
	} else {
		$('.email_fail').empty();
		$('.email_success').html('사용 가능한 이메일입니다.');
		email2Check = 1;
		modifyConfirm();
	}
});

// 전화번호 앞자리 유효성 검사
$(document).on("propertychange change keyup paste", '#phone', function() {
	var phoneExp = /^01([0|1|6|7|8|9])$/;
	if(!phoneExp.test($('#phone').val())) {
		$('.phone-success').empty();
		$('.phone-fail').html('전화번호 형식에 맞게 작성해 주세요.');
		phone1Check = 0;
		modifyConfirm();
	} else {
		$('.phone-fail').empty();
		$('.phone-success').html('사용 가능한 전화번호입니다.');
		phone1Check = 1;
		modifyConfirm();
	}
});

// 전화번호 중간자리 유효성 검사
$(document).on("propertychange change keyup paste", '#phone2', function() {
	var phone2Exp = /^([0-9]{3,4})$/;
	if(!phone2Exp.test($('#phone2').val())) {
		$('.phone-success').empty();
		$('.phone-fail').html('전화번호 형식에 맞게 작성해 주세요.');
		phone2Check = 0;
		modifyConfirm();
	} else {
		$('.phone-fail').empty();
		$('.phone-success').html('사용 가능한 전화번호입니다.');
		phone2Check = 1;
		modifyConfirm();
	}
});

//전화번호 끝자리 유효성 검사
$(document).on("propertychange change keyup paste", '#phone3', function() {
	var phone3Exp = /^([0-9]{4})$/;
	if(!phone3Exp.test($('#phone3').val())) {
		$('.phone-success').empty();
		$('.phone-fail').html('전화번호 형식에 맞게 작성해 주세요.');
		phone3Check = 0;
		modifyConfirm();
	} else {
		$('.phone-fail').empty();
		$('.phone-success').html('사용 가능한 전화번호입니다.');
		phone3Check = 1;
		modifyConfirm();
	}
});

function modifyConfirm() {
	if((idCheck && pwdCheck && pwd2Check && email1Check && email2Check && phone1Check && phone2Check && phone3Check) == 1) {
		$('.modify-confirm-btn').empty();
		$('.modify-confirm-btn').html("<input class='btn-detail modify-btn' type='button' value='확인'/>");
	} else {
		$('.modify-confirm-btn').empty();
		$('.modify-confirm-btn').html("<input class='btn-detail modify-btn-error' type='button' value='확인'/>");
	};
}

function modifyMember(num) {
	pwdCheck = 0;
	pwd2Check = 0;
	$.ajax({
		url: '/test/member_detail.do',
		data: { 'num': num },
		type: 'get',
		dataType: 'json',
		success: getModifyMember,
		error: function() {alert("Detail Error..");}
	});
}

function getModifyMember(data) {
	var res = "";
	
	if(data.member_no == 0) {
		alert('getModifyMember Error..')
	} else {
		res += "<div class='modify-row'>";	
		res += "<h3 class='modify-title'><label for='id'>아이디</label></h3>";
		res += "<span><input type='text' id='id' name='id' value="+data.mem_id+" maxlength='12' required/></span>";
		res += "<span class='id_success success_confirm'></span>";
		res += "<span class='id_fail error_confirm'></span></div>";
		res += "<div class='modify-row'>";
		res += "<h3 class='modify-title'><label for='pwd'>비밀번호</label></h3>";
		res += "<span><input type='password' id='pwd' name='pwd' maxlength='16' required/>";
		res += "<span class='pwd_success success_confirm'></span>";
		res += "<span class='pwd_fail error_confirm'></span>";
		res += "</span><h3 class='modify-title'><label for='pwd2'>비밀번호 재확인</label></h3>";
		res += "<span><input type='password' id='pwd2' name='pwd2' maxlength='16' required/>";
		res += "<span class='pwd2_confirm'></span></span></div>";
		res += "<div class='modify-row'>";
		res += "<h3 class='modify-title'><label for='name'>성 명</label></h3>";
		res += "<span><input type='text' id='name' name='name' value="+data.mem_name+" required/></span></div>";
		res += "<div class='modify-row'><h3 class='modify-title'><label for='email'>이메일</label></h3>";
		res += "<span><input type='text' id='email' name='email1' value="+data.mem_email.split('@')[0]+" required/>";
		res += "<span class='email-divider'>@</span>";
		res += "<input type='text' id='email2' name='email2' value="+data.mem_email.split('@')[1]+" required/></span>";
		res += "<span class='email_success success_confirm'></span>";
		res += "<span class='email_fail error_confirm'></span></div>";
		res += "<div class='modify-row'>";
		res += "<h3 class='modify-title'><label for='phone'>전화번호</label></h3>";
		res += "<span><input type='text' id='phone' name='phone1' value="+data.mem_phone.split('-')[0]+" maxlength='3' required/>";
		res += "<span class='phone-divider'>-</span>";
		res += "<input type='text' id='phone2' name='phone2' value="+data.mem_phone.split('-')[1]+" maxlength='4' required/>";
		res += "<span class='phone-divider'>-</span>";
		res += "<input type='text' id='phone3' name='phone3' value="+data.mem_phone.split('-')[2]+" maxlength='4' required/></span>";
		res += "<div class='phone-success success_confirm'></div>";
		res += "<div class='phone-fail error_confirm'></div>";
		res += "</div><div class='modify-confirm-btn'>";
		res += "<input class='btn-detail modify-btn-error' type='button' value='확인'/>";
		res += "</div>";
		
		$(".inquiry").empty();
		$(".reserve").empty();
		$('.modify').empty();
		$(".modify").html(res);
	}
}


/* 회원 수정 - End */

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
