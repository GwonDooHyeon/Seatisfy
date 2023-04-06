// 작성자 : 권두현
// 작성일시 : 2023. 4. 5. 11:26
package com.reserve.seat.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.reserve.seat.mapper.NoticeMapper;

@Service
public class NoticeService {

	@Autowired
	private NoticeMapper noticeMapper;
	
	//공지 등록
	public void insertNotice(NoticeDTO notice) {
		noticeMapper.insertNotice(notice);
	}

	//공지 목록
	public List<NoticeDTO> AllNoticeList() {
		return noticeMapper.AllNoticeList();
	}

	//공지 상세보기
	public NoticeDTO detailNotice(String nno) {
		return noticeMapper.detailNotice(nno);
	}
	
	//공지 수정
	public void updateNotice(NoticeDTO notice) {
		noticeMapper.updateNotice(notice);
	}

	//공지 삭제
	public void deleteNotice(String nno) {
		noticeMapper.deleteNotice(nno);
	}
	
	//공지 페이징 목록
	public List<NoticeDTO> selectAllNotice(Criteria cri){
		return noticeMapper.selectAllNotice(cri);
	}
	
	//공지 전체 갯수
	public int totalCount(Criteria cri) {
		return noticeMapper.totalCount(cri);
	}
	
}
