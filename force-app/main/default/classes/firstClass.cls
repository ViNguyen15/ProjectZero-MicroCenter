public with sharing class firstClass {

    public static void SOQL() {
        List<Account> myResults = [SELECT name FROM Account];
        Sustem.debug(myResults[0].name);
    }

    //Aggregate functions
    /*
    values are stored in "AggregateResult" data type, i.e
    AggregateResult myResult = SELECT AVG(field) FROM Account;
    AVG(), COUNT(), MIN(), MAX(), SUM(), COUNT_DISTINCT()
    ignores null values for fields
    */

    /*
    GROUP BY clause allows sorting of results

    Date Functions
    CALENDER_YEAR(), CALENDER_QUARTER(), DAY_IN_MONTH(), DAY_IN_WEEK(), DAY_IN_YEAR(), DAY_ONLY(), 
    FISCAL_MONTH(), FISCAL_QUARTER(), FISCAL_YEAR(), HOUR_IN_DAY(), WEEK_IN_MONTH(), WEEK_IN_YEAR()
    SELECT DAY_IN_WEEK(CloseDate) FROM Oppurtunity GROUP BY DAY_IN_WEEK(CloseDate); <-- example query

    */

    /*
    Relationship Queries
    - Parent to Child
    - Accounts -> Contacts
    - SELECT name, (SELECT name FROM Contacts) FROM account;

    ORDER BY
    can order a query by a field DESC (descending) or ASC (Ascending)
    Can add "NULLS LAST" or "NULLS FIRST" to choose where null values go

    */


    /*
    DML: Data Manipulation Language

    ALLOWS PERSISTENT CHANGES TO DATABASE
    -Insert
    -Update
    -Delete
    -Merge

    Example: Account myNewAccount = new Account(name = 'My Test Account', rating = 'hot');
    Insert myNewAccount;
    List<Account> toDelete = [SELECT name FROM Account WHERE name = 'My Test Account'];
    Delete toDelete;

    Salesforce will throw an error if you try to insert a record with a null value in a required field.
    If even a single record is a list is invalid, insert will fail.
    However, if you add the "false" parameter to an insert, it will set "all or nothing" to false
    and you will be able to insert the valid records from that list.

    example: Database.Insert(myList, false); will insert all valid records even if some are invalid
             Database.Insert(myList); fails with just one invalid record

    You can only complete 150 DML statements per query - governor limits.
    Attempting to complete over 150 DML statements in a query will rollback all statements in the query and fail.
    */

    /*
    SAVEPOINTS
        Rolling back to a save point does not reset your governor limits
        Savepoints will not revert IDs
        Savepoints discard any DML that occurs after the savepoint
        If you rollback to a savepoint before another savepoint, the latter becomes inaccessible.

        Sample code:
        Savepoint sp1 = Database.setSavepoint();
        Database.Rollback(sp1);
        Setting a savepoint counts as a DML operation.
        Savepoints can easily result in surpassing governor limits.
    */
}