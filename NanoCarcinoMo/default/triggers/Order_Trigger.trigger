/*
Joshua Jones 08/25/2021
*/

trigger Order_Trigger on Order(before insert, before update, before delete, after insert, after update, after delete, after undelete)
{
    switch on trigger.operationType
    {
        when BEFORE_INSERT //Orders don't start out with any items added to them, so we don't need to do anything here.
        { 
        }
        when BEFORE_UPDATE 
        { 
            CreateTreatmentHandler.GenerateTAs(Trigger.new, trigger.old); //We need both the old and new trigger to compare the record for a change in the status
        }
        when BEFORE_DELETE 
        { 
        }
        when AFTER_INSERT 
        { 
        }
        when AFTER_UPDATE 
        { 
            Upsert CreateTreatmentHandler.TAs; //Had to use Upsert here; I think I'm getting duplicates because of the Save Order of Execution. 
        }
        when AFTER_DELETE 
        { 
        }
        when AFTER_UNDELETE 
        {
        }
    }
}