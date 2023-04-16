<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<html>
<%@include file="../include/header.jsp"%>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<style>
/* 맵 설정, 검색 리스트  */
.map_wrap, .map_wrap * {margin:0;padding:0;font-family:'Malgun Gothic',dotum,'돋움',sans-serif;font-size:12px;}
.map_wrap a, .map_wrap a:hover, .map_wrap a:active{color:#000;text-decoration: none;}
.map_wrap {position:relative;width:100%;height:300px;}
#menu_wrap {position:absolute;top:0;left:0;bottom:0;width:250px;margin:10px 0 30px 10px;padding:5px;overflow-y:auto;background:rgba(255, 255, 255, 0.7);z-index: 1;font-size:12px;border-radius: 10px;}
.bg_white {background:#fff;}
#menu_wrap hr {display: block; height: 1px;border: 0; border-top: 2px solid #5F5F5F;margin:3px 0;}
#menu_wrap .option{text-align: center;}
#menu_wrap .option p {margin:10px 0;}  
#menu_wrap .option button {margin-left:5px;}
#placesList li {list-style: none;}
#placesList .item {position:relative;border-bottom:1px solid #888;overflow: hidden;cursor: pointer;min-height: 65px;}
#placesList .item span {display: block;margin-top:4px;}
#placesList .item h5, #placesList .item .info {text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
#placesList .item .info{padding:10px 0 10px 55px;}
#placesList .info .gray {color:#8a8a8a;}
#placesList .info .jibun {padding-left:26px;background:url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_jibun.png) no-repeat;}
#placesList .info .tel {color:#009900;}
#placesList .item .markerbg {float:left;position:absolute;width:36px; height:37px;margin:10px 0 0 10px;background:url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png) no-repeat;}
#placesList .item .marker_1 {background-position: 0 -10px;}
#placesList .item .marker_2 {background-position: 0 -56px;}
#placesList .item .marker_3 {background-position: 0 -102px}
#placesList .item .marker_4 {background-position: 0 -148px;}
#placesList .item .marker_5 {background-position: 0 -194px;}
#placesList .item .marker_6 {background-position: 0 -240px;}
#placesList .item .marker_7 {background-position: 0 -286px;}
#placesList .item .marker_8 {background-position: 0 -332px;}
#placesList .item .marker_9 {background-position: 0 -378px;}
#placesList .item .marker_10 {background-position: 0 -423px;}
#placesList .item .marker_11 {background-position: 0 -470px;}
#placesList .item .marker_12 {background-position: 0 -516px;}
#placesList .item .marker_13 {background-position: 0 -562px;}
#placesList .item .marker_14 {background-position: 0 -608px;}
#placesList .item .marker_15 {background-position: 0 -654px;}
#pagination {margin:10px auto;text-align: center;}
#pagination a {display:inline-block;margin-right:10px;}
#pagination .on {font-weight: bold; cursor: default;color:#777;}

/* 지도에 현재 중앙 위치 정보 표기 */
.title {font-weight:bold;display:block;}
.hAddr {position:absolute;right:10px;top:10px;border-radius: 2px;background:#fff;background:rgba(255,255,255,0.8);z-index:1;padding:5px;}
#centerAddr {display:block;margin-top:2px;font-weight: normal;}
.bAddr {padding:5px;text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}

/* 좌석 번호 설정 */
.seat {
  text-align: center;
  border: 1px solid #444444;
}

.seat-disable {
  text-align: center;
  border: 1px solid #444444;
  background-color: #808080;
}

.table-fixed {
  width: 100%;
  min-width: 700px;
  /* 테이블 전체의 너비를 100%로 설정합니다. */
  table-layout: fixed;
  /* 테이블 레이아웃을 고정된(fixed) 모드로 설정합니다. */
}

.table-fixed th,
.table-fixed td {
  /* 각 셀의 높이를 50px로 설정합니다. */
  height: 50px;
  /* 각 셀의 너비를 33.33%로 설정합니다. */
  width: 33.33%;
  /* 셀의 내용이 너비보다 길 경우, 너비를 넘치는 부분을 생략하고 ...으로 표시합니다. */
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

</style>
<body>
<%@include file="../include/navbar.jsp"%>
<header class="mt-5 mb-5 pt-5 pb-5" style="background-image: url('/resources/assets/img/portfolio/fullsize/1.jpg'); background-size: cover;">
	<div class="container">
		<h1 class="mt-5 mb-5 pt-5 pb-5 text-white"><span class="text-shadow">예약 게시글 수정</span></h1>
	</div>
</header>
<div class="container">
	<div class="container mb-3">
		<div class="row justify-content-center">
			<div class="col-lg-3 d-none d-lg-block">
				<%@ include file="../include/sidebar_reser.jsp"%>
			</div>

			<!-- <div class="col-lg-9"> -->
			<div class="col-lg-9">
				<form:form action="/reserve/edit/${ post.pno }" method="post" modelAttribute="postDTO" id="postFrm">
					<input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }"/>
					<fieldset class="border p-2 rounded mb-5">
	    				<legend><strong>게시글 작성</strong></legend>
						<label for="ptitle" class="form-label">제목</label>
						<form:input path="ptitle" id="ptitle" class="form-control rounded" value="${ post.ptitle }"/>
						<div><form:errors path="ptitle" cssStyle="color:red;"/></div>
						
						<label for="summernote" class="form-label">내용</label>
						<form:textarea path="pcontent" id="summernote"/><br>
						<div><form:errors path="pcontent" cssStyle="color:red;"/><br></div>
						<form:hidden path="pwriter" value="작성자"/>
					</fieldset>
					<fieldset class="border p-2 rounded mb-5">
	    				<legend><strong>장소 정보</strong></legend>
	    				<div><div class="badge bg-success">검색을 통한 입력 권장</div></div>
						<div class="map_wrap mt-3">
						    <div class="rounded" id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
						
						    <div id="menu_wrap" class="bg_white">
						        <div class="option">
						            <div>
						     	 장소 검색 : 
						                <input class="rounded" type="text" id="keyword" size="15">
						                <button type="button" onclick="searchPlaces()">검색</button><br>
						            </div>
						        </div>
						        <hr>
						        <ul id="placesList"></ul>
						        <div id="pagination"></div>
						    </div>
						    <div class="hAddr">
						        <span class="title">지도중심기준 행정동 주소정보</span>
						        <span id="centerAddr"></span>
						    </div>
						</div>
						<label for="place" class="form-label">장소</label>
						<form:input path="place" id="place" class="form-control rounded" value="${ post.place }"/>
						<div><form:errors path="place" cssStyle="color:red;"/></div>
						
						<label for="address" class="form-label">주소</label>
						<form:input path="address" id="address" class="form-control rounded" value="${ post.address }"/>
						<div><form:errors path="address" cssStyle="color:red;"/></div>
					</fieldset>
					<fieldset class="border p-2 rounded mb-5">
	    				<legend><strong>예약 정보</strong></legend>
	    				<div><div class="badge bg-danger">(등록 후 수정 불가)</div></div>
						<label for="seatX" class="form-label mt-3">자리 배치 정보</label>
						<div class="mb-3">
							<input id="seatX" type="hidden" />
							<input id="seatY" type="hidden" />
						</div>
						<form:hidden path="seatinfo"/>
						<div class="table-responsive">
							<table class="table table-fixed table-responsive" id="seatTable">
							</table>
						</div>
						<div><form:errors path="seatinfo" cssStyle="color:red;"/></div>
						<label for="sdate" class="form-label mt-3">시작일</label>
						<form:input id="sdate" path="startdate" type="datetime-local" class="form-control rounded" value="${ post.startdate }"/>
						<div><form:errors path="startdate" cssStyle="color:red;"/></div>
						
						<label for="edate" class="form-label mt-3">종료일</label>
						<form:input id="edate" path="enddate" type="datetime-local" class="form-control rounded" value="${ post.enddate }"/>
						<div><form:errors path="enddate" cssStyle="color:red;"/></div>
					</fieldset>
					<div class="row">
						<div class="col-12 text-end">
							<button class="btn btn-sm btn-outline-success" type="button" id="submitBtn">전송</button>
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>
</div>
<%@include file="../include/footer.jsp"%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=앱키&libraries=services"></script>
<script>
// 마커를 담을 배열입니다
var markers = [];

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 장소 검색 객체를 생성합니다
var ps = new kakao.maps.services.Places();  

// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
var infowindow = new kakao.maps.InfoWindow({zIndex:1});

// 엔터로 장소를 검색합니다
$('#keyword').on("keypress", function(){
	if(event.keyCode == 13) {
		searchPlaces();
	}
})

// 키워드 검색을 요청하는 함수입니다
function searchPlaces() {

    var keyword = document.getElementById('keyword').value;

    if (!keyword.replace(/^\s+|\s+$/g, '')) {
        alert('키워드를 입력해주세요!');
        return false;
    }

    // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
    ps.keywordSearch( keyword, placesSearchCB); 
}

// 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {

        // 정상적으로 검색이 완료됐으면
        // 검색 목록과 마커를 표출합니다
        displayPlaces(data);

        // 페이지 번호를 표출합니다
        displayPagination(pagination);

    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

        alert('검색 결과가 존재하지 않습니다.');
        return;

    } else if (status === kakao.maps.services.Status.ERROR) {

        alert('검색 결과 중 오류가 발생했습니다.');
        return;

    }
}

// 검색 결과 목록과 마커를 표출하는 함수입니다
function displayPlaces(places) {

    var listEl = document.getElementById('placesList'), 
    menuEl = document.getElementById('menu_wrap'),
    fragment = document.createDocumentFragment(), 
    bounds = new kakao.maps.LatLngBounds(), 
    listStr = '';
    
    // 검색 결과 목록에 추가된 항목들을 제거합니다
    removeAllChildNods(listEl);

    // 지도에 표시되고 있는 마커를 제거합니다
    removeMarker();
    
    for ( var i=0; i<places.length; i++ ) {

        // 마커를 생성하고 지도에 표시합니다
        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
            marker = addMarker(placePosition, i), 
            itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다

        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
        // LatLngBounds 객체에 좌표를 추가합니다
        bounds.extend(placePosition);

        // 마커와 검색결과 항목에 mouseover 했을때
        // 해당 장소에 인포윈도우에 장소명을 표시합니다
        // mouseout 했을 때는 인포윈도우를 닫습니다
        (function(marker, title) {
            kakao.maps.event.addListener(marker, 'mouseover', function() {
                displayInfowindow(marker, title);
            });

            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });

            itemEl.onmouseover =  function () {
                displayInfowindow(marker, title);
            };

            itemEl.onmouseout =  function () {
                infowindow.close();
            };
        })(marker, places[i].place_name);

        fragment.appendChild(itemEl);
    }

    // 검색결과 항목들을 검색결과 목록 Element에 추가합니다
    listEl.appendChild(fragment);
    menuEl.scrollTop = 0;

    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
    map.setBounds(bounds);
}

