package com.reserve.seat.reserve.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.javassist.compiler.ast.NewExpr;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reserve.seat.Criteria;
import com.reserve.seat.mapper.NoticeMapper;
import com.reserve.seat.mapper.PostMapper;
import com.reserve.seat.mapper.ReserMapper;
import com.reserve.seat.mapper.SeatMapper;
import com.reserve.seat.mapper.ReplyMapper;
import com.reserve.seat.reply.ReplyDTO;
import com.reserve.seat.reserve.domain.PostDTO;
import com.reserve.seat.reserve.domain.ReserDTO;
import com.reserve.seat.reserve.domain.SeatDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class ReserServiceImpl implements ReserService {
	private final PostMapper postMapper;
	private final ReserMapper reserMapper;
	private final SeatMapper seatMapper;
	private final ReplyMapper replyMapper;


	/**
	 * ReserService -----------------------------------
	 */
	@Override
	public List<ReserDTO> getMyReserList(int amount, int offset, String username) {
		return reserMapper.selectAllReserById(amount, offset, username);
	}

	@Override
	public ReserDTO getReser(int rno) {
		return reserMapper.selectReser(rno);
	}

	@Override
	public List<ReserDTO> getReserById(String username) {
		return reserMapper.selectReserById(username);
	}
	
	@Override
	public ReserDTO getReserByIdAndPno(String username, int pno) {
		return reserMapper.selectReserByIdAndPno(username, pno);
	}

	@Override
	public void addReser(ReserDTO rdto) {
		reserMapper.insertReser(rdto);
	}

	@Override
	public int getReserTotalCount(String username) {
		return reserMapper.totalCount(username);
	}
	
	
	
	/**
	 * PostService -----------------------------------
	 */
	@Override
	public List<PostDTO> getPostList(Criteria criteria) {
		return postMapper.selectAllPost(criteria);
	}
	
	@Override
	public List<PostDTO> getPostListById(int amount, int offset, String[] typeArr, String keyword, String pwriter) {
		return postMapper.selectAllPostById(amount, offset, typeArr, keyword, pwriter);
	}

	@Override
	public PostDTO getPost(int pno) {
		return postMapper.selectPost(pno);
	}

	@Override
	public void addPost(PostDTO pdto) {
		postMapper.insertPost(pdto);
	}

	@Override
	public boolean editPost(PostDTO pdto) {
		return postMapper.updatePost(pdto);
	}

	@Override
	public int removePost(int pno) {
		return postMapper.deletePost(pno);
	}

	@Override
	public int getPostTotalCount(Criteria criteria) {
		return postMapper.totalCount(criteria);
	}
	
	@Override
	public int getPostTotalCountById(int amount, int offset, String[] typeArr, String keyword, String pwriter) {
		return postMapper.totalCountById(amount, offset, typeArr, keyword, pwriter);
	}
	
	
	/**
	 * SeatService -------------------------------------
	 */
	@Override
	public List<SeatDTO> getSeatList(Criteria criteria) {
		return null;
	}

	@Override
	public SeatDTO getSeat(int sno) {
		return seatMapper.selectSeat(sno);
	}
	
	@Override
	public List<Integer> getSeatsByPost(int pno) {
		return seatMapper.selectSeatsByPost(pno);
	}

	@Override
	public void addSeat(String seatinfo, int pno) {
		int seatNum = 1;
		for (String row : seatinfo.split(" ")) {
			for (String col : row.split(",")) {
				if (col.equals("1")) {
					SeatDTO sdto = new SeatDTO(null, seatNum++, pno, false);
					seatMapper.insertSeat(sdto);					
				}
			}
		}
		
	}
	
	@Override
	public int deleteSeatByPost(int seatnum, int pno) {
		return seatMapper.deleteSeatByPost(seatnum, pno);
	}

	@Override
	public int getSeatTotalCount(Criteria criteria) {
		return seatMapper.totalCount(criteria);
	}
	
	
	/**
	 * CombinationService -------------------------------------
	 */
	@Transactional
	@Override
	public boolean reserveSeat(ReserDTO rdto) {
		SeatDTO updateSeatDTO = seatMapper.selectSeatLock(
				new SeatDTO(null, rdto.getSeatnum(), rdto.getPno(), null));
		if (!updateSeatDTO.getIsreserved()) {
			if (reserMapper.insertReser(rdto) == 1) {
				return seatMapper.updateSeat(rdto.getSeatnum(), rdto.getPno(), true) == 1 ? true : false;			
			}
		} else {
			seatMapper.updateSeat(
					updateSeatDTO.getSeatnum(), 
					updateSeatDTO.getPno(), 
					updateSeatDTO.getIsreserved());
		}
		return false;
	}
	
	@Transactional
	@Override
	public boolean cancelReser(int seatnum, String username, int pno) {
		seatMapper.selectSeatLock(new SeatDTO(null, seatnum, pno, null));
		if (reserMapper.deleteReser(username, pno) == 1) {
			return seatMapper.updateSeat(seatnum, pno, false) == 1 ? true : false;			
		}
		return false;
	}
	
		//댓글 등록
		public void insertReply(ReplyDTO replyDTO) {
			replyMapper.insertReply(replyDTO);
		}
		
		//댓글 수정
		public void updateReply(ReplyDTO replyDTO) {
			replyMapper.updateReply(replyDTO);
		}
		
		//댓글 삭제
		public void deleteReply(int rno) {
			replyMapper.deleteReply(rno);;
		}

		//특정 댓글 하나 조회
		public ReplyDTO selectReply(String rno) {
			return replyMapper.selectReply(rno);
		}
		
		//전체 댓글 조회
		public List<ReplyDTO> AllReplyList(int amount, int offset, int pno){
			System.out.println(amount +" / "+ offset +" / "+ pno);
			return replyMapper.AllReplyList(amount, offset, pno);
		}

		@Override
		public int getReplyTotalCount(int pno) {
			return replyMapper.totalCount(pno);
		}
	
}
