trigger PizzaTrigger on Pizza__C (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    //the main switch statement
    switch on trigger.operationType {
        when BEFORE_INSERT { 
            TriggerHelper.updatePrice(Trigger.new);
        }
        when BEFORE_UPDATE { 
            TriggerHelper.updatePrice(Trigger.new);
        }
        when BEFORE_DELETE { 
        }
        when AFTER_INSERT { 
            updateShoppingCart(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            updateShoppingCart(Trigger.new, Trigger.oldMap);
        }
        when AFTER_DELETE { 
        }
        when AFTER_UNDELETE {
            
        }
    }


}
