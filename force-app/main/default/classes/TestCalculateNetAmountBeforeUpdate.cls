@isTest
private class TestCalculateNetAmountBeforeUpdate {
    @isTest
    static void testTriggerLogic() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Order testOrder = new Order(
            AccountId = testAccount.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            TotalAmount = 1000, // Populate other required fields as needed
            ShipmentCost__c = 100
        );
        insert testOrder;
        
        // Verify trigger behavior
        testOrder.TotalAmount = 1500;
        update testOrder;
        
        // Retrieve the updated order and verify Net Amount calculation
        testOrder = [SELECT Id, NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals(1400, testOrder.NetAmount__c, 'NetAmount__c should be calculated correctly');
    }
}

