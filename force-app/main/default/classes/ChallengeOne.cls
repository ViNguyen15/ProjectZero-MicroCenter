public with sharing class ChallengeOne {
    
    //Challenge one: Create a class that has a method to add 151 accounts,
    //with unique names, to your org.

    public static void addAccounts(){
        list<Account> toAdd = new list<Account>();
        for (Integer i = 0; i < 152; i++){
            toAdd.add(new Account(name = 'challenge account ' + i));
        }
        insert toAdd;
    }

    //Challenge two: Query for the accounts you made, 
    //and then remove only those accounts from the database.
    //this will also delete the contacts I made for testing.

    public static void delAccounts(){
        List<Account> toDelete = [SELECT name FROM Account WHERE name LIKE 'challenge%'];
        delete toDelete;
        list<Contact> toDeleteTwo = [SELECT name FROM Contact WHERE name LIKE 'challenge%'];
        delete toDeleteTwo;
    }

    //Challenge three: Query for all Contacts without an email and/or a phone field
    // and give default values for those fields

    public static void setContactFieldDefaults(){
        List<Contact> toModify = [SELECT phone,email FROM Contact WHERE phone = null OR email = null];
        for (Integer i = 0; i < toModify.size(); i++){
            if (toModify[i].phone == null){
                toModify[i].phone = '(000)000-0000';
            }
            if (toModify[i].email == null){
                toModify[i].email = 'garbage@revature.com';
            }
        }
        update toModify;
    }

    //Challenge Four: Create a map of Accounts to Contacts with the default email 
    //or phone value. Accounts that do not have any Contacts with the default email 
    //or phone value should be ignored.

    public static Map<Contact,Id> makeMap(){
        Map<Contact, Id> theMap = new Map<Contact, Id>();
        List<Id> relevantIDs = new List<Id>();
        List<Contact> relevantContacts = [SELECT accountId FROM Contact WHERE phone = '(000)000-0000' OR email = 'garbage@revature.com'];
        List<Account> relevantAccounts = [SELECT name FROM Account WHERE id = ]
        for (Integer i = 0; i < relevantContacts.size(); i++){
            if (relevantContacts[i].phone == '(000)000-0000'){
                relevantIDs.add
            } else if (relevantContacts[i].email == 'garbage@revature.com'){
                theMap.put(relevantContacts[i], relevantContacts[i].accountId);
            }
        }
        for (Integer i = 0; i < relevantContacts.size(); i++){
            if (relevantContacts[i].phone == '(000)000-0000'){
                theMap.put(relevantContacts[i], relevantContacts[i].accountId);
            } else if (relevantContacts[i].email == 'garbage@revature.com'){
                theMap.put(relevantContacts[i], relevantContacts[i].accountId);
            }
        }
        return theMap;
    }

    //Challenge Five: Using your mighty mapping powers, switch the Account and Contact names.
    //New Account names should be made in the format: "Contact1 and Contact2" if it has 
    //multiple contacts, and Contact names should have the first word of an Account name 
    //as the first name if an Account has multiple words as its name, otherwise all other
    //words of an Account name should be in the Last Name field of a Contact

    public static void swapAccountAndContactNames(){
        Map<Contact, Id> theMap = makeMap();
        List<Account> relevantAccounts = new List<Account>();
        List<Contact> relevantContacts = [SELECT firstName,lastName,accountID FROM Contact WHERE phone = '(000)000-0000' OR email = 'garbage@revature.com'];
        for (Integer i = 0; i < relevantContacts.size(); i++){
            String originalContactName = relevantContacts[i].firstName + ' ' + relevantContacts[i].lastName;
            if (theMap.get(relevantContacts[i]).name.contains(' ')){
                relevantContacts[i].firstName = theMap.get(relevantContacts[i]).name.subStringBefore(' ');
                relevantContacts[i].lastName = theMap.get(relevantContacts[i]).name.subStringAfter(' ');
            } else {
                relevantContacts[i].lastName = theMap.get(relevantContacts[i]).name;
            }
            relevantAccounts.add(theMap.get(relevantContacts[i]));
            relevantAccounts[i].name = originalContactName;
        }
        update relevantContacts;
        update relevantAccounts;
        

    }

    //sets up contacts for testing challenges 3, 4, 5. Assumes Challenge one code has been ran.
    public static void setupTestContacts(){
        List<Account> associatedAccounts = [SELECT name FROM Account WHERE name LIKE 'challenge account %'];
        list<Contact> toAdd = new list<Contact>();
        for (Integer i = 0; i < associatedAccounts.size(); i++){
            toAdd.add(new Contact(firstName = 'challenge', lastName = 'contact' + i, AccountId = associatedAccounts[i].ID));
        }
        insert toAdd;
    }

}
