package uchiring.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import uchiring.domain.AgentScheduleDTO;
import uchiring.domain.PropertiesDTO;
import uchiring.domain.ReservationsDTO;
import uchiring.domain.UsersDTO;
import uchiring.service.AgentScheduleService;
import uchiring.service.EmailService;
import uchiring.service.PropertyService;
import uchiring.service.ReservationService;
import uchiring.service.UserService;

@Controller
@RequestMapping("User")
public class UserController {
	//로그 출력용
	private static final Logger log =
			LoggerFactory.getLogger(UserController.class);

	//UserService 주입
	@Autowired
	private UserService userService;
	
	//EmailService 주입
	@Autowired
	private EmailService emailService;
	
	@Autowired
    private AgentScheduleService scheduleService;
	
	 @Autowired
	private PropertyService propertyService;
	
	 @Autowired
	 private ReservationService reservationService; 
	 
	//로그인 폼
	@GetMapping("user_login")
	public String userLogin(HttpSession session) {
		log.info("User Call : user_login");
		if(session.getAttribute("user") == null) {
			return "User/user_login";//로그인 페이지로 이동
		}else {
			//로그인한 사용자 일경우
			return "redirect:/";
		}
	}
	
	//로그인처리
	@PostMapping("user_login")
	public String userLoginPro(UsersDTO usersDTO, HttpServletRequest request) {
		log.info("User Call : user_login_ok");
		
		UsersDTO uDTO = userService.userLogin(usersDTO);
	
			request.getSession().setAttribute("user", uDTO);
			request.getSession().setMaxInactiveInterval(30*60);//30분
		
		return "redirect:/";
	}
	//로그아웃 처리
	@GetMapping("user_logout")
	public String userLogout(HttpSession session) {
		log.info("User Call : logout");
		session.invalidate();
		
		return "redirect:/";//index로 이동
	}
		
	//회원가입 폼
	@GetMapping("user_insert")
	public String userInsert() {
		log.info("User Call : userInsert");
		
		return "User/user_insert";
	}
	
	//ID 중복검사
	@ResponseBody
	@PostMapping("user_emailCheck")
	public String userEmailCheck(@RequestParam("email") String email) {
		log.info("User Call : EmailCheck");
		int row = userService.userEmailCheck(email);
		return String.valueOf(row);
	}
	
	//본인인증(email)
	@ResponseBody
	@PostMapping("user_email")
	public String emailSend(@RequestParam("email") String email) {
		String tempNum = emailService.sendEmail(email);
		
		log.info("인증번호 : " + tempNum);
		return tempNum;
	}
	
	//회원가입처리
		@PostMapping("user_insert")
		public String userInsertPro(UsersDTO usersDTO, RedirectAttributes rttr) {
			log.info("User Call : user_insert_pro");
			
			int row = userService.userWrite(usersDTO);
			
			if(row > 0) {
				// 성공 시 메시지 설정
				rttr.addFlashAttribute("msg", "会員登録が完了しました。ログインしてください。");
				return "redirect:/User/user_login"; // 로그인 페이지로 이동
			} else {
				// 실패 시 메시지 설정
				rttr.addFlashAttribute("msg", "会員登録に失敗しました。もう一度お試しください。");
				return "redirect:/User/user_insert"; // 회원가입 페이지로 복귀
			}
		}
	
