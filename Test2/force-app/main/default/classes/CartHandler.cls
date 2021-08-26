public class CartHandler {
    
    public static void CartProductUpdate(List<Cart__c> cart){
        List<Product2> productToUpdate = 
            [SELECT name, quantity__c FROM Product2 WHERE ID = :cart[0].product__c];
        //System.debug(productToUpdate);
        productToUpdate[0].quantity__c--;
        //System.debug(productToUpdate);
        Update productToUpdate;
    }
    
    public static void CartTotal(List<Cart__c> cart){
        //List<AggregateResult> checkoutResult = 
            //[SELECT account__c, SUM(Product__r.Price__c) priceSum, COUNT(Id) totalCount FROM Cart__c GROUP BY Account__c];
       //List<Checkout__c> checkoutExist = [SELECT account__c FROM checkout__c];
        //List<Checkout__c> toInsert = new List<Checkout__c>();
        
        
        List<Account> accountToUpdate = [SELECT id, price__c From Account];
        List<ID> accountCartNew = new List<ID>();
        for(Cart__c c: cart){
            accountCartNew.add(c.Id);
        }
        List<Cart__c> CartPrice = [SELECT account__c, product__r.Price__c FROM Cart__C WHERE id IN :accountCartNew];
        
        //for(AggregateResult result: checkoutResult){
        //    toInsert.add(new Checkout__c(name = result.account__c, account = account__c));
        //}
        
        for(Cart__c c : cartPrice){
            for(Account a : accountToUpdate){
                if(c.account__C == a.id){
                    Decimal price;
                    if(a.price__c==null){
                        price = 0;
                    }else{
                    	price = a.price__c;
                    }
                    System.debug(c.Product__r.price__c);
                    price += c.Product__r.price__c;
                    a.price__c = price;
                    
                }
            }
        }
        
        Update accountToUpdate;
        
        
        //for(AggregateResult result: checkoutResult){
        //    for(Checkout__c index : checkoutExist){
        //        if(result.account__c == index.account__c){
             
        //        }
        //    }
        //}
        
        //checkout.add(new Checkout__c(name = 'name',
        //                            account__c = cart[0].account__c,
        //                            TotalItems__c = 1,
        //                            TotalPrice__c = 1));
        //System.debug(checkout);
        //Upsert checkout;
        //Upsert toInsert;
        
    }
    
    public CartHandler(){}
    
}