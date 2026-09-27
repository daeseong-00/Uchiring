<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>退会手続き - ウチリング</title>
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
            <a href="/User/user_mypage" class="text-sm font-medium text-gray-600 hover:text-blue-600 transition">
                マイページに戻る
            </a>
        </div>
    </header>

    <!-- Main Section -->
    <main class="flex-grow flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full bg-white p-8 rounded-2xl shadow-sm border border-gray-100">
            <div class="text-center mb-8">
                <h1 class="text-2xl font-bold text-red-600">退会手続き</h1>
                <p class="text-sm text-gray-500 mt-2">
                    退会すると、すべてのデータが削除され復구できません。<br>ご確認の上、パスワードを入力してください。
                </p>
            </div>

            <form action="/User/user_delete" method="post" class="space-y-5" onsubmit="return confirm('本当に退会しますか？');">
                
                <!-- 현재 비밀번호 확인 -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">現在のパスワード</label>
                    <input type="password" name="password" required placeholder="パスワードを入力してください" 
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 outline-none text-sm">
                </div>

                <!-- 탈퇴 버튼 -->
                <button type="submit" 
                        class="w-full bg-red-600 text-white font-bold py-3 rounded-xl shadow-md hover:bg-red-700 transition text-sm mt-2">
                    アカウントを削除する
                </button>
            </form>
            
            <div class="text-center mt-6">
                <a href="/User/user_mypage" class="text-sm text-gray-500 hover:text-gray-700 transition">キャンセルして戻る</a>
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