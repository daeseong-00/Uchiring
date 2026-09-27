<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ログイン - ウチリング</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans JP', sans-serif; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 min-h-screen flex flex-col justify-between">

    <!-- Header -->
    <header class="bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
            <a href="/" class="text-2xl font-bold text-blue-600 tracking-tight">
                ウチリング <span class="text-xs font-normal text-gray-500">Uchiring</span>
            </a>
            <a href="/User/user_insert" class="text-sm font-medium text-gray-600 hover:text-blue-600 transition">
                新規会員登録
            </a>
        </div>
    </header>

    <!-- Main Form Section -->
    <main class="flex-grow flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full bg-white p-8 rounded-2xl shadow-sm border border-gray-100">
            <div class="text-center mb-8">
                <h1 class="text-2xl font-bold text-gray-900">ログイン</h1>
                <p class="text-sm text-gray-500 mt-1">ウチリングへようこそ。ログインして予約を管理しましょう。</p>
            </div>

            <form action="/User/user_login" method="post" class="space-y-5">
                
                <!-- メールアドレス (Email / ID) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">メールアドレス</label>
                    <input type="email" name="email" required 
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm"
                           placeholder="example@uchiring.com">
                </div>

                <!-- パスワード (Password) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">パスワード</label>
                    <input type="password" name="password" required 
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm"
                           placeholder="••••••••">
                </div>

                <!-- ログインボタン -->
                <button type="submit" 
                        class="w-full bg-blue-600 text-white font-bold py-3 rounded-xl shadow-md hover:bg-blue-700 transition text-sm mt-2">
                    ログイン
                </button>
            </form>

            <div class="text-center mt-6 text-sm text-gray-500">
                アカウントをお持ちではありませんか？ 
                <a href="/User/user_insert" class="text-blue-600 font-medium hover:underline">新規会員登録</a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 py-6 text-center text-sm text-gray-500">
        <p>&copy; 2026 Uchiring Inc. All Rights Reserved.</p>
    </footer>

    <!-- 회원가입 완료 등 컨트롤러에서 넘어오는 알림 메시지 처리 -->
    <c:if test="${not empty msg}">
        <script>
            alert("${msg}");
        </script>
    </c:if>
</body>
</html>