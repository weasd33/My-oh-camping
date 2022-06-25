<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="dto" value="${detailList }"/>
<c:set var="paging" value="${Paging }" />
<c:set var="sortKey" value="${sortKey }" />
<div class="card detail-modal">
  <div class="card-body">
    <h5 class="card-title"><span class="card-name">${dto.mem_id }</span><span class="title">님 정보</span></h5><hr class="card-line">
    <div class="card-text"><span class="icon-user-1 icon"></span>${dto.mem_name }</div><hr>
    <div class="card-text"><span class="icon-mail icon"></span>${dto.mem_email }</div><hr>
    <div class="card-text"><span class="icon-phone icon"></span>${dto.mem_phone }</div><hr>
    <div class="card-text"><span class="icon-user-plus icon"></span>${dto.mem_condate }</div><hr>
    <div class="card-text"><span class="icon-eye icon"></span>${dto.mem_regdate }</div><hr>
    <div class="card-btn">
    	<span><input class="btn btn-danger" type="button" value="탈퇴" onclick="if(confirm('해당 회원을 탈퇴시키겠습니까??')) {
						location.href='member_delete.do?num=${dto.member_no }&page=${paging.getPage() }&sortKey=${sortKey }'} else { return; }"></span>
    	<span><input class="btn btn-secondary" type="button" value="취소" onclick="history.back()"></span>
    </div>
  </div>
</div>
<script type="text/javascript">
	
	setTimeout(function() {
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
	}, 0.1);
	
</script>
