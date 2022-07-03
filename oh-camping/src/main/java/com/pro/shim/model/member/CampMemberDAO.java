package com.pro.shim.model.member;

import java.util.List;
import java.util.Map;

import com.pro.shim.model.CampPageDTO;
import com.pro.shim.model.reserve.CampReserveDTO;

public interface CampMemberDAO {
	
	// 전체 회원 수
	public int getListCount();
	
	// 전체 회원 목록
	public List<CampMemberDTO> getMemberList(CampPageDTO dto);

	// 전체 회원 정렬
	public List<CampMemberDTO> getSortList(String sortKey, CampPageDTO dto);

	// 검색 회원 수
	public int searchListCount(String search, String keyword);

	// 검색 회원 목록
	public List<CampMemberDTO> getSearchList(CampPageDTO dto);

	// 회원 상세 정보
	public CampMemberDTO getMemberDetail(int num);

	// 회원 삭제
	public int memberDelete(int num);

	// 시퀀스 갱신
	public void updateSequence(int num);

	// 해당 회원 예약 내역
	public List<CampReserveDTO> getReserveList(Map<String, Object> map);

	// 해당 회원 예약 수
	public int getReserveCount(String id);

	// 예약 상세 내역
	public CampReserveDTO getReserveCont(int room_no);
	
}
