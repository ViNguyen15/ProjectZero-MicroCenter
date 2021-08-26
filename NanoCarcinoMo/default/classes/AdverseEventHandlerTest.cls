/*
Joshua Jones 08/25/2021
*/

@isTest 
public class AdverseEventHandlerTest 
{   
    @isTest
    public static void TP_LabInsertion() //This inserts labs that should pass our checks. 
    {
        Test.startTest();
        
        TreatmentAdministration__c treatment = DataFactory.CreateTreatments(1)[0];
        treatment.Labs_Uploaded__c = true; 
        treatment.PRE_ADMIN_NB_Efficacy__c = 250.0;
        treatment.POST_ADMIN_NB_Activity__c = 53.2;
        treatment.NB_Activity__c = 452.7;
        
        boolean preAdminResult = AdverseEventHandler.PreActivityTest(treatment);
        System.assertEquals(true, preAdminResult); //Checking each individual method
        
        boolean postAdminActResult = AdverseEventHandler.PostActivityTest(treatment);
        System.assertEquals(true, postAdminActResult);
        
        boolean preAdminEff = AdverseEventHandler.PreEfficacyTest(treatment);
        System.assertEquals(true, preAdminEff);
        
        Insert treatment; //Inserting the treatment to the database
        
        List<Case> queryCase = [SELECT region__c FROM Case]; //Retrieving the cases from the database
        System.assertEquals(0, queryCase.Size()); //We should not have generated any cases, so this result should be zero. 
        
        Test.stopTest();
    }
    
    @isTest
    public static void TN_LabInsertion() //Here I'm checking for failure on the TA. 
    {
        Test.starttest();
        
        TreatmentAdministration__c treatment2 = DataFactory.CreateTreatments(1)[0];
        treatment2.Labs_Uploaded__c = true; 
        treatment2.PRE_ADMIN_NB_Efficacy__c = 999.9;
        treatment2.POST_ADMIN_NB_Activity__c = 999.9;
        treatment2.NB_Activity__c = 999.9; //These values are all out of range. 
        
        boolean preAdminResult2 = AdverseEventHandler.PreActivityTest(treatment2); 
        System.assertEquals(false, preAdminResult2); //Checking for failure on each individual method
        
        boolean postAdminActResult2 = AdverseEventHandler.PostActivityTest(treatment2);
        System.assertEquals(false, postAdminActResult2);
        
        boolean preAdminEff2 = AdverseEventHandler.PreEfficacyTest(treatment2);
        System.assertEquals(false, preAdminEff2);
        
        TreatmentAdministration__c treatment3 = DataFactory.CreateTreatments(1)[0]; //This is a second lab that fails if values are too low
        treatment3.Labs_Uploaded__c = true; 
        treatment3.PRE_ADMIN_NB_Efficacy__c = 000.1;
        treatment3.POST_ADMIN_NB_Activity__c = 000.1; //This value would pass. 
        treatment3.NB_Activity__c = 000.1;
        
        boolean preAdminResult3 = AdverseEventHandler.PreActivityTest(treatment3);
        System.assertEquals(false, preAdminResult3); //Checking for failure
        
        boolean preAdminEff3 = AdverseEventHandler.PreEfficacyTest(treatment3);
        System.assertEquals(false, preAdminEff3);
        
        Insert treatment2;
        Insert treatment3; 
        
        List<Case> escalatedCases = [SELECT region__c FROM Case];
        System.assertEquals(2, escalatedCases.size()); //We should have generated 2 cases from inserting the two failed TA Labs
        
        Test.stopTest();
    }
    
    @isTest
    public static void TP_LabBulkInsertion() //Testing for bulk insertion with positive lab values
    {
        Test.startTest();
        List<TreatmentAdministration__c> testBatch = DataFactory.CreateTreatments(151);
        AdverseEventHandler.LabValueHandler(testBatch);
        Insert testBatch;
        
        List<TreatmentAdministration__c> queryTest = [SELECT region__c FROM TreatmentAdministration__c];
        Integer results = queryTest.Size();
        System.assertEquals(151, results); //Did all of our TAs get inserted?
        
        List<Case> allCases = [SELECT region__c FROM Case];
        System.assertEquals(0, allCases.size()); //We should have generated no new cases. 
        
        Test.stopTest();
    }
    
    @isTest
    public static void TN_LabBulkInsertion() 
    {
        Test.starttest();
        
        DataFactory.InsertNegatives(151);
        
        List<Case> returned = [SELECT region__c FROM CASE];
        
        System.assertEquals(151, returned.size()); //We should have generated 151 cases for all of the negative value TA Labs Inserted. 
        
        Test.stopTest();
    }

    @isTest
    public static void TP_UpdateSingle() //We should be able to update multiple times if lab values have not been uploaded. 
    {
        Test.startTest();
        
        DataFactory.InsertNonLabs(1);
        
        TreatmentAdministration__c TA = [SELECT region__c FROM TreatmentAdministration__c LIMIT 1];
        TA.region__c = 'Asia/Pacific'; 
        Update TA;
        
        TreatmentAdministration__c T2 = [SELECT region__c FROM TreatmentAdministration__c LIMIT 1];
        
        System.AssertEquals('Asia/Pacific', T2.Region__c); //Did our Update succeed?
        T2.Region__c = 'Africa/Europe'; 
        Update T2;
        
        TreatmentAdministration__c T3 = [SELECT region__c FROM TreatmentAdministration__c LIMIT 1];
        
        System.AssertEquals('Africa/Europe', T3.Region__c); 
        
        List<TreatmentAdministration__c> allTreatments = [SELECT Region__c FROM TreatmentAdministration__c];
        
        System.assertEquals(1, allTreatments.size()); //We should still only have one total TA
        
        Test.stopTest();
    }
    
