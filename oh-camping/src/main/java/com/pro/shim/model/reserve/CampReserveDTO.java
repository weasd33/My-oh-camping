package com.pro.shim.model.reserve;

import lombok.Data;

@Data
public class CampReserveDTO {
	private int room_no;				// 객실 번호
	private String room_name;			// 객실 이름
	private String room_resdate;		// 객실 날짜(사용일)
	private int room_possible;			// 사용 여부
	private int room_mpeople;			// 인원수
	private int room_price;				// 객실 가격
	private String payment_orderdate;	// 결제일
	private String payment_request;		// 요청 사항
	private String mem_name;			// 예약자명
	private String mem_id;				// 예약자 아이디
	private String mem_email;			// 예약자 이메일
	private String mem_phone;			// 예약자 전화번호
}
