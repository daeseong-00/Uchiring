package uchiring.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import uchiring.domain.AgentScheduleDTO;
import uchiring.domain.UsersDTO;
import uchiring.service.AgentScheduleService;

@Controller
@RequestMapping("/Agent/schedule")
public class AgentScheduleController {

    @Autowired
    private AgentScheduleService scheduleService;

    // 1. 일정 등록 폼 이동 + 목록 조회
    @GetMapping("register")
    public String scheduleForm(HttpSession session, Model model) {
        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
        if (loginUser == null) {
            return "redirect:/login";
        }
        
        // 에이전트가 등록한 일정 목록 조회해서 뷰에 전달
        List<AgentScheduleDTO> scheduleList = scheduleService.getSchedulesByAgent(loginUser.getUser_id());
        model.addAttribute("scheduleList", scheduleList);
        
        return "Agent/agent_schedule"; 
    }
    @PostMapping("register")
    public String scheduleRegisterPro(
            @RequestParam("start_date") String startDateStr,
            @RequestParam("end_date") String endDateStr,
            HttpSession session,
            RedirectAttributes rttr) {
        
        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
        if (loginUser == null) {
            return "redirect:/login";
        }
        
        try {
            scheduleService.registerSchedule(loginUser.getUser_id(), startDateStr, endDateStr);
            rttr.addFlashAttribute("msg", "スケジュールが登録されました。");
        } catch (Exception e) {
            e.printStackTrace();
            // 커스텀 예외 메시지가 있으면 출력하고, 없으면 기본 에러 메시지 출력
            String errorMsg = e.getMessage() != null ? e.getMessage() : "登録中にエラーが発生しました。";
            rttr.addFlashAttribute("msg", errorMsg);
        }
        
        return "redirect:/Agent/schedule/register";
    }
    


    // 3. 일정 삭제 처리
    @GetMapping("delete")
    public String scheduleDelete(@RequestParam("schedule_id") int scheduleId, RedirectAttributes rttr) {
        try {
            scheduleService.removeSchedule(scheduleId);
            rttr.addFlashAttribute("msg", "スケジュールが削除されました。");
        } catch (Exception e) {
            e.printStackTrace();
            rttr.addFlashAttribute("msg", "削除中にエラーが発生しました。");
        }
        return "redirect:/Agent/schedule/register";
    }
}