trigger AccountTrigger on Account (after insert, after update) {
    
    Boolean isFuture = System.isFuture();
    System.debug('Is Future?' + isFuture);
    
    if (!ConfirmAccount.AsyncFlag) {
        
        Set<ID> ids = new Set<ID>();
        
        System.debug('Just created ids: ' + ids);
        for (Account newAcnt : trigger.new) {

		    if (Trigger.isUpdate && newAcnt.Client_Code__c== null && newAcnt.SendAccount__c){
                System.debug('Send Account' + newAcnt.Name + ': ' + newAcnt.Id);
                ids.add(newAcnt.id);   

            }
        } 
        
        if ((ids.size() > 0) && (!isFuture)) {
            System.debug('Final IF' + ids);
            ConfirmAccount.confirmAccountName(ids);
            }
    }
    
}