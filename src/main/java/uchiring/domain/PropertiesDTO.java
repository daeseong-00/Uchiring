package uchiring.domain;

import lombok.Data;

@Data
public class PropertiesDTO {
	private	int property_id;
	private int agent_id;
	private String title;
	private String description;
	private int price;
	private int management_fee;
    private String layout;
	private String address;
	private String image_url;
	private String created_at;
}
