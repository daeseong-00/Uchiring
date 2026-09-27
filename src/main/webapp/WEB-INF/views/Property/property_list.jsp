<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>物件一覧 - ウチリング</title>
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
                <c:if test="${not empty sessionScope.user and sessionScope.user.role eq 'AGENT'}">
                    <a href="/Property/register" class="text-sm font-medium bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition">
                        物件登録
                    </a>
                </c:if>
                <a href="/" class="text-sm font-medium text-gray-600 hover:text-blue-600 transition">
                    ホーム
                </a>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="flex-grow max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 w-full">
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-900">物件一覧</h1>
            <p class="text-sm text-gray-500 mt-1">ウチリングがおすすめする最新の物件情報です。</p>
        </div>
	<%-- 매물 검색 바 (레이아웃 필터 추가) --%>
        <form action="/Property/search" method="get" class="flex flex-col sm:flex-row gap-2 mb-4">
            <!-- 레이아웃 선택 셀렉트 박스 -->
            <select name="layout" class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white text-sm">
                <option value="">間取り</option>
                <option value="1R" ${selectedLayout eq '1R' ? 'selected' : ''}>1R</option>
                <option value="1K" ${selectedLayout eq '1K' ? 'selected' : ''}>1K</option>
                <option value="1DK" ${selectedLayout eq '1DK' ? 'selected' : ''}>1DK</option>
                <option value="1LDK" ${selectedLayout eq '1LDK' ? 'selected' : ''}>1LDK</option>
                <option value="2K" ${selectedLayout eq '2K' ? 'selected' : ''}>2K</option>
                <option value="2DK" ${selectedLayout eq '2DK' ? 'selected' : ''}>2DK</option>
                <option value="2LDK" ${selectedLayout eq '2LDK' ? 'selected' : ''}>2LDK</option>
            </select>

            <input type="text" name="keyword" value="${keyword}" placeholder="地域または物件タイトルを入力してください。" 
                   class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm">
            
            <button type="submit" class="px-6 py-2 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 transition text-sm">
                検索
            </button>
        </form>

        <%-- 검색어(keyword)가 존재할 때만 검색 결과 건수 표시 --%>
        <c:if test="${not empty keyword}">
            <div class="mb-6 text-sm text-gray-600">
                「<span class="font-bold text-blue-600">${keyword}</span>」の検索結果：
                <span class="font-bold text-gray-900">${totalCount}</span>件の物件が見つかりました。
            </div>
        </c:if>
        <!-- 매물 카드 그리드 -->
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
            <c:choose>
                <c:when test="${empty propertyList}">
                    <div class="col-span-full text-center py-20 bg-white rounded-2xl border border-gray-100">
                        <p class="text-gray-400 text-base">登録された物件はありません。</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="property" items="${propertyList}">
                        <!-- 콤마로 된 이미지 중 첫 번째 사진 추출 로직 -->
                        <c:set var="firstImage" value="" />
                        <c:if test="${not empty property.image_url}">
                            <c:set var="images" value="${fn:split(property.image_url, ',')}" />
                            <c:set var="firstImage" value="${images[0]}" />
                        </c:if>

                        <a href="/Property/detail?id=${property.property_id}" 
                           class="bg-white rounded-2xl overflow-hidden border border-gray-100 shadow-sm hover:shadow-md transition flex flex-col group">
                            
                            <!-- 썸네일 이미지 영역 -->
                            <div class="relative h-48 bg-gray-200 overflow-hidden">
                                <c:choose>
                                    <c:when test="${not empty firstImage}">
                                        <img src="/upload/${firstImage}" alt="物件画像" 
                                             class="w-full h-full object-cover group-hover:scale-105 transition duration-300">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-full h-full flex items-center justify-center text-gray-400 text-sm">No Image</div>
                                    </c:otherwise>
                                </c:choose>
                                <span class="absolute top-3 left-3 bg-blue-600 text-white text-xs font-semibold px-2.5 py-1 rounded-md shadow">
                                    ${property.layout}
                                </span>
                            </div>

                            <!-- 정보 영역 -->
                            <div class="p-5 flex flex-col flex-grow justify-between">
                                <div>
                                    <h2 class="text-base font-bold text-gray-900 group-hover:text-blue-600 transition line-clamp-1">
                                        ${property.title}
                                    </h2>
                                    <p class="text-xs text-gray-500 mt-1 line-clamp-1">${property.address}</p>
                                </div>
                                <div class="mt-4 pt-4 border-t border-gray-100 flex items-center justify-between">
                                    <div>
                                        <span class="text-xs text-gray-400 block">家賃</span>
                                        <span class="text-lg font-bold text-blue-600">¥${property.price}</span>
                                    </div>
                                    <div class="text-right">
                                        <span class="text-xs text-gray-400 block">管理費</span>
                                        <span class="text-sm font-medium text-gray-700">¥${property.management_fee}</span>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 동적 페이징 버튼 영역 -->
        <div class="flex justify-center mt-10 gap-2">
            <c:forEach begin="1" end="${totalPage}" var="i">
                <%-- 검색 상태일 때와 일반 목록일 때의 페이징 링크 분기 (layout 파라미터 포함) --%>
                <c:choose>
                    <c:when test="${not empty keyword or not empty selectedLayout}">
                        <c:set var="pageUrl" value="/Property/search?keyword=${keyword}&layout=${selectedLayout}&page=${i}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="pageUrl" value="/Property/list?page=${i}" />
                    </c:otherwise>
                </c:choose>

                <a href="${pageUrl}" 
                   class="px-3.5 py-1.5 border rounded-lg text-sm font-medium transition 
                   <c:if test='${currentPage eq i}'>bg-blue-600 text-white border-blue-600 shadow-sm</c:if>
                   <c:if test='${currentPage ne i}'>bg-white text-gray-700 hover:bg-gray-100 border-gray-200</c:if>">
                    ${i}
                </a>
            </c:forEach>
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