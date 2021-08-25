/*
Joshua Jones 08/25/2021
*/

trigger TreatmentAdministrationTrigger on TreatmentAdministration__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
switch on trigger.operationType 
   {
        when BEFORE_INSERT 
        { 
           
        }
        when BEFORE_UPDATE //Because we know the system is going to be Inserting all of our TAs, we don't need to validate them in Before_Insert
        { 
           AdverseEventHandler.ValidateData(trigger.new);
           AdverseEventHandler.PreviouslyUploaded(trigger.new);
        }
        when BEFORE_DELETE 
        { 
        }
        when AFTER_INSERT 
        { 
            AdverseEventHandler.LabValueHandler(trigger.new);
        }
        when AFTER_UPDATE 
        { 
            AdverseEventHandler.LabValueHandler(trigger.new);
        }
        when AFTER_DELETE 
        { 
        }
        when AFTER_UNDELETE 
        {
        }
    }
}