// 검색결과 항목을 Element로 반환하는 함수입니다
function getListItem(index, places) {

    var el = document.createElement('li'),
    itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                '<div class="info">' +
                '   <h5>' + places.place_name + '</h5>';

    if (places.road_address_name) {
        itemStr += '    <span onclick="addPlace(\''+places.road_address_name+'\',\''+places.place_name+'\')">' + places.road_address_name + '</span>' +
                    '   <span onclick="addPlace(\''+places.address_name+'\',\''+places.place_name+'\')" class="jibun gray">' +  places.address_name  + '</span>';
    } else {
        itemStr += '    <span onclick="addPlace(\''+places.address_name+'\',\''+places.place_name+'\')">' +  places.address_name  + '</span>'; 
    }
                 
      itemStr += '  <span class="tel">' + places.phone  + '</span>' +
                '</div>';           

    el.innerHTML = itemStr;
    el.className = 'item';

    return el;
}

// 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
function addMarker(position, idx, title) {
    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
        imgOptions =  {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        },
        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });

    marker.setMap(map); // 지도 위에 마커를 표출합니다
    markers.push(marker);  // 배열에 생성된 마커를 추가합니다

    return marker;
}

// 지도 위에 표시되고 있는 마커를 모두 제거합니다
function removeMarker() {
    for ( var i = 0; i < markers.length; i++ ) {
        markers[i].setMap(null);
    }   
    markers = [];
}

