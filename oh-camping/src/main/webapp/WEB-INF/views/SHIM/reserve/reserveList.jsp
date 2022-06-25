<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link href="<c:url value="/resources/SHIM/css/reserve/main.css" />?3" rel="stylesheet">
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
			<div>예약 목록</div>
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
					<table class="table sales-table">
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
						<tbody class="sales-tbody">
							<tr>
								<td>22/03/18</td>
								<td>3185</td>
								<td>계곡 1호</td>
								<td>4</td>
								<td>300,000원</td>
								<td><b>미사용</b></td>
							</tr>
							<tr>
								<td>22/03/18</td>
								<td>3181</td>
								<td>대형 1호</td>
								<td>6</td>
								<td>400,000원</td>
								<td style="color: red"><b>사용 완료</b></td>
							</tr>
							<tr>
								<td>22/03/24</td>
								<td>3245</td>
								<td>계곡 1호</td>
								<td>4</td>
								<td>300,000원</td>
								<td style="color: blue"><b>예약 완료</b></td>
							</tr>
							<tr>
								<td>22/03/24</td>
								<td>3246</td>
								<td>계곡 2호</td>
								<td>4</td>
								<td>300,000원</td>
								<td style="color: green"><b>예약 가능</b></td>
							</tr>
							<tr>
								<td>22/04/18</td>
								<td>4183</td>
								<td>대형 3호</td>
								<td>6</td>
								<td>400,000원</td>
								<td><b>미사용</b></td>
							</tr>
							<tr>
								<td>22/04/20</td>
								<td>4201</td>
								<td>대형 1호</td>
								<td>6</td>
								<td>400,000원</td>
								<td style="color: red"><b>사용 완료</b></td>
							</tr>
							<tr>
								<td>22/04/24</td>
								<td>4245</td>
								<td>계곡 1호</td>
								<td>4</td>
								<td>300,000원</td>
								<td style="color: blue"><b>예약 완료</b></td>
							</tr>
							<tr>
								<td>22/04/24</td>
								<td>4246</td>
								<td>계곡 2호</td>
								<td>4</td>
								<td>300,000원</td>
								<td style="color: green"><b>예약 가능</b></td>
							</tr>
							<tr>
								<td>22/05/18</td>
								<td>5183</td>
								<td>대형 3호</td>
								<td>6</td>
								<td>400,000원</td>
								<td><b>미사용</b></td>
							</tr>
							<tr>
								<td>22/05/20</td>
								<td>5201</td>
								<td>대형 1호</td>
								<td>6</td>
								<td>400,000원</td>
								<td style="color: red"><b>사용 완료</b></td>
							</tr>
							<tr>
								<td>22/05/24</td>
								<td>5245</td>
								<td>계곡 1호</td>
								<td>4</td>
								<td>300,000원</td>
								<td style="color: blue"><b>예약 완료</b></td>
							</tr>
							<tr>
								<td>22/05/24</td>
								<td>5246</td>
								<td>계곡 2호</td>
								<td>4</td>
								<td>300,000원</td>
								<td style="color: green"><b>예약 가능</b></td>
							</tr>
							<tr>
								<td>22/06/18</td>
								<td>6183</td>
								<td>대형 3호</td>
								<td>6</td>
								<td>400,000원</td>
								<td><b>미사용</b></td>
							</tr>
							<tr>
								<td>22/06/20</td>
								<td>6201</td>
								<td>대형 1호</td>
								<td>6</td>
								<td>400,000원</td>
								<td style="color: red"><b>사용 완료</b></td>
							</tr>
							<tr>
								<td>22/06/24</td>
								<td>6245</td>
								<td>계곡 1호</td>
								<td>4</td>
								<td>300,000원</td>
								<td style="color: blue"><b>예약 완료</b></td>
							</tr>
							<tr>
								<td>22/06/24</td>
								<td>6246</td>
								<td>계곡 2호</td>
								<td>4</td>
								<td>300,000원</td>
								<td style="color: green"><b>예약 가능</b></td>
							</tr>
						</tbody>
					</table>
					<%-- ----------------------- 예약 상세 정보 ----------------------- --%>
					<c:set var="now" value="<%=new java.util.Date() %>"/>
					<div class="sales-content">
						<table class="table content-table">
							<tr class="content-thead">
								<th>객실 번호</th>
								<td>6241</td>
							</tr>
							<tr class="content-thead">
								<th>객실 이름</th>
								<td>계곡 1호</td>
							</tr>
							<tr class="content-thead">
								<th>예약자명</th>
								<td>심규복</td>
							</tr>
							<tr class="content-thead">
								<th>아이디</th>
								<td>weasd33</td>
							</tr>
							<tr class="content-thead">
								<th>이메일</th>
								<td>weasd33@naver.com</td>
							</tr>
							<tr class="content-thead">
								<th>전화번호</th>
								<td>010-1234-5678</td>
							</tr>
							<tr class="content-thead">
								<th>인원 수</th>
								<td>4</td>
							</tr>
							<tr class="content-thead">
								<th>결제 가격</th>
								<td>300,000원</td>
							</tr>
							<tr class="content-thead">
								<th>결제일</th>
								<td>2022-06-20</td>
							</tr>
							<tr class="content-thead">
								<th>사용일</th>
								<td>2022-06-24</td>
							</tr>
							<tr class="content-thead">
								<th>사용 여부</th>
								<td>사용 예정</td>
							</tr>
						</table>
					</div>
				</div>
			</section>
		</main>
	</div>		
	
</body>
</html>