package com.tsv;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

class EnvTest {

    private final String BLOB_CONNECTION_STRING =
            System.getenv("BLOB_CONNECTION_STRING") != null ? System.getenv("BLOB_CONNECTION_STRING") :
                    "not set";


    @Test
    void test() {
        System.out.println("BLOB_CONNECTION_STRING: " + BLOB_CONNECTION_STRING);
        Assertions.assertNotEquals("not set", BLOB_CONNECTION_STRING, "BLOB_CONNECTION_STRING is not set");
    }
}
