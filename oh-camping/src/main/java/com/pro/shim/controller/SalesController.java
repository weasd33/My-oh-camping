package com.pro.shim.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pro.shim.model.sales.CampSalesDAO;

@Controller
@RequestMapping("sales/*")
public class SalesController {
	
	@Autowired
	private CampSalesDAO dao;
	
	@RequestMapping("main.do")
	public String main() {
		return "SHIM/sales/salesTotal";
	};
	
	@RequestMapping("list.do")  // 분류 매출 관련
	@ResponseBody
	public Map<String, Object> sortTotal(@RequestParam(value = "radio_date", required = false, defaultValue = "all_date") String date,
						@RequestParam(value = "divide_room", required = false, defaultValue = "all_room") String room, 
						@RequestParam(value = "start_date", required = false) String start_date, 
						@RequestParam(value = "end_date", required = false) String end_date, Model model) {
		
		Map<String, String> map = new HashMap<String, String>();
		
		String format_SD = ""; // 시작 날짜 포맷 변수
		String format_ED = ""; // 끝 날짜 포맷 변수
		
		if (start_date != null && start_date != "" && end_date != null && end_date != "") { // 기간별 매출 조회
			try {
				System.out.println("객 실 : " + room + "\n기 간 : " + start_date + " ~ " + end_date);
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
			
		} else { // 날짜별 매출 조회
			System.out.println("객 실 : " + room + "\n날 짜 : " + date);
		}
		
		map.put("date", date); // 날짜
		map.put("start_date", format_SD); // 시작 날짜
		map.put("end_date", format_ED); // 끝 날짜
		map.put("room", room); // 객실 이름
		
		Map<String, Object> data = new HashMap<String, Object>();
		
		data.put("allList", this.dao.getSalesList(map)); // 날짜별 매출 목록
		data.put("total", this.dao.getSalesTotal(map)); // 날짜별 매출 총액
		data.put("totalList", this.dao.getTotalList(map)); // 날짜별 매출 통계
		data.put("date", date); // 날짜
		data.put("room", room); // 객실
		data.put("sDate", start_date); // 시작 날짜
		data.put("eDate", end_date); // 끝 날짜
		
		return data;
	}
}
