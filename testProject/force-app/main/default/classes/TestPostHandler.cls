@isTest
public class TestPostHandler {
    
    @testSetup //unused
    static void setup() {
        //User bob = new User(alias = 'bthe', Username = 'bthemod', LastName ='themod', Email = 'bob@email.com', TimeZoneSidKey= '', LocaleSidKey = '', EmailEncodingKey = '', ProfileId = '', LanguageLocaleKey = '');
        User bob = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Content Moderator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'bthe',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        User emily = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Content Moderator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'ethe',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        //User emily = new User(alias = 'ethe');
        //Insert bob;
        //Insert emily;
    }
    
    @isTest
    static void TPflaggedPostTransfer() {
        Test.startTest();
        
        //single
        createRecords(1, 1);
        System.assertEquals(new List<Integer>{1, 1}, countOwners());
        updateRecords();
        System.assertEquals(new List<Integer>{2, 0}, countOwners());
        
        //bulk
        createRecords(200, 300);
        System.assertEquals(new List<Integer>{202, 300}, countOwners());
        updateRecords();
        System.assertEquals(new List<Integer>{502, 0}, countOwners());
        
        //restricted user
        createRecords(0, 1); 
        //swapActives(false);
        User mod = [SELECT id FROM User WHERE Alias = 'bthe' LIMIT 1];
        System.runAs(mod){           
            try {
                List<Post__c> toDelete = [SELECT id FROM Post__c WHERE Flagged__c = true];
                Delete toDelete;
                System.assertEquals(new List<Integer>{0, 1}, countOwners());
            }
            catch (System.Exception e) {
                System.assert(false);
            }
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void TNflaggedPostTransfer() { 
        Test.startTest();
        //restricted user
        //swapActives(false);
        createRecords(0, 1);
        User mod = [SELECT id FROM User WHERE Alias = 'bthe' LIMIT 1];
        System.runAs(mod){           
            try {
                List<Post__c> toDelete = [SELECT id FROM Post__c WHERE Flagged__c = false];
                Delete toDelete;
                System.assert(false);
            }
            catch (System.Exception e) {
                System.assert(true);
            }
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void TPflaggedContacts() {//swap actives is nonfunctional, testing the internal method of fpt without testing for active user
        Test.startTest();
        ID refID = ID.valueOf('0055e000006U183AAC');
        //swapActives(true);
        List<Contact> toInsert = new List<Contact>{new Contact(lastname = 'test', Banned__c = true)};
        //Insert toInsert;
        PostHandler.fptInner(toInsert, refID);
        List<Contact> existing = [SELECT OwnerID FROM Contact WHERE lastname = 'test'];
        
        List<User> modManager = [SELECT id, isActive FROM User WHERE alias = 'ethe' LIMIT 1];
        System.assert(modManager.Size() == 1);
        System.assert(!modManager[0].isActive);
        
        System.assertEquals(toInsert[0].OwnerID, refID);
        Test.stopTest();
    }
    
    @isTest
    static void TNflaggedContacts() {
        ID refID = ID.valueOf('0055e000006U183AAC');
        //swapActives(false);
        List<Contact> toInsert = new List<Contact>{new Contact(lastname = 'test', Banned__c = true)};
            Insert toInsert;
        List<Contact> existing = [SELECT OwnerID FROM Contact WHERE lastname = 'test'];
        
        System.assertNotEquals(existing[0].OwnerID, refID);
    }
    
    @isTest
    static void TBflaggedContacts() {
        
    }
    
    
    
    static void createRecords(Integer numFlagged, Integer numUnflagged){
        List<Post__c> toInsert = new List<Post__c>();
        
        for (numFlagged = numFlagged; numFlagged > 0; numFlagged--) {
            toInsert.add(new Post__c(Flagged__c = true));
        }
        
        for (numUnflagged = numUnflagged; numUnflagged > 0; numUnflagged--) {
            toInsert.add(new Post__c(Flagged__c = false));
        }
        
        Insert toInsert;
    }
    
    static void updateRecords() {
        List<Post__c> toUpdate = [SELECT Flagged__c FROM Post__c WHERE Flagged__c = false];
        for (Post__c record : toUpdate) {
            record.Flagged__c = true;
        }
        Update toUpdate;
    }
    
    static List<Integer> countOwners() {
        Integer meaninglessNumber;
        ID refID = ID.valueOf('00G5e000000aaxNEAQ');
        
        List<Integer> count = new List<Integer>{0, 0};
            
            for (Post__c p : [SELECT OwnerID FROM Post__c]) {
                //meaninglessNumber = (p.OwnerID == refID) ? count[0]++ : count[1]++; //internal salesforce error
                if (p.OwnerID == refID) {
                    count[0]++;
                } else {
                    count[1]++;
                }
            }
        return count;
    }
    
    Static void swapActives(Boolean toManager) {//change this to call overload eventually
        List<User> users = [SELECT alias, isActive FROM User WHERE alias = 'cthe' OR alias = 'ethe'];
        for (User current : users) {
            if (current.alias == 'bthe' && toManager || current.alias == 'ethe' && !toManager) {
                current.isActive = false;
            }
        }
        for (User current : users) {
            if (current.alias == 'ethe' && toManager || current.alias == 'bthe' && !toManager) {
                current.isActive = true;
            }
        }
        Update users;
    }
    
    Static void swapActives(String stringDeactivate, String stringActivate) {
        List<User> users = [SELECT alias, isActive FROM User WHERE alias = :stringDeactivate OR alias = :stringActivate];
        for (User current : users) {
            if (current.alias == stringDeactivate) {
                current.isActive = false;
            }
        }
        for (User current : users) {
            if (current.alias == stringActivate) {
                current.isActive = true;
            }
        }
        Update users;
    }    
}