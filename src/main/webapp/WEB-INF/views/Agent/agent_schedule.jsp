<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>内見可能日時の登録・管理</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen py-10 px-4">

    <div class="max-w-xl mx-auto space-y-8">
        
        <!-- 1. 등록 폼 카드 -->
        <div class="bg-white rounded-2xl shadow-xl overflow-hidden">
            <!-- 카드 헤더 -->
            <div class="bg-gradient-to-r from-blue-600 to-indigo-700 px-6 py-5 text-white">
                <h2 class="text-2xl font-bold">📅 訪問可能時間帯の登録</h2>
                <p class="text-blue-100 text-sm mt-1">お客様が予約できる「開始時間」と「終了時間」を設定してください。</p>
            </div>

            <!-- 카드 바디 -->
            <div class="p-8">
                <form action="/Agent/schedule/register" method="post" class="space-y-5" onsubmit="return validateForm()">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">開始日時 (Start)</label>
                        <input type="datetime-local" name="start_date" required
                               class="w-full px-4 py-3 bg-gray-50 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:bg-white transition text-gray-800">
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">終了日時 (End)</label>
                        <input type="datetime-local" name="end_date" required
                               class="w-full px-4 py-3 bg-gray-50 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:bg-white transition text-gray-800">
                    </div>
                    
                    <button type="submit" 
                            class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-4 rounded-xl shadow-lg hover:shadow-xl transition duration-200">
                        + 時間帯を追加する
                    </button>
                </form>

                <!-- 마이페이지 돌아가기 버튼 (카드 내부 하단에 깔끔하게 배치) -->
                <div class="mt-8 pt-6 border-t border-gray-200 flex justify-between items-center text-sm">
                    <a href="/User/user_mypage" class="text-blue-600 hover:text-blue-800 font-semibold transition flex items-center gap-1">
                        &larr; マイページへ戻る
                    </a>
                </div>
            </div>
        </div>

        <!-- 2. 등록된 목록 카드 -->
        <div class="bg-white rounded-2xl shadow-xl p-8">
            <h3 class="text-lg font-bold text-gray-800 mb-4">📋 登録済み時間帯一覧</h3>
            
            <c:choose>
                <c:when test="${empty scheduleList}">
                    <div class="text-center py-8 text-gray-400 text-sm border-2 border-dashed border-gray-100 rounded-xl">
                        登録されたスケジュールがありません。
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="space-y-3">
                        <c:forEach var="schedule" items="${scheduleList}">
                            <div class="flex items-center justify-between p-4 bg-gray-50 rounded-xl border border-gray-200">
                                <div>
                                    <div class="font-semibold text-gray-800">
                                        <fmt:formatDate value="${schedule.start_date}" pattern="yyyy/MM/dd (E) HH:mm" /> 
                                        ~ 
                                        <fmt:formatDate value="${schedule.end_date}" pattern="HH:mm" />
                                    </div>
                                    <div class="text-xs mt-1">
                                        <c:choose>
                                            <c:when test="${schedule.is_available eq 'Y'}">
                                                <span class="text-green-600 font-medium">予約可能 (Available)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-red-500 font-medium">予約済み (Booked)</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <c:if test="${schedule.is_available eq 'Y'}">
                                    <a href="/Agent/schedule/delete?schedule_id=${schedule.schedule_id}" 
                                       onclick="return confirm('本当に削除しますか？');"
                                       class="px-3 py-1.5 bg-red-50 text-red-600 hover:bg-red-100 text-xs font-semibold rounded-lg transition">
                                        削除
                                    </a>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <!-- 유효성 검사 스크립트 -->
    <script>
    function validateForm() {
        const start = document.querySelector('input[name="start_date"]').value;
        const end = document.querySelector('input[name="end_date"]').value;
        
        if (start >= end) {
            alert("終了日時は開始日時より後の時間を設定してください。");
            return false;
        }
        return true;
    }
    </script>

    <c:if test="${not empty msg}">
        <script>alert("${msg}");</script>
    </c:if>
</body>
</html>