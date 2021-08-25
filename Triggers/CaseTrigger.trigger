/*
Joshua Jones 08/25/2021
*/

trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete)
{  
    switch on trigger.operationType 
    {
        when BEFORE_INSERT 
        {   
            AssignmentHandler.AssignInvestigators(trigger.new); //This function will assign our investigators to cases. 
        }
        when BEFORE_UPDATE 
        { 
            AssignmentHandler.AssignInvestigators(trigger.new); 
        }
        when BEFORE_DELETE 
        { 
            
        }
        when AFTER_INSERT 
        { 
            AssignmentHandler.UpdateInvestigators(); //Here we update the case count value for our investigators. 
        }
        when AFTER_UPDATE 
        { 
            AssignmentHandler.UpdateInvestigators();
        }
        when AFTER_DELETE 
        { 
        }
        when AFTER_UNDELETE 
        {
        }
    }
}