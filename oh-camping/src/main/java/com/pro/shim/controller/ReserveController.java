package com.pro.shim.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	
	@RequestMapping("sort.do")
	@ResponseBody
	public List<CampReserveDTO> sort(@RequestParam("room_status") String room_status,
							@RequestParam("divide_room") String divide_room,
							@RequestParam("start_date") String start_date,
							@RequestParam("end_date") String end_date) { // 객실,예약 정렬 정보
		
		String format_SD = ""; // 시작 날짜 포맷 변수
		String format_ED = ""; // 끝 날짜 포맷 변수
		
		try {
			SimpleDateFormat dtformat = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat newDtFormat = new SimpleDateFormat("yy/MM/dd");
			
			// String -> Date 변환
			Date startDate = dtformat.parse(start_date);
			Date endDate = dtformat.parse(end_date);
			
			if(endDate.before(startDate)) { // start_date가 end_date 보다 클 경우 치환
				Date temp;
				temp = startDate;
				startDate = endDate;
				endDate = temp;
			}
			
			// yyyy-MM-dd -> yy/MM/dd
			format_SD = newDtFormat.format(startDate);
			format_ED = newDtFormat.format(endDate);
			
		} catch (ParseException e) { e.printStackTrace(); }
		
		Map<String, String> map = new HashMap<String, String>();
		map.put("room_status", room_status);
		map.put("divide_room", divide_room);
		map.put("start_date", format_SD);
		map.put("end_date", format_ED);
		
		// 예약 정보 정렬 리스트
		List<CampReserveDTO> list = this.dao.getReserveSort(map);
		
		return list;
	};
}
