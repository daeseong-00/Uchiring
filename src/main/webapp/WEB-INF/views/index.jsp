<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ウチリング (Uchiring) - 日本不動産 訪問予約サービス</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans JP', sans-serif; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 min-h-screen flex flex-col justify-between">

    <!-- Header / Navigation -->
    <header class="bg-white shadow-sm sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
            <!-- Logo -->
            <div class="flex items-center space-x-2">
                <a href="/" class="text-2xl font-bold text-blue-600 tracking-tight">
                    ウチリング <span class="text-xs font-normal text-gray-500">Uchiring</span>
                </a>
            </div>

            <!-- Navigation Menu -->
            <nav class="hidden md:flex items-center space-x-6 text-sm font-medium">
                <a href="/" class="text-gray-600 hover:text-blue-600 transition">ホーム</a>
                <a href="/Property/list" class="text-gray-600 hover:text-blue-600 transition">物件を探す</a>
                
                <%-- 에이전트일 경우에만 네비게이션에 '物件登録' 메뉴 노출 --%>
                <c:if test="${not empty sessionScope.user and sessionScope.user.role eq 'AGENT'}">
                    <a href="/Property/register" class="text-blue-600 font-bold hover:text-blue-700 transition">物件登録</a>
                </c:if>
                
                
            </nav>

            <!-- User Auth Menu -->
            <div class="flex items-center space-x-3">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="/User/user_login" class="text-sm font-medium text-gray-600 hover:text-blue-600 px-3 py-2 transition">
                            ログイン
                        </a>
                        <a href="/User/user_insert" class="text-sm font-medium bg-blue-600 text-white px-4 py-2 rounded-lg shadow-sm hover:bg-blue-700 transition">
                            新規会員登録
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="text-sm font-medium text-gray-700">
                            <span class="text-blue-600 font-bold">${sessionScope.user.name}</span>様
                        </span>
                        <a href="/User/user_mypage" class="text-sm text-gray-600 hover:text-blue-600 transition">
                            マイページ
                        </a>
                        <a href="/User/user_logout" class="text-sm font-medium bg-gray-100 text-gray-700 px-3 py-2 rounded-lg hover:bg-gray-200 transition">
                            ログアウト
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

   <!-- Hero Section -->
    <main class="flex-grow">
        <div class="bg-gradient-to-br from-blue-900 to-blue-700 text-white py-20 px-4 sm:px-6 lg:px-8 text-center">
            <div class="max-w-3xl mx-auto">
                <h1 class="text-3xl sm:text-4xl md:text-5xl font-bold tracking-tight mb-6">
                    日本のお部屋探しを、もっと簡単・スマートに。
                </h1>
                <p class="text-base sm:text-lg text-blue-100 mb-8 leading-relaxed">
                    ウチリングは、外国籍の方やスムーズな内見を希望する方のための<br class="hidden sm:inline">
                    不動産現地訪問予約プラットフォームです。
                </p>
                <div class="flex flex-col sm:flex-row justify-center gap-4">
                    <a href="/Property/list" class="bg-white text-blue-700 font-bold px-8 py-3.5 rounded-xl shadow-lg hover:bg-blue-50 transition">
                        物件一覧を見る
                    </a>
                    
                    <c:choose>
                        <%-- 로그인하지 않은 경우: '지금 바로 시작' 버튼 노출 --%>
                        <c:when test="${empty sessionScope.user}">
                            <a href="/User/user_insert" class="bg-blue-600 border border-blue-400 text-white font-bold px-8 py-3.5 rounded-xl shadow-lg hover:bg-blue-500 transition">
                                今すぐ始める
                            </a>
                        </c:when>
                        
                        <%-- 로그인한 유저의 role이 AGENT인 경우: '물건 등록' 버튼 노출 --%>
                        <c:when test="${sessionScope.user.role eq 'AGENT'}">
                            <a href="/Property/register" class="bg-emerald-600 border border-emerald-400 text-white font-bold px-8 py-3.5 rounded-xl shadow-lg hover:bg-emerald-500 transition">
                                物件を登録する
                            </a>
                        </c:when>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Features Section -->
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
            <div class="text-center mb-12">
                <h2 class="text-2xl font-bold text-gray-900">ウチリングの特徴</h2>
                <p class="text-gray-500 text-sm mt-2">安心のサポートで理想の住まいへご案内します</p>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 text-center">
                    <div class="w-12 h-12 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center mx-auto mb-4 font-bold text-xl">01</div>
                    <h3 class="font-bold text-lg mb-2">カンタン訪問予約</h3>
                    <p class="text-gray-600 text-sm leading-relaxed">希望の日時を選んでリクエストするだけで、面倒な不動産会社とのやり取りがスムーズに。</p>
                </div>
                <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 text-center">
                    <div class="w-12 h-12 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center mx-auto mb-4 font-bold text-xl">02</div>
                    <h3 class="font-bold text-lg mb-2">厳選された物件情報</h3>
                    <p class="text-gray-600 text-sm leading-relaxed">仲介会社が直接管理する信頼性の高い物件情報をリアルタイムで確認できます。</p>
                </div>
                <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 text-center">
                    <div class="w-12 h-12 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center mx-auto mb-4 font-bold text-xl">03</div>
                    <h3 class="font-bold text-lg mb-2">安心のサポート体制</h3>
                    <p class="text-gray-600 text-sm leading-relaxed">内見当日の流れから契約までのステップを分かりやすくトータルサポート。</p>
                </div>
            </div>
        </div>
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