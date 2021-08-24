public with sharing class PreventDuplicates {

    public static void handleFriendsList(List<Friends_List__c> input) {
        checkDuplicates(input, 'Contact1__c', 'Contact2__c', [SELECT Contact1__c, Contact2__c FROM Friends_List__c]);
    }
    
    public static void handleGroupMember(List<Group_Member__c> input) {
        checkDuplicates(input, 'Group__c', 'Contact__c', [SELECT Group__c, Contact__c FROM Group_Member__c]);
    }
    
    public static void handleLikeList(List<Like_List__c> input) {
        checkDuplicates(input, 'Post__c', 'Contact__c', [SELECT Post__c, Contact__c FROM Like_List__c]);
    }
    
    
    public static void checkDuplicates(List<sObject> inputObjects, String field1, String field2, List<sObject> existingObjects) {
        List<sObject> toRemove = new List<sObject>();
        for (Integer i = 0; i < inputObjects.Size(); i++) {
            for (sObject e : existingObjects) {
                if (inputObjects[i].get(field1) == e.get(field1) && inputObjects[i].get(field2) == e.get(field2)) {
                    inputObjects[i].addError('Junction already exists between these objects');
                }
            } 
            for (Integer i2 = i + 1; i2 < inputObjects.Size(); i2++) {
                    if (inputObjects[i].get(field1) == inputObjects[i2].get(field1) && inputObjects[i].get(field2) == inputObjects[i2].get(field2)) {
                    inputObjects[i].addError('Duplicate record in input');
                }
            } 
        } 
    }

}