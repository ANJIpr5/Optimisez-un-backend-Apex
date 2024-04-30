public without sharing class MyTeamOrdersController {
    // Method to calculate the sum of TotalAmount for orders related to a specific salesperson
    public static Decimal calculateTotalSumOfOrdersForSalesperson(Id salespersonId) {
        Decimal totalSum = 0;
        
        // Query for the sum of TotalAmount for orders related to the specified salesperson
        List<AggregateResult> groupedResults = [SELECT SUM(TotalAmount) total
                                                 FROM Order
                                                 WHERE Account.OwnerId = :salespersonId];
        
        // Retrieve the sum from the aggregate result (there should be only one result)
        if (!groupedResults.isEmpty()) {
            totalSum = (Decimal) groupedResults[0].get('total');
        }
        
        return totalSum;
    }
}
