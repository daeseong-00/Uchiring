package uchiring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import uchiring.domain.UsersDTO;
import uchiring.mapper.UserMapper;
import uchiring.util.UserSHA256;

@Service
public class UserService {

	//UserMapper 주입
	@Autowired
	private UserMapper userMapper;

	//1. id 중복 검사
	public int userEmailCheck(String email) {
		return userMapper.userEmailCheck(email);
	}

	//2. 회원가입
	public int userWrite(UsersDTO usersDTO) {
		//비번 암호화
		usersDTO.setPassword(UserSHA256.getSHA256(usersDTO.getPassword()));
		
		return userMapper.userWrite(usersDTO);
	}

	//3. 회원 로그인
	public UsersDTO userLogin(UsersDTO usersDTO) {
		//비번 암호화
		usersDTO.setPassword(UserSHA256.getSHA256(usersDTO.getPassword()));
		
		return userMapper.userLogin(usersDTO);
	}
	//4. 회원 수정
	public UsersDTO getUserByEmail(String email) {
	    return userMapper.getUserByEmail(email);
	}

	public int updateUser(UsersDTO usersDTO) {
	    // 비밀번호를 수정하는 경우에만 암호화 처리 (비워져 들어올 경우 처리 등 필요에 따라 분기)
	    if(usersDTO.getPassword() != null && !usersDTO.getPassword().trim().equals("")) {
	        usersDTO.setPassword(UserSHA256.getSHA256(usersDTO.getPassword()));
	    }
	    return userMapper.updateUser(usersDTO);
	}
	
	//5. 회원 탈퇴 처리
	public int deleteUser(String email, String password) {
	    // 입력받은 비밀번호를 암호화하여 DB의 암호화된 비밀번호와 대조
	    String encryptedPassword = UserSHA256.getSHA256(password);
	    return userMapper.deleteUser(email, encryptedPassword);
	}

	

	
}