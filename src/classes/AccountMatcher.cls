/**
 * @description Orchestrates account matching using multiple strategies
 */
public class AccountMatcher {

    private List<IAccountMatchingStrategy> strategies;

    public AccountMatcher() {
        this.strategies = new List<IAccountMatchingStrategy>{
                new TaxIdMatchingStrategy(),
                new CompanyNameMatchingStrategy()
        };
    }

    public AccountMatcher(List<IAccountMatchingStrategy> customStrategies) {
        this.strategies = customStrategies;
    }

    public MatchResult findMatch(ApplicationSubmissionDTO submission) {
        for (IAccountMatchingStrategy strategy : strategies) {
            Account match = strategy.findMatch(submission);
            if (match != null) {
                return new MatchResult(match, strategy.getStrategyName());
            }
        }

        return new MatchResult(null, 'No Match Found');
    }

    public class MatchResult {
        public Account matchedAccount { get; set; }
        public String strategyUsed { get; set; }
        public Boolean hasMatch { get; set; }

        public MatchResult(Account account, String strategy) {
            this.matchedAccount = account;
            this.strategyUsed = strategy;
            this.hasMatch = (account != null);
        }
    }
}