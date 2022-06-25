package com.pro.shim.model.sales;

import java.util.List;
import java.util.Map;

public interface CampSalesDAO {

	// 매출 목록
	public List<CampSalesDTO> getSalesList(Map<String, String> map);

	// 매출 총액
	public int getSalesTotal(Map<String, String> map);
	
	// 매출 통계
	public List<CampSalesDTO> getTotalList(Map<String, String> map);
	
}
