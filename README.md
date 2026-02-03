# CloudsquareCaseStudy
Salesforce Developer Case Study Vasyl Opyruk
Overview
This system allows external partners to submit applications into Salesforce through two channels:

A public-facing form on an Experience Cloud site (LWC component)
A REST API webhook endpoint for external system integrations

When an application comes in, the system tries to match it against existing Accounts. If we find a match, we create an Opportunity. If not, we create a Lead.

Overall Design
I built this solution around three main components:
1. Data Transfer Object (DTO)
I created ApplicationSubmissionDTO as a single source of truth for application data. This DTO is used everywhere - in the LWC component, the REST endpoint, and when creating Lead/Opportunity records. 
The benefit here is simple: if we need to add or remove a field later , we only update it in one place - the DTO class. Without this, we'd have to update the LWC JavaScript, the REST endpoint parsing logic, and the record creation methods separately. This approach keeps everything in sync and makes maintenance much easier.

2. Strategy Pattern for Account Matching
I used the Strategy Pattern for account matching because the requirements clearly show different matching rules with priority (Tax ID first, then Company Name). By creating an IAccountMatchingStrategy interface and separate strategy classes (TaxIdMatchingStrategy, CompanyNameMatchingStrategy), we can easily add new matching strategies in the future without touching existing code. The AccountMatcher class orchestrates these strategies in priority order.
3. Centralized Service Layer
ApplicationProcessingService handles all the business logic - validation, matching, and record creation. This service is called by both the LWC component and the REST endpoint, so the business logic is identical regardless of where the submission comes from.

Key Tradeoffs
Security Mode Choice
I used without sharing for the matching strategies because guest users on the public Experience Cloud site typically don't have read access to the Account object. For a production system I'd recommend reviewing this decision.

API Key Authentication
For the webhook endpoint, I implemented a simple header-based API key check (X-Test-Key). This is fine for a proof of concept, but in production we'd want to use smth more advanced.

What I Intentionally Didn't Implement Yet (And Why)
Audit/Logging Object for API Requests
I didn't create a custom object to track incoming webhook requests with their full request/response payloads. Here's why:
In a production system, you absolutely want this - a custom object like Application_Submission_Log__c 

This would be invaluable for:

Debugging integration issues
Security auditing (who's calling our API and when)
Compliance requirements
Monitoring submission volume and success rates

I left it out to keep the exercise focused on the core architectural patterns, but it's straightforward to add later.

Enhanced Error Handling
Current error handling returns generic messages to API callers. Production would benefit from:

Structured error response objects with error codes
Validation Errors
Custom exception classes for different error types


Test Data Factory Class
While it's a Salesforce best practice to create a centralized TestDataFactory class for generating test data (improves readability, reduces duplication, easier maintenance), I kept the test data creation inline within each test class for this exercise. This makes each test self-contained and easier to review independently without jumping between files. In a production codebase with dozens of test classes, a TestDataFactory would be essential, but for a small case study with 6 test classes, inline data creation keeps things straightforward and demonstrates that I understand how to write tests without adding unnecessary complexity.


