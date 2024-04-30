@isTest
private class TestCalculateNetAmountBeforeUpdate {
    @isTest
    static void testBulkTriggerLogic() {
        // Prepare test data
        List<Account> testAccounts = new List<Account>();
        List<Order> testOrders = new List<Order>();

        // Create multiple test accounts and orders for bulk testing
        for (Integer i = 0; i < 5; i++) {
            Account testAccount = new Account(Name = 'Test Account ' + i);
            testAccounts.add(testAccount);

            Order testOrder = new Order(
                AccountId = testAccount.Id,
                EffectiveDate = Date.today(),
                Status = 'Draft',
                TotalAmount = 1000 + (i * 100), // Vary TotalAmount for each order
                ShipmentCost__c = 100
            );
            testOrders.add(testOrder);
        }

        // Bulk insert test accounts and orders
        insert testAccounts;
        insert testOrders;

        // Verify trigger behavior for each test order
        for (Order testOrder : testOrders) {
            // Update TotalAmount to trigger the trigger logic
            testOrder.TotalAmount = testOrder.TotalAmount + 500;
            update testOrder; // delete and adapt
        }

        // Retrieve and validate NetAmount__c for each updated order
        List<Order> updatedOrders = [SELECT Id, NetAmount__c FROM Order WHERE Id IN :testOrders];
        System.assertEquals(testOrders.size(), updatedOrders.size(), 'Number of updated orders should match');

        for (Order updatedOrder : updatedOrders) {
            Decimal expectedNetAmount = updatedOrder.TotalAmount - updatedOrder.ShipmentCost__c;
            System.assertEquals(expectedNetAmount, updatedOrder.NetAmount__c, 'NetAmount__c should be calculated correctly');
        }
    }
}

