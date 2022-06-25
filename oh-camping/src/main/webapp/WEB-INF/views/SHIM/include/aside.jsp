<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="<c:url value="/resources/SHIM/css/aside.css" />?3" rel="stylesheet">
<aside id="aside">
	<nav class="navi">
		<ul>
			<li>
				<span class="icon-users"></span>
				<a href="<%=request.getContextPath() %>/member_list.do">회원 관리</a>
			</li>
			<li>
				<span class="icon-docs"></span>
				<a href="<%=request.getContextPath() %>/reserve/list.do">예약 관리</a>
			</li>
			<li>
				<span class="icon-money"></span>
				<a href="<%=request.getContextPath() %>/sales/list.do">매출 관리</a>
			</li>
		</ul>
	</nav>
</aside>
