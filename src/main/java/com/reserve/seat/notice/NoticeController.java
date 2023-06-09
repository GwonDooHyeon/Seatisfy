// 작성자 : 권두현
// 작성일시 : 2023. 4. 5. 10:37
package com.reserve.seat.notice;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.reserve.seat.Criteria;
import com.reserve.seat.mapper.NoticeMapper;
import com.reserve.seat.reply.ReplyDTO;
import com.reserve.seat.user.User;
import com.reserve.seat.user.UserService;

@Controller
@RequestMapping("/notice")
public class NoticeController {

	@Autowired
	private NoticeService noticeService;
	
	@Autowired
	private UserService userService;

	//공지 등록 조회 폼
	@GetMapping("/add")
	public String requestAddNoticeForm(@ModelAttribute("notice") NoticeDTO notice, Principal principal, Model model) {
		
		User user = userService.getUserDetail(principal.getName());
		model.addAttribute("user", user);
		
		return "notice/noticeAdd";
	}

	//공지 등록
	@PostMapping("/add")
	public String submitAddNoticeForm(@Validated @ModelAttribute("notice") NoticeDTO notice, BindingResult br) {
		
		if(br.hasErrors()) {
			return "notice/noticeAdd";
		}
		
		//공지를 notice 테이블에 등록하고
		noticeService.insertNotice(notice);
		
		return "redirect:/notice";	 //공지 전체 목록으로 response.sendRedirect()처리
	}

	//공지 전체 목록
	@GetMapping
	public String NoticeList(Model model, Criteria cri) {
		
		
		return "notice/noticeAllList";
	}
	
	//공지 전체 목록
	@PostMapping("/list")
	@ResponseBody
	public List<NoticeDTO> NoticeListCount(Criteria cri) {

		return noticeService.selectAllNotice(cri);
		
	}
	
	//페이지 수
	@PostMapping("/total")
	@ResponseBody
	public int NoticeList(Criteria cri) {

		int totalcount = noticeService.totalCount(cri);
		
		return totalcount;
	}
	
	//공지 상세 보기
	@GetMapping("/detail")
	public String requestNoticeByNum(@RequestParam("nno") String nno, Model model) {
		
		//폼을 띄우기 전에 조회수 하나 증가
		noticeService.updateHit(nno);
		
		
		NoticeDTO noticeNum = noticeService.detailNotice(nno);
		model.addAttribute("notice", noticeNum);

		return "notice/noticeDetail";
	}
	
	//공지 수정 폼
	@GetMapping("/update")
	public String updateNoticeForm(@ModelAttribute("updateNotice") NoticeDTO notice, 
								   @RequestParam("nno") String nno, Model model) {
		
		NoticeDTO noticeNum = noticeService.detailNotice(nno);
		model.addAttribute("notice", noticeNum);
		
		return "notice/noticeUpdate";
	}
	
	//공지 수정
	@PostMapping("/update")
	public String updateNotice(@Validated @ModelAttribute("updateNotice") NoticeDTO notice,
			BindingResult br) {
		
		if(br.hasErrors()) {
			return "notice/update?nno=" + notice.getNno();
		}
		
		noticeService.updateNotice(notice);
		return "redirect:/notice";
	}
	
	//공지 삭제
	@PostMapping("/remove")
	@ResponseBody
	public void removeNotice(@RequestParam("nno") String nno) {
		
		noticeService.deleteNotice(nno);
		
	}
	
	
	
	
	
	
}
