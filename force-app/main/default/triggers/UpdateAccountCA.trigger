trigger UpdateAccountCA on Order (after update) {
	
    set<Id> setAccountIds = new set<Id>(); // Collect Account IDs
    
    for(Order updatedOrder : Trigger.new) {
        accountIds.add(updatedOrder.AccountId);
    }
    // Bulk Query to fetch Account information
    Map<Id, Account> accountIdToAccountMap = new Map<Id, Account>([SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds]);

    // Update Account Chiffre_d_affaire__c based on TotalAmount of updated Orders
    for (Order updatedOrder : Trigger.new) {
        Account acc = accountIdToAccountMap.get(updatedOrder.AccountId);
        acc.Chiffre_d_affaire__c += updatedOrder.TotalAmount; //  Update Accounts
    }
    //  Update Accounts in bulk
    update accountIdToAccountMap.values();
}
    
