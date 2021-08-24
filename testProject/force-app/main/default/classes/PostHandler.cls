public class PostHandler {
    //rename classes and other comment
    
    public static void flaggedPostTransfer(List<Post__c> input) {
        ID refID = ID.valueOf('00G5e000000aaxNEAQ');
        
        for (Post__c updated : input) {
            if (updated.Flagged__c == true) {
                if (updated.OwnerId != refID) {
                    updated.OwnerId = refID;//does this need to be bulkified? (test)
                }
            }
        }
    }
    
    public static void flaggedPostTransfer(List<Contact> input) {
        List<User> modManager = [SELECT id, isActive FROM User WHERE alias = 'ethe' LIMIT 1];
        ID refID = ID.valueOf('0055e000006U183AAC');
        
        if (modManager[0].isActive) {
			fptInner(input, refID);
        }
    }
    
    public static void fptInner(List<Contact> input, ID refID) {
        for (Contact updated : input) {
            if (updated.Banned__c == true) {
                if (updated.OwnerId != refID) {
                    /*
					try {updated.OwnerId = refID;}
					catch (System.Exception e) {
					updated.Banned__c = false;
					}
					*/
                    updated.OwnerId = refID;
                }
            }
        }
    }
    
}