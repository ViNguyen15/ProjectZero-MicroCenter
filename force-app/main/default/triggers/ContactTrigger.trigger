trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    switch on trigger.operationType {
        when BEFORE_INSERT {
           ContactHandler.ValidateContact(trigger.new);      
        }
        when BEFORE_UPDATE {
           ContactHandler.ValidateContact(trigger.new);  
        }
        when BEFORE_DELETE {
        }
        when AFTER_INSERT {
        }
        when AFTER_UPDATE {
        }
        when AFTER_DELETE {
            ContactDeleteHandler.DeleteEmptyAccounts();
        }
        when AFTER_UNDELETE {
            
        }
    }
    
    System.Debug('A record has been inserted!');
}