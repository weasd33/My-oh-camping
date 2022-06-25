package com.pro.shim.model.sales;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CampSalesDAOImpl implements CampSalesDAO {

	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public List<CampSalesDTO> getSalesList(Map<String, String> map) { // 날짜별 매출 목록
		try {
			return this.sqlSession.selectList("sales_list", map);
		} catch (NullPointerException e) {
			return null;
		}
	}
	
	@Override
	public int getSalesTotal(Map<String, String> map) { // 날짜별 매출 총액
		try {
			return this.sqlSession.selectOne("sales_total", map);
		} catch (NullPointerException e) {
			return 0;
		}
	}

	@Override
	public List<CampSalesDTO> getTotalList(Map<String, String> map) { // 날짜별 매출 통계
		try {
			return this.sqlSession.selectList("sales_totalList", map);
		} catch (NullPointerException e) {
			return null;
		}
	}

}
