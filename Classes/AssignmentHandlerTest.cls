/*
Joshua Jones 08/25/2021
*/

@isTest
public class AssignmentHandlerTest 
{
    
    @isTest
    public static void TP_SelectInvestigator() //This function really shouldn't fail; we don't get this far if there aren't any investigators to assign.
    {
        DataFactory.createInvestigators(18, true);
        
        test.startTest();
        
        List<User> allInvestigators = [SELECT CaseCount__c FROM USER WHERE Profile.Name = 'Investigator' AND isActive = true];
        
        List<Double> caseCounts = new List<Double>();
       
        for(User u : allInvestigators)
        {
            caseCounts.add(u.CaseCount__c);
        }
        
        caseCounts.sort(); //This function sorts in ascending order. 
       
        Double lowest = caseCounts.get(0);
        System.assertEquals(lowest, AssignmentHandler.selectInvestigator(allInvestigators).caseCount__c);
        //AssignmentHandler.selectInvestigator should return an investigator with the lowest case count even if there are multiple investigators with the same amount.
        test.stopTest();
    }
    
    @isTest
    public static void TP_AddBulkCase()
    {
        DataFactory.createInvestigators(151, false);
        
        test.startTest();
        
        DataFactory.createCases(151);
        
        List<User> allInvestigators = [SELECT caseCount__c FROM User WHERE Profile.Name = 'Investigator' AND isActive = true];
        
        for(User u : allInvestigators)
        {
            System.assertEquals(1, u.CaseCount__c); //Creating 151 cases for 151 users should mean they all have 1 case assigned. 
        }
        
        test.stopTest();
    }
    
    @isTest 
    public static void TN_AddBulkCase() //This should only fail if we don't have any investigators. 
    {
        test.startTest();
        DataFactory.createCases(151);
        List<User> allInvestigators = [SELECT caseCount__c FROM User WHERE Profile.Name = 'Investigator' AND isActive = true];
        
        System.assertEquals(0, allInvestigators.size()); //We should have no active investigators for this test. 
        
        List<Case> allCases = [SELECT region__c, AssignedTo__c FROM Case];
        
        for(Case c : allCases)
        {
            System.assertEquals(null, c.AssignedTo__c); //These cases should not have been assigned, because there are no investigators. 
        }
        
        test.stopTest();
    }

    @isTest
    public static void TSingle_Assignment()
    {
        DataFactory.createInvestigators(1, false);
        
        test.startTest();
        
        List<User> allUsers = [SELECT CaseCount__c FROM User WHERE Profile.name = 'Investigator' AND isActive = true];
        System.assertEquals(1, allUsers.size());
        
        DataFactory.createCases(1);
        
        Case cases = [SELECT AssignedTo__c FROM Case LIMIT 1];
        User users = [SELECT CaseCount__c FROM User WHERE Profile.name = 'Investigator' AND isActive = true];
        
        System.assertEquals(1, users.CaseCount__c); //Did we update our casecount? 
        System.assertEquals(Users.id, Cases.AssignedTo__c); //Did our case get assigned? 
        
        test.stopTest();
    }
    
    @isTest
    public static void TSingle_Unassignment()
    {
        DataFactory.createInvestigators(1, false);
        DataFactory.CreateCases(1);
        
        test.startTest();
        
        Case aCase = [SELECT AssignedTo__c FROM Case LIMIT 1];
        User aUser = [SELECT CaseCount__c FROM User WHERE Profile.Name = 'Investigator' AND isActive = true LIMIT 1];
        
        aCase.Status = 'Closed';
        Update aCase;
        
        Case finalCase = [SELECT AssignedTo__c, Status FROM Case WHERE id = :aCase.id];
        User updatedUser = [SELECT CaseCount__c FROM User WHERE id = :aUser.id];
        
        System.assertEquals(0, updatedUser.CaseCount__c); //Checking if the casecount got updated for unassignment
        System.assertEquals(finalCase.AssignedTo__c, null); //Checking that set this to null
        System.assertEquals(finalCase.Status, 'Closed'); //Checking that the final case was closed
        
        test.stopTest();
    }
}