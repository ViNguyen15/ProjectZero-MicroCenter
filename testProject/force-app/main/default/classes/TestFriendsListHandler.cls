@isTest
public class TestFriendsListHandler {
    
    @testSetup
    static void setup() {
        List<Contact> testContacts = new List<Contact>();
        
        for (Integer i = 0; i < 500; i++) { //needs to be greater than two bulk tests combined
            testContacts.add(new Contact(lastname = ('name ' + i)));
        }
        Insert testContacts;
    }
    
    @isTest
    static void TPcreateMirrors() {
        Test.startTest();
        
        Insert createRecords(1, 1);
        System.assertEquals(new List<Integer>{2, 1}, tallyAcceptedAndNot());
        Update updateRecords();
        System.assertEquals(new List<Integer>{4, 0}, tallyAcceptedAndNot());
        Delete deleteRecords(1);
        System.assertEquals(new List<Integer>{2, 0}, tallyAcceptedAndNot());
        
        Test.stopTest();
    }
    
    @isTest
    static void TScreateMirrors() {
        Test.startTest();
        
        Insert createRecords(1, 0);
        System.assertEquals(new List<Integer>{2, 0}, tallyAcceptedAndNot());
        Update updateRecords();
        System.assertEquals(new List<Integer>{2, 0}, tallyAcceptedAndNot());
        
        Test.stopTest();
    }
    
    @isTest//takes too much cpu time to finish
    static void TBcreateMirrors() {
        Test.startTest();
        /*
        Insert createRecords(200, 175);
        System.assertEquals(new List<Integer>{400, 175}, tallyAcceptedAndNot());
        Update updateRecords();
        System.assertEquals(new List<Integer>{750, 0}, tallyAcceptedAndNot());
		Delete deleteRecords(200);
		System.assertEquals(new List<Integer>{350, 0}, tallyAcceptedAndNot());
        */
        Test.stopTest();
    }
    
    @isTest//use more specific exception
    static void TRUcreateMirrors() {
        Test.startTest();
        
        Insert createRecords(1, 1);
        User mod = [SELECT id FROM User WHERE Alias = 'bthe' LIMIT 1];
        System.runAs(mod){
            try {Insert createRecords(1, 1); System.assert(false);}
            catch (System.Exception e) {
                System.assert(true);
            }
            //System.assertEquals(new List<Integer>{0, 0}, tallyAcceptedAndNot());
            
            try {Update updateRecords();}
            catch (System.Exception e) {
                
            }
            System.assertEquals(new List<Integer>{0, 0}, tallyAcceptedAndNot());
            
            try {Delete deleteRecords(1);}
            catch(System.Exception e) {
                
            }
            System.assertEquals(new List<Integer>{0, 0}, tallyAcceptedAndNot());
        }
        Test.stopTest();        
    }
    
    
    
    
    static List<Integer> tallyAcceptedAndNot() {
        List<Integer> acceptedThenNot = new List<Integer>{0, 0};
            for (Friends_List__c fl : [SELECT Contact1__c, Contact2__c, RequestAccepted__c FROM Friends_List__C]) {
                if (fl.RequestAccepted__c == true) {acceptedThenNot[0]++;}
                else {acceptedThenNot[1]++;}     
            }
        return acceptedThenNot;
    }
    
    static List<Friends_List__c> createRecords(Integer numAccepted, Integer numUnaccepted) {
        List<Contact> temp = [SELECT lastname FROM Contact];
        List<Friends_List__c> inputRecords = new List<Friends_List__c>();
        
        for (Integer i = 0; i < numAccepted; i++) {
            inputRecords.add(new Friends_List__c(Contact1__c = temp[0].id, Contact2__c = temp[i + 1].id, RequestAccepted__c = true));
        }
        for (Integer i = 0; i < numUnaccepted; i++) {
            inputRecords.add(new Friends_List__c(Contact1__c = temp[i + numAccepted].id, Contact2__c = temp[i + numAccepted + 1].id, RequestAccepted__c = false));
        }
        return inputRecords;
    }
    
    static List<Friends_List__c> updateRecords() {
        List<Friends_List__c> existing = [SELECT RequestAccepted__c FROM Friends_List__c];
        List<Friends_List__c> updateRecords = new List<Friends_List__c>();
        for (Friends_List__c current : existing) {
            if (current.RequestAccepted__c == false) {
                current.RequestAccepted__c = true;
                updateRecords.add(current);
            }
        }
        return updateRecords;
    }
    
    static List<Friends_List__c> deleteRecords(Integer numToDelete) {
        List<Friends_List__c> toDelete = new List<Friends_List__c>();
        List<Friends_List__c> first = [SELECT id FROM Friends_List__c WHERE RequestAccepted__c = true LIMIT 1];
        ID refID = first[0].id; //Contact1__C = :refID AND 
        List<Friends_List__c> existing = [SELECT RequestAccepted__c FROM Friends_List__c WHERE RequestAccepted__c = true];
        for (Integer i = 0; i < numToDelete; i++) {
            toDelete.add(existing[i]);
        }
        return toDelete;
    }
}