// 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
function displayPagination(pagination) {
    var paginationEl = document.getElementById('pagination'),
        fragment = document.createDocumentFragment(),
        i; 

    // 기존에 추가된 페이지번호를 삭제합니다
    while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild (paginationEl.lastChild);
    }

    for (i=1; i<=pagination.last; i++) {
        var el = document.createElement('a');
        el.href = "#";
        el.innerHTML = i;

        if (i===pagination.current) {
            el.className = 'on';
        } else {
            el.onclick = (function(i) {
                return function() {
                    pagination.gotoPage(i);
                }
            })(i);
        }

        fragment.appendChild(el);
    }
    paginationEl.appendChild(fragment);
}

// 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
// 인포윈도우에 장소명을 표시합니다
function displayInfowindow(marker, title) {
    var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

    infowindow.setContent(content);
    infowindow.open(map, marker);
}

 // 검색결과 목록의 자식 Element를 제거하는 함수입니다
function removeAllChildNods(el) {   
    while (el.hasChildNodes()) {
        el.removeChild (el.lastChild);
    }
}
 
// 장소 클릭 시 주소 폼에 삽입
function addPlace(address, place) {   
    $("#place").val(place)
    $("#address").val(address)
}
</script>

<script>
// 주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();

var marker = new kakao.maps.Marker(), // 클릭한 위치를 표시할 마커입니다
    infowindow = new kakao.maps.InfoWindow({zindex:1}); // 클릭한 위치에 대한 주소를 표시할 인포윈도우입니다

