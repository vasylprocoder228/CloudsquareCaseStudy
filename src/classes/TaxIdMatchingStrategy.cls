/**
 * @description Matches accounts by Federal Tax ID
 */
public without sharing class TaxIdMatchingStrategy implements IAccountMatchingStrategy {
    
    public Account findMatch(ApplicationSubmissionDTO submission) {

        if (String.isBlank(submission.federalTaxId)) {
            return null;
        }
        
        
        List<Account> matches = [
            SELECT Id, Name, Federal_Tax_ID__c
            FROM Account
            WHERE Federal_Tax_ID__c = :submission.federalTaxId //OPTIONAL IS TO CLEAN FEDERAL TAX ID ( REMOVE DASHES AND SPACES )
            LIMIT 1
        ];
        
        return matches.isEmpty() ? null : matches[0];
    }
    
    public String getStrategyName() {
        return 'Federal Tax ID Matching';
    }
}