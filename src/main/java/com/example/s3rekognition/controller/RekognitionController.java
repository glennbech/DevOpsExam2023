package com.example.s3rekognition.controller;

import com.amazonaws.services.rekognition.AmazonRekognition;
import com.amazonaws.services.rekognition.AmazonRekognitionClientBuilder;
import com.amazonaws.services.rekognition.model.*;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ListObjectsV2Result;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.example.s3rekognition.PPEClassificationResponse;
import com.example.s3rekognition.PPEResponse;
import io.micrometer.core.annotation.Timed;
import io.micrometer.core.instrument.Gauge;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;


@RestController
public class RekognitionController implements ApplicationListener<ApplicationReadyEvent> {

    private final AmazonS3 s3Client;
    private final AmazonRekognition rekognitionClient;

    private final MeterRegistry meterRegistry;

    private static final Logger logger = Logger.getLogger(RekognitionController.class.getName());


    @Autowired
    public RekognitionController(MeterRegistry meterRegistry) {
        this.s3Client = AmazonS3ClientBuilder.standard().build();
        this.rekognitionClient = AmazonRekognitionClientBuilder.standard().build();
        this.meterRegistry = meterRegistry;
    }

    /**
     * This endpoint takes an S3 bucket name in as an argument, scans all the
     * Files in the bucket for Protective Gear Violations.
     * <p>
     *
     * @param bucketName the name of the bucket that contains the images to be used
     * @return a json with information about which images had violations and not
     */
    @GetMapping(value = "/scan-ppe", consumes = "*/*", produces = "application/json")
    @ResponseBody
    @Timed(value = "latency_noMask")
    public ResponseEntity<PPEResponse> scanForPPE(@RequestParam String bucketName) {
        int violations = 0;
        int nonViolations = 0;
        int people = 0;

        // List all objects in the S3 bucket
        ListObjectsV2Result imageList = s3Client.listObjectsV2(bucketName);

        // This will hold all of our classifications
        List<PPEClassificationResponse> classificationResponses = new ArrayList<>();

        // This is all the images in the bucket
        List<S3ObjectSummary> images = imageList.getObjectSummaries();

        // Iterate over each object and scan for PPE
        for (S3ObjectSummary image : images) {
            logger.info("scanning " + image.getKey());

            // This is where the magic happens, use AWS rekognition to detect PPE
            DetectProtectiveEquipmentRequest request = new DetectProtectiveEquipmentRequest()
                    .withImage(new Image()
                            .withS3Object(new S3Object()
                                    .withBucket(bucketName)
                                    .withName(image.getKey())))
                    .withSummarizationAttributes(new ProtectiveEquipmentSummarizationAttributes()
                            .withMinConfidence(80f)
                            .withRequiredEquipmentTypes("FACE_COVER"));

            DetectProtectiveEquipmentResult result = rekognitionClient.detectProtectiveEquipment(request);

            // If any person on an image lacks PPE on the face, it's a violation of regulations
            boolean violation = isViolation(result, "FACE");
            if (violation) violations++; else nonViolations++;

            logger.info("scanning " + image.getKey() + ", violation result " + violation);
            // Categorize the current image as a violation or not.
            int personCount = result.getPersons().size();
            people += personCount;
            PPEClassificationResponse classification = new PPEClassificationResponse(image.getKey(), personCount, violation);
            classificationResponses.add(classification);
        }
        Number violationsPercentage = ((double) violations / (violations + nonViolations)) * 100;
        meterRegistry.gauge("noMask_violations_percentage", violationsPercentage);
        registerToMeter("violations_noMask", violations, nonViolations, "noMask_violations_percentage", people);

        PPEResponse ppeResponse = new PPEResponse(bucketName, classificationResponses);
        return ResponseEntity.ok(ppeResponse);
    }

    /**
     * This endpoint is an experimental one where VerneVokterne
     * wanted to test their software against construction workers that are doing
     * some renovations at the hospital, ensuring they are wearing protective helmets
     *
     * @param bucketName the name of the bucket that contains the images to be used
     * @return a json with information about which images had violations and not
     */
    @GetMapping(value = "/scan-construction", consumes = "*/*", produces = "application/json")
    @ResponseBody
    @Timed(value = "latency_noHelmet")
    public ResponseEntity<PPEResponse> scanForHeadCover(@RequestParam String bucketName) {
        int violations = 0;
        int nonViolations = 0;
        int people = 0;

        // List all objects in the S3 bucket
        ListObjectsV2Result imageList = s3Client.listObjectsV2(bucketName);

        // This will hold all of our classifications
        List<PPEClassificationResponse> classificationResponses = new ArrayList<>();

        // This is all the images in the bucket
        List<S3ObjectSummary> images = imageList.getObjectSummaries();

        for (S3ObjectSummary image : images) {
            logger.info("scanning" + image.getKey());

            DetectProtectiveEquipmentRequest request = new DetectProtectiveEquipmentRequest()
                    .withImage(new Image()
                            .withS3Object(new S3Object()
                                    .withBucket(bucketName)
                                    .withName(image.getKey())))
                    .withSummarizationAttributes(new ProtectiveEquipmentSummarizationAttributes()
                            .withMinConfidence(80f)
                            .withRequiredEquipmentTypes("HEAD_COVER"));

            DetectProtectiveEquipmentResult result = rekognitionClient.detectProtectiveEquipment(request);

            // If any person on an image lacks PPE on the head, it's a violation of regulations
            boolean violation = isViolation(result, "HEAD");
            if (violation) violations++; else nonViolations++;

            logger.info("scanning " + image.getKey() + ", violation result " + violation);
            // Categorize the current image as a violation or not.
            int personCount = result.getPersons().size();
            people += personCount;
            PPEClassificationResponse classification = new PPEClassificationResponse(image.getKey(), personCount, violation);
            classificationResponses.add(classification);
        }
        Number violationsPercentage = ((double) violations / (violations + nonViolations)) * 100;
        meterRegistry.gauge("noHelmet_violations_percentage", violationsPercentage);
        registerToMeter("violations_noHelmet", violations, nonViolations, "noHelmet_violations_percentage", people);


        PPEResponse ppeResponse = new PPEResponse(bucketName, classificationResponses);
        return ResponseEntity.ok(ppeResponse);
    }

