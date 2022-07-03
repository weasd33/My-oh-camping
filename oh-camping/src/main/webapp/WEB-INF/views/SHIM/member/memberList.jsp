<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link href="<c:url value="/resources/SHIM/css/member/main.css" />?20" rel="stylesheet">
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
		res += "<input class='btn-detail btn-modify' type='button' value='정보수정'/>";
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
		$(".reserve").empty(); /* 예약 목록 지움 */
	}
};

/* 해당 회원 예약 내역 */
function roomDateFormat(date) {
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

function reserveList(page, mem_id) { 
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
	res += "</tr></thead>";
	res += "<tbody class='reserve-body'>";
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
			res += "<td>"+ roomDateFormat(vo["room_resdate"]) +"</td> <td>"+roomStatus(vo["room_resdate"])+"</td>";
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
	
	$(".reserve").empty();
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
		res += "<tr><th colspan='2'>요청사항:</th><th>사용일</th><td>"+roomDateFormat(list.room_resdate)+"</td></tr>";
		res += "<tr><td colspan='4'><div>";
		res += "<pre class='reserve-request'>"+list.payment_request+"</pre></div>";
		res += "<span class='icon-logout back-btn' onclick='reserveList("+page+", \""+mem_id+"\");'></span>";
		res += "</td></tr></tbody></table>";
		
		$(".reserve").empty();
		$(".reserve").html(res);
	}
};

/* 해당 회원 예약 내역  - End */

function viewHidden() { /* 취소 클릭 시 숨기기 */
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

/* 회원 수정 */
/* function modify(num) {
	$.ajax({
		url: '/test/member_modify.do',
		data: { 'num': num },
		type: 'get',
		dataType: 'json',
		success: modifyView,
		error: function() {alert("Modify Error...");}
	});
};

function modifyView(data) {
	res = "";
	if(data == null) {
		alert('Modify Error...');
	} else {
		res += "<h5 class='card-title'><span class='card-name'><input value='" + data.mem_name + "' required/></span><span class='title'>님 정보</span></h5><hr class='card-line'>";
		res += "<div class='card-text'><span class='icon-user-1 icon'></span><input value='" + data.mem_id + "' required/></div><hr>";
		res += "<div class='card-text'><span class='icon-user-1 icon'></span><input type='password' value='" + data.mem_pwd + "' required/></div><hr>";
		res += "<div class='card-text'><span class='icon-user-1 icon'></span><input type='password' value='" + data.mem_pwd + "' required/></div><hr>";
		res += "<div class='card-text'><span class='icon-mail icon'></span><input value='" + data.mem_email + "' required/></div><hr>";
		res += "<div class='card-text'><span class='icon-phone icon'></span><input value='" + data.mem_phone + "' required/></div><hr>";
		res += "<div class='card-btn'>";
		res += "<span><input class='btn btn-primary' type='button' value='완료' onclick='modify(" + data.member_no + ");'/></span>";
		res += "<span><input class='btn btn-danger' type='button' value='탈퇴' onclick=\"if(confirm('해당 회원을 탈퇴시키겠습니까?')) { location.href='member_delete.do?num=" + data.member_no + "' } else { return; }\"></span>";
		res += "<span><input class='btn btn-secondary' type='button' value='취소' onclick='viewHidden();'></span>";
		res += "</div>";
	}
	$(".card-body").empty();
	$(".card-body").html(res);
}; */

/* 회원 수정 */

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
					<tbody class="detail-user">
					<%-- Ajax 회원 조회 --%>
					</tbody>
				</table>
		<%-- ----------------------- 페이징 부분 ----------------------- --%>		
				<nav class="paging" aria-label="Page navigation example">
					<ul class="list-page pagination justify-content-center">
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
			
				<%-- 문의 내역 --%>
				<div class="inquiry">
					<table class="table table-striped">
						<thead class="inquiry-head">
							<tr>
								<th>No.</th> <th>유 형</th> <th>제 목</th>
								<th>작성일</th> <th></th>
							</tr>
						</thead>
						<tbody class="inquiry-body">
							<tr class="inquiry-title" style='cursor:pointer;'>
								<td>1</td> <td>객실문의</td>
								<td>객실 관련 문의 드립니다.</td> <td>22/04/21</td>
								<td><input class="btn-detail del-inquiry" type="button" value="삭제"></td>
							</tr>
							<tr>
								<td>15</td> <td>결제</td>
								<td>비용 관련 문의 드립니다.</td> <td>22/05/01</td>
								<td><input class="btn-detail del-inquiry" type="button" value="삭제"></td>
							</tr>
							<tr>
								<td>26</td> <td>객실</td>
								<td>숙소 상태 문의드려요</td> <td>22/05/22</td>
								<td><input class="btn-detail del-inquiry" type="button" value="삭제"></td>
							</tr>
							<tr>
								<td>134</td> <td>기타</td>
								<td>주차 문의 드립니다.</td> <td>22/06/01</td>
								<td><input class="btn-detail del-inquiry" type="button" value="삭제"></td>
							</tr>
							<tr>
								<td>166</td> <td>예약</td>
								<td>예약 관련 문의 드립니다.</td> <td>22/07/01</td>
								<td><input class="btn-detail del-inquiry" type="button" value="삭제"></td>
							</tr>
						</tbody>
						
						<!-- 문의 클릭 시 문의 내용 보임 -->
						<!-- <tbody class="inquiry-body">
							<tr class="inquiry-title" style='cursor:pointer;'>
								<td>1</td> <td>객실문의</td>
								<td>객실 관련 문의 드립니다.</td> <td>22/04/21</td>
								<td><input class="btn-detail del-inquiry" type="button" value="삭제"></td>
							</tr>
							<tr>
								<td colspan="5">
									<div>
										<pre class="inquiry-cont">
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
											객실 관련 문의 드립니다. 객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
											객실 관련 문의 드립니다. 객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
											객실 관련 문의 드립니다. 객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
											객실 관련 문의 드립니다. 객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
											객실 관련 문의 드립니다. 객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
											객실 관련 문의 드립니다. 객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
											객실 관련 문의 드립니다. 객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
											객실 관련 문의 드립니다. 객실 관련 문의 드립니다.
														객실 관련 문의 드립니다.객실 관련 문의 드립니다.
										</pre>
									</div>
								</td>
							</tr>
						</tbody> -->
					</table>
					
					<!-- 문의 페이징 -->
					<nav class="paging inquiry-paging" aria-label="Page navigation example">
						<ul class="inquiry-page pagination justify-content-center">
							<li class='page-item cur-page' aria-current="page"><a class='page-link'>1</a></li>
							<li class='page-item'><a class='page-link'>2</a></li>
							<li class='page-item'><a class='page-link'>3</a></li>
						</ul>
					</nav>
				</div>
				
				<%-- 문의 내역 - End --%>
				
				<%-- 예약 내역 --%>
				<div class="reserve"></div>
		</div>
</body>
</html>
