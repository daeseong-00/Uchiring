package uchiring.service;

import java.util.Random;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EmailService {
	private final JavaMailSender emailSender;
    
    // 인증 번호 6자리 생성 메서드
    public String createCode() {
        Random random = new Random();
        StringBuilder key = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            key.append(random.nextInt(10));
        }
        return key.toString();
    }

    // 메일 양식 작성 및 전송
    public String sendEmail(String toEmail) {
        String authCode = createCode();
        
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("ウチリング 会員登録認証番号");
        message.setText("認証番号は " + authCode + " です。");
        
        emailSender.send(message);
        return authCode; // 사용자가 입력한 값과 비교하기 위해 리턴 (Redis나 세션에 저장 권장)
    }
}