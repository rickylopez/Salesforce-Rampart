trigger AddProducer2AccountSharing on Account (after update) {

  System.debug('After Update Triggered: AddProducer2AccountSharing');

  List<AccountShare> addProdcerToAccount = new List<AccountShare>();
  for (Account acct : trigger.new) {

  	if(acct.X2nd_Producer__c != null && acct.X2nd_Producer__c != 'HO'){

  		List<User> userInfo = new List<User>([Select Id 
  												from User 
  											   where Sagitta_User_Code__c =:acct.X2nd_Producer__c 
  											   Limit 1]);

      List<User> user2Info = new List<User>([Select Id 
                                             From User 
                                             Where Second_Sagitta_User_Code__c =:acct.X2nd_Producer__c 
                                             LIMIT 1]);

  		if (!userInfo.isEmpty()){

  		AccountShare newShare = new AccountShare(); 


  		newShare.AccountId              = acct.Id; 
  		newShare.UserOrGroupID          = userInfo.get(0).Id; 
			newShare.AccountAccessLevel	    = 'Edit';
			newShare.OpportunityAccessLevel	= 'Edit';
			newShare.CaseAccessLevel        = 'Edit';
			addProdcerToAccount.add(newShare);
      }
  
      if (!user2Info.isEmpty()){

      AccountShare newShare = new AccountShare(); 


      newShare.AccountId              = acct.Id; 
      newShare.UserOrGroupID          = user2Info.get(0).Id; 
      newShare.AccountAccessLevel     = 'Edit';
      newShare.OpportunityAccessLevel = 'Edit';
      newShare.CaseAccessLevel        = 'Edit';
      addProdcerToAccount.add(newShare);
      }



            
    } 
   }    
   System.debug('Insert these Sharing Records' + addProdcerToAccount);
   if (addProdcerToAccount.size()>=1){
        for (AccountShare acctSharing : addProdcerToAccount) {
        
            try {
                insert acctSharing; 
                
            	} catch(DmlException e) {
            System.debug('The following exception has occurred during update: ' + e.getMessage());
            	}    
            }
    }

}