<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>  
	
<!DOCTYPE html>		
<html>
<%@include file="../include/header.jsp"%>
<style>
.text-of {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.text-table th,
.text-table td{
	font-size: 90%;
}
</style>
<body>
<%@include file="../include/navbar.jsp"%>
<header class="mt-5 mb-5 pt-5 pb-5" style="background-image: url('/resources/assets/img/portfolio/fullsize/2.jpg'); background-size: cover;">
	<div class="container">
		<h1 class="mt-5 mb-5 pt-5 pb-5 text-white"><span class="text-shadow">QnA 보기</span></h1>
	</div>
</header>
<div class="container">
	<div class="container mt-5">
		<div class="row justify-content-center">
			<div class="col-lg-3 d-none d-lg-block">
				<%@ include file="../include/sidebar_support.jsp"%>
			</div>
			<div class="col-lg-9">
				<div class="row">
					<div class="col-12 text-end mb-2">
						<sec:authorize access="hasRole('ROLE_ADMIN')">
						<button class="btn btn-outline-warning btn-sm mx-1" type="button" id="editBtn">수정</button>
								<button class="btn btn-outline-danger btn-sm mx-1" type="button" id="removeBtn">삭제</button>
						</sec:authorize>
					</div>
				</div>
				<table class="table text-nowrap text-table table-rounded shadow-sm">
					<tr class="row">
						<th class="col-sm-1 text-center table-primary text-of">제목</th>
						<td class="col-sm-4 text-of table-light">${qna.qtitle}</td>
						<th class="col-sm-1 text-center table-primary text-of">작성자</th>
						<td class="col-sm-2 text-of table-light">관리자</td>
						<th class="col-sm-1 text-center table-primary text-of">등록일</th>
						<td class="col-sm-3 text-of table-light">${qna.qdate}</td>
					</tr>
				</table>

				<div class="py-3 px-5">
					<div class="text-lg" style="min-height: 300px;">
						<p class="text-lg" style="width: 100%;">${qna.qcontent}</p>
						<!-- <p id="ncontent"></p> -->
					</div>
				</div>
				<div class="col-lg-12 text-end mt-5">
					<a class="btn btn-outline-secondary btn-sm mx-3" href="/qnas">목록</a>
				</div>
			</div>
		</div>
	</div>
</div>

					

	
<%@include file="../include/footer.jsp"%>
<script>
var csrfToken = getCsrfToken();

function getCsrfToken(){
    return '${_csrf.token}';
}
/* function checkForm() {
	  // 폼 유효성 검사를 수행
	  if (bindingResult.hasErrors()) {
	    alert("폼을 제출할 수 없습니다.");
	    return false;
	  }

	  // 폼 유효성 검사를 통과하면 true 반환
	  return true;
	} */
$("#editBtn").on("click", function() {
	  var qnaQno = '${qna.qno}'; // 해당 게시물의 pno 값을 가져옵니다.
	  location.href = '/qnas/update?qno=' + qnaQno; // edit 페이지로 이동합니다.
	});
	
$("#removeBtn").on("click", function() {
	if(confirm('정말로 삭제하시겠습니까?')) {
  // 해당 게시물의 nno
  var qno = '${qna.qno}';
  // POST 요청
  $.ajax({
    type: "POST",
    url: "/qnas/delete",
    data: {
      qno : qno
    },
    beforeSend: function(xhr) {
      // 요청 헤더에 CSRF 토큰을 추가
  	  xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
    },
    success: function(result) {
  	  location.href = '/qnas'; 
    },
    error: function(xhr, status, error) {
      console.log("삭제 요청 실패");
      console.log(xhr.responseText);
    }
  });
	}
});
</script>
</body>
</html>