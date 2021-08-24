trigger PizzaTrigger on Pizza__C (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    //the main switch statement
    switch on trigger.operationType {
        when BEFORE_INSERT { 
            updatePrice();
        }
        when BEFORE_UPDATE { 
            updatePrice();
        }
        when BEFORE_DELETE { 
        }
        when AFTER_INSERT { 
            updateShoppingCart();
        }
        when AFTER_UPDATE {
            updateShoppingCart();
        }
        when AFTER_DELETE { 
        }
        when AFTER_UNDELETE {
            
        }
    }
    // used to update the price based on the size and toppings of the pizza
    // TODO: fix specials discount (based on record type)
    public static void updatePrice(){
        for (pizza__c toAdjust : Trigger.New){

            toAdjust.Price__c = 0.00;

            switch on toAdjust.size__c {
                when 'Small' {
                    toAdjust.price__c += 10;
                }
                when 'Medium' {
                    toAdjust.price__c += 14;
                }
                when 'Large' {
                    toAdjust.price__c += 16;
                }
                when 'Extra_Large' {
                    toAdjust.price__c += 18;
                }
            }
            if (!(toAdjust.toppings__c == null)){
                if (toAdjust.toppings__c.contains('Pepporoni')){
                    toAdjust.price__c += .50;
                }
                if (toAdjust.toppings__c.contains('Bacon')){
                    toAdjust.price__c += .50;
                }
                if (toAdjust.toppings__c.contains('Sausage')){
                    toAdjust.price__c += .50;
                }
                if (toAdjust.toppings__c.contains('Pineapple')){
                    toAdjust.price__c += .50;
                }
            }
            //Discounts based on record type (special offers)
            
            String recordType = toAdjust.RecordTypeID;
            if (recordType == 'meatLoverSpecial'){
                toAdjust.price__c *= .80;
            }
            
        }
    }
    //Updates the price total of a shopping cart on pizza creation or update
    public static void updateShoppingCart(){
        Map<ID, Decimal> pricedifferences = new Map<ID, Decimal>();
        for (pizza__c toAdjust : Trigger.New){
            if (Trigger.isInsert){
                pricedifferences.put(toAdjust.shopping_cart__c, toAdjust.price__c);
            } else {
                if (toAdjust.price__c != Trigger.oldMap.get(toAdjust.id).price__c){
                    pricedifferences.put(toAdjust.shopping_cart__c, toAdjust.price__c - Trigger.oldMap.get(toAdjust.id).price__c);
                }
            }
        }
        List<shopping_cart__c> cartList = [SELECT id, total_cost__c FROM Shopping_cart__c];
        for (shopping_cart__c toAdjust: cartList){
            if (!(pricedifferences.get(toAdjust.id) == null)){
                toAdjust.Total_Cost__c += pricedifferences.get(toAdjust.id);
            }
        }
        Update cartList;
    }



}
