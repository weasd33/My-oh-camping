package com.pro.shim.model.sales;

import lombok.Data;

@Data
public class CampSalesDTO {
	
	private String room_resdate;	// 객실 날짜(대분류)
	private String room_name;		// 객실 이름
	private int room_price;			// 결제 가격
	private int room_possible;		// 객실 예약 가능 여부(0: 가능, 1: 불가능)
	private int total_cnt;			// 총 예약 횟수
	private int total_price;		// 매출 총액
	private double price_rate;		// 매출 비율
}
