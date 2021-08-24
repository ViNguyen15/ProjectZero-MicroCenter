trigger ShoppingCartTrigger on Shopping_Cart__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    //The main switch statement
    switch on trigger.operationType {
        when BEFORE_INSERT { 
            setCostToZero();
        }
        when BEFORE_UPDATE { 
        }
        when BEFORE_DELETE { 
        }
        when AFTER_INSERT { 
        }
        when AFTER_UPDATE {
        }
        when AFTER_DELETE { 
        }
        when AFTER_UNDELETE {
            
        }
    }

    public static void setCostToZero(){
        for (shopping_cart__c cart : Trigger.new){
            cart.Total_Cost__c = 0;
        }
    }
}