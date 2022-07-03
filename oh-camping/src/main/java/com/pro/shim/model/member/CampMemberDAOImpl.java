package com.pro.shim.model.member;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.pro.shim.model.CampPageDTO;
import com.pro.shim.model.reserve.CampReserveDTO;

@Repository
public class CampMemberDAOImpl implements CampMemberDAO {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public int getListCount() {	// 전체 회원 수
		return this.sqlSession.selectOne("count");
	}
	
	@Override
	public List<CampMemberDTO> getMemberList(CampPageDTO dto) { // 회원 전체 조회
		return this.sqlSession.selectList("allList", dto);
	}

	@Override
	public List<CampMemberDTO> getSortList(String sortKey, CampPageDTO dto) { // 회원 정렬 조회
		return this.sqlSession.selectList("sort_" + sortKey, dto);
	}
	
	@Override
	public int searchListCount(String search, String keyword) { // 검색 회원 수
		// search : no, id, name, email
		return this.sqlSession.selectOne(search + "_cnt", keyword);
	}

	@Override
	public List<CampMemberDTO> getSearchList(CampPageDTO dto) { // 검색 회원 목록
		return this.sqlSession.selectList(dto.getSearch(), dto);
	}

	@Override
	public CampMemberDTO getMemberDetail(int num) { // 회원 상세 정보
		return this.sqlSession.selectOne("detail", num);
	}

	@Override
	public int memberDelete(int num) { // 회원 삭제
		return this.sqlSession.delete("delete", num);
	}

	@Override
	public void updateSequence(int num) { // 시퀀스 갱신
		this.sqlSession.update("seq", num);
	}

	@Override
	public List<CampReserveDTO> getReserveList(Map<String, Object> map) { // 해당 회원 예약 내역
		return this.sqlSession.selectList("reserveList", map);
	}

	@Override
	public int getReserveCount(String id) { // 해당 회원 예약 수
		return this.sqlSession.selectOne("reserveCnt", id);
	}

	@Override
	public CampReserveDTO getReserveCont(int room_no) { // 예약 상세 내역
		return this.sqlSession.selectOne("reserveCont", room_no);
	}

}
