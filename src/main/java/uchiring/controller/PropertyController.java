package uchiring.controller;

import java.io.File;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import uchiring.domain.AgentScheduleDTO;
import uchiring.domain.PropertiesDTO;
import uchiring.domain.UsersDTO;
import uchiring.service.AgentScheduleService;
import uchiring.service.PropertyService;
import uchiring.service.ReservationService;

@Controller
@RequestMapping("Property")
public class PropertyController {
    //로그 출력용
    private static final Logger log =
        LoggerFactory.getLogger(PropertyController.class);
    
    //서비스 주입
    @Autowired
    private PropertyService propertyService;
    
    @Autowired
    private AgentScheduleService scheduleService;
    
    @Autowired
    private ReservationService reservationService;
    
    // 1. 물건 등록 폼 이동 (GET)
    @GetMapping("register")
    public String propertyRegisterForm(HttpSession session) {
        log.info("Property Call : register form");
        
        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
        if(loginUser == null) {
            return "redirect:/User/user_login";
        }
        if(!"AGENT".equals(loginUser.getRole())) {
            return "redirect:/";
        }
        
        return "Property/property_register";
    }

    // 2. 물건 등록 처리 (POST)
    @PostMapping("register")
    public String propertyRegisterPro(
            PropertiesDTO dto, 
            @RequestParam("uploadFiles") MultipartFile[] uploadFiles,
            HttpSession session,
            RedirectAttributes rttr) {
        
        log.info("Property Call : register pro");
        
        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
        if(loginUser == null || !"AGENT".equals(loginUser.getRole())) {
            return "redirect:/User/user_login";
        }
        
        try {
            List<String> savedFileNames = new ArrayList<>();
            String uploadFolder = "C:/uchiring_upload/";
            
            for (MultipartFile file : uploadFiles) {
                if (!file.isEmpty()) {
                    String originalFileName = file.getOriginalFilename();
                    String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                    
                    File saveFile = new File(uploadFolder, savedFileName);
                    file.transferTo(saveFile);
                    
                    savedFileNames.add(savedFileName);
                }
            }
            
            String combinedImageUrls = String.join(",", savedFileNames);
            
            dto.setAgent_id(loginUser.getUser_id());
            dto.setImage_url(combinedImageUrls);
            
            propertyService.registerProperty(dto);
            
            rttr.addFlashAttribute("msg", "物件と複数の画像が正常に登録されました。");
            
        } catch (Exception e) {
            e.printStackTrace();
            rttr.addFlashAttribute("msg", "物件の登録中にエラーが発生しました。");
            return "redirect:/Property/register";
        }
        
        return "redirect:/";
    }
    
    // 3. 물건 목록 페이지 이동 (GET - 페이징 적용)
    @GetMapping("list")
    public String propertyList(
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model) {
        log.info("Property Call : list page, page = " + page);
        
        Map<String, Object> result = propertyService.getPropertyList(page);
        
        model.addAttribute("propertyList", result.get("propertyList"));
        model.addAttribute("totalPage", result.get("totalPage"));
        model.addAttribute("currentPage", result.get("currentPage"));
        
        return "Property/property_list"; 
    }
    
    // 4. 상세 보기 페이지 이동 (GET)
    @GetMapping("detail")
    public String propertyDetail(@RequestParam(value = "id", required = false) Integer propertyId, Model model, RedirectAttributes rttr) {
        if (propertyId == null) {
            rttr.addFlashAttribute("msg", "物件IDが見つかりません。");
            return "redirect:/Property/list";
        }
        
        log.info("Property Call : detail page, id = " + propertyId);
        PropertiesDTO property = propertyService.getPropertyDetail(propertyId);
        
        if (property == null) {
            rttr.addFlashAttribute("msg", "該当する物件が存在しません。");
            return "redirect:/Property/list";
        }
        
        model.addAttribute("property", property);
        
     // 에이전트 스케줄 조회
        List<AgentScheduleDTO> agentSchedules = scheduleService.getSchedulesByAgent(property.getAgent_id());
        model.addAttribute("agentSchedules", agentSchedules);
        
        // 👇 [추가] 해당 매물에 이미 예약된 시간 목록 조회해서 전달
        List<Timestamp> reservedDates = reservationService.getReservedDates(propertyId);
        model.addAttribute("reservedDates", reservedDates);
        
        return "Property/property_detail"; 
    }

