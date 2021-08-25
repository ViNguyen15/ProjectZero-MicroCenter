/*
Joshua Jones 08/25/2021
*/

@isTest(SeeAllData = false)
public class CreateTreatmentHandlerTest 
{
    @isTest
    public static void TP_GenerateTAs()
    {
        DataFactory.CreateOrders(1);
        
        test.startTest();
        
        Order anOrder = [SELECT status FROM Order LIMIT 1];
        PricebookEntry pBook = [SELECT id FROM PricebookEntry LIMIT 1];
        Product2 prod = [SELECT id FROM Product2 LIMIT 1]; 
        
        OrderItem anOI = new orderItem(OrderID = anOrder.id, Product2ID = prod.id, PricebookEntryID = pBook.id, Quantity = 151, UnitPrice = 10000);
        Insert anOI; //All of this just gets us to the point where we have a valid order with Orderitems that can be activated. 
        
        anOrder.status = 'Activated';
        Update anOrder;
        
        List<TreatmentAdministration__c> TAs = [SELECT region__c FROM TreatmentAdministration__c];
        
        System.assertEquals(151, TAs.Size()); //We should have generated 100 TAs for our single item because the orderItem quantity was 100. 
        
        List<Order> allOrders = [SELECT id FROM Order];
        
        System.assertEquals(1, allOrders.size()); //Still only have one order. 

        test.stopTest();
    }
    
    @isTest
    public static void TN_GenerateTAs() 
    {
        DataFactory.createOrders(1);
        
        test.startTest();
        
        Order anOrder = [SELECT status FROM Order LIMIT 1];
        PricebookEntry pBook = [SELECT id FROM PricebookEntry LIMIT 1];
        Product2 prod = [SELECT id FROM Product2 LIMIT 1]; 
        
        OrderItem anOI = new orderItem(OrderID = anOrder.id, Product2ID = prod.id, PricebookEntryID = pBook.id, Quantity = 1, UnitPrice = 10000);
        Insert anOI;
        
        anOrder.status = 'Activated';
        Update anOrder;
        
        List<Order> newOrder = [SELECT id FROM Order];
        System.assertEquals(1, newOrder.size()); //There should still only be one order. 
        
        for(Order o : newOrder)
        {
            o.Description = 'Some description text.';
        }
        
        Update newOrder;
        
        
        List<TreatmentAdministration__c> TAs = [SELECT region__c FROM TreatmentAdministration__c];
        
        System.assertEquals(1, TAs.size()); //Even though we updated an activated order a second time, we did not generate additional TAs for it. 
        
        test.stopTest();
    }
    
    @isTest
    public static void TB_GenerateTAs()
    {
        DataFactory.CreateOrders(151);
        
        test.startTest();
        
        List<Order> orderList = [SELECT status FROM Order];
        PricebookEntry pBook = [SELECT id FROM PricebookEntry];
        Product2 prod = [SELECT id FROM Product2];
        
        List<OrderItem> orderItems = new List <OrderItem>();
        
        for(Order o : orderList)
        {
            orderItems.add(new orderItem(OrderID = o.id, Product2ID = prod.id, PricebookEntryID = pBook.id, Quantity = 1, UnitPrice = 10000));
            o.status = 'Activated';
        }
        
        Insert orderItems;
        Update orderList;
        
        List<TreatmentAdministration__c> TAs = [SELECT region__c FROM TreatmentAdministration__c];
        
        System.assertEquals(151, TAs.size()); //We should have generated a TA for each activated order. 
        
        List<Order> newOrders = [SELECT id FROM Order];
        for(Order o : newOrders)
        {
            o.Description = 'Some text';
        }
        
        Update newOrders;
        
        List<TreatmentAdministration__c> T2s = [SELECT region__c FROM TreatmentAdministration__c];
        
        System.assertEquals(151, T2s.size()); //We should not have inserted new TAs. 
        
        test.stopTest();
    }
}