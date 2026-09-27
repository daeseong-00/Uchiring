package uchiring.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import uchiring.domain.AgentScheduleDTO;

@Mapper
public interface AgentScheduleMapper {
    // 가용 일정 등록 쿼리 호출
   public void insertAgentSchedule(Map<String, Object> map);
   
   // 에이전트별 등록된 일정 목록 조회
   public List<AgentScheduleDTO> selectSchedulesByAgentId(int agentId);
   
   // 일정 삭제
   public void deleteAgentSchedule(int scheduleId);
   
// 예약 승인 시 스케줄 상태를 'N'으로 변경
   public int updateScheduleStatusByDate(Map<String, Object> map);
}
