/**
 * @description Service class for processing application submissions
 */
public with sharing class ApplicationProcessingService {

    @AuraEnabled
    public static ProcessingResult processApplication(ApplicationSubmissionDTO submission) {
        if (submission == null) {
            return new ProcessingResult(false, 'Submission data is required');
        }

        List<String> validationErrors = submission.validate();
        if (!validationErrors.isEmpty()) {
            return new ProcessingResult(false, String.join(validationErrors, '; '));
        }

        try {
            return processInternal(submission);
        } catch (DmlException e) {
            return new ProcessingResult(false, 'DML error');
        } catch (Exception e) {
            return new ProcessingResult(false, 'Error processing application');
        }
    }

    @TestVisible
    private static ProcessingResult processInternal(ApplicationSubmissionDTO submission) {
        AccountMatcher matcher = new AccountMatcher();
        AccountMatcher.MatchResult matchResult = matcher.findMatch(submission);

        if (matchResult.hasMatch) {

            Opportunity opp = createOpportunity(submission, matchResult.matchedAccount);
            insert opp;
            return new ProcessingResult(true, 'Opportunity created successfully!'
            );
        } else {
            Lead lead = createLead(submission);
            insert lead;
            return new ProcessingResult(true, 'Lead created successfully!'
            );
        }
    }


    private static Opportunity createOpportunity(ApplicationSubmissionDTO submission, Account account) {
        return new Opportunity(
                Name = submission.companyName + ' - Application',
                AccountId = account.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount = submission.annualRevenue,
                LeadSource = submission.source
        );
    }


    private static Lead createLead(ApplicationSubmissionDTO submission) {
        return new Lead(
                Company = submission.companyName,
                FirstName = submission.contactFirstName,
                LastName = submission.contactLastName,
                Email = submission.email,
                Phone = submission.phone,
                AnnualRevenue = submission.annualRevenue,
                LeadSource = submission.source
        );
    }

    public class ProcessingResult {
        @AuraEnabled public Boolean success { get; set; }
        @AuraEnabled public String message { get; set; }

        public ProcessingResult(Boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }
}