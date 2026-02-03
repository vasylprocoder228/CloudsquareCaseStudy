/**
 * @description Strategy interface for account matching algorithms
 */
public interface IAccountMatchingStrategy {
    /**
     * @description Attempts to find a matching Account
     * @param submission The application data
     * @return Matching Account or null if no match found
     */
    Account findMatch(ApplicationSubmissionDTO submission);
    
    /**
     * @description Returns the name of this strategy for logging/debugging
     */
    String getStrategyName();
}