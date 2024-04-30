//display team orders by salesperson 

public with sharing class TeamOrdersController {
    
    // Method to retrieve team orders by salesperson
    public static List<Order> getTeamOrdersBySalesperson(Id salespersonId) {
        List<Order> teamOrders = new List<Order>();
        
        // Query for orders related to the specified salesperson using a bulk-friendly approach
        for (AggregateResult ar : [
            SELECT Id, AccountId, EffectiveDate, TotalAmount, Status
            FROM Order
            WHERE Account.OwnerId = :salespersonId
        ]) {
            Order ord = new Order(
                Id = (Id) ar.get('Id'),
                AccountId = (Id) ar.get('AccountId'),
                EffectiveDate = (Date) ar.get('EffectiveDate'),
                TotalAmount = (Decimal) ar.get('TotalAmount'),
                Status = (String) ar.get('Status')
            );
            teamOrders.add(ord);
        }
        
        return teamOrders;
    }
}
