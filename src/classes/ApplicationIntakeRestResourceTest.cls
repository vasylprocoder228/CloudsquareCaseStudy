@IsTest
private class ApplicationIntakeRestResourceTest {

    private static final String VALID_API_KEY = 'test-12345';
    private static final String API_KEY_HEADER = 'X-Test-Key';

    @IsTest
    static void testSuccessfulWebhookSubmission() {
        String jsonBody = JSON.serialize(new Map<String, Object>{
                'companyName' => 'Webhook Company',
                'email' => 'webhook@test.com',
                'phone' => '555-9999',
                'contactFirstName' => 'Webhook',
                'contactLastName' => 'User'
        });

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(jsonBody);
        req.headers.put(API_KEY_HEADER, VALID_API_KEY);
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ApplicationIntakeRestResource.APIResponse response =
                ApplicationIntakeRestResource.submitApplication();
        Test.stopTest();

        System.assertEquals(201, res.statusCode);
    }

    @IsTest
    static void testMissingApiKey() {
        String jsonBody = JSON.serialize(new Map<String, Object>{
                'companyName' => 'Test Company',
                'email' => 'test@test.com',
                'phone' => '555-0000',
                'contactFirstName' => 'Test',
                'contactLastName' => 'User'
        });

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(jsonBody);
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ApplicationIntakeRestResource.APIResponse response =
                ApplicationIntakeRestResource.submitApplication();
        Test.stopTest();

        System.assertEquals(401, res.statusCode);
    }

    @IsTest
    static void testInvalidApiKey() {
        String jsonBody = JSON.serialize(new Map<String, Object>{
                'companyName' => 'Test Company',
                'email' => 'test@test.com',
                'phone' => '555-0000',
                'contactFirstName' => 'Test',
                'contactLastName' => 'User'
        });

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(jsonBody);
        req.headers.put(API_KEY_HEADER, 'wrong-key');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ApplicationIntakeRestResource.APIResponse response =
                ApplicationIntakeRestResource.submitApplication();
        Test.stopTest();

        System.assertEquals(401, res.statusCode);
    }

    @IsTest
    static void testEmptyRequestBody() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('');
        req.headers.put(API_KEY_HEADER, VALID_API_KEY);
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ApplicationIntakeRestResource.APIResponse response =
                ApplicationIntakeRestResource.submitApplication();
        Test.stopTest();

        System.assertEquals(400, res.statusCode);
    }

    @IsTest
    static void testInvalidJson() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('invalid json');
        req.headers.put(API_KEY_HEADER, VALID_API_KEY);
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ApplicationIntakeRestResource.APIResponse response =
                ApplicationIntakeRestResource.submitApplication();
        Test.stopTest();
    }
}