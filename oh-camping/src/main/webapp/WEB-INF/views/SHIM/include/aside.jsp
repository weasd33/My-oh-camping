<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="<c:url value="/resources/SHIM/css/aside.css" />?4" rel="stylesheet">
<aside id="aside">
	<nav class="navi">
	
		<hr class="sidebar-divider">
		<div class="sidebar-heading">MANAGE</div>
		
		<ul>
			<li class="nav-item">
				<span class="icon-users"></span>
				<a href="<%=request.getContextPath() %>/main.do">회원 관리</a>
			</li>
			<li class="nav-item">
				<span class="icon-docs"></span>
				<a href="<%=request.getContextPath() %>/reserve/main.do">예약 관리</a>
			</li>
			<li class="nav-item">
				<span class="icon-money"></span>
				<a href="<%=request.getContextPath() %>/sales/main.do">매출 관리</a>
			</li>
		</ul>
		
		<hr class="sidebar-divider">
		<div class="sidebar-heading">선아님</div>
		
		<ul>
			<li class="nav-item">
				<a href="#">공지사항</a>
			</li>
			<li class="nav-item">
				<a href="#">1:1 문의</a>
			</li>
			<li class="nav-item">
				<a href="#">팝업 관리</a>
			</li>
			<li class="nav-item">
				<a href="#">리뷰 관리</a>
			</li>
		</ul>
		
		<hr class="sidebar-divider">
		
	</nav>
</aside>
