@isTest
private class testUpdateAccountCA {
    @isTest static void test() {
        // Create test data
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert pd1;

        // Create PricebookEntry
        Id standardPricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        // Create Order with required fields populated
        Order o1 = new Order(
            AccountId = acc1.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            ContractId = null // Populate other required fields as needed
        ); 
        insert o1;

        // Create Order Items
        OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
        insert oi1;

        OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
        insert oi2;     

        // Perform assertions to validate results
        // Assert that the order status is 'Draft'
        Order updatedOrder = [SELECT Id, Status FROM Order WHERE Id = :o1.Id];
        System.assertEquals('Draft', updatedOrder.Status, 'Order status should be "Draft"');
    }
}

// look at Test Set up in google
// Create Pricebook
Pricebook2 standardPricebook = new Pricebook2(Name = 'Standard Pricebook', IsActive = true);
insert standardPricebook;

// Create PricebookEntry
PricebookEntry pbe = new PricebookEntry(
    Pricebook2Id = standardPricebook.Id,
    Product2Id = pd1.Id,
    UnitPrice = 1020,
    IsActive = true
);
Insert pbe;

// Create Order with required fields populated including PricebookId
Order o1 = new Order(
    AccountId = acc1.Id,
    EffectiveDate = Date.today(),
    Status = 'Draft',
    ContractId = null,
    Pricebook2Id = standardPricebook.Id // Specify PricebookId
);
insert o1;


  