<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>  

<!DOCTYPE html>
<html>
<%@ include file="../include/header.jsp"%>
<body>
<%@ include file="../include/navbar.jsp"%>
<header class="mt-5 mb-5 pt-5 pb-5" style="background-image: url('/resources/assets/img/portfolio/fullsize/2.jpg'); background-size: cover;">
	<div class="container">
		<h1 class="mt-5 mb-5 pt-5 pb-5 text-white"><span class="text-shadow">예약 목록</span></h1>
	</div>
</header>
<div class="container">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-lg-3 d-none d-lg-block">
				<%@ include file="../include/sidebar_reser.jsp"%>
			</div>
			
			<div class="col-lg-9">
				<div class="row">
					<div class="col-6 text-muted">
						<select class="form-select form-select-sm d-inline"
							id="selectAmount" style="width: 80px">
							<option value="10" selected>6</option>
							<option value="20">12</option>
							<option value="40">24</option>
						</select> <span class="d-inline">개씩 보기</span>
					</div>
					<div class="col-6 text-end">
					<sec:authorize access="hasAnyRole('ROLE_USER', 'ROLE_ADMIN')">
						<a href="/reserve/add" class="btn btn-sm btn-outline-success">예약 등록 </a>
					</sec:authorize>
					</div>
				</div>
				<hr class="my-4">

				<%-- <table class="table table-hover table-rounded shadow-sm bg-body rounded">
					<thead>
						<tr class="bg-primary" style="color: white;">
							<th scope="col" class="col-1">no</th>
							<th scope="col" class="col-4">제목</th>
							<th scope="col" class="col-1">작성자</th>
							<th scope="col" class="col-3">예약 기간</th>
							<th scope="col" class="col-1">상태</th>
							<th scope="col" class="col-2">작성일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${ list }" var="pvo" varStatus="i">
							<tr class="move" data="${ pvo.pno }">
					            <td>${ pvo.pno }</td>
					            <td>${ pvo.ptitle }</td>
					            <td>${ pvo.pcontent }</td>
					            <td>${ pvo.pwriter }</td>
					            <fmt:parseDate value="${noticeDateStr}" var="noticePostDate" pattern="yyyyMMdd"/>
								<fmt:formatDate value="${noticePostDate}" pattern="yyyy.MM.dd"/>
					            <td>${ pvo.regdate }</td>
					        </tr>
						</c:forEach>
					</tbody>
				</table> --%>
				<div class="card-columns row" id="imgList">
					
				</div>
				<div class="row text-center" id="none"></div>
				<hr class="my-4">
				<div class="row">
					<div class="col-md-8">
						<ul class="pagination justify-content-center" id="pagination">

						</ul>
					</div>
					<div class="col-md-4">
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
<%@ include file="../include/scriptUtil.jsp"%>	
<script src="/resources/js/page.js"></script>
<script>

