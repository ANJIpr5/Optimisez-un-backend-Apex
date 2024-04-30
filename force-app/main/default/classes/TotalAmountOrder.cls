public with sharing class Service { // Method to calculate the total sum of orders
    public static Decimal calculateTotalSumOfOrders() {
        Decimal totalSum = 0;
        
        // Query for the total sum of orders
        AggregateResult[] groupedResults = [SELECT SUM(TotalAmount) total FROM Order];
        if (groupedResults.size() > 0) {
            totalSum = (Decimal) groupedResults[0].get('total');
        }
        
        return totalSum;
    }
    
    // Add more methods to calculate other business figures as needed
}


