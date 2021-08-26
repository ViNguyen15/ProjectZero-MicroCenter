public class ContactHandler {
    public static void ValidateContact(List<Contact> newContact){
        List<Contact> orgContact = [SELECT name, email FROM Contact];
        for (integer i=0; i<orgContact.size(); i++) {
            for(integer j=0; j<newContact.size(); j++){
                if(newContact[j].Email == orgContact[i].Email){
                    
                    newContact[j].addError('Entered email already exists!');
                }
                else {
                    continue;
                }
            }
         }
     }
}