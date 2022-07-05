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

	// 해당 회원 문의 수
	public int getInquiryCount(String id);
	
	// 해당 회원 문의 내역
	public List<CampInquiryDTO> getInquiryList(Map<String, Object> map);

	// 해당 문의 상세 정보
	public CampInquiryDTO getInquiryCont(int no);

	// 해당 문의 삭제
	public void deleteInquiry(int no);

	// 해당 문의 삭제 후 시퀀스 갱신
	public void updateInquirySeq(int no);

	// 아이디 중복 체크를 위한 전체 ID 조회
	public List<CampMemberDTO> getMemberAllId(int no);

	// 회원 정보 수정
	public void modifyMember(Map<String, Object> map);
	
}
