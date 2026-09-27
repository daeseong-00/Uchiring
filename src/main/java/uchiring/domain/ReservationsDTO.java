package uchiring.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ReservationsDTO {
	private int reservation_id;
	private int property_id;
	private int user_id;
	private Timestamp reservation_date; 
    private String status;
    private Timestamp created_at;
    private String property_title; 
    private String user_name;
}
