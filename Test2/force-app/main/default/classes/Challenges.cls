public with sharing class Challenges {

    // adding 151 accounts with unique names
    public static void Challenge1(){
        List<Account> uniqueAccounts = new List<Account>();
        for(Integer i = 0; i < 151; i++) {
            uniqueAccounts.add(new Account(name = 'Name' + i));
        }
        Insert uniqueAccounts;
    }

    //Query for the accounts you made, and then 
    //remove only those accounts from the database.
    public static void Challenge2(){
        List<Account> toDelete = [SELECT name FROM Account WHERE name LIKE 'Name%'];
        Delete toDelete;
    }
    
    // Query for all Contacts without an email and/or 
    // a phone field and give default values for those fields
    public static void Challenge3(){
        String defaultPhone = '(000)000-0000';
        String defaultEmail = 'tempEmail@revature.com';
        List<Contact> toInsert = 
            [SELECT name FROM Contact WHERE email = null or phone = null];
        for(Integer i = 0; i < toInsert.size();i++){
            if(toInsert[i].phone == null) {
            	toInsert[i].phone = defaultPhone;
            }
            if(toInsert[i].email == null) {
            	toInsert[i].email = defaultEmail;
            }
        }
        Update toInsert;
    }
    
    //Create a map of Accounts to Contacts with the default email or phone value. 
    //Accounts that do not have any Contacts with the default email or 
    //phone value should be ignored.
    public static void Challenge4(){
        // List<Contact> myList = 
        //Map<Account, String> myMap;
    }
    
    public static void Challenge5(){
        
    }
    
    public static void Test(){
        System.debug('Hello World');
    }

    public Challenges() {

    }
    
    
    
    
}