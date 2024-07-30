package com.tsv.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class OrderReservationRequest {

    private String sessionId;
    private String orderJSON;
}