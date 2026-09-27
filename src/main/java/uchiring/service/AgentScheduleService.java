package uchiring.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import uchiring.domain.AgentScheduleDTO;
import uchiring.mapper.AgentScheduleMapper;

@Service
public class AgentScheduleService {
	
	@Autowired
	private AgentScheduleMapper schedulemapper;
	
	private static final Logger log = LoggerFactory.getLogger(AgentScheduleService.class);
	
	public void registerSchedule(int agentId, String startDate, String endDate) {
        // 시작 시간이 종료 시간보다 크거나 같으면 예외 발생
        if (startDate.compareTo(endDate) >= 0) {
            throw new IllegalArgumentException("終了日時は開始日時より後の時間を選択してください。");
        }

        Map<String, Object> map = new HashMap<>();
        map.put("agentId", agentId);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        
        schedulemapper.insertAgentSchedule(map);
    }
    
 // 에이전트 일정 목록 조회
    public List<AgentScheduleDTO> getSchedulesByAgent(int agentId) {
        return schedulemapper.selectSchedulesByAgentId(agentId);
    }
    
    // 일정 삭제
    public void removeSchedule(int scheduleId) {
        schedulemapper.deleteAgentSchedule(scheduleId);
    }
    
 // 예약 날짜 기준으로 스케줄 상태 'N'으로 변경
    public int updateScheduleStatusByDate(int agentId, String reservationDate) {
        Map<String, Object> map = new HashMap<>();
        map.put("agentId", agentId);
        map.put("reservationDate", reservationDate);

        int updatedCount = schedulemapper.updateScheduleStatusByDate(map);
        log.info(">>> 스케줄 상태 변경 갱신 건수: " + updatedCount);
        return updatedCount;
    }
}
