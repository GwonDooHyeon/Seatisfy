<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<%@include file="include/header.jsp" %>
<style>
@media (min-width: 992px) {
  #mainNav {
    border-bottom: 1px solid transparent;
    background: transparent;
  }
  #mainNav .navbar-brand {
    color: rgb(255, 255, 255);
  }
  #mainNav .navbar-brand:focus, #mainNav .navbar-brand:hover {
    color: rgb(255, 255, 255);
  }
  #mainNav .navbar-nav > li.nav-item > a.nav-link {
    color: rgb(255, 255, 255);
  }
  #mainNav .navbar-nav > li.nav-item > a.nav-link:focus, #mainNav .navbar-nav > li.nav-item > a.nav-link:hover {
    color: rgb(255, 255, 255);
  }
}
@media (min-width: 992px) {
  #mainNav {
    transition: background-color 0.2s;
    /* Force Hardware Acceleration in WebKit */
    transform: translate3d(0, 0, 0);
    -webkit-backface-visibility: hidden;
    backface-visibility: hidden;
  }
  #mainNav.is-fixed {
    /* when the user scrolls down, we hide the header right above the viewport */
    position: fixed;
    top: -83px;
    transition: transform 0.2s;
    border-bottom: 1px solid white;
    background-color: rgba(255, 255, 255, 0.9);
    transform: translate3d(0, 0%, 0);
  }
  #mainNav.is-fixed .navbar-brand {
    color: #212529;
  }
  #mainNav.is-fixed .navbar-brand:focus, #mainNav.is-fixed .navbar-brand:hover {
    color: #0085A1;
  }
  #mainNav.is-fixed .navbar-nav > li.nav-item > a {
    color: #212529;
  }
  #mainNav.is-fixed .navbar-nav > li.nav-item > a:focus, #mainNav.is-fixed .navbar-nav > li.nav-item > a:hover {
    color: #0085A1;
  }
  #mainNav.is-visible {
    /* if the user changes the scrolling direction, we show the header */
    transform: translate3d(0, 100%, 0);
  }
  
/* 헤더 높이만큼 여백부여 */
body {
  padding-top: 0px;
}
}
</style>
    <body>
<%@include file="include/navbar.jsp" %>

        <!-- Page Header-->
        <header class="masthead" style="background-image: url('resources/assets/img/home-bg.jpg')">
            <div class="container position-relative px-4 px-lg-5">
                <div class="row gx-4 gx-lg-5 justify-content-center">
                    <div class="col-md-10 col-lg-8 col-xl-7">
                        <div class="site-heading">
                            <h1>Seatisfy</h1>
                            <span class="subheading">seat reservation system</span>
                        </div>
                    </div>
                </div>
            </div>
        </header>
        <!-- Main Content-->
        <div class="container px-4 px-lg-5">
            <div class="row gx-4 gx-lg-5 justify-content-center">
                <div class="col-md-10 col-lg-8 col-xl-7">
                    <!-- Post preview-->
                    <div class="post-preview">
                        <a href="/reserve">
                            <h2 class="post-title text-primary">어느 곳이든지 가능</h2>
                            <h3 class="post-subtitle">어느 곳이든 등록하고 자리 예약을 실행해 보세요</h3>
                        </a>
                        <p class="post-meta">
                            어떤 장소든 가능해요
                        </p>
                    </div>
                    <!-- Divider-->
                    <hr class="my-4" />
                    <!-- Post preview-->
                    <div class="post-preview">
                        <a href="/reserve">
                            <h2 class="post-title text-primary text-end">어떤 배치든지 가능</h2>
                            <h3 class="post-subtitle text-end">자리 배치가 규칙적이지 않아도 괜찮아요</h3>
                        </a>
                        <p class="post-meta text-end">
                            자리 배치를 직접 등록할 수 있어요
                        </p>
                    </div>
                    <!-- Divider-->
                    <hr class="my-4" />
                    <!-- Post preview-->
                    <div class="post-preview">
                        <a href="/join">
                            <h2 class="post-title text-primary">누구든지 가능</h2>
                            <h3 class="post-subtitle">회원이라면 누구나 예약할 수 있어요</h3>
                        </a>
                        <p class="post-meta">
                            회원 가입을 해보세요
                        </p>
                    </div>
                    <!-- Divider-->
                    <hr class="my-4" />
                    <!-- Pager-->
                    <div class="d-flex justify-content-end mb-4"><a class="btn btn-primary text-uppercase" href="/login">로그인 하러가기 →</a></div>
                </div>
            </div>
        </div>
<%@include file="include/footer.jsp" %>

    </body>
</html>
    