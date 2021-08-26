@isTest
public class ContactHandlerTest {
    
    @testSetup
    public static void setup(){
        List<Contact> testContact = new List<Contact>();

        for (integer i=0; i< 151; i++){
            
            testContact.add(new contact(lastname='testSubject', email = 'test'+ i+ '@email.com'));       
        }
        insert testContact;
    }
    
    @isTest
    public static void positiveTest(){
        test.startTest();
        
        Contact con = new Contact();
        con.lastname = 'John';
        con.email = 'new@email.com';
        // for insert test
        insert con;
        // for update test
        con.email = 'new2@email.com';
        update con;
        
        test.stopTest();
    }
    
    @isTest
    public static void negativeTest(){
        test.startTest();
        
        Contact tempCon = new Contact();
        tempCon.lastname = 'singh';
        tempCon.Email = 'test1@email.com';
        
        Try {
            insert tempCon;
            system.assert(false);
        }
        Catch (system.Exception e){
            String str =  e.getMessage();
            system.assertequals(true, str.contains('Entered email already exists!'));
        }
        
        // for update test
         
        tempCon = [Select email FROM Contact WHERE email = 'test0@email.com' LIMIT 1];
        tempCon.email = 'test1@email.com'; 
        
        Try {
            update tempCon;
            system.assert(false);
        }
        Catch (system.Exception e){
            String str =  e.getMessage();
            system.assertequals(true, str.contains('Entered email already exists!'));
        }
        
        test.stopTest();
    }
    @isTest
    public static void bulkTest(){
        test.startTest();
        
        // insert test
        List<Contact> tempCon2 = new List<Contact>();
        for (integer i=0; i<151; i++) {
            tempCon2.add(new contact(lastname='testSubject', email = 'testm'+ i+ '@email.com')); 
        }
        
        // update test
        
        insert tempCon2;
                for (integer i=0; i<151; i++) {
            tempCon2[i].email = 'testk'+ i+ '@email.com'; 
        }
        update tempCon2;
        
        test.stopTest();
    }

}