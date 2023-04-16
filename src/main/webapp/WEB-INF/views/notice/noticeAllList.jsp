<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>	
<html>
<%@include file="../include/header.jsp"%>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<body>
<%@include file="../include/navbar.jsp"%>
<header class="mt-5 mb-5 pt-5 pb-5" style="background-image: url('/resources/assets/img/portfolio/fullsize/3.jpg'); background-size: cover;">
	<div class="container">
		<h1 class="mt-5 mb-5 pt-5 pb-5 text-white"><span class="text-shadow">공지사항</span></h1>
	</div>
</header>
<div class="container mt-5">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-lg-3 d-none d-lg-block">
				<%@ include file="../include/sidebar_support.jsp"%>
			</div>
			
			<div class="col-lg-9">
					<div class="row">
						<div class="col-6 text-muted">
							<select class="form-select form-select-sm d-inline"
								id="selectAmount" style="width: 80px">
								<option value="10" selected>10</option>
								<option value="20">20</option>
								<option value="40">40</option>
							</select> <span class="d-inline">개씩 보기</span>
						</div>
						<div class="col-6 text-end">
						<sec:authorize access="hasRole('ROLE_ADMIN')">
							<button id="regBtn" type="button"
							class="btn btn-sm btn-outline-success">등록</button>
						</sec:authorize>
						</div>
					</div>
					<hr class="my-4">

					<table class="table table-hover shadow bg-body table-rounded">
						<thead>
							<tr class="bg-primary" style="color: white;">
								<th scope="col" class="col-1">번호</th>
								<th scope="col" class="col-3">제목</th>
								<th scope="col" class="col-3">작성자</th>
								<th scope="col" class="col-2">작성일</th>
								<th scope="col" class="col-1">조회수</th>
							</tr>
						</thead>
						<tbody id="imgList">
								
						</tbody>
					</table>
					
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



	
						
<%@include file="../include/footer.jsp"%>	
<%@ include file="../include/scriptUtil.jsp"%>					
	<script src="/resources/js/page.js"></script>
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
         return '/notice/total'
      }
      /* 게시물 가져오기 위해 처리한 jsp URL 입력해주세요 */
      function getListUrl() {
         return '/notice/list'
      }

      function getCsrfToken(){
          return '${_csrf.token}';
       } 
      
      function printList(data) {
         //TODO: 리스트 출력 처리 하세요
         if (data.length < 1) {
            var noneStr = '';
            noneStr ='<div>등록된 게시물이 없습니다.<div>'
            $("#none").html(noneStr);
         }  else {
 			$("#none").html('');
 		}
         var imgHTML = '';
         
         for (var i = 0; i < data.length; i++) {
        	    var regDate = new Date(data[i].regDate); // Date 객체 생성
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
        	      + '<tr onclick="location.href=\'/notice/detail?nno='
        	      + data[i].nno + "'\">"
        	      + "<td>" + data[i].nno + "</td>"
        	      + "<td>" + data[i].ntitle + "</td>"
        	      + '<td id=' + i + '>'
        	      + getName(data[i].nwriter, i) + '</td>'
        	      + '<td>' + formatRegDate + "</td>"
        	      + "<td>" + data[i].hit + "</td></a></tr>"
        	  }
         $('#imgList').html(imgHTML); 
      }	
      
    //등록 버튼 클릭 이벤트 처리
  	$('#regBtn').on('click', function(){
  		self.location = "/notice/add";
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
				$('#'+i).html(data.name);
			})
	}
    
  	    
</script>      
<script	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>