package com.tsv.service;

import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobContainerClientBuilder;
import com.azure.storage.blob.models.BlobHttpHeaders;

import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;

public class BlobService {

    private final String blobConnectionString;

    public BlobService(String blobConnectionString) {
        this.blobConnectionString = blobConnectionString;
    }

    public void createFileInBlobStorage(String fileNamePrefix, String fileContent) {
        // implementation
        BlobContainerClient blobContainerClient = createBlobContainerIfNotExist("orderitems");
        BlobClient client = blobContainerClient.getBlobClient(fileNamePrefix + "_products");

        // Convert the file content to a binary data stream
        ByteArrayInputStream dataStream = new ByteArrayInputStream(fileContent.getBytes(StandardCharsets.UTF_8));

        // Upload the stream to the blob, overwriting any existing blob with the same name
        client.upload(dataStream, fileContent.length(), true);

        // Optionally, set the content type of the blob to 'text/plain' or any appropriate value
        BlobHttpHeaders headers = new BlobHttpHeaders();
        headers.setContentType("application/json");
        client.setHttpHeaders(headers);
    }

    private BlobContainerClient createBlobContainerIfNotExist(String containerName) {
        BlobContainerClient blobContainerClient = new BlobContainerClientBuilder()
                .connectionString(this.blobConnectionString)
                .containerName(containerName)
                .buildClient();

        if (!blobContainerClient.exists()) {
            blobContainerClient.create();
        }

        return blobContainerClient;
    }
}