// 현재 지도 중심좌표로 주소를 검색해서 지도 좌측 상단에 표시합니다
searchAddrFromCoords(map.getCenter(), displayCenterInfo);

// 지도를 클릭했을 때 클릭 위치 좌표에 대한 주소정보를 표시하도록 이벤트를 등록합니다
kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
    searchDetailAddrFromCoords(mouseEvent.latLng, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            var detailAddr = !!result[0].road_address ? '<div>도로명주소 : ' + result[0].road_address.address_name + '</div>' : '';
            detailAddr += '<div>지번 주소 : ' + result[0].address.address_name + '</div>';
            
            var content = '<div class="bAddr">' +
                            '<span class="title">주소 정보</span>' + 
                            detailAddr + 
                        '</div>';
		
            // 마커를 클릭한 위치에 표시합니다 
            marker.setPosition(mouseEvent.latLng);
            marker.setMap(map);

            // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
            infowindow.setContent(content);
            infowindow.open(map, marker);
            
            // 폼에 입력 함
            var address = !!result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name
    		$("#address").val(address);
        }   
    });
});

// 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
kakao.maps.event.addListener(map, 'idle', function() {
    searchAddrFromCoords(map.getCenter(), displayCenterInfo);
});

function searchAddrFromCoords(coords, callback) {
    // 좌표로 행정동 주소 정보를 요청합니다
    geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);         
}

function searchDetailAddrFromCoords(coords, callback) {
    // 좌표로 법정동 상세 주소 정보를 요청합니다
    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
}

// 지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
function displayCenterInfo(result, status) {
    if (status === kakao.maps.services.Status.OK) {
        var infoDiv = document.getElementById('centerAddr');

        for(var i = 0; i < result.length; i++) {
            // 행정동의 region_type 값은 'H' 이므로
            if (result[i].region_type === 'H') {
                infoDiv.innerHTML = result[i].address_name;
                break;
            }
        }
    }    
}
</script>

