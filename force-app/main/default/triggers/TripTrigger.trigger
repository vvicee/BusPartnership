trigger TripTrigger on Trip__c (before insert, after delete, after update) {

    // ll buses are involved in trips
    List<Bus__c> busesInTrips = [SELECT Id, Status__c 
                                FROM Bus__c
                                WHERE Id IN (SELECT Bus__c FROM Trip__c)];


    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Bus__c bus: busesInTrips) {
            bus.Status__c = 'In Use';
        }
        update busesInTrips;
    }


    if (Trigger.isDelete) {
        // container for buses available after deleting trips
        List<Bus__c> availableBuses = new List<Bus__c>();
        // container for id buses from trips that are deleted
        Set<Id> idDeletedBuses = new Set<Id>();

        for(Trip__c trip: Trigger.old) {
            idDeletedBuses.add(trip.Bus__c); 
        }

        List<Bus__c> deletedBuses = [SELECT Id, Status__c 
                                      FROM Bus__c
                                      WHERE Id IN: idDeletedBuses ];

        for (Bus__c bus: deletedBuses) {
            if (!busesInTrips.contains(bus)) {
               bus.Status__c = 'Available';
               availableBuses.add(bus);
            }
        }
        update availableBuses;
    }
}