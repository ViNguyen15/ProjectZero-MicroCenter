public with sharing class WorkingWithData {
    //SOQL
    // - Salesforce Object Object Query Language
    // - SQL familiar syntax, but different than SQL
    // - We can use this natively in Apex
    // - Querying for the data in our Org
    //  - Using the sObjects that exist in our Org
    //  - We are getting the records that exist for our org

    public WorkingWithData() {

    }

    public void SOQL(){
        // List<sObject> myResults = [SELECT name FROM Account];
        // System.debug(myResults[0].get('name'));

        //Same as above. If not using sObjects you wont need to use get
        List<Account> myResults = [SELECT name FROM Account];
        System.debug(myResults[0].name);
    }

    Set<String> namesToFilter = new Set<String>();

    //SOQL Clauses
    // OFFSET: changes where the record starts
    // LIMIT: Limit how many records are returned
    //  -OFFSET and LIMIT is used together to perform pagination
    // WHERE: Adds on a filter to your query
    //  -SELECT name FROM Account WHERE name LIKE '%a%a%'
    //  -SELECT name FROM Account WHERE name IN :namesToFilter
    // ORDER BY
    //  - Sets the
    //  - WITE SECURITY ENFORCED
    //      -If you dont have access to something in the query, throws an error

    // - FIELDS()
    //      -ALL, STANDARD, CUSTOM
    //      -This will repect field level security
    //      -SELECT FIELD(ALL) FROM Account

    // - FORMAT()
    //      -Format number, date, time, currency fields
    //      -SELECT FORMAT(annualRevenue) FROM Account

    // - FOR
    //      -VIEW: Update the Last Viewed Date field on the records
    //      -REFERENCE: Update the Last Referenced Date field on the records
    //      -UPDATE: Locks record from being updated by anyone except the locker until the transaction ends
    //      -SELECT name FROM Account FOR VIEW

    public static void AggregateFunctions(){
        // When you use an aggregate function, the return type now is AggregateResult
        // Still able to use .get()
        // Can give fields an alias to reference them by, otherwise the name of the fields is expr#, starting with 0
        // Aggregate Functions
        // - AVG(), COUNT(), MIN(), MAX(), SUM(), COUNT_DISTINCT
        // - SELECT AVG(annualRevenue) FROM Account
        // GROUP BY
        // SELECT rating, AVG(annualRevenue) FROM Account GROUP BY rating 
        // HAVING
        // - Filters the GROUP BY Clause
        // - SELECT rating, FORMAT(AVG(annualRevenue)) FROM Account GROUP BY rating HAVING NOT rating = null


    }

    public static void DateFunctions(){
        // Date Functions
        // - CALENDAR_YEAR(), CALENDAR_QUARTER(), DAY_IN_MONTH(), DAY_IN_WEEK, DAY_IN_YEAR(), DAY_ONLY(), FISCAL_MONTH(),
        //      FISCAL_QUARTER(), FISCAL_YEAR(), HOUR_IN_DAY(), WEEK_IN_MONTH(), WEEK_IN_YEAR()
        //  SELECT DAY_IN_WEEK(CloseDate) FROM Opportunity GROUP BY DAY_IN_WEEK(CloseDate)
    }


    public static void RelationshipQueries(){
        List<Account> myResults = [SELECT name, (SELECT name FROM Contacts) FROM Account];
        for (Account currAccount : myResults) {
            List<Contact> associatedContacts = currAccount.contacts;
        }

        // Relationship Queries
        //  - Parent to Child
        //      - Accounts -> Contacts
        //      - SELECT name, (Select name FROM Contacts) FROM Account
        //  - Child to Parent
        //      - Contacts -> Accounts
        //      - SELECT name, Account.name FROM Contact

        // Relationship query and filtering query
        // - SELECT name, (SELECT name FROM Contacts) FROM Account Where id IN (SELECT accountID from Contact WHERE name LIKE 'a%')
    }

    public static void DML(){

        // Account myNewAccount = new Account(name = 'My Test Account', rating = 'Hot', AnnualRevenue = 150000000);
        // Insert myNewAccount;

        // List<Account> toDelete = [SELECT  FROM Account WHERE name = 'My Test Account'];
        // Delete toDelete;

        // Account toUpdate = [SELECT name, rating, active__c FROM Account WHERE name = 'My Test Account' LIMIT 1];
        // toUpdate.active__c = 'Yes';
        // Update toUpdate;

        // Database.insert(myNewContact);
 
        // Data Manipulation Language
        // - This allows us to persist changes to the database
        // - Insert
        // - Update
        // - Delete
        // - Merge
        // - Upsert

        List<Contact> myContactList = new List<Contact>();
        myContactList.add(new Contact(lastName = 'Valid Contact'));
        myContactList.add(new Contact(firstName = 'Invalid Contact'));

        //all or nothing is defaultly on


        Database.Insert(myContactList, false);

        // Database methods allow the AllOrNothing parameter to be specified as false, allowing partial DML operations to be run

        
    }

    public static void GovernorLimits(){

        
        // dont do this since you will reach the Governor Limits
        for(Integer i = 0; i < 152; i++){
            Insert new Contact(lastName = 'This will fail!');
        }

        // use collections like loops to do best practices
        List<Contact> toInsert = new List<Contact>();
        for(Integer i = 0; i < 152; i++){
            toInsert.add (new Contact(lastName = 'This will succeed!'));
        }
        Insert toInsert;

        // SOQL Queries also have governor limits
        // We should map together records that need to be accessed together

        List<Account> myAccounts = 
            [SELECT name, (SELECT name FROM Contacts) FROM Account];
        Map<Account, List<Contact> > myMap = new Map<Account, List<Contact> >();
        for (INTEGER index = 0; index < myAccounts.Size(); index++) {
            myMap.put(myAccounts[index], myAccounts[myAccounts.size() - 1 - index].Contacts);
        }
    }

    public static void TCL() {
        // transaction Control Language
        // - Set Savepoints
        // - Rollback to savepoints

        Savepoint sp1 = Database.SetSavepoint();

        Database.rollback(sp1);
        // Does not revert ID's
        // Discard any DML that occurs after the savepoint
        // If you rollback to a savepoiint that occurs before another savepoint, that point is no longer valid
        // rolling back to savepoint does not reset your governor limits
        // setting a savepoint COUNTS as a dml operation
    }


}