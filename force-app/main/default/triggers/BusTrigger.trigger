trigger BusTrigger on Bus__c (before insert, before update) {

    for(Bus__c bus: Trigger.new) { 
        if (bus.Type__c == 'Depot') { 
        //   System.debug(bus.Account__r.Placement__c);
        //    bus.State__c = bus.Account__r.Placement__c; //For depot buses, we set the account state
              Account acc = [SELECT Id, Placement__c FROM Account WHERE Id =: bus.Account__c];
              bus.State__c = acc.Placement__c;
        }
    }
}