    @isTest
    public static void TN_UpdateSingle() //We should experience failure trying to update records with labs uploaded and not all values filled in.
    {
        Test.startTest();
        
        DataFactory.InsertNonLabs(1);
        TreatmentAdministration__c TA = [SELECT region__c FROM TreatmentAdministration__c LIMIT 1];
        TA.Labs_Uploaded__c = true; 
        try
        {
            Update TA; //We should be unable to update labs that have not had all lab values filled in. 
        }
        catch (Exception e)
        {
            String mesg = e.getMessage();
            System.assertEquals(true, mesg.contains('All lab values')); //Did we get the right error? 
        }
        
        TA.NB_Activity__c = 400.1;
        TA.PRE_ADMIN_NB_Efficacy__c = 301.1;
        
        try
        {
            Update TA;
        }
        catch(Exception e)
        {
            String mesg = e.getMessage();
            System.assertEquals(true, mesg.contains('All lab values')); //We should still fail because we don't have all of the lab values.
        }
        
        TA.POST_ADMIN_NB_Activity__c = 94.1;
        Update TA; //This should succeed now, because we now have all values. 
        
        try //Now we fail again, because labs have already been uploaded. 
        {
            Update TA;
        }
        catch(Exception e)
        {
            String mesg = e.getMessage();
            System.assertEquals(true, mesg.contains('Once labs are uploaded')); //No more updates after labs have been uploaded. 
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void TP_UpdateBulk()
    {
        Test.startTest();
        
        DataFactory.InsertNonLabs(151);
        List<TreatmentAdministration__c> TAs = [SELECT region__c FROM TreatmentAdministration__c];
        
        for(TreatmentAdministration__c TA : TAs)
        {
           TA.Region__c = 'Asia/Pacific'; 
        }
        Update TAs;
        List<TreatmentAdministration__c> TAs2 = [SELECT region__c FROM TreatmentAdministration__c];
        
        for(TreatmentAdministration__c TA: TAs2)
        {
            System.assertEquals('Asia/Pacific', TA.Region__c); //Did all of our TAs get Updated? 
            TA.Labs_Uploaded__c = true;
            TA.NB_Activity__c = 320.0;
            TA.PRE_ADMIN_NB_Efficacy__c = 301.0;
            TA.POST_ADMIN_NB_Activity__c = 71; 
        }
        Update TAs2; //We should be able to update more than once until labs have been uploaded on records. 
        List<TreatmentAdministration__c> totalRecords = [SELECT region__c FROM TreatmentAdministration__c];
        
        System.assertEquals(151, totalRecords.size()); 
        
           
        Test.stopTest();
    }
    
    @isTest
    public static void TN_UpdateBulk()
    {
        Test.startTest();
        
        DataFactory.InsertNonLabs(151); 
        
        List<TreatmentAdministration__c> TAs = [SELECT region__c FROM TreatmentAdministration__c];
        
        for(TreatmentAdministration__c TA : TAs)
        {
            TA.Labs_Uploaded__c = true;
            TA.NB_Activity__c = 301.1;
        }
        
        try
        {
            Update TAs;
        }
        catch (exception e)
        {
            String mesg = e.getMessage();
            System.assertEquals(true, mesg.contains('All lab values'));
        }
        
        for(TreatmentAdministration__c TA : TAs)
        {
            TA.PRE_ADMIN_NB_Efficacy__c = 301.1;
            TA.POST_ADMIN_NB_Activity__c = 43.1;
        }
        
        Update TAs;
        
        try
        {
            Update TAs;
        }
        catch(exception e)
        {
            String mesg = e.getMessage();
            System.assertEquals(true, mesg.contains('Once labs are uploaded'));
        }
        
        
     
        Test.stopTest();
    }
    
    @isTest
    public static void TP_BulkCaseInsertion() //We're testing for bulk case generation/lab failure here. 
    {
        test.startTest();
        
        DataFactory.InsertNegatives(151); 
        List<case> casesGenerated = [SELECT region__c FROM case]; 
        
        System.assertEquals(151, casesGenerated.size());
        
        DataFactory.InsertNonLabs(49);
        
        List<TreatmentAdministration__c> TAs = [SELECT region__c FROM TreatmentAdministration__c WHERE Labs_Uploaded__c = false ];
        
        for(TreatmentAdministration__c TA : TAs)
        {
            TA.Labs_Uploaded__c = true;
            TA.NB_Activity__c = 999.9;
            TA.PRE_ADMIN_NB_Efficacy__c = 999.9;
            TA.POST_ADMIN_NB_Activity__c = 999.9;
        }
        Update TAs;
        
        List<Case> totalCases = [SELECT region__c FROM Case];
        
        System.assertEquals(200, totalCases.size()); //Inserted and updated TAs with expected fail values both generated cases properly. 
        
        test.stopTest();
    }
}