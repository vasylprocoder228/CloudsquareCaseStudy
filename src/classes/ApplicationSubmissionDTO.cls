/**
 * @description Data Transfer Object for application submissions
 */
public class ApplicationSubmissionDTO {
    @AuraEnabled public String companyName { get; set; }
    @AuraEnabled public String email { get; set; }
    @AuraEnabled public String phone { get; set; }
    @AuraEnabled public String contactFirstName { get; set; }
    @AuraEnabled public String contactLastName { get; set; }
    @AuraEnabled public String federalTaxId { get; set; }
    @AuraEnabled public Decimal annualRevenue { get; set; }
    @AuraEnabled public String source { get; set; } // 'Community' or 'Webhook'
    
    public List<String> validate() {
        List<String> errors = new List<String>();
        
        if (String.isBlank(companyName)) {
            errors.add('Company Name is required');
        }
        if (String.isBlank(email)) {
            errors.add('Email is required');
        }
        if (String.isBlank(phone)) {
            errors.add('Phone is required');
        }
        if (String.isBlank(contactFirstName)) {
            errors.add('Contact First Name is required');
        }
        if (String.isBlank(contactLastName)) {
            errors.add('Contact Last Name is required');
        }
        if (String.isBlank(source)) {
            errors.add('Source is required');
        }
        
        return errors;
    }
    
    public Boolean isValid() {
        return validate().isEmpty();
    }
}