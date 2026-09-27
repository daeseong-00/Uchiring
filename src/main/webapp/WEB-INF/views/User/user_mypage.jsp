<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>マイページ - ウチリング</title>
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
            <a href="/User/user_logout" class="text-sm font-medium text-gray-600 hover:text-red-600 transition">
                ログアウト
            </a>
        </div>
    </header>

    <!-- Main Section -->
    <main class="max-w-4xl mx-auto px-4 py-12 w-full flex-grow space-y-8">
        
        <!-- 사용자 환영 인사 및 요약 카드 -->
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 flex justify-between items-center">
            <div>
                <h1 class="text-xl font-bold text-gray-900">${user.name} 様、こんにちは！</h1>
                <p class="text-sm text-gray-500 mt-1">${user.email} 
                    <span class="ml-2 px-2 py-0.5 bg-blue-50 text-blue-600 text-xs font-semibold rounded-full">
                        <c:choose>
                            <c:when test="${user.role eq 'AGENT' or user.role eq 'agent'}">エージェント (Agent)</c:when>
                            <c:otherwise>一般会員 (User)</c:otherwise>
                        </c:choose>
                    </span>
                </p>
            </div>
            <div class="flex items-center space-x-3">
                <c:if test="${user.role eq 'AGENT' or user.role eq 'agent'}">
                    <a href="/Agent/schedule/register" 
                       class="bg-blue-600 text-white text-sm font-medium px-4 py-2.5 rounded-xl hover:bg-blue-700 shadow-sm transition">
                        📅 内見可能日時設定
                    </a>
                </c:if>
                <a href="/User/user_modify" 
                   class="bg-gray-100 text-gray-700 text-sm font-medium px-4 py-2.5 rounded-xl hover:bg-gray-200 transition">
                    会員情報修正
                </a>
            </div>
        </div>

        <!-- 롤별 컨텐츠 분기 -->
        <c:choose>
            <%-- ================= [에이전트 화면] ================= --%>
            <c:when test="${user.role eq 'AGENT' or user.role eq 'agent'}">
                
                <!-- 1. 내가 등록한 매물 목록 -->
                <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-lg font-bold text-gray-900">🏠 登録した物件一覧</h2>
                        <a href="/Property/register" class="text-xs bg-blue-50 text-blue-600 px-3 py-1.5 rounded-lg font-semibold hover:bg-blue-100 transition">+ 物件登録</a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty myProperties}">
                            <div class="text-center py-8 text-gray-400 text-sm border-2 border-dashed border-gray-100 rounded-xl">
                                登録された物件がありません。
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-3">
                                <c:forEach var="prop" items="${myProperties}">
                                    <div class="p-4 bg-gray-50 rounded-xl border border-gray-200 flex justify-between items-center">
                                        <div>
                                            <p class="font-semibold text-gray-800">${prop.title}</p>
                                            <p class="text-xs text-gray-500 mt-0.5">${prop.address}</p>
                                        </div>
                                        <a href="/Property/detail?id=${prop.property_id}" class="text-xs text-blue-600 hover:underline">詳細</a>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 2. 에이전트 스케줄 및 예약 현황 -->
                <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
                    <h2 class="text-lg font-bold text-gray-900 mb-4">📅 訪問予約およびスケジュール状況</h2>
                    
                    <c:choose>
                        <c:when test="${empty scheduleList}">
                            <div class="text-center py-8 text-gray-400 text-sm border-2 border-dashed border-gray-100 rounded-xl">
                                登録されたスケジュールがありません。
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-3">
                                <c:forEach var="sch" items="${scheduleList}">
                                    <div class="p-4 bg-gray-50 rounded-xl border border-gray-200 flex justify-between items-center">
                                        <div>
                                            <div class="font-semibold text-gray-800 text-sm">
                                                <fmt:formatDate value="${sch.start_date}" pattern="yyyy/MM/dd HH:mm" /> ~ 
                                                <fmt:formatDate value="${sch.end_date}" pattern="HH:mm" />
                                            </div>
                                            <div class="text-xs mt-1">
                                                <c:choose>
                                                    <c:when test="${sch.is_available eq 'Y'}">
                                                        <span class="text-green-600 font-medium">予約可能 (Available)</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-red-500 font-medium">予約済み (Booked)</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 3. 에이전트 매물에 들어온 방문 예약 관리 -->
                <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 mt-6">
                    <h2 class="text-lg font-bold text-gray-900 mb-4">📋 申込された訪問予約の管理</h2>
                    
                    <c:choose>
                        <c:when test="${empty agentReservations}">
                            <div class="text-center py-8 text-gray-400 text-sm border-2 border-dashed border-gray-100 rounded-xl">
                                現在、受け付けられた予約はありません。
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-3">
                                <c:forEach var="ares" items="${agentReservations}">
                                    <div class="p-4 bg-gray-50 rounded-xl border border-gray-200 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                                        <div>
                                            <a href="/Property/detail?id=${ares.property_id}" class="text-xs text-blue-600 font-semibold hover:underline mb-1 inline-block">
                                                物件: ${ares.property_title}
                                            </a>
                                            <p class="font-semibold text-gray-800">
                                                予約者: <span class="text-gray-900">${ares.user_name}</span> さん
                                            </p>
                                            <p class="text-xs text-gray-500 mt-1">
                                                予約希望日時: <fmt:formatDate value="${ares.reservation_date}" pattern="yyyy/MM/dd HH:mm" />
                                            </p>
                                        </div>
                                        
                                        <div class="flex items-center gap-2">
                                            <span class="px-3 py-1 bg-blue-50 text-blue-600 text-xs font-semibold rounded-lg mr-2">
                                                <c:choose>
                                                    <c:when test="${ares.status eq 'PENDING'}">承認待ち (確認中)</c:when>
                                                    <c:when test="${ares.status eq 'CONFIRMED'}">予約確定</c:when>
                                                    <c:when test="${ares.status eq 'CANCELLED'}">キャンセル</c:when>
                                                    <c:otherwise>${ares.status}</c:otherwise>
                                                </c:choose>
                                            </span>
                                            
                                            <!-- PENDING 상태일 때만 승인/거절 버튼 노출 -->
                                            <c:if test="${ares.status eq 'PENDING'}">
                                                <form action="/Reservation/agent/status" method="post" style="margin: 0;">
                                                    <input type="hidden" name="reservation_id" value="${ares.reservation_id}">
                                                    <input type="hidden" name="status" value="CONFIRMED">
                                                    <button type="submit" onclick="return confirm('この予約を承認しますか？');" class="px-3 py-1.5 bg-blue-600 text-white hover:bg-blue-700 text-xs font-semibold rounded-lg transition">
                                                        承認
                                                    </button>
                                                </form>
                                                
                                                <form action="/Reservation/agent/status" method="post" style="margin: 0;">
                                                    <input type="hidden" name="reservation_id" value="${ares.reservation_id}">
                                                    <input type="hidden" name="status" value="CANCELLED">
                                                    <button type="submit" onclick="return confirm('この予約をキャンセルしますか？');" class="px-3 py-1.5 bg-red-50 text-red-600 hover:bg-red-100 text-xs font-semibold rounded-lg transition">
                                                        キャンセル
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </c:when>

            <%-- ================= [일반 사용자 화면] ================= --%>
            <c:otherwise>
                
                <!-- 일반 사용자 예약 현황 -->
                <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
                    <h2 class="text-lg font-bold text-gray-900 mb-4">お部屋の訪問予約状況</h2>
                    
                    <c:choose>
                        <c:when test="${empty myReservations}">
                            <div class="text-center py-12 text-gray-400 text-sm border-2 border-dashed border-gray-100 rounded-xl">
                                現在、予約履歴はありません。
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-3">
                                <c:forEach var="res" items="${myReservations}">
                                    <div class="p-4 bg-gray-50 rounded-xl border border-gray-200 flex justify-between items-center">
                                        <div>
                                            <a href="/Property/detail?id=${res.property_id}" class="font-semibold text-gray-800 hover:text-blue-600 hover:underline transition">
                                                ${res.property_title}
                                            </a>
                                            <p class="text-xs text-gray-500 mt-1">
                                                予約日時: <fmt:formatDate value="${res.reservation_date}" pattern="yyyy/MM/dd HH:mm" />
                                            </p>
                                        </div>
                                        
                                        <div class="flex items-center space-x-3">
                                            <span class="px-3 py-1 bg-blue-50 text-blue-600 text-xs font-semibold rounded-lg">
                                                <c:choose>
                                                    <c:when test="${res.status eq 'PENDING'}">承認待ち (確認中)</c:when>
                                                    <c:when test="${res.status eq 'CONFIRMED'}">予約確定</c:when>
                                                    <c:when test="${res.status eq 'CANCELLED'}">キャンセル</c:when>
                                                    <c:otherwise>${res.status}</c:otherwise>
                                                </c:choose>
                                            </span>
                                            
                                            <!-- PENDING 상태일 때만 취소 버튼 노출 -->
                                            <c:if test="${res.status eq 'PENDING'}">
                                                <form action="/Reservation/cancel" method="post" onsubmit="return confirm('本当に予約をキャンセルしますか？');" style="margin: 0;">
                                                    <input type="hidden" name="reservation_id" value="${res.reservation_id}">
                                                    <button type="submit" class="px-3 py-1 bg-red-50 text-red-600 hover:bg-red-100 text-xs font-semibold rounded-lg transition">
                                                        キャンセル
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </c:otherwise>
        </c:choose>

    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 py-6 text-center text-sm text-gray-500">
        <p>&copy; 2026 Uchiring Inc. All Rights Reserved.</p>
    </footer>

    <c:if test="${not empty msg}">
        <script>alert("${msg}");</script>
    </c:if>
</body>
</html>