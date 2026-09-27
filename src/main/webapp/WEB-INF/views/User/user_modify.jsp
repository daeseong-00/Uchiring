<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            <a href="${pageContext.request.contextPath}/" class="text-2xl font-bold text-blue-600 tracking-tight">
                ウチリング <span class="text-xs font-normal text-gray-500">Uchiring</span>
            </a>
            <a href="${pageContext.request.contextPath}/User/user_logout" class="text-sm font-medium text-gray-600 hover:text-red-600 transition">
                ログアウト
            </a>
        </div>
    </header>

    <!-- Main Section -->
    <main class="flex-grow flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full bg-white p-8 rounded-2xl shadow-sm border border-gray-100">
            <div class="text-center mb-8">
                <h1 class="text-2xl font-bold text-gray-900">マイページ</h1>
                <p class="text-sm text-gray-500 mt-1">登録情報の確認および変更</p>
            </div>

            <form action="${pageContext.request.contextPath}/User/user_modify" method="post" class="space-y-5">
                
                <!-- 이메일 (아이디 역할이므로 수정 불가 readonly) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">メールアドレス（ログインID）</label>
                    <input type="email" name="email" value="${user.email}" readonly 
                           class="w-full px-4 py-2.5 border border-gray-200 bg-gray-100 rounded-lg text-sm text-gray-500 cursor-not-allowed">
                </div>

                <!-- 이름 -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">お名前</label>
                    <input type="text" name="name" value="${user.name}" required 
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none text-sm">
                </div>

                <!-- 비밀번호 -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">新しいパスワード</label>
                    <input type="password" name="password" placeholder="変更する場合のみ入力してください" 
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none text-sm">
                </div>

                <!-- 전화번호 -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">電話番号</label>
                    <input type="text" name="phone" value="${user.phone}" 
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none text-sm">
                </div>

                <!-- 수정 버튼 -->
                <button type="submit" 
                        class="w-full bg-blue-600 text-white font-bold py-3 rounded-xl shadow-md hover:bg-blue-700 transition text-sm mt-2">
                    変更を保存する
                </button>
            </form>
            <!-- 회원 탈퇴 텍스트 링크형 -->
			<div class="mt-8 pt-6 border-t border-gray-100 text-right">
			    <a href="${pageContext.request.contextPath}/User/user_delete" 
			       class="text-xs font-bold text-red-600 hover:text-red-800 hover:underline transition flex items-center justify-end gap-1">
			        <span>⚠️</span> 退会をご希望の方はこちら
			    </a>
			</div>
            <div class="text-center mt-6">
                <a href="/User/user_mypage" class="text-sm text-gray-500 hover:text-blue-600 transition">マイページに戻る</a>
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