@isTest
public class ContactDeleteAccountTest {
    
    @testSetup
    public static void setup(){
        
        List<Account> testAccount = new List<Account>();
        
        for (integer i = 0; i < 200; i++){
            testAccount.add(new Account(name = 'test account ' + i));
        }
        insert testAccount;
        
        testAccount = [select ID from Account];
        
        
        List<Contact> testContact = new List<Contact>();

        for (integer i=0; i< 151; i++){
            Contact test2Contact = new contact(AccountID = testAccount[i].id,  lastname='testSubject', email = 'test'+ i+ '@email.com');
       //     test2Contact.put('account',testAccount[i]);
            testContact.add(test2Contact);       
        }
        insert testContact;
    }
    
    @isTest
    public static void positiveTest(){
        test.startTest();
        
        Contact con = [select name, account.id from contact limit 1];
       // system.assertnotequals(con.account.id,  null);
        // for insert test
        delete con;
        list<Account> currAcc= [select name from Account];
		
        system.assertequals(150, currAcc.size());
        
        test.stopTest();
    }

    @isTest
    public static void bulkTest(){
        test.startTest();
        

        List<Contact> toDelete = [Select name from Contact];
        
        delete toDelete;


        
        test.stopTest();
    }

}