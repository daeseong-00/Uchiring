package uchiring.controller;

import java.sql.Timestamp;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import uchiring.domain.ReservationsDTO;
import uchiring.domain.UsersDTO;
import uchiring.service.AgentScheduleService;
import uchiring.service.ReservationService;

@Controller
@RequestMapping("Reservation")
public class ReservationController {
    
    private static final Logger log = LoggerFactory.getLogger(ReservationController.class);

    @Autowired
    private ReservationService reservationService;
    
    @Autowired
    private AgentScheduleService agentScheduleService;

    // 예약 신청 처리
    @PostMapping("register")
    public String reservationRegisterPro(
            @RequestParam("property_id") int propertyId,
            @RequestParam("reservation_date") Timestamp reservationDate,
            HttpSession session,
            RedirectAttributes rttr) {
        
        log.info("Reservation Call : register pro");
        
        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "ログイン後に予約を進めてください。");
            return "redirect:/User/user_login";
        }
        
        try {
            ReservationsDTO dto = new ReservationsDTO();
            dto.setProperty_id(propertyId);
            dto.setUser_id(loginUser.getUser_id());
            dto.setReservation_date(reservationDate);
            dto.setStatus("PENDING"); // 대기 상태
            
            reservationService.registerReservation(dto);
            
            rttr.addFlashAttribute("msg", "来訪予約が正常に申請されました。");
        } catch (Exception e) {
            e.printStackTrace();
            rttr.addFlashAttribute("msg", "予約申請中にエラーが発生しました。");
        }
        
        return "redirect:/Property/detail?id=" + propertyId;
    }
    
 // 예약 취소 처리
    @PostMapping("cancel")
    public String cancelReservation(
            @RequestParam("reservation_id") int reservationId,
            HttpSession session,
            RedirectAttributes rttr) {
        
        log.info("Reservation Call : cancel reservation id = " + reservationId);
        
        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "ログイン後にご利用ください。");
            return "redirect:/User/user_login";
        }
        
        int result = reservationService.cancelReservation(reservationId, loginUser.getUser_id());
        
        if (result > 0) {
            rttr.addFlashAttribute("msg", "予約がキャンセルされました。");
        } else {
            rttr.addFlashAttribute("msg", "予約のキャンセルに失敗しました。");
        }
        
        return "redirect:/User/user_mypage";
    }
 // 에이전트 예약 승인/거절 처리
    @PostMapping("agent/status")
    public String updateReservationStatus(
            @RequestParam("reservation_id") int reservationId,
            @RequestParam("status") String status,
            HttpSession session,
            RedirectAttributes rttr) {
        
        log.info("Reservation Call : agent update status -> id: " + reservationId + ", status: " + status);
        
        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
        if (loginUser == null || (!"AGENT".equals(loginUser.getRole()) && !"agent".equals(loginUser.getRole()))) {
            rttr.addFlashAttribute("msg", "権限がありません。");
            return "redirect:/User/user_login";
        }
        
        int result = reservationService.changeReservationStatusByAgent(reservationId, status, loginUser.getUser_id());
        
        if (result > 0) {
            // 승인(CONFIRMED) 상태로 바꿨다면 스케줄 상태도 'N'으로 변경
        	if ("CONFIRMED".equals(status)) {
        	    try {
        	        ReservationsDTO reservation = reservationService.getReservationById(reservationId);
        	        
        	        if (reservation != null) {
        	            String resDateStr = reservation.getReservation_date().toString().substring(0, 19);
        	            log.info(">>> 변환된 예약 날짜 문자열: " + resDateStr); // 이 로그가 찍히는지 확인
        	            
        	            // 몇 건이 업데이트 되었는지 리턴 받도록 수정 가능
        	            // int updatedRows = agentScheduleService.updateScheduleStatusByDate(loginUser.getUser_id(), resDateStr);
        	            agentScheduleService.updateScheduleStatusByDate(loginUser.getUser_id(), resDateStr);
        	        }
        	    } catch (Exception e) {
        	        e.printStackTrace();
        	        log.error("Failed to update schedule status for reservationId: " + reservationId);
        	    }
        	}
            
            rttr.addFlashAttribute("msg", "予約ステータスが変更されました。");
        } else {
            rttr.addFlashAttribute("msg", "予約ステータス変更に失敗しました。");
        }
        
        return "redirect:/User/user_mypage";
    }
}