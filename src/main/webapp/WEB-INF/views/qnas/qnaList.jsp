<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<%@include file="../include/header.jsp"%>
<body>
 <%@include file="../include/navbar.jsp"%> 
	<div class="container mt-5">
	<div class="container">
		<div class="row justify-content-center">
			<h2 class="mb-5">Q n A</h2>
			<div class="col-lg-3 d-none d-lg-block">
				<%@ include file="../include/sidebar_support.jsp"%>
			</div>
			<div class="col-lg-9">
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
						<sec:authorize access="hasAnyRole('ROLE_USER', 'ROLE_ADMIN')">
							<a href="/qnas/add" class="btn btn-sm btn-outline-success"> 등록 </a>
						</sec:authorize>
						</div>
					</div>
					<hr class="my-4">

					<table class="table table-hover shadow bg-body table-rounded">
						<thead>
							<tr style="background-color: #999999; color: white;">
								<th scope="col" class="col-2">번호</th>
								<th scope="col" class="col-4 ">제목</th>
								<th scope="col" class="col-3">작성일</th>
							</tr>
						</thead>
						<tbody id="imgList">
							<tr>
						  <th scope="row">1</th>
						  <td><a href="#">첫 번째 게시물</a></td>
						  <td>2023-04-13</td>
						</tr>	
						</tbody>
					</table>

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
									<option value="TC">제목/내용</option>
								</select> <input class="form-control form-control-sm" type="search"
									placeholder="검색어" id="keyword">
								<button class="btn btn-sm btn-outline-success" type="button" id="searchBtn">
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
         return '/qnas/total'
      }
      /* 게시물 가져오기 위해 처리한 jsp URL 입력해주세요 */
      function getListUrl() {
         return '/qnas/list'
      }
      
      function getCsrfToken() {
    	  return '${ _csrf.token }';
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
             var regDate = new Date(data[i].regDate); // Date 객체 생성
             var qDate = new Date(data[i].qdate);
             
             // "YYYY-MM-DD" 형식의 날짜 문자열 생성
             var qDateString = qDate.getFullYear() + "-" + (qDate.getMonth() + 1).toString().padStart(2, '0') + "-" + qDate.getDate().toString().padStart(2, '0');

             imgHTML += ''
                 + "<tr>"
                 + "<td style='line-height: 100px;'>" + data[i].qno + "</td>"
                 + "<td style='line-height: 100px;'><a href=\"qnas/select?qno="
                 + data[i].qno	+"'\">"	+ data[i].qtitle + "</a></td>"
                 + "<td class='qcon' style='display:none'>" + data[i].qcontent + "</td>"
                 + "<td style='line-height: 100px;'>" + qDateString + "</td>" // "YYYY-MM-DD" 형식의 날짜 문자열 추가
                 + "</tr>";
                 
         }
         $('#imgList').html(imgHTML);
         $(document).on('click', '#imgList tr', function() {
/*         	    var index = $(this).index(); // 클릭한 행의 인덱스 찾기*/   
      	    $(this).find('td.qcon').toggle(); // 다음 형제 요소(td) 보이거나 숨기기
        	  });
      }	
</script>
</body>
</html>