    // 4-1. 수정 페이지 이동 (GET) - 작성자 본인 확인 추가
    @GetMapping("update")
    public String propertyUpdateForm(
            @RequestParam(value = "propertyId", required = false) Integer propertyId, 
            HttpSession session, 
            Model model, 
            RedirectAttributes rttr) {
        
        if (propertyId == null) {
            rttr.addFlashAttribute("msg", "物件IDが見つかりません。");
            return "redirect:/Property/list";
        }
        
        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
        PropertiesDTO property = propertyService.getPropertyDetail(propertyId);
        
        if (property == null) {
            rttr.addFlashAttribute("msg", "該当する物件が存在しません。");
            return "redirect:/Property/list";
        }
        
        // 로그인 상태가 아니거나, 등록한 본인(agent_id)이 아닐 경우 차단
        if (loginUser == null || property.getAgent_id() != loginUser.getUser_id()) {
            rttr.addFlashAttribute("msg", "修正権限がありません。");
            return "redirect:/Property/detail?id=" + propertyId;
        }
        
        model.addAttribute("property", property);
        return "Property/property_update"; 
    }

 // 4-2. 수정 처리 (POST)
    @PostMapping("update")
    public String propertyUpdatePro(
            PropertiesDTO dto, 
            @RequestParam(value = "uploadFiles", required = false) MultipartFile[] uploadFiles,
            HttpSession session, 
            RedirectAttributes rttr) {
        
        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
        PropertiesDTO originProperty = propertyService.getPropertyDetail(dto.getProperty_id());
        
        if (loginUser == null || originProperty == null || originProperty.getAgent_id() != loginUser.getUser_id()) {
            rttr.addFlashAttribute("msg", "修正権限がありません。");
            return "redirect:/Property/list";
        }
        
        try {
            // 새롭게 업로드된 파일이 있는지 확인
            if (uploadFiles != null && uploadFiles.length > 0 && !uploadFiles[0].isEmpty()) {
                List<String> savedFileNames = new ArrayList<>();
                String uploadFolder = "C:/uchiring_upload/";
                
                for (MultipartFile file : uploadFiles) {
                    if (!file.isEmpty()) {
                        String originalFileName = file.getOriginalFilename();
                        String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                        
                        File saveFile = new File(uploadFolder, savedFileName);
                        file.transferTo(saveFile);
                        
                        savedFileNames.add(savedFileName);
                    }
                }
                
                // 새 파일 이름들을 콤마로 묶어서 DTO에 세팅
                String combinedImageUrls = String.join(",", savedFileNames);
                dto.setImage_url(combinedImageUrls);
            } else {
                // 새 파일을 올리지 않았다면 기존 이미지 유지
                dto.setImage_url(originProperty.getImage_url());
            }
            
            propertyService.updateProperty(dto);
            rttr.addFlashAttribute("msg", "物件情報が正常に修正されました。");
            
        } catch (Exception e) {
            e.printStackTrace();
            rttr.addFlashAttribute("msg", "物件の修正中にエラーが発生しました。");
        }
        
        return "redirect:/Property/detail?id=" + dto.getProperty_id();
    }

    // 5. 삭제 처리 - 파라미터명 수정(propertyId) 및 작성자 본인 확인 추가
    @GetMapping("delete")
    public String propertyDelete(
            @RequestParam(value = "propertyId", required = false) Integer propertyId, 
            HttpSession session, 
            RedirectAttributes rttr) {
        
        if (propertyId == null) {
            rttr.addFlashAttribute("msg", "物件IDが見つかりません。");
            return "redirect:/Property/list";
        }
        
        UsersDTO loginUser = (UsersDTO) session.getAttribute("user");
        PropertiesDTO property = propertyService.getPropertyDetail(propertyId);
        
        if (property == null) {
            rttr.addFlashAttribute("msg", "該当する物件が存在しません。");
            return "redirect:/Property/list";
        }
        
        // 로그인 상태가 아니거나, 등록한 본인(agent_id)이 아닐 경우 차단
        if (loginUser == null || property.getAgent_id() != loginUser.getUser_id()) {
            rttr.addFlashAttribute("msg", "削除権限がありません。");
            return "redirect:/Property/detail?id=" + propertyId;
        }
        
        propertyService.deleteProperty(propertyId);
        rttr.addFlashAttribute("msg", "物件が削除されました。");
        return "redirect:/Property/list";
    }
    
    @GetMapping("search")
    public String searchProperties(
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "layout", required = false) String layout, // 👈 레이아웃 파라미터 추가
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model) {
        
        log.info("Property Call : search keyword = " + keyword + ", layout = " + layout + ", page = " + page);
        
        Map<String, Object> result = propertyService.searchProperties(keyword, layout, page);
        
        model.addAttribute("propertyList", result.get("propertyList"));
        model.addAttribute("totalPage", result.get("totalPage"));
        model.addAttribute("currentPage", result.get("currentPage"));
        model.addAttribute("totalCount", result.get("totalCount"));
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedLayout", layout); // 👈 선택된 레이아웃 유지용
        
        return "Property/property_list"; 
    }
}