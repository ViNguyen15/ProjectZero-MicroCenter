public class FriendsListHandler {
    public static void createMirrors(List<Friends_List__c> input) {

        //finally working?
    
        List<Friends_List__c> output = duplicatesList(input, true);//new duplicates        
        if (output.Size() > 0) {Insert output;}
    }
    
    public static void deleteMirrors(List<Friends_List__c> input) {
      
        List<Friends_List__c> output = duplicatesList(input, false);//existing duplicates        
        if (output.Size() > 0) {Delete output;}
    }
    
    public static List<Friends_List__c> duplicatesList(List<Friends_List__c> input, boolean isInsert) {
        List<Friends_List__c> output = new List<Friends_List__c>();       
        List<Friends_List__c> existingFriends = new List<Friends_List__c>([SELECT Contact1__c, Contact2__c FROM Friends_List__c WHERE RequestAccepted__c = True]);
        
        for (Friends_List__c inputRecord : input) {
            if (inputRecord.RequestAccepted__c == true) {
                output.addall(hasDuplicates(inputRecord, existingFriends, isInsert));
            }
        }
        return output;
    }
    
    public static List<Friends_List__c> hasDuplicates(Friends_List__c inputRecord, List<Friends_List__c> existingFriends, boolean isInsert) {
        List<Friends_List__c> innerOutput = new List<Friends_List__c>();
        
        for (Friends_List__c existing : existingFriends) {      
            if (isDuplicate(inputRecord, existing)) { 
                if (isInsert) {return innerOutput;}
                else{//for delete triggers
                    innerOutput.add(existing);
                    System.debug('Mirror to be deleted');
                }
            }
        }

        if (isInsert) {
            innerOutput.add(new Friends_List__c(Contact1__c = inputRecord.contact2__c, Contact2__c = inputRecord.contact1__c, RequestAccepted__c = true));
            System.debug('Record mirrored');
        }
        return innerOutput;
    }
    
    public static boolean isDuplicate(Friends_List__c a, Friends_List__c b) {        
        if (a.Contact1__c == b.Contact2__c && a.Contact2__c == b.Contact1__c) {return true;}        
        return false;
    }
}