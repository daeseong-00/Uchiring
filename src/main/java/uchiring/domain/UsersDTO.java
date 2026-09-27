package uchiring.domain;

import lombok.Data;

@Data
public class UsersDTO {
	private int user_id;
	private String email;
	private String password;
	private String name;
	private String role;
	private String phone;
}
