package com.pro.shim.model.reserve;

import java.util.List;

public interface CampReserveDAO {

	// 객실 전체 조회
	public List<CampReserveDTO> getReserveList();
	
	// 예약 상세 정보
	public CampReserveDTO getReserveCont(int no);
}
