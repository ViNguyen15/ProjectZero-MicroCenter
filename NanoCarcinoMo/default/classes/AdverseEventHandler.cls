/*
Joshua Jones 08/25/2021
*/

public class AdverseEventHandler 
{
    public static void LabValueHandler(List<TreatmentAdministration__c> administrations)
    {
        List<TreatmentAdministration__c> failedLabs = new List<TreatmentAdministration__c>();
        
        for(TreatmentAdministration__c TA : administrations)
        {
            if(TA.Labs_Uploaded__c) //Labs should be uploaded before adding values
            {
                if(TA.PRE_ADMIN_NB_Efficacy__c != null && TA.POST_ADMIN_NB_Activity__c != null && TA.NB_Activity__c != null) 
                { //We want all lab values entered into a record before performing this check; none should be null. 
                    if(!PreEfficacyTest(TA) || !PostActivityTest(TA) || !PreActivityTest(TA))
                    {
                        failedLabs.Add(TA); //If we fail our lab value check, add them here. 
                    }                              
                }   
                else //We reach this error if any lab values are missing after the labs have been uploaded. 
                {
                    TA.addError('All lab values must be entered if the labs have been uploaded.');
                }
             }
         }
       if(failedLabs != null)
       {
           InsertCases(failedLabs); 
       }
    }
    @testVisible
    private static void InsertCases(List<TreatmentAdministration__c> toEscalate) //This method will create a new case for each TreatmentAdministration__c that failed its labs. 
    {
        List<Case> adverseEventCase = new List<Case>();
        
        for(TreatmentAdministration__c TA : toEscalate)
        {
            adverseEventCase.Add(New Case(region__c = TA.Region__c, Treatment_Administration__c = TA.Id, AccountID = TA.Account__c, Product__c = TA.Product__c, type = 'Adverse Reaction'));
        }     
        Insert adverseEventCase;
        
    }
    
    public static void ValidateData(List<TreatmentAdministration__c> administrations) //Don't allow updating records with lab values. 
    {
        for (TreatmentAdministration__c TA : administrations)
        {
            if(TA.PreviouslyUploaded__c)
            {
                TA.addError('Once labs are uploaded, Treatment Administrations may no longer be updated.');
            }
        }
    }
    
    public static List<TreatmentAdministration__c> PreviouslyUploaded(List<TreatmentAdministration__c> admins)
    {
        for(TreatmentAdministration__c TA : admins)
        { 
            if(TA.Labs_Uploaded__c)
            {
                TA.PreviouslyUploaded__c = true; //We're explicitly setting updates to always fail after labs have been uploaded, because our 
            } //organization's SOP's dictate that this should never be happening due to the sensitivity of the data. 
        }
        
        return admins;
    }
    
    @testVisible                            
    private static boolean PreActivityTest(TreatmentAdministration__c TA) //Reference range: 300 - 600
    {
        return (TA.NB_Activity__c > 300.0 && TA.NB_Activity__c < 600.0);
    }
    @testVisible
    private static boolean PostActivityTest(TreatmentAdministration__c TA) // Reference Range: <100
    {
        return (TA.POST_ADMIN_NB_Activity__c < 100.0);
    }
    @testVisible
    private static boolean PreEfficacyTest(TreatmentAdministration__c TA) // Reference Range: 230 - 350
    {
        return(TA.PRE_ADMIN_NB_Efficacy__c > 230.0 && TA.PRE_ADMIN_NB_Efficacy__c < 350.0);
    }
}