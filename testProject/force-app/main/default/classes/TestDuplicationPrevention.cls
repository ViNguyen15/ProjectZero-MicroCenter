@isTest
public class TestDuplicationPrevention {
    
    @testSetup
    static void setup(){
        List<Contact> testContacts = new List<Contact>();
        List<Group__c> testGroups = new List<Group__c>();
        List<Post__c> testPosts = new List<Post__c>();
        
        for (Integer i = 0; i < 200; i++) {
            testContacts.add(new Contact(lastname = ('name '+ i)));
            testGroups.add(new Group__c(name = ('group ' + i)));
            testPosts.add(new Post__c(contents__c = 'post ' + i));
        }
        Insert testContacts;
        Insert testGroups;  
        Insert testPosts;
        
        List<Friends_List__c> existingFL = new List<Friends_List__c>();
        List<Group_Member__c> existingGM = new List<Group_Member__c>();
        List<Like_List__c> existingLL = new List<Like_List__c>();
        for (Integer i = 0; i < 1; i++) {
            existingFL.add(new Friends_List__c(Contact1__c = testContacts[2 * i].id, Contact2__c = testContacts[(2 * i) + 1].id));
            existingGM.add(new Group_Member__c(Contact__c = testContacts[i].id, Group__c = testGroups[i].id));
            existingLL.add(new Like_List__c(Contact__c = testContacts[i].id, Post__c = testPosts[i].id));
        }
        System.assertEquals(testGroups[0].id, existingGM[0].Group__c);
        Insert existingFL;
        Insert existingGM;
        Insert existingLL;
    }
    
    
    
