package com.pro.shim.model.member;

import lombok.Data;

@Data
public class CampMemberDTO {
	private int member_no; 			// 번호
	private String mem_id; 			// 아이디
	private String mem_pwd; 		// 비밀번호
	private String mem_name; 		// 이름
	private String mem_phone; 		// 전화번호
	private String mem_email; 		// 이메일

}
