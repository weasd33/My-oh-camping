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
			res += "<tr onclick='detailView(" + vo["member_no"] + ")' style='cursor:pointer;'>";
			res += "<td>" + vo["mem_id"] + "</td>";
			res += "<td>" + vo["mem_name"] + "</td>";
			res += "<td>" + vo["mem_email"] + "</td>";
			res += "<td>" + vo["mem_regdate"].substring(0, 10) + "</td>";
			res += "<td>" + vo["mem_condate"].substring(0, 19) + "</td>";
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
				paging += "<li class='page-item cur-page'><a class='page-link' onclick='getList(\""+i+"\", \""+sortKey+"\")'>" + i + "</a></li>";
			} else {
				paging += "<a class='page-link' onclick='getList(\""+i+"\", \""+sortKey+"\")'>" + i + "</a>";
			}
		}
		
		if(endBlock < allPage) {
			paging += "<li class='page-item'><a class='page-link' onclick='getList(\""+(endBlock+1)+"\", \""+sortKey+"\")'>›</a></li>";
			paging += "<li class='page-item'><a class='page-link' onclick='getList(\""+allPage+"\", \""+sortKey+"\")'>»</a></li>";
		}
		
		$(".pagination").empty();
		$(".pagination").html(paging);
	}
};
/* 회원 전체 조회 - End */

/* 회원 상세 정보 */
function detailView(num) { /* 정보 클릭 시 보이기*/
	$.ajax({
		url: '/test/member_list.do',
		data: { 'num': num },
		type: 'get',
		dataType: 'json',
		success: detailShow,
		error: function() {alert("Detail Error..");}
	});
};

function detailShow(data) {
	var cont = data.memberCont;
	res = "";
	if(data == null) {
		alert('회원 정보가 존재하지 않습니다.');
	} else {
		res += "<h5 class='card-title'><span class='card-name'>" + cont.mem_name + "</span><span class='title'>님 정보</span></h5><hr class='card-line'>";
		res += "<div class='card-text'><span class='icon-user-1 icon'></span>" + cont.mem_id + "</div><hr>";
		res += "<div class='card-text'><span class='icon-mail icon'></span>" + cont.mem_email + "</div><hr>";
		res += "<div class='card-text'><span class='icon-phone icon'></span>" + cont.mem_phone + "</div><hr>";
		res += "<div class='card-text'><span class='icon-user-plus icon'></span>" + cont.mem_regdate.substring(0, 10) + "</div><hr>";
		res += "<div class='card-text'><span class='icon-eye icon'></span>" + cont.mem_condate.substring(0, 19) + "</div><hr>";
		res += "<div class='card-btn'>";
		res += "<span><input class='btn btn-danger' type='button' value='탈퇴' onclick=\"if(confirm('해당 회원을 탈퇴시키겠습니까?')) { location.href='member_delete.do?num=" + cont.member_no + "' } else { return; }\"></span>";
		res += "<span><input class='btn btn-secondary' type='button' value='취소' onclick='viewHidden();'></span>";
		res += "</div>";
		
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
	}
};

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

/* 검색 부분 */
$(function() {
	$('.search_btn').click(function() {
		/* 정렬 옵션 초기화 */
		$(".sort option:eq(0)").prop("selected", true);
		
		var search = $('.search_option').val();
		var keyword = $('.search_key').val();
		
		if(keyword == "") {
			alert("검색어를 입력해주세요.");
		} else {
			searchList(1, search, keyword);
		}
	});
});

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
			res += "<tr onclick='detailView()' style='cursor:pointer;'>";
			res += "<td>" + vo["mem_id"] + "</td>";
			res += "<td>" + vo["mem_name"] + "</td>";
			res += "<td>" + vo["mem_email"] + "</td>";
			res += "<td>" + vo["mem_regdate"].substring(0, 10) + "</td>";
			res += "<td>" + vo["mem_condate"].substring(0, 19) + "</td>";
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
				paging += "<li class='page-item cur-page'><a class='page-link' onclick='searchList(\""+i+"\", \""+search+"\", \""+keyword+"\")'>" + i + "</a></li>";
			} else {
				paging += "<a class='page-link' onclick='searchList(\""+i+"\", \""+search+"\", \""+keyword+"\")'>" + i + "</a>";
			}
		}
		
		if(endBlock < allPage) {
			paging += "<li class='page-item'><a class='page-link' onclick='searchList(\""+i+"\", \""+search+"\", \""+keyword+"\")'>›</a></li>";
			paging += "<li class='page-item'><a class='page-link' onclick='searchList(\""+i+"\", \""+search+"\", \""+keyword+"\")'>»</a></li>";
		}
		
		$(".pagination").empty();
		$(".pagination").html(paging);
	}
};
/* 검색 부분 - End*/