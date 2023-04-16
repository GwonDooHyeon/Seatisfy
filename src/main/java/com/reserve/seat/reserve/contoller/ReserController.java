

package com.reserve.seat.reserve.contoller;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
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
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.reserve.seat.Criteria;
import com.reserve.seat.reply.ReplyDTO;
import com.reserve.seat.reserve.domain.PostDTO;
import com.reserve.seat.reserve.domain.ReserDTO;
import com.reserve.seat.reserve.service.ReserService;
import com.reserve.seat.user.User;
import com.reserve.seat.user.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/reserve")
@RequiredArgsConstructor
public class ReserController {
	private final ReserService reserService;
	private final UserService userService;
	
	@GetMapping
	public String reserList(@ModelAttribute Criteria criteria, Model model) {
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
			return "redirect:/login";
		}
		postDTO.setPwriter(principal.getName());
		reserService.addPost(postDTO);
		reserService.addSeat(postDTO.getSeatinfo(), postDTO.getPno());
		return "redirect:/reserve";
	}
	
	@GetMapping("/edit/{pno}")
	public String editView(@ModelAttribute PostDTO postDTO,
			@PathVariable int pno, 
			Model model,
			Principal principal) {
		
		postDTO = reserService.getPost(pno);
		model.addAttribute("post", postDTO);
		if (!principal.getName().equals(postDTO.getPwriter())) { // 작성자 확인 처리
			return "redirect: /reserve";
		}
		return "reserve/postEditForm";
	}
	
	@PostMapping("/edit/{pno}")
	public String editForm(@Validated @ModelAttribute PostDTO postDTO, 
			@PathVariable int pno,
			BindingResult bindingResult, 
			Principal principal) {
		
		PostDTO pdto = reserService.getPost(pno);
		if (!principal.getName().equals(pdto.getPwriter())) { // 작성자 확인 처리
			return "redirect: /reserve";
		}
		User user = userService.getUserDetail(principal.getName());
		if (user == null) {
			return "redirect: /login";
		}
		
		if (bindingResult.hasErrors()) {
	        return "/reserve/postEditForm";
	    }
		
		if (postDTO.getStartdate() != null && postDTO.getEnddate() != null) {
			LocalDateTime startDate = LocalDateTime.parse(postDTO.getStartdate());
			LocalDateTime endDate = LocalDateTime.parse(postDTO.getEnddate());
			
			if (!endDate.isAfter(startDate)) {
            	bindingResult.rejectValue("enddate", "startDate.after.endDate", "시작일보다 종료일이 먼저일 수 없습니다");
            	return "/reserve/postEditForm";
			}
        }
		
		postDTO.setPwriter(principal.getName());
		reserService.editPost(postDTO);
		return "redirect: /reserve/detail/{pno}";
	}
	
	@ResponseBody
	@PostMapping("/remove")
	public String removePost(
			@RequestParam int pno, 
			RedirectAttributes redirectAttributes,
			Principal principal) {
		String result = "";
		PostDTO pdto = reserService.getPost(pno);
		if (!principal.getName().equals(pdto.getPwriter())) { // 작성자 확인 처리
			return "/reserve?result=rmfail";
		}
		User user = userService.getUserDetail(principal.getName());
		if (user == null) {
			return "/login";
		}
		
		if (reserService.removePost(pno) == 1) {
			result = "rmsuccess";
		} else {
			result = "rmfail";
		}
		return "/reserve?result=" + result;
	}
	
	@GetMapping("/detail/{pno}")
	public String detailView(@ModelAttribute ReserDTO reserDTO, 
			Model model, 
			@PathVariable int pno, 
			Principal principal
			) {
		
		PostDTO postDTO = reserService.getPost(pno);
		String name = userService.getUserDetail(postDTO.getPwriter()).getName();
		if (name != null) {
			model.addAttribute("name", name);
		}
		model.addAttribute("post", postDTO);
		model.addAttribute("seats", reserService.getSeatsByPost(pno));
		model.addAttribute("seatinfo", reserService.getPost(pno).getSeatinfo());
		model.addAttribute("myreser", reserService.getReserByIdAndPno(principal.getName(), pno));
		model.addAttribute("username", principal.getName());
		
		//댓글 조회
//		List<ReplyDTO> replyList = reserService.AllReplyList(String.valueOf(pno)); 
//		int cnt = replyList.size();	// 댓글 수
//		model.addAttribute("replyList", replyList);
//		model.addAttribute("cnt", cnt);
		
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
		if (reserDTO.getSeatnum() == null) {
			redirectAttributes.addAttribute("result", "nosn");
			return "redirect: /reserve/detail/{pno}";
		}
		
		PostDTO post = reserService.getPost(pno);
		LocalDateTime nowTime = LocalDateTime.now();
		LocalDateTime startDate = LocalDateTime.parse(post.getStartdate());
		LocalDateTime endDate = LocalDateTime.parse(post.getEnddate());
		if (nowTime.isAfter(startDate) && nowTime.isBefore(endDate)) {
			ReserDTO rdto = reserService.getReserByIdAndPno(principal.getName(), pno);
			User user = userService.getUserDetail(principal.getName());
			if (user == null) {
				return "redirect:/login";
			}
			if (rdto != null) {
				redirectAttributes.addAttribute("result", "dupli");
			} 
//			else if (post.getPwriter().equals(principal.getName())) {
//				redirectAttributes.addAttribute("result", "fail");
//			} 
			else {
				reserDTO.setEmail(principal.getName());
				boolean result = reserService.reserveSeat(reserDTO);			// 예약 실행
				String msg = result ? "success" : "reserved";
				redirectAttributes.addAttribute("result", msg);
			}
		}
		redirectAttributes.addAttribute(reserService.getSeatsByPost(pno));
		redirectAttributes.addAttribute("seatinfo", reserService.getPost(pno).getSeatinfo());
		return "redirect: /reserve/detail/{pno}";
	}
	
	/**
	 *  예약 취소
	 *  */
	@PostMapping("/detail/{pno}/cancel")
	public String reserveCancel(@Validated @ModelAttribute ReserDTO reserDTO, 
			@PathVariable int pno, 
			RedirectAttributes redirectAttributes,
			Principal principal) {
		
		PostDTO post = reserService.getPost(pno);
		LocalDateTime nowTime = LocalDateTime.now();
		LocalDateTime startDate = LocalDateTime.parse(post.getStartdate());
		LocalDateTime endDate = LocalDateTime.parse(post.getEnddate());
		if (nowTime.isAfter(startDate) && nowTime.isBefore(endDate)) {
			int seatnum = reserService.getReserByIdAndPno(principal.getName(), pno).getSeatnum();
			boolean cancelResult = reserService.cancelReser(seatnum, principal.getName(), pno);
			if (cancelResult) {
				redirectAttributes.addAttribute("result", "ccsuccess");
			} else {
				redirectAttributes.addAttribute("result", "ccfail");
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
	
	@GetMapping("/test")
	public String test() {
		return "reserve/test";
	}
	
	//댓글 등록
	@PostMapping("/addReply")
	@ResponseBody
  	public String addReply(@Validated @ModelAttribute ReplyDTO replyDTO, BindingResult bindingResult) {
		if (bindingResult.hasErrors()) {
	        return "fail";
	    }
		
		System.out.println(replyDTO.getPno());
		System.out.println(replyDTO.getRcontent());
		System.out.println(replyDTO.getRwriter());
  		reserService.insertReply(replyDTO);
  		
  		return "ok";
  	}
	
	//댓글 수정
	@PostMapping("/updateReply")
	@ResponseBody
	public String updateReply(@ModelAttribute ReplyDTO replyDTO) {
		String content = replyDTO.getRcontent();
		if (content == null || content == "") {
	        return "fail";
	    }
		reserService.updateReply(replyDTO);
		return "ok";
	}
	
	//댓글 삭제
  	@PostMapping("/removeReply")
  	@ResponseStatus(code = HttpStatus.OK)
  	public void removeReply(int rno) {
  		
  		reserService.deleteReply(rno);
  	}
}
