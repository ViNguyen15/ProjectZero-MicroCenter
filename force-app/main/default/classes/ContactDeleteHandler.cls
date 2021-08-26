public class ContactDeleteHandler {
    
    public static void DeleteEmptyAccounts() {

        List<Account> Acc2 = [SELECT name, (SELECT name FROM contacts) FROM account];
        
        integer x;
        List<Account> toDelete = new List<Account>();
        for (integer i=0; i < Acc2.size(); i++){
            
            x = Acc2[i].Contacts.size();
            if (x == 0) {
                toDelete.add(Acc2[i]);
            }          
        }
      database.delete(toDelete, false);

	}

}