public with sharing class TriggerHelper {

    //used for Order Ticket Insert to validate inputs
    public static void checkForDuplicates(list<Order_Ticket__c> triggerlist){
        List<Order_Ticket__C> Tickets = [SELECT id, Pizza__c, Cook__c FROM Order_Ticket__c];
        for (Order_Ticket__C curr : triggerlist){
            for (Order_Ticket__C tik : Tickets){
                System.debug('code here');
                if (tik.cook__c == curr.cook__c && tik.pizza__c == curr.pizza__c){
                    System.debug('error added');
                    curr.addError('this is a duplicate ticket');
                }
            }
        }
    }
}
