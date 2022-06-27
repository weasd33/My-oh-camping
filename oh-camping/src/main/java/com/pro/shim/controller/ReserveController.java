package com.pro.shim.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pro.shim.model.reserve.CampReserveDAO;
import com.pro.shim.model.reserve.CampReserveDTO;

@Controller
@RequestMapping("reserve/*")
public class ReserveController {

	@Autowired
	private CampReserveDAO dao;
	
	@RequestMapping("main.do")
	public String main() {
		return "SHIM/reserve/reserveList";
	};
	
	@RequestMapping("list.do")
	@ResponseBody
	public List<CampReserveDTO> list() { // 객실 전체 조회
		List<CampReserveDTO> list = this.dao.getReserveList();
		
		return list;
	};
	
	@RequestMapping("cont.do")
	@ResponseBody
	public CampReserveDTO cont(@RequestParam("room_no") int no) { // 객실,예약 상세 정보
		CampReserveDTO cont = this.dao.getReserveCont(no);

		return cont;
	};
}
