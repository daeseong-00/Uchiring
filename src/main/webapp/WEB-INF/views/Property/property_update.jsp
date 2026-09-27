<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>物件修正 - ウチリング</title>
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
            <a href="/Property/list" class="text-sm font-medium text-gray-600 hover:text-blue-600 transition">
                物件一覧へ
            </a>
        </div>
    </header>

    <!-- Main Content -->
    <main class="flex-grow max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-10 w-full">
        <div class="bg-white rounded-2xl border border-gray-100 shadow-sm p-6 sm:p-8">
            
            <div class="mb-8 border-b border-gray-100 pb-4">
                <h1 class="text-2xl font-bold text-gray-900">物件情報修正</h1>
                <p class="text-sm text-gray-500 mt-1">登録されている物件情報を変更します。</p>
            </div>

            <!-- form 태그에 enctype 속성 추가 -->
			<form action="/Property/update" method="post" enctype="multipart/form-data" class="space-y-6">
			    <input type="hidden" name="property_id" value="${property.property_id}">
			    <!-- 기존 이미지 유지를 위해 기존 image_url도 숨겨서 전달 가능 -->
			    <input type="hidden" name="image_url" value="${property.image_url}">
                <!-- 타이틀 -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">タイトル</label>
                    <input type="text" name="title" value="${property.title}" required
                           class="w-full px-4 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                </div>

                <!-- 가격 및 관리비 -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">家賃 (¥)</label>
                        <input type="number" name="price" value="${property.price}" required
                               class="w-full px-4 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">管理費 (¥)</label>
                        <input type="number" name="management_fee" value="${property.management_fee}"
                               class="w-full px-4 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                    </div>
                </div>

                <!-- 레이아웃 / 주소 -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">間取り (Layout)</label>
                        <input type="text" name="layout" value="${property.layout}" placeholder="例: 1R, 1LDK"
                               class="w-full px-4 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">住所</label>
                        <input type="text" name="address" value="${property.address}" required
                               class="w-full px-4 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                    </div>
                </div>
				<!-- 사진 수정 영역 추가 -->
				    <div>
				        <label class="block text-sm font-medium text-gray-700 mb-2">物件画像変更 (新しい画像をアップロードすると置き換わります)</label>
				        <input type="file" name="uploadFiles" multiple 
				               class="w-full px-4 py-2.5 rounded-xl border border-gray-200 text-sm file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
				    </div>
                <!-- 상세 설명 -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">詳細説明</label>
                    <textarea name="description" rows="6" required
                              class="w-full px-4 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">${property.description}</textarea>
                </div>

                <!-- 버튼 그룹 -->
                <div class="flex items-center justify-end gap-3 pt-4 border-t border-gray-100">
                    <a href="/Property/detail?id=${property.property_id}" class="px-5 py-2.5 border border-gray-300 rounded-xl text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                        キャンセル
                    </a>
                    <button type="submit" class="px-6 py-2.5 bg-blue-600 text-white rounded-xl text-sm font-medium hover:bg-blue-700 transition shadow-sm">
                        修正
                    </button>
                </div>
            </form>

        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 py-6 text-center text-sm text-gray-500">
        <p>&copy; 2026 Uchiring Inc. All Rights Reserved.</p>
    </footer>

</body>
</html>