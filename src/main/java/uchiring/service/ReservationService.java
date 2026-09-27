package uchiring.service;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import uchiring.domain.ReservationsDTO;
import uchiring.mapper.ReservationMapper;

@Service
public class ReservationService {

    @Autowired
    private ReservationMapper reservationMapper;

    // 예약 신청 로직
    public void registerReservation(ReservationsDTO dto) {
        reservationMapper.insertReservation(dto);
    }

    // 유저별 예약 목록 조회 로직
    public List<ReservationsDTO> getReservationsByUser(int userId) {
        return reservationMapper.selectReservationsByUserId(userId);
    }

    // 에이전트별 예약 목록 조회 로직
    public List<ReservationsDTO> getReservationsByAgent(int agentId) {
        return reservationMapper.selectReservationsByAgentId(agentId);
    }
    
    public List<Timestamp> getReservedDates(int propertyId) {
        return reservationMapper.selectReservedDatesByProperty(propertyId);
    }

 // 예약 취소 로직
    public int cancelReservation(int reservationId, int userId) {
        return reservationMapper.updateReservationStatusToCancelled(reservationId, userId);
    }
    
 // 에이전트 예약 상태 변경 로직
    public int changeReservationStatusByAgent(int reservationId, String status, int agentId) {
        return reservationMapper.updateReservationStatusByAgent(reservationId, status, agentId);
    }
    public List<ReservationsDTO> getReservationsByUserId(int userId) {
        return reservationMapper.selectReservationsByUserId(userId);
    }
    
 // 예약 ID로 예약 단건 조회 로직
    public ReservationsDTO getReservationById(int reservationId) {
        return reservationMapper.selectReservationById(reservationId);
    }
    
}