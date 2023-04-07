package com.reserve.seat.user;

import java.security.SecureRandom;
import java.util.Base64;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.reserve.seat.mapper.UserMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService{
	
	private final UserMapper userMapper;
	private final BCryptPasswordEncoder bcryptPasswordEncoder;
	private final MailService mailService;
	
	@Override
	public void signup(User user) {
		userMapper.insertUser(user);		
	}

	@Override
	public boolean changeTmpPw(User user) {
      
		String tempPw = generateTempPassword();
      
		String encodedTmpPw = bcryptPasswordEncoder.encode(tempPw);
		user.setPassword(encodedTmpPw);
      
		boolean result = (userMapper.updatePassword(user) != 0) ? true : false;
		if (result) {
			mailService.sendMailForPw(user.getUsername(), tempPw);
		}
		return result;
	}
   
	// 랜덤한 임시 비밀번호 생성하는 메소드
	public static String generateTempPassword() {
		SecureRandom random = new SecureRandom();
		byte[] bytes = new byte[10];
		random.nextBytes(bytes);
		return Base64.getEncoder().encodeToString(bytes);
	}


}
