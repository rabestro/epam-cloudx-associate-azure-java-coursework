package com.chtrembl.petstoreapp.exception;

public class CustomException extends RuntimeException {

    public CustomException(String message, Throwable cause) {
        super(message, cause);
    }
}
