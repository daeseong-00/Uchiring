<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${property.title} - ウチリング</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
    <style> body { font-family: 'Noto Sans JP', sans-serif; } </style>
</head>
<body class="bg-gray-50 text-gray-800 min-h-screen flex flex-col justify-between">

    <!-- Header -->
    <header class="bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
            <a href="/" class="text-2xl font-bold text-blue-600 tracking-tight">
                ウチリング <span class="text-xs font-normal text-gray-500">Uchiring</span>
            </a>
            <div class="flex items-center gap-4">
                <a href="/Property/list" class="text-sm font-medium text-gray-600 hover:text-blue-600 transition">
                    物件一覧へ戻る
                </a>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="flex-grow max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10 w-full">
        
        <!-- 알림 메시지 처리 -->
        <c:if test="${not empty msg}">
            <script>alert("${msg}");</script>
        </c:if>

        <div class="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden p-6 sm:p-8">
            
            <!-- 상단 타이틀 및 레이아웃 뱃지 -->
            <div class="flex flex-wrap items-center justify-between gap-4 border-b border-gray-100 pb-6">
                <div>
                    <span class="inline-block bg-blue-100 text-blue-600 text-xs font-semibold px-2.5 py-1 rounded-md mb-2">
                        ${property.layout}
                    </span>
                    <h1 class="text-2xl sm:text-3xl font-bold text-gray-900">${property.title}</h1>
                    <p class="text-sm text-gray-500 mt-1">${property.address}</p>
                </div>
                <div class="text-right">
                    <span class="text-xs text-gray-400 block">家賃</span>
                    <div class="text-2xl font-bold text-blue-600">¥${property.price} <span class="text-sm font-normal text-gray-500">(管理費: ¥${property.management_fee})</span></div>
                </div>
            </div>

            <!-- 이미지 갤러리 영역 -->
            <div class="py-6 border-b border-gray-100">
                <h3 class="text-sm font-semibold text-gray-700 mb-4">物件画像</h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
				    <c:if test="${not empty property.image_url}">
				        <c:set var="images" value="${fn:split(property.image_url, ',')}" />
				        <c:forEach var="img" items="${images}">
				            <!-- bg-gray-900(어두운 배경) 또는 bg-gray-100으로 여백 색상 지정 가능 -->
				            <div class="h-64 bg-gray-100 rounded-xl overflow-hidden border border-gray-100 flex items-center justify-center">
				                <img src="/upload/${img}" alt="物件詳細画像" class="max-h-full max-w-full object-contain">
				            </div>
				        </c:forEach>
				    </c:if>
				</div>
            </div>

            <!-- 상세 설명 영역 -->
            <div class="py-6 border-b border-gray-100">
                <h3 class="text-sm font-semibold text-gray-700 mb-2">詳細説明</h3>
                <p class="text-gray-600 leading-relaxed whitespace-pre-line">${property.description}</p>
            </div>

            <!-- 하단 버튼 영역 (수정 / 삭제 / 목록) -->
            <div class="flex items-center justify-between pt-6">
                <a href="/Property/list" class="px-5 py-2.5 border border-gray-300 rounded-xl text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                    一覧に戻る
                </a>
                
                <!-- 로그인한 유저의 ID와 매물 등록자(agent_id)가 같을 때만 수정/삭제 버튼 노출 -->
                <c:if test="${not empty sessionScope.user and sessionScope.user.user_id eq property.agent_id}">
                    <div class="flex items-center gap-3">
                        <a href="/Property/update?propertyId=${property.property_id}" class="px-5 py-2.5 bg-blue-600 text-white rounded-xl text-sm font-medium hover:bg-blue-700 transition shadow-sm">
                            修正
                        </a>
                        <a href="/Property/delete?propertyId=${property.property_id}" onclick="return confirm('本当にこの物件を削除しますか？');" class="px-5 py-2.5 bg-red-50 text-red-600 rounded-xl text-sm font-medium hover:bg-red-100 transition">
                            削除
                        </a>
                    </div>
                </c:if>
            </div>
			<!-- 방문 예약 신청 영역 (일반 회원 전용) -->
            <div class="py-6 border-b border-gray-100">
                <h3 class="text-sm font-semibold text-gray-700 mb-4">🏠 訪問予約申込</h3>
                
                <c:choose>
                    <%-- 비로그인 상태 --%>
                    <c:when test="${empty sessionScope.user}">
                        <div class="p-4 bg-gray-50 rounded-xl text-center text-sm text-gray-500">
                            ご予約には<a href="/User/user_login" class="text-blue-600 font-semibold underline">ログイン</a>が必要です。
                        </div>
                    </c:when>
                    <%-- 에이전트 계정인 경우 --%>
                    <c:when test="${sessionScope.user.role eq 'AGENT' or sessionScope.user.role eq 'agent'}">
                        <div class="p-4 bg-gray-50 rounded-xl text-center text-sm text-gray-400">
                            エージェントアカウントでは物件の予約を申し込むことができません。
                        </div>
                    </c:when>
                    <%-- 일반 회원인 경우 --%>
                    <c:otherwise>
                        <form action="/Reservation/register" method="post">
                            <input type="hidden" name="property_id" value="${property.property_id}">
                            
                            <c:choose>
                                <%-- 등록된 에이전트 스케줄이 없을 때 --%>
                                <c:when test="${empty agentSchedules}">
                                    <div class="p-4 bg-gray-50 rounded-xl text-center text-sm text-gray-400">
                                        現在、エージェントが設定した訪問可能な日程がありません。
                                    </div>
                                </c:when>
                                <%-- 에이전트 스케줄이 있을 때 --%>
                                <c:otherwise>
                                    <div class="space-y-3 mb-4">
                                        <label class="block text-xs text-gray-500">ご希望の訪問日時を選択してください：</label>
                                        <select name="reservation_date" required class="w-full p-3 border border-gray-300 rounded-xl text-sm focus:outline-none focus:border-blue-500">
										    <option value="">-- 日時を選択してください --</option>
										    <c:forEach var="sch" items="${agentSchedules}">
										        <c:if test="${sch.is_available eq 'Y'}">
										            <%-- 이미 예약된 시간인지 확인하기 위한 변수 플래그 --%>
										            <c:set var="isReserved" value="false" />
										            <c:forEach var="resDate" items="${reservedDates}">
										                <c:if test="${sch.start_date eq resDate}">
										                    <c:set var="isReserved" value="true" />
										                </c:if>
										            </c:forEach>
										            
										            <%-- 예약되지 않은 시간대만 옵션으로 노출 --%>
										            <c:if test="${not isReserved}">
										                <option value="${sch.start_date}">
										                    <fmt:formatDate value="${sch.start_date}" pattern="yyyy/MM/dd HH:mm" /> ~ 
										                    <fmt:formatDate value="${sch.end_date}" pattern="HH:mm" />
										                </option>
										            </c:if>
										        </c:if>
										    </c:forEach>
										</select>
                                    </div>
                                    <button type="submit" class="w-full py-3 bg-blue-600 text-white rounded-xl text-sm font-medium hover:bg-blue-700 transition shadow-sm">
                                        訪問予約を申し込む
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 py-6 text-center text-sm text-gray-500">
        <p>&copy; 2026 Uchiring Inc. All Rights Reserved.</p>
    </footer>

</body>
</html>