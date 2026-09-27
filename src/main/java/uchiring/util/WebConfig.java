package uchiring.util;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 웹에서 /upload/** 주소로 요청하면, 로컬 PC의 C:/uchiring_upload/ 폴더 안의 파일을 보여줍니다.
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:///C:/uchiring_upload/");
    }
}