@IsTest
private class ApplicationProcessingServiceTest {

    @IsTest
    static void testSuccessfulLeadCreation() {
        ApplicationSubmissionDTO dto = new ApplicationSubmissionDTO();
        dto.companyName = 'New Lead Company';
        dto.email = 'lead@test.com';
        dto.phone = '555-0001';
        dto.contactFirstName = 'Jane';
        dto.contactLastName = 'Smith';
        dto.source = 'Community';

        Test.startTest();
        ApplicationProcessingService.ProcessingResult result = ApplicationProcessingService.processApplication(dto);
        Test.stopTest();

        System.assertEquals(true, result.success);

        List<Lead> leads = [SELECT Id, Company FROM Lead WHERE Email = 'lead@test.com'];
        System.assertEquals(1, leads.size());
    }

    @IsTest
    static void testSuccessfulOpportunityCreationTaxId() {
        Account acc = new Account(
                Name = 'Existing Account',
                Company_Name__c = 'Existing Account',
                Federal_Tax_ID__c = '999999999'
        );
        insert acc;

        ApplicationSubmissionDTO dto = new ApplicationSubmissionDTO();
        dto.companyName = 'Existing Account';
        dto.email = 'opp@test.com';
        dto.phone = '555-0002';
        dto.contactFirstName = 'Bob';
        dto.contactLastName = 'Johnson';
        dto.federalTaxId = '999999999';
        dto.source = 'Community';

        Test.startTest();
        ApplicationProcessingService.ProcessingResult result = ApplicationProcessingService.processApplication(dto);
        Test.stopTest();

        List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = :acc.Id];
        System.assertEquals(1, opps.size());
    }

    @IsTest
    static void testSuccessfulOpportunityCreationCompanyName() {
        Account acc = new Account(
                Name = 'Existing Account',
                Company_Name__c = 'Existing Account',
                Federal_Tax_ID__c = '999999999'
        );
        insert acc;

        ApplicationSubmissionDTO dto = new ApplicationSubmissionDTO();
        dto.companyName = 'Existing Account';
        dto.email = 'opp@test.com';
        dto.phone = '555-0002';
        dto.contactFirstName = 'Bob';
        dto.contactLastName = 'Johnson';
        dto.source = 'Community';

        Test.startTest();
        ApplicationProcessingService.ProcessingResult result = ApplicationProcessingService.processApplication(dto);
        Test.stopTest();

        List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = :acc.Id];
        System.assertEquals(1, opps.size());
    }

    @IsTest
    static void testValidationError() {
        ApplicationSubmissionDTO dto = new ApplicationSubmissionDTO();
        dto.companyName = 'Test';

        Test.startTest();
        ApplicationProcessingService.ProcessingResult result =
                ApplicationProcessingService.processApplication(dto);
        Test.stopTest();
    }
}