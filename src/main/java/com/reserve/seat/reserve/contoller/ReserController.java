

package com.reserve.seat.reserve.contoller;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.reserve.seat.Criteria;
import com.reserve.seat.reserve.domain.PostDTO;
import com.reserve.seat.reserve.domain.ReserDTO;
import com.reserve.seat.reserve.service.ReserService;
import com.reserve.seat.user.User;
import com.reserve.seat.user.UserService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/reserve")
@RequiredArgsConstructor
public class ReserController {
	private final ReserService reserService;
	private final UserService userService;
	
	@GetMapping
	public String reserList(Model model, @ModelAttribute Criteria criteria) {
//		List<PostDTO> list = reserService.getListAll(criteria != null ? criteria : new Criteria());
//		model.addAttribute("list", list);
//		int totalCount = reserMapper.totalCount(criteria);
//		model.addAttribute("pageDTO", new PageDTO(criteria, totalCount));
		return "reserve/postList";
	}
	
	@GetMapping("/add")
	public String addView(@ModelAttribute PostDTO postDTO) {
		return "reserve/postForm";
	}
	
	@PostMapping("/add")
	public String addForm(@Validated @ModelAttribute PostDTO postDTO, BindingResult bindingResult, Principal principal) {
		
		if (bindingResult.hasErrors()) {
	        return "/reserve/postForm";
	    }
		
		if (postDTO.getStartdate() != null && postDTO.getEnddate() != null) {
			LocalDateTime startDate = LocalDateTime.parse(postDTO.getStartdate());
			LocalDateTime endDate = LocalDateTime.parse(postDTO.getEnddate());
			
			if (!endDate.isAfter(startDate)) {
            	bindingResult.rejectValue("enddate", "startDate.after.endDate", "시작일보다 종료일이 먼저일 수 없습니다");
            	return "/reserve/postForm";
			}
        }
		
		User user = userService.getUserDetail(principal.getName());
		if (user == null) {
			return "redirect:/user/login";
		}
		postDTO.setPwriter(principal.getName());
		reserService.addPost(postDTO);
		reserService.addSeat(postDTO.getSeatinfo(), postDTO.getPno());
		return "redirect:/reserve";
	}
	
	@GetMapping("/detail/{pno}")
	public String detailView(@ModelAttribute ReserDTO reserDTO, Model model, @PathVariable int pno, Principal principal) {
		PostDTO postDTO = reserService.getPost(pno);
		postDTO.setPwriter(userService.getUserDetail(principal.getName()).getName());
		model.addAttribute("post", postDTO);
		model.addAttribute("seats", reserService.getSeatsByPost(pno));
		model.addAttribute("seatinfo", reserService.getPost(pno).getSeatinfo());
		model.addAttribute("reser", reserService.getReserById(principal.getName()));
		return "reserve/postDetail";
	}
	
	/**
	 *  예약 실행 
	 *  */
	@PostMapping("/detail/{pno}")
	public String reserve(@Validated @ModelAttribute ReserDTO reserDTO, 
			@PathVariable int pno, 
			RedirectAttributes redirectAttributes,
			Principal principal) {
		
		PostDTO post = reserService.getPost(pno);
		LocalDateTime nowTime = LocalDateTime.now();
		LocalDateTime startDate = LocalDateTime.parse(post.getStartdate());
		LocalDateTime endDate = LocalDateTime.parse(post.getEnddate());
		if (nowTime.isAfter(startDate) && nowTime.isBefore(endDate)) {
			ReserDTO rdto = reserService.getReserByIdAndPno(principal.getName(), pno);
			User user = userService.getUserDetail(principal.getName());
			if (user == null) {
				return "redirect:/user/login";
			}
			if (rdto == null && post.getPwriter().equals(user.getName())) {
				reserService.reserveSeat(reserDTO, null);								
			} else {
				
			}
		}
		redirectAttributes.addAttribute(reserService.getSeatsByPost(pno));
		redirectAttributes.addAttribute("seatinfo", reserService.getPost(pno).getSeatinfo());
		return "redirect: /reserve/detail/{pno}";
	}
	
	
	@GetMapping("/myreser")
	public String myReserList() {
		return "reserve/myReserList";
	}
	
	@GetMapping("/mypost")
	public String myPostList() {
		return "reserve/myPostList";
	}
}