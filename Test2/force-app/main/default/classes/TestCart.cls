@isTest
public class TestCart {
    
    @testSetup
    static void setup(){
        List<Product2> testProducts = new List<Product2>();
        List<Account> testAccounts = new List<Account>();
        
        for(Integer i = 0; i < 10; i++){
            testProducts.add(new Product2(name = 'products'+ i, quantity__c = (2 + i), price__c = ((i+1)*20) ));
            testAccounts.add(new Account(name = 'Tester' + i, price__c = 0));
        }
        Insert testProducts;
        Insert testAccounts;
        
        testProducts = [SELECT id FROM Product2];
        testAccounts = [SELECT id FROM Account];
        
        List<Cart__c> testCarts = new List<Cart__c>();
        
        for(Integer j = 0; j < 3; j++ ){
            testCarts.add(new Cart__c(account__c = testAccounts[j].id, 
                                  product__c = testProducts[j].id));
        }
        Insert testCarts;
        
    }
    
    @isTest
    static void TestProductUpdate(){
        setup();
        Test.startTest();
        List<Product2> productToBeTested = [SELECT name, quantity__c FROM Product2 WHERE name = 'Products0'];
        Decimal num = productToBeTested[0].quantity__c;
        List<Account> accountToBeTested = [SELECT id FROM Account];
        
        Insert new Cart__c(account__c = accountToBeTested[0].id, 
                           product__c = productToBeTested[0].id);
               
        List<Product2> newProduct = [SELECT name, quantity__c FROM Product2 WHERE name = 'Products0'];
        Decimal num2 = newProduct[0].quantity__c;
        
        System.assertEquals(num - 1, num2);
        
        Test.stopTest();
        
    }
    
    @isTest
    static void TestPrice(){
        setup();
        Test.startTest();
        List<Product2> productToBeTested = [SELECT name, quantity__c FROM Product2 WHERE name = 'Products0'];
        
        List<Account> accountToBeTested = [SELECT id, price__c FROM Account WHERE name = 'Tester0'];
        Decimal num = accountToBeTested[0].price__c;
        
        List<Cart__c> testingCarts = new List<Cart__c>();
        for(Integer i = 0; i < 151; i++){
        	testingCarts.add(new Cart__c(account__c = accountToBeTested[0].id, 
                    					 product__c = productToBeTested[0].id));
        }
        Insert testingCarts;
        
        List<Account> accountTested = [SELECT id, price__c FROM Account WHERE name = 'Tester0'];
        Decimal num2 = accountTested[0].price__c;
        
        System.assertEquals(3060, num2);
        
        Test.stopTest();
    }

}