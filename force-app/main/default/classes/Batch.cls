global class UpdateSalesFiguresBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext context) {
        
        // Query for the accounts that need to be updated
        return Database.getQueryLocator([

        SELECT Id,
        (SELECT TotalAmount FROM Orders__r)

         FROM Account
         
         ]);
    }
    
    global void execute(Database.BatchableContext context, List<Account> scope) {
        Map<Id, Decimal> accountIdToSalesFigure = new Map<Id, Decimal>(); //map to hold account Id to sales figure

        // Perform the logic to update the sales figures of the accounts
        for (Account acc : scope) {

            // Query for related orders and calculate sales figure
            List<Order> relatedOrders = [SELECT TotalAmount FROM Order WHERE AccountId = :acc.Id];
            Decimal salesFigure = 0;

            for (Order ord : relatedOrders) {
                salesFigure += ord.TotalAmount;
            }
            accountIdToSalesFigure.put(acc.Id, salesFigure);  // Update sales figure field
        }
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIdToSalesFigure.keySet()) {
            Account acc = new Account(Id = accId, Sales_Figure__c = accountIdToSalesFigure.get(accId));
            accountsToUpdate.add(acc);
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
        
    
    
    global void finish(Database.BatchableContext context) {
        // Perform any post-processing tasks if needed
    }
}

