//trigger CalculMontant on Order (before update) {
	
//	Order newOrder= trigger.new[0];
	//newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
//}




// This line starts the trigger and gives it a name//
trigger CalculateNetAmountBeforeUpdate on Order (before update) {


// This line starts a loop that goes through each order that's being updated, calcluate net amount//
    for (Order ord : Trigger.new) {
      //Trigger.new refers to the list of records of the sObject //


      // This line calculates the Net Amount for each order.//
        ord.NetAmount__c = ord.TotalAmount - ord.ShipmentCost__c;
    }
}
