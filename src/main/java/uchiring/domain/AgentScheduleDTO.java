package uchiring.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class AgentScheduleDTO {
	private int schedule_id;
    private int agent_id;
    private Timestamp start_date;
    private Timestamp end_date;   
    private String is_available;
}
