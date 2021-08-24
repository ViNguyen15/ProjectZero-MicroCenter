trigger FriendsListTriggers on Friends_List__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            PreventDuplicates.handleFriendsList(Trigger.New);
        }
        when AFTER_INSERT {
            FriendsListHandler.createMirrors(Trigger.new);
        }
        when BEFORE_UPDATE {
            
        }
        when AFTER_UPDATE {
            FriendsListHandler.createMirrors(Trigger.new);
        }
        when BEFORE_DELETE {
            
        }
        when AFTER_DELETE {
            FriendsListHandler.deleteMirrors(Trigger.old);
        }
        when AFTER_UNDELETE {
            
        }
        
    }
}