trigger LikeListTriggers on Like_List__c (before insert, before update, before delete, after insert, after update, after delete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            PreventDuplicates.handleLikeList(Trigger.new);
        }
        when AFTER_INSERT {
            
        }
        when BEFORE_UPDATE {
            
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