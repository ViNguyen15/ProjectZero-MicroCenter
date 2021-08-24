trigger ContactTriggers on Contact (before insert, before update,before delete, after insert, after update, after delete, after undelete) {
    
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            PostHandler.flaggedPostTransfer(Trigger.new);
        }
        when AFTER_INSERT {
            
        }
        when BEFORE_UPDATE {
            PostHandler.flaggedPostTransfer(Trigger.new);
        }
        when AFTER_UPDATE {
            
        }
        when BEFORE_DELETE {
            
        }
        when AFTER_DELETE {
            
        }
        when AFTER_UNDELETE {
            
        }
    }
}