    //Friends List Tests
    @isTest
    static void TPhandleFriendsList() {
        Test.startTest();
        
        try {insertRecords('Friends List', 1, 2, 3); System.assert(true);}
        catch (System.Exception e) {
            System.assert(false);
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void TNhandleFriendsList() {
        Test.startTest();
        
        try {insertRecords('Friends List', 1, 0, 1); System.assert(false);}
        catch (System.Exception e) {
            System.assert(true);
        }
        
        Test.stopTest();
    }
    
    @isTest //bulk positive
    static void TBPhandleFriendsList() {
        Test.startTest();
        
        try {insertRecords(Friends_List__c.sObjectType, 'Contact1__c', Contact.sObjectType, ' ORDER BY lastname', 'Contact2__c', Contact.sObjectType, ' ORDER BY lastname', 175, false, 1, 2); System.assert(true);}
        catch (System.Exception e) {
            System.assert(false);
        }
        
        Test.stopTest();
    }
    
    @isTest //bulk negative
    static void TBNhandleFriendsList() {
        Test.startTest();
        
        try {insertRecords('Friends List', 200, 1, 2); System.assert(false);}
        catch (System.Exception e) {
            System.assert(true);
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void TRUhandleFriendsList() {
        Test.startTest();
        
        User mod = [SELECT id FROM User WHERE Alias = 'bthe' LIMIT 1];
        System.runAs(mod){
            try {
                insertRecords('Friends List', 1, 2, 3);
                system.assert(false);
            }
            catch (System.Exception e) {
                System.assert(true);
            }
        }
        
        Test.stopTest();
    }
    
    
    
    
    //Group Member Tests
    @isTest
    static void TPhandleGroupMember() {
        Test.startTest();
        
        try {insertRecords('Group Member', 1, 1, 1); System.assert(true);}
        catch (System.Exception e) {
            System.assert(false);
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void TNhandleGroupMember() {
        Test.startTest();
        
        try {insertRecords('Group Member', 1, 0, 0); System.assert(false);}
        catch (System.Exception e) {
            System.assert(true);
        }
        
        Test.stopTest();
    }
    
    @isTest //bulk positive
    static void TBPhandleGroupMember() {
        Test.startTest();
        
        try {insertRecords(Group_Member__c.sObjectType, 'Contact__c', Contact.sObjectType, ' ORDER BY lastname', 'Group__c', Group__c.sObjectType, ' ORDER BY Name', 175, false, 0, 0); System.assert(true);}
        catch (System.Exception e) {
            System.assert(false);
        }
        
        Test.stopTest();
    }
    
    @isTest //bulk negative
    static void TBNhandleGroupMember() {
        Test.startTest();
        
        try {insertRecords('Group Member', 200, 1, 1); System.assert(false);}
        catch (System.Exception e) {
            System.assert(true);
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void TRUhandleGroupMember() {
        Test.startTest();
        
        User mod = [SELECT id FROM User WHERE Alias = 'bthe' LIMIT 1];
        System.runAs(mod){
            try {
                insertRecords('Group Member', 1, 2, 2);
                system.assert(false);
            }
            catch (System.Exception e) {
                System.assert(true);
            }
        }
        
        Test.stopTest();
    }
    
    
    
    
    
    //Like List Tests
    @isTest
    static void TPhandleLikeList() {
        Test.startTest();
        
        try {insertRecords('Like List', 1, 1, 1); System.assert(true);}
        catch (System.Exception e) {
            System.assert(false);
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void TNhandleLikeList() {
        Test.startTest();
        
        try {insertRecords('Like List', 1, 0, 0); System.assert(false);}
        catch (System.Exception e) {
            System.assert(true);
        }
        
        Test.stopTest();
    }
    
    @isTest //bulk positive
    static void TBPhandleLikeList() {
        Test.startTest();
        
        try {insertRecords(Like_List__c.sObjectType, 'Contact__c', Contact.sObjectType, ' ORDER BY lastname', 'Post__c', Post__c.sObjectType, ' ORDER BY Contents__c', 175, false, 1, 1); System.assert(true);}
        catch (System.Exception e) {
            System.assert(false);
        }
        
        Test.stopTest();
    }
    
    @isTest //bulk negative
    static void TBNhandleLikeList() {
        Test.startTest();
        
        try {insertRecords('Like List', 200, 1, 1); System.assert(false);}
        catch (System.Exception e) {
            System.assert(true);
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void TRUhandleLikeList() {
        Test.startTest();
        
        User mod = [SELECT id FROM User WHERE Alias = 'bthe' LIMIT 1];
        System.runAs(mod){
            try {
                insertRecords('Like List', 1, 2, 2);
                system.assert(false);
            }
            catch (System.Exception e) {
                System.assert(true);
            }
        }
        
        Test.stopTest();
    }
    
    
    
    
    static void insertRecords(sObjectType type, String field1, sObjectType type1, String order1, String field2, sObjectType type2, string order2, Integer numRecords, Boolean identical, Integer delete1, Integer delete2) {
        
        String query = 'SELECT id FROM ' + type1 + order1;
        List<sObject> object1 = new List<sObject>(Database.query(query));
        query = 'SELECT id FROM ' + type2 + order2;
        List<sObject> object2 = new List<sObject>(Database.query(query));
        
        for (Integer i = 0; i < delete1; i++) {
            object1.remove(0);
        }
        for (Integer i = 0; i < delete2; i++) {
            object2.remove(0);
        }
        
        List<sObject> output = new List<sObject>();
        sObject temp;
        
        for (Integer i = 1; i <= numRecords; i++) {
            temp = type.newSObject();
            if (identical) {
                temp.put(field1, object1[0].id);
                temp.put(field2, object2[0].id);
            } else {
                temp.put(field1, object1[i].id);
                temp.put(field2, object2[i].id);
            }
            output.add(temp);
        }
        Insert output; 
    }    
    
    static void insertRecords(String type, Integer numRecords, Integer delete1, Integer delete2) {
        switch on (type) {
            when ('Friends List') {
                insertRecords(Friends_List__c.sObjectType, 'Contact1__c', Contact.sObjectType, ' ORDER BY lastname', 'Contact2__c', Contact.sObjectType, ' ORDER BY lastname', numRecords, true, delete1, delete2);
            }
            when ('Group Member') {
                insertRecords(Group_Member__c.sObjectType, 'Contact__c', Contact.sObjectType, ' ORDER BY lastname', 'Group__c', Group__c.sObjectType, ' ORDER BY Name', numRecords, true, delete1, delete2);
            }
            when ('Like List') {
                insertRecords(Like_List__c.sObjectType, 'Contact__c', Contact.sObjectType, ' ORDER BY lastname', 'Post__c', Post__c.sObjectType, ' ORDER BY Contents__c', numRecords, true, delete1, delete2);
            }
        }
    }
    
}