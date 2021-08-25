/*
Joshua Jones 08/25/2021
*/

@isTest (SeeAllData = false)
public class DataFactory 
{
    public static void InsertPositives(Integer numTreatments) //These labs have values that should pass our tests. 
    {
        List<TreatmentAdministration__c> toInsert = new List<TreatmentAdministration__c>();
        
        for(Integer num = 0; num < numTreatments; num++) 
        {
            toInsert.add(new TreatmentAdministration__c(Region__c = 'Americas', Labs_Uploaded__c = true, POST_ADMIN_NB_Activity__c = 80.1, PRE_ADMIN_NB_Efficacy__c = 301.1, NB_Activity__c = 537.1));
        }
        Insert toInsert;
    }
    
    public static void InsertNegatives(Integer numTreatments) //These labs have values that should fail our tests. 
    {
        List<TreatmentAdministration__c> toInsert = new List<TreatmentAdministration__c>();
        for(Integer num = 0; num < numTreatments; num++)
        {
             toInsert.add(new TreatmentAdministration__c(Region__c = 'Americas', Labs_Uploaded__c = true, POST_ADMIN_NB_Activity__c = 999.9, PRE_ADMIN_NB_Efficacy__c = 999.9, NB_Activity__c = 999.9));
        }
        Insert toInsert;
    }
    
    public static void InsertNonLabs(Integer numTreatments) //These TAs have no labs. 
    {
        List<TreatmentAdministration__c> toInsert = new List<TreatmentAdministration__c>();
        for(Integer num = 0; num < numTreatments; num++)
        {
            toInsert.add(new TreatmentAdministration__c(Region__c = 'Americas'));
        }
        Insert toInsert;
    }
    
    public static List<TreatmentAdministration__c> CreateTreatments(Integer numTreatments) //Creating TA data with default values
    {
        List<TreatmentAdministration__c> toReturn = new List<TreatmentAdministration__c>();
        
        for(Integer num = 0; num < numTreatments; num++) 
        {
            toReturn.add(new TreatmentAdministration__c(Region__c = 'Americas'));
        }
        
        return toReturn;
    }
    
    public static void createInvestigators(Integer num, boolean randomCaseCount)
    {
        List<User> someUsers = new List<User>();
        List<User> ProfileIDs = [SELECT ProfileID FROM User WHERE Profile.Name = 'Investigator' LIMIT 1]; 
        
        for(Integer n = 0; n < num; n++) //Users have a lot of required values....
        {
            User u = new user();
            u.LastName = 'Inv #' + string.valueOf(n);
            u.Email = 'test@test.com';
            u.Alias = 'Tcode';
            u.Username = string.valueof(n) + 'person@person.com';
            u.CommunityNickname = string.valueof(n) + 'test12';
            u.LocaleSidKey = 'en_US';
            u.TimeZoneSidKey = 'GMT';
            u.ProfileID = '00e90000000oyi5';
            u.LanguageLocaleKey = 'en_US';
            u.EmailEncodingKey = 'UTF-8';
            u.ProfileId = ProfileIDs.get(0).ProfileID;
            u.IsActive = true;
            
            if(randomCaseCount)
            {
                u.CaseCount__c = Math.rint(Math.random() * 10); //I wanted to randomize casecounts for some testing. 
            }
            else
            {
                u.CaseCount__c = 0;
            }
            someUsers.add(u);          
        }
        Insert someUsers;
    }
    
    public static void createCases(Integer toCreate) //Just creating cases. 
    {
        List<Case> toInsert = new List<Case>();
        
        for(Integer i = 0; i < toCreate; i++)
        {
            toInsert.add(new Case(region__c = 'Americas', Type = 'Adverse Reaction'));
        }
        Insert toInsert;
    }
    
    public static void createOrders(Integer toCreate) //Orders need accounts, and we need pricebooks/products/pricebookentries for testing our code. 
    {
        List<Order> toInsert = new List<Order>();  //We'll generate orderItems in our tests. 
        Account anAccount = new Account(name = 'Account name');
        PriceBook2 aPriceBook = new PriceBook2(isActive = true, id = Test.getStandardPricebookId());
        Product2 aProduct = new Product2(name = 'NanoThing', isActive = true);
        Update aPriceBook;
        Insert anAccount; 
        Account theAccount = [SELECT id FROM Account];
        
        for(Integer i = 0; i < toCreate; i++)
        {
            toInsert.add(new Order(Name = 'Order# ' + string.valueof(i), AccountID = theAccount.id, EffectiveDate = System.today(), Status = 'Draft', Pricebook2ID = aPricebook.id));
        }
        
        Insert toInsert;
        Insert aProduct;

        aPriceBook = [SELECT id FROM Pricebook2];
        aProduct = [SELECT id FROM Product2];
        
        PricebookEntry anEntry = new PricebookEntry(Product2ID = aProduct.ID, Pricebook2ID = aPriceBook.ID, UnitPrice = 10000);
        Insert anEntry;
    }
}