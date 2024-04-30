@isTest
private class TestUpdateAccountCA {
    @isTest static void testBulkOrderCreation() {
        // Create test account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Create product
        Product2 pd = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert pd;

        // Create standard pricebook
        Pricebook2 standardPricebook = new Pricebook2(Name = 'Standard Pricebook', IsActive = true);
        insert standardPricebook;

        // Create pricebook entry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pd.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        insert pbe;

        // Prepare a list of orders and order items for bulk insertion
        List<Order> ordersToInsert = new List<Order>();
        List<OrderItem> orderItemsToInsert = new List<OrderItem>();

        // Create multiple orders with order items
        for (Integer i = 0; i < 5; i++) {
            // Create Order
            Order newOrder = new Order(
                AccountId = acc.Id,
                EffectiveDate = Date.today(),
                Status = 'Draft',
                ContractId = null,
                Pricebook2Id = standardPricebook.Id
            );
            ordersToInsert.add(newOrder);

            // Create Order Items for the Order
            OrderItem oi1 = new OrderItem(OrderId = newOrder.Id, PricebookEntryId = pbe.Id, Quantity = 10, UnitPrice = 150);
            OrderItem oi2 = new OrderItem(OrderId = newOrder.Id, PricebookEntryId = pbe.Id, Quantity = 20, UnitPrice = 1000);
            orderItemsToInsert.add(oi1);
            orderItemsToInsert.add(oi2);
        }

        // Bulk insert orders and order items
        insert ordersToInsert;
        insert orderItemsToInsert;

        // Perform assertions to validate results for all created orders
        List<Order> insertedOrders = [SELECT Id, Status FROM Order WHERE Id IN :ordersToInsert];
        System.assertEquals(5, insertedOrders.size(), 'Expected number of inserted orders does not match');

        for (Order insertedOrder : insertedOrders) {
            System.assertEquals('Draft', insertedOrder.Status, 'Order status should be "Draft"');
        }
    }
}