</script>
<script>
onload = function() {
	switch ('${param.result}') {
	  case 'rmsuccess':
	  	popModal('삭제 성공', '게시물이 삭제되었습니다');
	    break;
	  case 'rmfail':
	  	popModal('삭제 실패', '삭제에 실패하였습니다');
	    break;
	}
	pageObj.pageCal(cri);
}
	/*
	 [form id 이걸로 하셈]

	 검색 버튼 : searchBtn
	 검색 입력 인풋 : keyword
	 검색 선택 셀렉트 : selectType
	 게시글 표시 갯수 셀렉트 : selectAmount
	 */
	
	/* 전체 게시물 수 가져오기 위해 처리한 jsp URL 입력해주세요 */
	function getTotalCountUrl() {
		return '/reser/post/total';
	}
	/* 게시물 가져오기 위해 처리한 jsp URL 입력해주세요 */
	function getListUrl() {
		return '/reser/post';
	}
	
	function getCsrfToken() {
		return '${_csrf.token}';
	}
	
	function printList(data) {
		//TODO: 리스트 출력 처리 하세요
		if (data.length < 1) {
			var noneStr = '';
			noneStr ='<div>등록된 게시물이 없습니다.<div>';
			$("#none").html(noneStr);
		} else {
			$("#none").html('');
		}
		var imgHTML = '';
		for (var i = 0; i < data.length; i++) {
			var status = getDateStatus(data[i].startdate, data[i].enddate)
			var statusColor = '';
			switch(status) {
				case '시작 전':statusColor = 'black';
					break;
				case '진행중':	statusColor = 'green';
					break;
				case '종료': 	statusColor = 'red';
					break;
			}
			
			
			var regDate = new Date(data[i].regdate); // Date 객체 생성
       	    var formatRegDate = '';
       	    var now = new Date(); // 오늘 날짜를 가져옵니다.
       	    if (regDate.getFullYear() == now.getFullYear() && regDate.getMonth() == now.getMonth() && regDate.getDate() == now.getDate()) {
       	      // 오늘 날짜와 같은 경우, 시간을 출력합니다.
       	      formatRegDate = ('0' + regDate.getHours()).slice(-2) + ':' + ('0' + regDate.getMinutes()).slice(-2) + ':' + ('0' + regDate.getSeconds()).slice(-2);
       	    } else {
       	      // 다른 날짜의 경우, 년-월-일 형식으로 출력합니다.
       	      formatRegDate = regDate.getFullYear() + '-' + ('0' + (regDate.getMonth() + 1)).slice(-2) + '-' + ('0' + regDate.getDate()).slice(-2);
       	    }
       	 imgHTML += ''
		       	+ '<div class="card col-md-4 col-sm-12" >'
		       	+ '<div  class="card-header text-of"><strong>'+data[i].ptitle+'</strong></div><div class="row mx-3">'
		       	+ '<div class="col-6 text-of" style="color: '+statusColor+';">'+status+'</div><div class="col-6 text-end"><i class="bi bi-alarm"></i>'
		       	+ '</div></div><a href="/reserve/detail/'+ data[i].pno + '"><div  class="card-body">'
		       	+ '<div class="row"><h5 class="col-3 text-of">장소:</h5>'
		       	+ '<div class="col-9 card-text comment text-end text-of">'+data[i].place+'</div>'
		       	+ '</div><h5 class="mt-3">시간</h5>'
		       	+ '<div class="card-text my-2 text-of">'+data[i].startdate.replace('T',' ')+' 시작</div>'
		       	+ '<div class="card-text my-2 text-of">'+data[i].startdate.replace('T',' ')+' 종료</div>'
		       	+ '<div class="row mt-3"><h5 class="col-6 text-of">작성자:</h5>'
		       	+ '<div class="col-6 card-text comment text-end text-of" id="td'+i+'">'+data[i].pwriter+'</div></div></div></a></div></div>';
		       	getName(data[i].pwriter, i)
			/* imgHTML += ''
					+ '<tr onclick="location.href=\'/reserve/detail/'
					+ data[i].pno + '\'"><td>' + data[i].pno + '</td>'
					+ '<td>' + data[i].ptitle + '</td>' + '<td id="td'+i+'">'
					+ getName(data[i].pwriter, i) + '</td>'
					+ '<td>' + data[i].startdate.replace('T',' ') + ' 부터<br>'
					+ data[i].enddate.replace('T',' ') +' 까지</td>'
					+ '<td style="color: '+statusColor+';">' + status +'</td>'
					+ '<td>' + formatRegDate + '</td></a></tr>'; */
		}
		$('#imgList').html(imgHTML);
	}
	
	function getDateStatus(sdate, edate) {
		const now = new Date(); // 현재 시각
		const startDateTime = new Date(sdate); // 시작일시를 Date 객체로 변환
		const endDateTime = new Date(edate); // 종료일시를 Date 객체로 변환

		if (now.getTime() < startDateTime.getTime()) {
			return '시작 전';
		} else if (now.getTime() >= startDateTime.getTime() && now.getTime() <= endDateTime.getTime()) {
			return '진행중';
		} else {
			return '종료';
		}
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
	
	function getName(email, i) {
		fetch("/uname", {	
			method: "post",
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
				'X-CSRF-TOKEN': '${ _csrf.token }'
			},
			body: new URLSearchParams({
					username: email
				})
	        })
			.then(resp => resp.json())
			.then(data => {
				console.log(data.name);
				$('#td'+i).html(data.name);
			})
	}
	
	removeAllParam();
</script>
</body>
</html>