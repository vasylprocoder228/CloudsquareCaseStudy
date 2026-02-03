/**
 * @description Matches accounts by Company Name
 */
public without sharing class CompanyNameMatchingStrategy implements IAccountMatchingStrategy {
    
    public Account findMatch(ApplicationSubmissionDTO submission) {

        if (String.isBlank(submission.companyName)) {
            return null;
        }
        
        List<Account> matches = [
            SELECT Id, Name
            FROM Account
            WHERE Company_Name__c = :submission.companyName
            LIMIT 1
        ];
        
        return matches.isEmpty() ? null : matches[0];
    }
    
    public String getStrategyName() {
        return 'Company Name Matching';
    }
}