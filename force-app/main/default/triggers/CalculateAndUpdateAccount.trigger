trigger CombinedOrderTriggers on Order (before update, after update) {

    // This block of code executes before the Order is updated
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Order ord : Trigger.new) {
            // Calculate Net Amount for each Order before update
            ord.NetAmount__c = ord.TotalAmount - ord.ShipmentCost__c;
        }
    }

    // This block of code executes after the Order is updated
    if (Trigger.isAfter && Trigger.isUpdate) {
        Set<Id> accountIdsToUpdate = new Set<Id>(); // Collect Account IDs to update

        for (Order updatedOrder : Trigger.new) {
            accountIdsToUpdate.add(updatedOrder.AccountId);
        }

        // Bulk Query to fetch Account information related to updated Orders
        Map<Id, Account> accountIdToAccountMap = new Map<Id, Account>([
            SELECT Id, Chiffre_d_affaire__c
            FROM Account
            WHERE Id IN :accountIdsToUpdate
        ]);

        // Update Account Chiffre_d_affaire__c based on TotalAmount of updated Orders
        for (Order updatedOrder : Trigger.new) {
            Account acc = accountIdToAccountMap.get(updatedOrder.AccountId);
            if (acc != null) {
                acc.Chiffre_d_affaire__c += updatedOrder.TotalAmount; // Update Account's Chiffre_d_affaire__c
            }
        }

        // Update Accounts in bulk
        update accountIdToAccountMap.values();
    }
}
