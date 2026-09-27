<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>新規会員登録 - ウチリング</title>
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
            <a href="/User/user_login" class="text-sm font-medium text-gray-600 hover:text-blue-600 transition">
                ログインへ
            </a>
        </div>
    </header>

    <!-- Main Form Section -->
    <main class="flex-grow flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full bg-white p-8 rounded-2xl shadow-sm border border-gray-100">
            <div class="text-center mb-8">
                <h1 class="text-2xl font-bold text-gray-900">新規会員登録</h1>
                <p class="text-sm text-gray-500 mt-1">ウチリングで簡単にお部屋の訪問予約を始めましょう</p>
            </div>

            <form action="/User/user_insert" method="post" class="space-y-5">
                
                <!-- お名前 (Name) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">お名前</label>
                    <input type="text" name="name" required 
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm"
                           placeholder="例：山田 太郎">
                </div>

                <!-- メールアドレス (Email / ID) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">メールアドレス（ログインID）</label>
                    <div class="flex gap-2">
                        <input type="email" id="email" name="email" required 
                               class="flex-grow px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm"
                               placeholder="example@uchiring.com">
                        <button type="button" id="checkEmailBtn" 
                                class="bg-gray-100 text-gray-700 text-xs font-medium px-4 py-2.5 rounded-lg hover:bg-gray-200 transition whitespace-nowrap">
                            重複確認
                        </button>
                    </div>
                    <p id="emailCheckResult" class="text-xs mt-1"></p>
                </div>

                <!-- 이메일 인증번호 입력 영역 (숨김 처리 상태로 시작) -->
                <div id="authCodeArea" class="hidden space-y-2 bg-gray-50 p-3 rounded-lg border border-gray-200">
                    <label class="block text-xs font-medium text-gray-700">認証コードを入力してください</label>
                    <div class="flex gap-2">
                        <input type="text" id="authCodeInput" 
                               class="flex-grow px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none text-sm bg-white"
                               placeholder="6桁のコード">
                        <button type="button" id="verifyCodeBtn" 
                                class="bg-blue-600 text-white text-xs font-medium px-4 py-2 rounded-lg hover:bg-blue-700 transition whitespace-nowrap">
                            確認
                        </button>
                    </div>
                    <p id="authCodeResult" class="text-xs"></p>
                </div>
                <!-- 인증 완료 여부를 숨겨서 체크할 수도 있음 (선택사항) -->
                <input type="hidden" id="isEmailVerified" value="false">

               <!-- パスワード (Password) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">パスワード</label>
                    <input type="password" id="password" name="password" required 
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm"
                           placeholder="••••••••">
                </div>

                <!-- パスワード確認 (Password Confirm) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">パスワード（確認）</label>
                    <input type="password" id="passwordConfirm" required 
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm"
                           placeholder="••••••••">
                    <p id="passwordCheckResult" class="text-xs mt-1"></p>
                </div>

                <!-- 電話番号 (Phone) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">電話番号</label>
                    <input type="text" name="phone" 
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm"
                           placeholder="090-1234-5678">
                </div>

                <!-- 権限 (Role) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">アカウント種別</label>
                    <select name="role" class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm bg-white">
                        <option value="USER">一般ユーザー（お部屋を探す方）</option>
                        <option value="AGENT">不動産エージェント（物件を登録する方）</option>
                    </select>
                </div>

                <!-- 登録ボタン -->
                <button type="submit" 
                        class="w-full bg-blue-600 text-white font-bold py-3 rounded-xl shadow-md hover:bg-blue-700 transition text-sm mt-2">
                    登録する
                </button>
            </form>

            <div class="text-center mt-6 text-sm text-gray-500">
                すでにアカウントをお持ちですか？ 
                <a href="/User/user_login" class="text-blue-600 font-medium hover:underline">ログイン</a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 py-6 text-center text-sm text-gray-500">
        <p>&copy; 2026 Uchiring Inc. All Rights Reserved.</p>
    </footer>

    <!-- AJAX 스크립트 (중복 체크 연동용 예시) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        let generatedCode = ""; // 서버에서 받은 인증번호를 담을 변수
        let isVerified = false;  // 이메일 인증 완료 여부

        // 1. 이메일 중복 체크 및 인증번호 전송 프로세스
        $('#checkEmailBtn').click(function() {
            let email = $('#email').val();
            if(!email) {
                alert('メールアドレスを入力してください。');
                return;
            }
            
            // 먼저 중복 체크 수행
            $.ajax({
                type: 'POST',
                url: '${pageContext.request.contextPath}/User/user_emailCheck',
                data: { email: email },
                success: function(result) {
                    let resText = $('#emailCheckResult');
                    if(result == '0') {
                        resText.text('このメールアドレスは使用可能です。認証コードを送信します...').removeClass('text-red-500').addClass('text-green-600');
                        
                        // 중복이 없으면 바로 이메일 인증번호 전송 요청
                        $.ajax({
                            type: 'POST',
                            url: '${pageContext.request.contextPath}/User/user_email',
                            data: { email: email },
                            success: function(tempNum) {
                                generatedCode = tempNum.trim(); // 서버가 리턴한 인증번호 저장
                                alert('認証コードがメールに送信されました。');
                                $('#authCodeArea').removeClass('hidden'); // 인증번호 입력창 노출
                            },
                            error: function() {
                                alert('メール送信に失敗しました。');
                            }
                        });

                    } else {
                        resText.text('すでに使用されているメールアドレスです。').removeClass('text-green-600').addClass('text-red-500');
                    }
                }
            });
        });

        // 2. 인증번호 확인 버튼 클릭
        $('#verifyCodeBtn').click(function() {
            let userInputCode = $('#authCodeInput').val();
            let authResult = $('#authCodeResult');

            if(userInputCode === generatedCode && generatedCode !== "") {
                isVerified = true;
                authResult.text('メール認証が完了しました。').removeClass('text-red-500').addClass('text-green-600');
                $('#email').attr('readonly', true); // 인증 후 이메일 변경 불가 처리
                $('#authCodeArea').addClass('bg-green-50');
            } else {
                isVerified = false;
                authResult.text('認証コードが一致しません。').removeClass('text-green-600').addClass('text-red-500');
            }
        });

        // 3. 폼 제출 시 이메일 인증 여부 검사
        $('form').submit(function(e) {
            if(!isVerified) {
                alert('メールアドレスの認証を完了してください。');
                e.preventDefault(); // 제출 막기
            }
        });
        
        // 비밀번호 일치 실시간 확인
        $('#passwordConfirm').on('keyup', function() {
            let pwd = $('#password').val();
            let pwdConfirm = $(this).val();
            let resText = $('#passwordCheckResult');

            if(pwdConfirm === '') {
                resText.text('');
                return;
            }

            if(pwd === pwdConfirm) {
                resText.text('パスワードが一致しています。').removeClass('text-red-500').addClass('text-green-600');
            } else {
                resText.text('パスワードが一致していません。').removeClass('text-green-600').addClass('text-red-500');
            }
        });
    </script>
    <!-- 컨트롤러에서 넘어오는 알림 메시지 처리 -->
    <c:if test="${not empty msg}">
        <script>
            alert("${msg}");
        </script>
    </c:if>
</body>
</html>