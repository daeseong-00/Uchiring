package uchiring.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import uchiring.domain.PropertiesDTO;
import uchiring.mapper.PropertyMapper;

@Service
public class PropertyService {
	//Mapper 주입
	@Autowired
	private PropertyMapper propertyMapper;
	
	// 매물 등록 비즈니스 로직
    public void registerProperty(PropertiesDTO dto) {
        propertyMapper.registerProperty(dto);
    }
    
 // 페이징 처리가 포함된 매물 목록 조회 로직
    public Map<String, Object> getPropertyList(int page) {
        int pageSize = 9; // 한 페이지당 보여줄 매물 개수 (3x3 그리드)
        int startRow = (page - 1) * pageSize + 1;
        int endRow = page * pageSize;
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("startRow", startRow);
        paramMap.put("endRow", endRow);
        
        List<PropertiesDTO> propertyList = propertyMapper.propertyList(paramMap);
        int totalCount = propertyMapper.selectPropertyCount();
        
        // 총 페이지 수 계산
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        // 데이터가 아예 없을 경우 최소 1페이지로 지정
        if (totalPage == 0) {
            totalPage = 1;
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("propertyList", propertyList);
        result.put("totalPage", totalPage);
        result.put("currentPage", page);
        
        return result;
    }
    
 // 상세 보기 로직
    public PropertiesDTO getPropertyDetail(int propertyId) {
        return propertyMapper.getPropertyDetail(propertyId);
    }

    // 수정 로직
    public void updateProperty(PropertiesDTO dto) {
        propertyMapper.updateProperty(dto);
    }

    // 삭제 로직
    public void deleteProperty(int propertyId) {
        propertyMapper.deleteProperty(propertyId);
    }
    
 // 에이전트별 매물 목록 조회
    public List<PropertiesDTO> getPropertiesByAgentId(int agentId) {
        return propertyMapper.getPropertiesByAgentId(agentId);
    }
    
    // 검색
    public List<PropertiesDTO> searchProperties(String keyword) {
        return propertyMapper.searchProperties(keyword);
    }
    
    public Map<String, Object> searchProperties(String keyword, String layout, int page) {
        int pageSize = 9;
        int startRow = (page - 1) * pageSize + 1;
        int endRow = page * pageSize;
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("keyword", keyword);
        paramMap.put("layout", layout); 
        paramMap.put("startRow", startRow);
        paramMap.put("endRow", endRow);
        
        List<PropertiesDTO> propertyList = propertyMapper.searchPropertiesWithPaging(paramMap);
        int totalCount = propertyMapper.selectSearchCount(paramMap); 
        
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPage == 0) {
            totalPage = 1;
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("propertyList", propertyList);
        result.put("totalPage", totalPage);
        result.put("currentPage", page);
        result.put("totalCount", totalCount);
        
        return result;
    }
}
