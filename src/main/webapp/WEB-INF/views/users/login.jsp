<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<%@include file="../include/header.jsp" %>
<style>
body {
  padding-top: 150px;
}
</style>
<body class="text-center">
<%@include file="../include/navbar.jsp" %>

<section class="h-100">
		<div class="container h-100">
			<div class="row justify-content-sm-center h-100">
				<div class="col-xxl-4 col-xl-5 col-lg-5 col-md-7 col-sm-9">
					<div class="card shadow-lg">
						<div class="card-body p-5">
							<h1 class="fs-4 card-title fw-bold mb-4">로그인</h1>
							
							<p class="error-msg">${error }</p>
							<form role="form" action="/login" method="post" accept-charset="UTF-8">
							<fieldset>
								<div class="mb-3">
									<label class="text-muted" for="email">이메일</label>
									<input type="email" class="form-control" name="username" placeholder="Email" autofocus>
								</div>
	
								<div class="mb-3">
									<label class="text-muted" for="password">비밀번호</label>
									<input type="password" class="form-control" name="password" placeholder="Password" >
								</div>

								<div class="mb-3">
									<button type="submit" class="btn btn-primary">
										로그인
									</button>
								</div>
								
								<div class="mb-3">
									<a href="/findid" class="float-end ">아이디 찾기</a>
									<br>
									<a href="/findpw" class="float-end">비밀번호 찾기</a>
								</div>
											
                                 <!-- 토큰 전송 -->
		                         <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"> 
							</fieldset>
							</form>
						</div>
						<div class="card-footer py-3 border-0">
							<a href="/join" class="text-dark text-center"><div>회원 가입</div></a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
    
<%@include file="../include/footer.jsp" %>
<script>
(function () {
	'use strict'

	// Fetch all the forms we want to apply custom Bootstrap validation styles to
	var forms = document.querySelectorAll('.needs-validation')

	// Loop over them and prevent submission
	Array.prototype.slice.call(forms)
		.forEach(function (form) {
			form.addEventListener('submit', function (event) {
				if (!form.checkValidity()) {
					event.preventDefault()
					event.stopPropagation()
				}

				form.classList.add('was-validated')
			}, false)
		})
})()
</script>
</body>
</html>
