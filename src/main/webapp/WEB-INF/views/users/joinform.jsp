<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>    
<!DOCTYPE html>
<html>
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
							<h1 class="fs-4 card-title fw-bold mb-4">회원가입</h1>
							
							<form:form modelAttribute="user" 
									   action="/join"
							           class="form-horizontal"
							           method="post">
							<fieldset>
								<div class="mb-3">
									<div class="mb-2 w-100">
										<label class="mb-2 text-muted" for="email">아이디</label>
									</div>
									<form:input path="username" class="form-control" placeholder="Email" autofocus = "${true }"/>
									<form:errors path="username" />
								</div>
	
								<div class="mb-3">
									<div class="mb-2 w-100">
										<label class="text-muted" for="password">비밀번호</label>
									</div>
									<form:input path="password" type="password" class="form-control" placeholder="Password"/>
									<form:errors path="password"/>
								</div>
								<div class="mb-3">
									<div class="mb-2 w-100">
										<label class="text-muted" for="passwordConfirm">비밀번호 확인</label>
									</div>
									<form:input path="passwordConfirm" type="password" class="form-control" placeholder="Password Confirm"/>
									<form:errors path="passwordConfirm" cssClass="error" />
								</div>
								<div class="mb-3">
									<div class="mb-2 w-100">
										<label class="text-muted" for="name">이름</label>
									</div>
									<form:input path="name" class="form-control" placeholder="Name"/>
									<form:errors path="name"/>
								</div>
								<div class="mb-3">
									<div class="mb-2 w-100">
										<label class="mb-2 text-muted" for="phone">전화번호</label>
									</div>
									<form:input path="phone" class="form-control" placeholder="Phone"/>
									<form:errors path="phone"/>
								</div>


								<div class="mb-3">
									<button type="submit" class="btn btn-primary ms-auto">회원가입</button>
								</div>
								
                                 <!-- 토큰 전송 -->
		                         <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"> 
							</fieldset>
							</form:form>
						</div>
						<div class="card-footer py-3 border-0">
							<a href="/login" class="text-dark text-center"><div>로그인</div></a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

	
<%@include file="../include/footer.jsp" %>
</body>
</html>