package uchiring.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import uchiring.domain.PropertiesDTO;

@Mapper
public interface PropertyMapper {
	 public void registerProperty(PropertiesDTO dto);
	 
	// 페이징 범위 조회를 위한 목록 메서드
	    public List<PropertiesDTO> propertyList(Map<String, Object> map);
	    
	    // 전체 매물 개수 조회 메서드 추가
	    public int selectPropertyCount();
	 // 상세 보기 (단건 조회)
	    public PropertiesDTO getPropertyDetail(int propertyId);

	 // 수정 처리
	    public void updateProperty(PropertiesDTO dto);

	 // 삭제 처리
	    public void deleteProperty(int propertyId);
	    
	 // 특정 에이전트가 등록한 매물 목록 조회
	    public List<PropertiesDTO> getPropertiesByAgentId(int agentId); 

	 // 검색
	    public List<PropertiesDTO> searchProperties(@Param("keyword") String keyword);
	    
	    public int selectSearchCount(Map<String, Object> paramMap);
	    public List<PropertiesDTO> searchPropertiesWithPaging(Map<String, Object> paramMap);
}
