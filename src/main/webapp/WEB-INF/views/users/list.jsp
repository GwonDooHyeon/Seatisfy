<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>	
<!DOCTYPE html>
<html>
<%@include file="../include/header.jsp" %>
<body>
<%@include file="../include/navbar.jsp" %>
<header class="mt-5 mb-5 pt-5 pb-5" style="background-image: url('/resources/assets/img/portfolio/fullsize/2.jpg'); background-size: cover;">
	<div class="container">
		<h1 class="mt-5 mb-5 pt-5 pb-5 text-white"><span class="text-shadow">회원 목록</span></h1>
	</div>
</header>
	<div class="container mt-5">	
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-lg-3 d-none d-lg-block">
				<%@ include file="../include/sidebar_user.jsp"%>
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
							<button id="regBtn" type="button"
						class="btn btn-xs pull-right btn-outline-secondary btn-sm">등록</button>
						</div>
					</div>
					<hr class="my-4">

					<table class="table table-hover shadow bg-body table-rounded">
						<thead>
							<tr class="bg-primary" style="color: white;">
								<th scope="col" class="col-1">번호</th>
								<th scope="col" class="col-2">이메일</th>
								<th scope="col" class="col-2">이름</th>
								<th scope="col" class="col-2">전화번호</th>
								<th scope="col" class="col-2">권한</th>
								<th scope="col" class="col-2">가입일</th>
								<th scope="col" class="col-3">관리</th>
								
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
									<option value="E" selected>이메일</option>
									<option value="N">이름</option>
									<option value="EN">이메일/이름</option>
								</select> <input class="form-control form-control-sm" type="search"
									placeholder="검색어" id="keyword">
								<button class="btn btn-sm btn-outline-secondary" type="button"
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
         return '/user/total'
      }
      /* 게시물 가져오기 위해 처리한 jsp URL 입력해주세요 */
      function getListUrl() {
         return '/user/listAjax'
      }
	
      function getCsrfToken(){
    	  return '${_csrf.token}';
      }
      
      function printList(data) {
         //TODO: 리스트 출력 처리 하세요
         if (data.length < 1) {
            var noneStr = '';
            noneStr ='<div>가입된 회원이 없습니다.<div>'
            $("#none").html(noneStr);
         }  else {
 			$("#none").html('');
 		}
         var imgHTML = '';
         for (var i = 0; i < data.length; i++) {
        	// var regDate = new Date(data[i].udate); // Date 객체 생성
            // var formatRegDate = udate.getFullYear() + '-' + ('0' + (udate.getMonth() + 1)).slice(-2) + '-' + ('0' + udate.getDate()).slice(-2); // yyyy-MM-dd 형식으로 변환
            
            var regDate = new Date(data[i].udate); // Date 객체 생성
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
                  + "<tr>"
            	  +"<td>" + data[i].uno + "</td>"
                  + "<td>" + data[i].username + "</td>" 
                  +'<td>' + data[i].name+ "</td>"
                  + '<td>' + data[i].phone  + "</td>"
                  +	"<td><select onchange=\"javascript:updateAuth(\'" + data[i].username +"\' ,'"+ i + "')"
                  + "\" id='" + i + "'"
                  +	" class='form-select form-select-sm '	 aria-label=\'.form-select-sm example'>"
                  +		"<option selected>" +data[i].authority + "</option>"
                  +		"<option disabled>---------</option>"
                  +		"<option value='ROLE_USER'>ROLE_USER</option>"
                  +		"<option value='ROLE_ADMIN'>ROLE_ADMIN</option>"
                  +		"</select></td>"
                  +"<td>" + formatRegDate + "</td>" 
                  +"<td><button onclick=\"javascript:removeConfirm("+ data[i].uno+")\"	class=\"btn btn-danger btn-sm\">삭제</button></td>"
                  +"</tr>"
         }
         $('#imgList').html(imgHTML); 
      }	
      
      
    //등록 버튼 클릭 이벤트 처리
  	$('#regBtn').on('click', function(){
  		self.location = "/join";
  	});
    
    // 회원 삭제 confirm
	function removeConfirm(uno) {
	    if (confirm("이 회원을 정말로 삭제하시겠습니까?")) {
	        removeUser(uno);
	    }
	}
    // 회원 삭제 버튼
  	function removeUser(uno) {
		$.ajax({
			type : "POST",
			url : "/user/remove",
			data : {
				uno : uno
			},
			beforeSend : function(xhr) { /*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
				xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			},
			success : function(result) {
				alert("회원이 삭제되었습니다.");
			},
			error : function(request, status, error) {
				alert(request.status + " " + request.responseText);
			}
		})

		window.location.reload();
	}
    
    //권한 변경 
	function updateAuth(username, e) {
		var auth = $('#'+e).val();
		$.ajax({
			type : "POST",
			url : "/user/list",
			data : {
				username : username,
				authority : auth
			},
			beforeSend : function(xhr) { /*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
				xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			},
			success : function(result) {
				pageObj.pageCal(cri);
			}
		})

	}
  
</script>      
<%@include file="../include/footer.jsp" %>
</body>
</html>