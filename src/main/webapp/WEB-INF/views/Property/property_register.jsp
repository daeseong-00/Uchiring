<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>物件登録 - ウチリング</title>
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
            <a href="/" class="text-sm font-medium text-gray-600 hover:text-blue-600 transition">
                ホームに戻る
            </a>
        </div>
    </header>

    <!-- Main Form Section -->
    <main class="flex-grow flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-2xl w-full bg-white p-8 rounded-2xl shadow-sm border border-gray-100">
            <div class="text-center mb-8">
                <h1 class="text-2xl font-bold text-gray-900">新規物件登録</h1>
                <p class="text-sm text-gray-500 mt-1">ウチリングに掲載する新しい物件情報を入力してください。</p>
            </div>

            <!-- ★ 파일 업로드를 위해 enctype="multipart/form-data" 추가 -->
            <form action="/Property/register" method="post" enctype="multipart/form-data" class="space-y-6">
                
                <!-- 제목 -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">物件タイトル</label>
                    <input type="text" name="title" required placeholder="例：[新築] 新宿駅から徒歩5分のプレミアムマンション"[cite: 2]
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none text-sm">
                </div>

                <!-- 가격 및 관리비 (2단 배치) -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">家賃 (円)</label>
                        <input type="number" name="price" required placeholder="例: 85000"[cite: 2]
                               class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none text-sm">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">管理費 / 共益費 (円)</label>
                        <input type="number" name="management_fee" placeholder="例: 5000"[cite: 2]
                               class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none text-sm">
                    </div>
                </div>

                <!-- 방 구조 및 주소 (2단 배치) -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">間取り</label>
                        <select name="layout" class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none text-sm bg-white">
                            <option value="1R">1R</option>
                            <option value="1K">1K</option>
                            <option value="1DK">1DK</option>
                            <option value="1LDK">1LDK</option>
                            <option value="2K/2DK">2K / 2DK</option>
                            <option value="2LDK以上">2LDK以上</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">住所</label>
                        <input type="text" name="address" required placeholder="例: 東京都新宿区西新宿 1-1-1"[cite: 2]
                               class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none text-sm">
                    </div>
                </div>

                <!-- ★ 사진 파일 업로드 입력창으로 변경 -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">物件画像 (写真ファイル)</label>
                    <input type="file" name="uploadFiles" accept="image/*" multiple required
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
                    <p class="text-xs text-gray-400 mt-1">※ JPEG、PNG形式の画像ファイルをアップロードしてください。</p>
                </div>

                <!-- 상세 설명 -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">物件詳細説明</label>
                    <textarea name="description" rows="4" placeholder="物件の特徴、周辺の便利施設、入居条件などを自由にご記入ください。"[cite: 2]
                              class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none text-sm resize-none"></textarea>
                </div>

                <!-- 등록 버튼 -->
                <button type="submit" 
                        class="w-full bg-blue-600 text-white font-bold py-3 rounded-xl shadow-md hover:bg-blue-700 transition text-sm">
                    物件を登録する
                </button>
            </form>
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