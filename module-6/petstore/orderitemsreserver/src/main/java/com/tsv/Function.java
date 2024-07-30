package com.tsv;

import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.HttpMethod;
import com.microsoft.azure.functions.HttpRequestMessage;
import com.microsoft.azure.functions.HttpResponseMessage;
import com.microsoft.azure.functions.HttpStatus;
import com.microsoft.azure.functions.annotation.AuthorizationLevel;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.HttpTrigger;
import com.tsv.dto.OrderReservationRequest;
import com.tsv.service.BlobService;

import java.util.Optional;

public class Function {

    private final String BLOB_CONNECTION_STRING =
            System.getenv("BLOB_CONNECTION_STRING") != null ? System.getenv("BLOB_CONNECTION_STRING") :
                    "not set";

    private final BlobService blobService = new BlobService(BLOB_CONNECTION_STRING);

    @FunctionName("saveOrUpdateOrderItems")
    public HttpResponseMessage run(
            @HttpTrigger(
                    name = "req",
                    methods = {HttpMethod.GET, HttpMethod.POST}, // Ensure this is set to POST
                    authLevel = AuthorizationLevel.ANONYMOUS)
            HttpRequestMessage<Optional<OrderReservationRequest>> request,
            final ExecutionContext context) {

        Optional<OrderReservationRequest> body = request.getBody();

        // Check if the request body is present
        if (body.isEmpty()) {
            return request.createResponseBuilder(HttpStatus.BAD_REQUEST)
                    .body("Missing OrderReservationRequest body").build();
        } else {
            // Retrieve the request body
            OrderReservationRequest orderRequest = body.get();

            blobService.createFileInBlobStorage(orderRequest.getSessionId(), orderRequest.getOrderJSON());
            return request.createResponseBuilder(HttpStatus.OK)
                    .body("File created for orderRequest.getSessionId(): " + orderRequest.getSessionId()).build();
        }
    }
}