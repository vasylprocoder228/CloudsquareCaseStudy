/**
 * @description REST API endpoint for external application submissions
 */
@RestResource(urlMapping='/v1/application-intake/*')
global with sharing class ApplicationIntakeRestResource {

    private static final String EXPECTED_API_KEY = 'test-12345';
    private static final String API_KEY_HEADER = 'X-Test-Key';

    @HttpPost
    global static APIResponse submitApplication() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            if (!isValidApiKey(req)) {
                res.statusCode = 401;
                return new APIResponse(false, 'Invalid or missing API key');
            }

            String requestBody = req.requestBody.toString();

            if (String.isBlank(requestBody)) {
                res.statusCode = 400;
                return new APIResponse(false, 'Request body is required');
            }

            ApplicationSubmissionDTO submission;
            try{
                submission = (ApplicationSubmissionDTO)
                        JSON.deserialize(requestBody, ApplicationSubmissionDTO.class);
            } catch (JSONException e) {
                res.statusCode = 400;
                return new APIResponse(false, 'Invalid JSON format');
            }

            submission.source = 'Webhook';

            ApplicationProcessingService.ProcessingResult result =
                    ApplicationProcessingService.processApplication(submission);

            if (result.success) {
                res.statusCode = 201;
                return new APIResponse(true, result.message);
            } else {
                res.statusCode = 400;
                return new APIResponse(false, result.message);
            }

        }  catch (Exception e) {
            res.statusCode = 500;
            return new APIResponse(false, 'An error occurred processing your request');
        }
    }

    private static Boolean isValidApiKey(RestRequest req) {
        String apiKey = req.headers.get(API_KEY_HEADER);

        if (String.isBlank(apiKey)) {
            return false;
        }

        return apiKey == EXPECTED_API_KEY;
    }

    global class APIResponse {
        public Boolean success;
        public String message;

        public APIResponse(Boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }
}