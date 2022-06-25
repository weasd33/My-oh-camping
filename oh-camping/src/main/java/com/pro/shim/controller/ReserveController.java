package com.pro.shim.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("reserve/*")
public class ReserveController {

	@RequestMapping("list.do")
	public String list() {
		return "SHIM/reserve/reserveList";
	};
}
