package uchiring.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import uchiring.domain.UsersDTO;

@Mapper
public interface UserMapper {
	//1. id 중복 검사
	public int userEmailCheck(String email);
	
	//2. 회원가입
	public int userWrite(UsersDTO usersDTO);
	
	//3. 로그인
	public UsersDTO userLogin(UsersDTO usersDTO);
	
	//4. 이메일로 회원 정보 조회 (마이페이지용)
    public UsersDTO getUserByEmail(String email);
    
    //5. 회원 정보 수정
    public int updateUser(UsersDTO usersDTO);
    
    // 6. 회원 탈퇴 (비밀번호 검증 포함)
    public int deleteUser(@Param("email") String email, @Param("password") String password);
    
    

}