<script>
  $('#summernote').summernote({
    placeholder: '',
    tabsize: 2,
    height: 120,
    toolbar: [
      ['style', ['style']],
      ['font', ['bold', 'underline', 'clear']],
      ['color', ['color']],
      ['para', ['ul', 'ol', 'paragraph']],
      ['table', ['table']],
      ['insert', ['link', 'picture', 'video']],
      ['view', ['fullscreen', 'codeview', 'help']]
    ]
  });
  
  $('#summernote').summernote('code', '${ post.pcontent }');
</script>

<script>
var SeatInfoList = null;

Array.matrix = function (m, n, initial) {
    var a, i, j, mat = [];
    for (i = 0; i < m; i += 1) {
        a = [];
        for (j = 0; j < n; j += 1) {
            a[j] = initial;
        }
        mat[i] = a;
    }
    return mat;
};

function errorsSeatTable() {
	console.log('validation');
	var seatinfo = $("#seatinfo").val();
	var seatNum = 1;
	
	var y = seatinfo.split(" ").length;
	var row = seatinfo.split(" ");
	var x = row[0].split(",").length;
	SeatInfoList = Array.matrix(y, x, 1);
	$("#seatX").val(x)
	$("#seatY").val(y)
	
	for (var i = 0; i < y; i++) {
		var col = row[i].split(",");
		for (var j = 0; j < x; j++) {
			SeatInfoList[i][j] = col[j] == 1 ? 1 : 0;
		}
	}
}

createSeatTable();
function createSeatTable() {
	var seatNum = 1
	var x = $("#seatX").val()
	var y = $("#seatY").val()
	$('#seatinfo').val('${ post.seatinfo }');
	console.log($("#seatinfo").val());
	if ($('#seatinfo').val() != '') {
		errorsSeatTable();
		x = $("#seatX").val()
		y = $("#seatY").val()
	} else {
		SeatInfoList = Array.matrix(y, x, 1);
		addSeatInfoForm(x, y)
		console.log(SeatInfoList)		
	}
	
	
	var seatTable = ""
	if (!isNaN(x) && !isNaN(y)) {
		for (var i = 0; i < y; i++) {
			seatTable += '<tr>' 
			for (var j = 0; j < x; j++) {
				if (SeatInfoList[i][j] != 0) {
					seatTable += '<td class="seat" onclick="changeSeatState(this)" data-x="'+j+'" data-y="'+i+'">'+seatNum+'</td>';
					seatNum++;
				} else {
					seatTable += '<td class="seat-disable" onclick="changeSeatState(this)" data-x="'+j+'" data-y="'+i+'"></td>';
				}
			}
			seatTable += '</tr>'
		}
		$("#seatTable").html(seatTable)
	}
}

$("#seatX").on("blur", function() {
	checkMinMaxRange("#seatX")
	
});
$("#seatY").on("blur", function() {
	checkMinMaxRange("#seatY")
});

function checkMinMaxRange(TagNameById) {
	var tag = $(TagNameById)
	var min = Number(tag.attr('min'));
	var max = Number(tag.attr('max'));
	if (!isNaN(tag.val())) {
		if (Number(tag.val()) < min) {
			tag.val(min)
		} else if (Number(tag.val()) > max) {
			tag.val(max)
		}
	}
}

$("#submitBtn").on('click', function() {
	$("#postFrm").submit();
});

$("#seatTableBtn").on('click', function() {
	$("#seatinfo").val('');
	createSeatTable();
});

</script>
<script>
//현재 날짜와 시간을 가져옵니다.
$(function() {
	$("#sdate").attr('min', '${ post.startdate }');
	$("#edate").attr('min', '${ post.startdate }');
});

$("#sdate").on('change', function() {
	$("#edate").attr('min', $("#sdate").val());
	$("#edate").val($("#sdate").val());
});
</script>
</body>
</html>
