/*
Joshua Jones 08/25/2021
*/

public class AssignmentHandler 
{
    public static List<User> userContext = new List<User>(); //Values get stored here during the before trigger. 
    
    public static List<Case> AssignInvestigators(List<Case> unAssigned)
    {
        List<User> allInvestigators = [SELECT CaseCount__c, LastName FROM User WHERE Profile.Name = 'Investigator' AND isActive = true]; 
        
        List<Case> returnedIfFail = unAssigned.clone();
        if(allInvestigators.size() == 0)
        {
            System.Debug('We were unable to assign Investigators to our case(s) because there are no currently active Investigators');
            return returnedIfFail;
        } //Cases don't absolutely have to be assigned by the system, but we'd prefer for them to be.
        else
        {
            List<Case> assignedCases = new List<Case>();
            
            for(Case c : unAssigned)
            {  
                if(c.Type == 'Adverse Reaction' && c.AssignedTo__c == null && c.Status != 'Closed') //We don't want to reassign cases that have already been assigned. 
                {
                    User u = selectInvestigator(allInvestigators);
                    c.AssignedTo__c = u.id;
                    c.OwnerId = u.id;  
                    assignedCases.add(c);  
                    u.CaseCount__c += 1;  
                    //We're keeping a local record of casecounts on our users because the information is changing over time,
                    //and we don't want to waste time and cause governor limit issues by querying the database needlessly.
                } 
                
                if(c.Type == 'Adverse Reaction' && c.AssignedTo__c != null && c.Status == 'Closed')
                { 
                    for(User u : allInvestigators)
                    {
                        if(u.id == c.AssignedTo__c)
                        {
                            c.AssignedTo__c = null; //Unassigning investigators from closed cases and updating their case count. 
                            u.CaseCount__c -= 1; 
                        }
                    }
                }
            }   
            userContext = allInvestigators.clone();
            return assignedCases;  
        }
    }
    
    public static User selectInvestigator(List<User> allInvestigators) //We're finding the investigator with the least current active assignments
    { 
        List<User> findLowest = allInvestigators.clone(); 
       
        List<User> result = new List<User>();
        
        Double currentLowest = 10000; //This needs a value so that our comparisons work.
        for(User u : findLowest) //This is just finding the lowest value of casecounts in the list.
        {
            if(u.CaseCount__c < currentLowest)
            {
                currentLowest = u.CaseCount__c;
            }
        } 
        for(User u : findLowest) //This will remove all users with a case count higher than the lowest value we found. 
        {
            if(u.CaseCount__c <= currentLowest)
            {
               result.add(u); 
            }
        }
        System.debug(result.get(0));
        return result.get(0); //This returns an investigator user with the lowest number of case counts, because there will always be at least one left in our list.     
    }
   
    public static void UpdateInvestigators() //Updating our Investigators
    {
        Update userContext;
    }
   
}