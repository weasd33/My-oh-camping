package com.pro.shim.model.reserve;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CampReserveDAOImpl implements CampReserveDAO {
	
	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public List<CampReserveDTO> getReserveList() { // 객실 전체 조회
		return this.sqlSession.selectList("reserve_list");
	}

	@Override
	public CampReserveDTO getReserveCont(int no) { // 예약 상세 정보
		return this.sqlSession.selectOne("reserve_cont", no);
	}
	
	@Override
	public List<CampReserveDTO> getReserveSort(Map<String, String> map) { // 예약 정렬 정보
		return this.sqlSession.selectList("reserve_sort", map);
	}
	
}