		// 마이페이지 메인 (예약현황 및 메뉴 제공 화면)
		@GetMapping("user_mypage")
	    public String userMyPage(HttpSession session, Model model) {
	        log.info("User Call : userMyPage");
	        
	        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
	        if(loginUser == null) {
	            return "redirect:/User/user_login";
	        }
	        
	        UsersDTO user = userService.getUserByEmail(loginUser.getEmail());
	        model.addAttribute("user", user);
	        
	        // 👇 2. 에이전트인 경우 자신이 등록한 매물 목록과 스케줄 목록을 조회해서 모델에 담기
	        if ("AGENT".equals(user.getRole()) || "agent".equals(user.getRole())) {
	            // 1. 에이전트 일정 목록 조회
	            List<AgentScheduleDTO> scheduleList = scheduleService.getSchedulesByAgent(user.getUser_id());
	            model.addAttribute("scheduleList", scheduleList);
	            
	            // 2. 에이전트가 등록한 매물 목록 조회
	            List<PropertiesDTO> myProperties = propertyService.getPropertiesByAgentId(user.getUser_id());
	            model.addAttribute("myProperties", myProperties);
	            
	            // 👇 에이전트 매물에 들어온 방문 예약 목록 조회
	            List<ReservationsDTO> agentReservations = reservationService.getReservationsByAgent(user.getUser_id());
	            model.addAttribute("agentReservations", agentReservations);
	        }else {
	            // 👇 일반 유저 예약 목록 조회
	            List<ReservationsDTO> myReservations = reservationService.getReservationsByUserId(user.getUser_id());
	            model.addAttribute("myReservations", myReservations);
	        }
	        
	        return "User/user_mypage"; 
	    }
		// 정보수정 폼 (GET)
	    @GetMapping("user_modify")
	    public String userModify(HttpSession session, Model model) {
	        log.info("User Call : userModify");
	        
	        // 세션에서 로그인한 유저 정보 가져오기
	        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
	        
	        if(loginUser == null) {
	            return "redirect:/User/user_login"; // 로그인 안 되어 있으면 로그인 페이지로
	        }
	        
	        // DB에서 최신 회원 정보 조회 후 모델에 담기
	        UsersDTO user = userService.getUserByEmail(loginUser.getEmail());
	        model.addAttribute("user", user);
	        
	        return "User/user_modify";
	    }

	    // 정보수정 처리 (POST)
	    @PostMapping("user_modify")
	    public String userModifyPro(UsersDTO usersDTO, HttpSession session, RedirectAttributes rttr) {
	        log.info("User Call : user_modify_pro");
	        
	        int row = userService.updateUser(usersDTO);
	        
	        if(row > 0) {
	            // 수정 성공 시 세션 정보도 갱신 (이름 등 바뀐 정보가 바로 보이도록)
	            session.setAttribute("user", userService.getUserByEmail(usersDTO.getEmail()));
	            rttr.addFlashAttribute("msg", "会員情報が修正されました。");
	        } else {
	            rttr.addFlashAttribute("msg", "会員情報の修正に失敗しました。");
	        }
	        
	        return "redirect:/User/user_mypage";
	    }
	    
	 // 1. 회원 탈퇴 폼 이동 (GET)
	    @GetMapping("user_delete")
	    public String userDeleteForm(HttpSession session) {
	        log.info("User Call : user_delete form");
	        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
	        if(loginUser == null) {
	            return "redirect:/User/user_login";
	        }
	        return "User/user_delete"; // user_delete.jsp로 이동
	    }

	    // 2. 회원 탈퇴 처리 (POST)
	    @PostMapping("user_delete")
	    public String userDeletePro(@RequestParam("password") String password, HttpSession session, RedirectAttributes rttr) {
	        log.info("User Call : user_delete_pro");
	        
	        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
	        if(loginUser == null) {
	            return "redirect:/User/user_login";
	        }
	        
	        // 비밀번호 검증 및 삭제 실행
	        int row = userService.deleteUser(loginUser.getEmail(), password);
	        
	        if(row > 0) {
	            session.invalidate(); // 탈퇴 성공 시 세션 파기
	            rttr.addFlashAttribute("msg", "退会処理が完了しました。ご利用ありがとうございました。");
	            return "redirect:/"; // 홈으로 이동
	        } else {
	            // 비밀번호가 틀렸거나 실패한 경우
	            rttr.addFlashAttribute("msg", "パスワードが正しくありません。");
	            return "redirect:/User/user_delete";
	        }
	    }
	    


}