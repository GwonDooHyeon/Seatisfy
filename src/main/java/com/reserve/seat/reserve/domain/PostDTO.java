/**
 * 작성자 : 유범석
 * 작성일 : 2023-04-05
 */

package com.reserve.seat.reserve.domain;

import javax.validation.constraints.NotBlank;

import com.reserve.seat.reserve.validator.DateTimeLocal;
import com.reserve.seat.reserve.validator.SeatInfo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PostDTO {
	private Integer pno;
	
	private String email;
	
	private String pwriter;
	
	@NotBlank(message = "제목을 비워둘 순 없습니다")
	private String ptitle;
	@NotBlank(message = "내용을 비워둘 순 없습니다")
	private String pcontent;
	@NotBlank(message = "장소를 비워둘 순 없습니다")
	private String place;
	@NotBlank(message = "주소를 비워둘 순 없습니다")
	private String address;
	
	@SeatInfo
	private String seatinfo;
	
	@DateTimeLocal
	private String startdate;
	
	@DateTimeLocal
	private String enddate;
	
	private String regdate;
	private String moddate;
}
