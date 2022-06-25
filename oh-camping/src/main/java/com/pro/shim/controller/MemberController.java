package com.pro.shim.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pro.shim.model.CampPageDTO;
import com.pro.shim.model.member.CampMemberDAO;
import com.pro.shim.model.member.CampMemberDTO;

@Controller
public class MemberController {

	@Autowired
	private CampMemberDAO dao;

	private final int rowsize = 10; // 한 페이지당 보여질 게시물 수
	private int totalRecord = 0; // DB 상의 전체 게시물의 수

	@RequestMapping("main.do")
	public String main() { // 관리자 홈
		return "SHIM/main";
	}

	@RequestMapping("member_list.do")
	public String list(@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "sortKey", required = false) String sortKey,
			@RequestParam(value = "num", defaultValue = "0") int num, Model model) { // 회원 목록 페이지

		// 전체 회원 수
		totalRecord = this.dao.getListCount();

		CampPageDTO dto = new CampPageDTO(page, rowsize, totalRecord);

		System.out.println("===========================");
		System.out.println("현재 페이지 : " + page + "\n총 개수 : " + totalRecord + "\n처음 : " + dto.getStartNo() + "\n끝 : "
				+ dto.getEndNo() + "\n정렬 : " + sortKey + "\n회원No. : " + num);

		List<CampMemberDTO> list;

		if (sortKey == null)
			sortKey = "null";

		if (sortKey.equals("null")) { // 정렬이 아닌 경우
			// 전체 회원 조회
			list = this.dao.getMemberList(dto);
		} else { // 정렬 했을 경우
			list = this.dao.getSortList(sortKey, dto);
		}

		if (num != 0) { // 상세 정보 조회
			CampMemberDTO detailList = this.dao.getMemberDetail(num);
			model.addAttribute("detailList", detailList);
		}

		model.addAttribute("List", list);
		model.addAttribute("Paging", dto);
		model.addAttribute("sortKey", sortKey);

		return "SHIM/member/memberList";
	}

	@RequestMapping("member_search.do")
	public String search(@RequestParam(value = "page", defaultValue = "1") int nowPage,
			@RequestParam("search") String search, @RequestParam("keyword") String keyword, Model model) {

		CampPageDTO dto;
		List<CampMemberDTO> list;

		// 검색 회원 수
		totalRecord = this.dao.searchListCount(search, keyword);

		dto = new CampPageDTO(nowPage, rowsize, totalRecord, search, keyword);

		// 검색 회원 목록
		list = this.dao.getSearchList(dto);

		if (list.size() == 0) { // 검색 후 페이지 이동 후 또 다시 검색을 할 때
								// 검색 페이지가 기존 페이지를 넘어가면 데이터가 있어도 없는 오류 방지 -> 페이지를 1로 다시 초기화 해서 검색
			nowPage = 1;
			dto = new CampPageDTO(nowPage, rowsize, totalRecord, search, keyword);
			list = this.dao.getSearchList(dto);
		}

		System.out
				.println("현재 페이지 : " + nowPage + "\n항목 : " + search + "\n내용 : " + keyword + "\n총 개수 : " + totalRecord);
		System.out.println("===========================");

		model.addAttribute("List", list);
		model.addAttribute("Paging", dto);
		model.addAttribute("search", search);
		model.addAttribute("keyword", keyword);

		return "SHIM/member/memberSearchList";
	}

	@RequestMapping(value = "member_delete.do", produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String delete(@RequestParam("num") int num, @RequestParam("page") int page,
						@RequestParam("sortKey") String sortKey) {

		int result = this.dao.memberDelete(num);
		System.out.println(sortKey);
		if(result > 0 ) { this.dao.updateSequence(num); }
		
		return "<script>alert('탈퇴 완료');"
				+ "location.href='member_list.do?page=" + page + "&sortKey=" + sortKey + "'"
				+ "</script>";
	}
}



