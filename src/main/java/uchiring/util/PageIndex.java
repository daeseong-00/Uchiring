package uchiring.util;
import java.net.URLEncoder;

public class PageIndex {
	//현재페이지번호, 총페이지, 서블릿파일
	public static String pageList(int page,int totpage,String url, int maxlist) {
		//String addtag : 검색추가시
		//int pageList =10;//페이지당 글수
		int idx_pre, idx_start;
		  	
		String s_pre = "";    // Prev 저장 변수
		String s_idx = "";    // 번호 저장 변수
		String s_next = "";   // Next 저장 변수

		idx_start = ((page-1) / maxlist) * maxlist + 1 ;  // 시작 페이지 계산
		idx_pre = ((page-1) / maxlist);              // Priview 페이지 계산

	  	// Prev 표시 부분
	  	if(idx_pre > 0) {
	  		s_pre = "<a class='list' href='"+url+"?page="+(idx_pre*maxlist)+"'>"
	  				+ " << </a>";
	  	} else {
	  		s_pre = " << ";
	  	}

	  	// 번호 표시부분	
	  	for(int i=0;i<10;i++,idx_start++) {
	  		if(idx_start>totpage) break;
	  		if(idx_start == page)
	  			s_idx = s_idx + " ["+idx_start+"] ";
	  		else {
	  			s_idx = s_idx + " <a class='list' href='" + url + "?page=" + idx_start;
	  			s_idx = s_idx + "'> [" + idx_start + "] </a> ";
	  		}
	  	}
		// Next 표시부분
	  	if(idx_start <= totpage ) {
	  		s_next = "<a class='list' href='"+url+"?page="+idx_start+"'>"
	  				+ " >> </a>";
	  	} else {
	  		s_next = " >> ";
	  	}

	  	String outHtml = s_pre + s_idx + s_next;  // Html 문 조합
	  	return outHtml;
	}

	public static String pageListHan(int page,int totpage,String url,int maxlist, String query, String key) {
		//int pageList =10;//페이지당 글수		
		int idx_pre, idx_start;
		  	
		String s_pre = "";    // Prev 저장 변수
		String s_idx = "";    // 번호 저장 변수
		String s_next = "";   // Next 저장 변수

		idx_start = ((page-1) / maxlist) * maxlist + 1 ;  // 시작 페이지 계산
		idx_pre = ((page-1) / maxlist);              // Priview 페이지 계산

	  	// Prev 표시 부분
	  	if(idx_pre > 0) {
	  		s_pre = "<a class='list' href='"+url+"?page="+(idx_pre*maxlist)+"&search="+query+"&key="+ URLEncoder.encode(key)+"'>"
	  				+ " << </a>";
	  	} else {
	  		s_pre = " << ";
	  	}

	  	// 번호 표시부분	
	  	for(int i=0;i<10;i++,idx_start++) {
	  		if(idx_start>totpage) break;
	  		if(idx_start == page)
	  			s_idx = s_idx + " ["+idx_start+"] ";
	  		else {
	  			s_idx = s_idx + " <a class='list' href='" + url + "?page=" + idx_start;
	  			s_idx = s_idx + "&search="+query+"&key=" + URLEncoder.encode(key) + "'> [" + idx_start + "] </a> ";
	  		}
	  	}
		// Next 표시부분
	  	if(idx_start <= totpage ) {
	  		s_next = "<a class='list' href='"+url+"?page="+idx_start+ "&search="+query+"&key="+ URLEncoder.encode(key)+"'>"
	  				+ " >> </a>";
	  	} else {
	  		s_next = " >> ";
	  	}

	  	String outHtml = s_pre + s_idx + s_next;  // Html 문 조합
	  	return outHtml;
	}

}
