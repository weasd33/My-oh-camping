package com.pro.shim.model.member;

import java.util.List;

import com.pro.shim.model.CampPageDTO;

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
	
}