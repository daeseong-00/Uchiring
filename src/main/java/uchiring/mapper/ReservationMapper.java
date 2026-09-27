package uchiring.mapper;

import java.sql.Timestamp;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import uchiring.domain.ReservationsDTO;

@Mapper
public interface ReservationMapper {
    // 1. 방문 예약 신청 (등록)
    public void insertReservation(ReservationsDTO dto);
    
    // 2. 일반 사용자의 예약 목록 조회
    public List<ReservationsDTO> selectReservationsByUserId(int userId);
    
    // 3. 에이전트가 관리하는 매물의 예약 목록 조회
    public List<ReservationsDTO> selectReservationsByAgentId(int agentId);
    
 // 해당 매물에 이미 예약된 날짜/시간 목록 조회
    List<Timestamp> selectReservedDatesByProperty(@Param("property_id") int propertyId);
    
 // 예약 취소 처리 (상태를 CANCELLED로 변경)
    public int updateReservationStatusToCancelled(@Param("reservation_id") int reservationId, @Param("user_id") int userId); 
    
 // 에이전트가 예약 상태 변경 (승인 CONFIRMED 또는 취소/거절 CANCELLED)
    public int updateReservationStatusByAgent(
            @Param("reservation_id") int reservationId, 
            @Param("status") String status, 
            @Param("agent_id") int agentId);
    
 // 예약 ID로 예약 정보 단건 조회
    public ReservationsDTO selectReservationById(int reservationId);
}