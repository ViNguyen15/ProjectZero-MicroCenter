/*
Joshua Jones 08/25/2021
*/

public class CreateTreatmentHandler 
{
    public static List<TreatmentAdministration__c> TAs = new List<TreatmentAdministration__c>(); //Using this to get TAs for inserting in After Update. 
    
    public static void GenerateTAs(List<Order> orders, List<Order> oldOrder) //We'll generate TreatmentAdministration__c objects here. We only do this if the order has been activated.
    {
        List<Order> isActive = new List<Order>();
        
        for(Order o : orders)
        {
            for(Order old : oldOrder) //We compare the old and new order statuses to see if they've gone from inactive to active. 
            {
                if(old.ID == o.ID)
                {
                    if(old.Status != 'Activated' && o.Status == 'Activated')
                    {
                        isActive.add(o);
                    }
                }
            }
        }
        List<OrderItem> OPs = [SELECT Quantity, OrderID, Product2ID FROM OrderItem WHERE OrderID IN :isActive];
        
        for(OrderItem OI : OPs)
        {
            for(Integer i = 0; i < OI.Quantity; i++) //We add a new TA for each orderItem Quantity count. 
            {    
                    TAs.add(new TreatmentAdministration__c(Account__c = GetAccount(OI.OrderId, isActive), Product__c = OI.Product2Id, Order__c = OI.OrderId, Product_Serial__c = GenerateSerial(OI.id, i)));       
            }
        }
    }
    
    public static string GenerateSerial(id theOrder, integer i) //Just generating a serial number for our products. 
    {
        string ord = Id.valueof(theOrder).to15();
        string intVal = string.valueOf(i);

        return ord + intVal;
    }
    
    public static id GetAccount(id orderID, List<Order> orderList) //Just retrieving the account associated with the order. I'm sure there's a better way to do this.
    {
        Account toReturn = new Account(); 
        for(Order o : orderList)
        {
            if(o.Id == orderID)
            {
                toReturn.Id = o.AccountId;
            }
        }   
        return toReturn.id;
    }
}