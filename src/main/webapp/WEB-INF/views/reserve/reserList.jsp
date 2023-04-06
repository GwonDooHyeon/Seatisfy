<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<%@ include file="../include/header.jsp"%>
<body>
<%@ include file="../include/navbar.jsp"%>
<div class="container">
	<div class="photo-gallery container mb-3">
		<div class="row justify-content-center">
			<h2>예약</h2>
			<%-- <div class="col-lg-3 d-none d-lg-block">
				<%@ include file="/include/sidebar4.jsp"%>
			</div> --%>

			<!-- <div class="col-lg-9"> -->
			<div class="col-lg-12">
				<div class="row">
					<div class="col-3 text-muted">
						<select class="form-select form-select-sm w-50 d-inline"
							id="selectAmount">
							<option value="10" selected>10</option>
							<option value="20">20</option>
							<option value="40">40</option>
						</select> <span class="d-inline">개씩 보기</span>
					</div>
					<div class="col-9 text-end">
				<%-- <% if (sid != null) { // 세션 처리 %>
						<a href="insertForm.jsp" class="btn btn-sm btn-outline-success">게시물 등록 </a>
					<%} %> --%>
					</div>
				</div>
				<hr class="my-4">

				<table class="table table-hover shadow bg-body rounded">
					<thead>
						<tr style="background-color: #999999; color: white;">
							<th scope="col" class="col-2">no</th>
							<th scope="col" class="col-6">제목</th>
							<th scope="col" class="col-2">작성자</th>
							<th scope="col" class="col-2">작성일</th>
						</tr>
					</thead>
					<tbody id="imgList">
						<%-- <c:forEach items="${ list }" var="pvo" varStatus="i">
							<tr class="move" data="${ pvo.pno }">
					            <td>${ pvo.pno }</td>
					            <td>${ pvo.ptitle }</td>
					            <td>${ pvo.pcontent }</td>
					            <td>${ pvo.pwriter }</td>
					            <fmt:parseDate value="${noticeDateStr}" var="noticePostDate" pattern="yyyyMMdd"/>
								<fmt:formatDate value="${noticePostDate}" pattern="yyyy.MM.dd"/>
					            <td>${ pvo.regdate }</td>
					        </tr>
						</c:forEach> --%>
					</tbody>
				</table>
				<div class="row text-center" id="none"></div>
				
				<hr class="my-4">
				<div class="row">
					<div class="col-8">
						<ul class="pagination justify-content-center" id="pagination">

						</ul>
					</div>
					<div class="col-4">
						<div class="d-flex text-end">
							<select class="form-select" id="selectType">
								<option value="T" selected>제목</option>
								<option value="C">내용</option>
								<option value="W">작성자</option>
								<option value="TC">제목/내용</option>
								<option value="TCW">제목/내용/작성자</option>
							</select> <input class="form-control form-control-sm" type="search"
								placeholder="검색어" id="keyword">
							<button class="btn btn-sm btn-outline-success" type="button"
								id="searchBtn">
								<i class="bi bi-search"></i>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
	

<%@ include file="../include/footer.jsp"%>	

<script src="/resources/js/page.js"></script>

<script>
	/*
	 [form id 이걸로 하셈]

	 검색 버튼 : searchBtn
	 검색 입력 인풋 : keyword
	 검색 선택 셀렉트 : selectType
	 게시글 표시 갯수 셀렉트 : selectAmount
	 */

	/* 전체 게시물 수 가져오기 위해 처리한 jsp URL 입력해주세요 */
	function getTotalCountUrl() {
		return '/reserve/total'
	}
	/* 게시물 가져오기 위해 처리한 jsp URL 입력해주세요 */
	function getListUrl() {
		return '/reserve'
	}

	function printList(data) {
		//TODO: 리스트 출력 처리 하세요
		if (data.length < 1) {
			var noneStr = '';
			noneStr ='<div>등록된 게시물이 없습니다.<div>'
			$("#none").html(noneStr);
		}
		var imgHTML = '';
		for (var i = 0; i < data.length; i++) {
			imgHTML += ''
					+ "<tr onclick=\"location.href='newsDetail.jsp?nno="
					+ data[i].pno + "'\"><td>" + data[i].pno + "</td>"
					+ '<td>' + data[i].ptitle + "</td>" + '<td>'
					+ data[i].pwriter + "</td><td>" + data[i].regdate + "</td></a></tr>"
		}
		$('#imgList').html(imgHTML);
	}
	
	$(function(){
	   const urlParams = new URL(location.href).searchParams;
	   const msg = urlParams.get('msg');

	   if (msg == "deleteSuccess") {
	      popModal("삭제 성공", "삭제에 성공하였습니다.")
	   } else if (msg == "fail") {
	      popModal("오류 발생", "오류가 발생하였습니다. 다시 시도해주세요.")
	   }
	});
</script>

</body>
</html>