    /**
     * This endpoint checks works in a laboratory for face, and hand covers
     *
     * @param bucketName the name of the bucket that contains the images to be used
     * @return a json with information about which images had violations and not
     */
    @GetMapping(value = "/scan-full-ppe", consumes = "*/*", produces = "application/json")
    @ResponseBody
    @Timed(value = "latency_noMaskOrGlove")
    public ResponseEntity<PPEResponse> scanForFullPPE(@RequestParam String bucketName) {
        int violations = 0;
        int nonViolations = 0;
        int people = 0;

        // List all objects in the S3 bucket
        ListObjectsV2Result imageList = s3Client.listObjectsV2(bucketName);

        // This will hold all of our classifications
        List<PPEClassificationResponse> classificationResponses = new ArrayList<>();

        // This is all the images in the bucket
        List<S3ObjectSummary> images = imageList.getObjectSummaries();

        for (S3ObjectSummary image : images) {
            logger.info("scanning" + image.getKey());

            DetectProtectiveEquipmentRequest request = new DetectProtectiveEquipmentRequest()
                    .withImage(new Image()
                            .withS3Object(new S3Object()
                                    .withBucket(bucketName)
                                    .withName(image.getKey())))
                    .withSummarizationAttributes(new ProtectiveEquipmentSummarizationAttributes()
                            .withMinConfidence(80f)
                            .withRequiredEquipmentTypes("FACE_COVER")
                            .withRequiredEquipmentTypes("HAND_COVER"));

            DetectProtectiveEquipmentResult result = rekognitionClient.detectProtectiveEquipment(request);

            // If any person on an image lacks PPE on the face and hands, it's a violation of regulations
            boolean violation = isViolation(result, "FACE");
            if (!violation) {
                violation = isViolation(result, "HAND");
            }
            if (violation) violations++; else nonViolations++;

            logger.info("scanning " + image.getKey() + ", violation result " + violation);
            // Categorize the current image as a violation or not.
            int personCount = result.getPersons().size();
            people += personCount;
            PPEClassificationResponse classification = new PPEClassificationResponse(image.getKey(), personCount, violation);
            classificationResponses.add(classification);
        }
        Number violationsPercentage = ((double) violations / (violations + nonViolations)) * 100;
        meterRegistry.gauge("noMaskOrGlove_violations_percentage", violationsPercentage);
        registerToMeter("violations_noMaskOrGlove", violations, nonViolations, "noMaskOrGlove_violations_percentage", people);

        PPEResponse ppeResponse = new PPEResponse(bucketName, classificationResponses);
        return ResponseEntity.ok(ppeResponse);
    }

    /**
     * Detects if the image has a protective gear violation for the FACE bodypart-
     * It does so by iterating over all persons in a picture, and then again over
     * each body part of the person. If the body part is a FACE and there is no
     * protective gear on it, a violation is recorded for the picture.
     * <p>
     * Update: Has been altered to take in a body part to check different parts
     *
     * @param result takes in the result of the rekognition check
     * @return a bool, determining which part there is a violation of
     */
    private static boolean isViolation(DetectProtectiveEquipmentResult result, String partOfBody) {
        return result.getPersons().stream()
                .flatMap(p -> p.getBodyParts().stream())
                .anyMatch(bodyPart -> bodyPart.getName().equals(partOfBody)
                        && bodyPart.getEquipmentDetections().isEmpty());
    }


    @Timed
    public void registerToMeter(String violationType, int violations, int nonViolations, String violationTypePercentage, int people) {

        meterRegistry.counter(violationType).increment(violations);
        meterRegistry.counter("violations_total").increment(violations);
        meterRegistry.gauge("people_count", people);
        System.out.println(people);
    }

    @Override
    public void onApplicationEvent(ApplicationReadyEvent applicationReadyEvent) {


    }

}

