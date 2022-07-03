package com.pro.shim.model.member;

import lombok.Data;

@Data
public class CampInquiryDTO {
	private int qa_no;			// 번호
	private String qa_writer;	// 작성자
	private String qa_userid;	// 회원 아이디
	private String qa_type;		// 종류(결제문의/객실문의/예약문의/기타문의)
	private String qa_title;	// 제목
	private String qa_cont;		// 내용
	private String qa_date;		// 등록날짜
	private int qa_hit;			// 조회수
	private int qa_group;		// 글 그룹(게시글 번호)
	private int qa_indent;		// 글 답변 들여쓰기
}
