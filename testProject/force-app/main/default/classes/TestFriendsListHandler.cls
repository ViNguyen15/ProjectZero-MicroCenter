@isTest
public class TestFriendsListHandler {
    
    @testSetup
    static void setup() {
        List<Contact> testContacts = new List<Contact>();
        
        for (Integer i = 0; i < 500; i++) { //500 because needs to be greater than two bulk tests combined
            testContacts.add(new Contact(lastname = ('name ' + i)));
        }
        Insert testContacts;
    }
    
    @isTest
    static void TPcrudMirrors() {
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
    static void TScrudMirrors() {
        Test.startTest();
        
        Insert createRecords(1, 0);
        System.assertEquals(new List<Integer>{2, 0}, tallyAcceptedAndNot());
        Update updateRecords();
        System.assertEquals(new List<Integer>{2, 0}, tallyAcceptedAndNot());
        Delete deleteRecords(1);
        System.assertEquals(new List<Integer>{0, 0}, tallyAcceptedAndNot());
        
        Test.stopTest();
    }
    
    @isTest//takes excessive cpu time, is at least O(n^2)
    static void TBcreateMirrors() {
        Test.startTest();
        
        Insert createRecords(200, 175);
        System.assertEquals(new List<Integer>{400, 175}, tallyAcceptedAndNot());
        Test.stopTest();
    }

    @isTest
    static void TBupdateMirrors() {
        
        Test.startTest();
        Insert createRecords(200, 100);
        Update updateRecords();
        System.assertEquals(new List<Integer>{600, 0}, tallyAcceptedAndNot());

        Test.stopTest();
    }


    @isTest
    static void TBdeleteMirrors() {
        Test.startTest();

        Insert createRecords(200, 100);
		Delete deleteRecords(175);
		System.assertEquals(new List<Integer>{50, 100}, tallyAcceptedAndNot());
        
        Test.stopTest();
    }


    
    @isTest//could use more specific exception
    static void TRUcrudMirrors() {
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
        List<Contact> temp = [SELECT lastname FROM Contact ORDER BY lastname];
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
        //List<Friends_List__c> first = [SELECT id FROM Friends_List__c WHERE RequestAccepted__c = true ORDER BY lastname LIMIT 1];
        List<Contact>  first = [SELECT id FROM Contact WHERE lastname = 'name 0'];

        ID refID = first[0].id; //Contact1__C = :refID AND 
        List<Friends_List__c> existing = [SELECT RequestAccepted__c FROM Friends_List__c WHERE Contact1__C = :refID AND RequestAccepted__c = true];
        for (Integer i = 0; i < numToDelete; i++) {
            toDelete.add(existing[i]);
        }
        return toDelete;
    }
}