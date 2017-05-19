trigger CreateNewOpp on Policy__c (after insert) {

System.debug('Create New Opp Fired');   

//List of Opportunities to Create and Associate Policy    
List<Opportunity> createOpps = new List<Opportunity>();
List<Policy__c> updatePolicy = new List<Policy__c>();

    for (Policy__c polInfo : Trigger.new) {
      
      //Does Policy Opportunity already exist? 
      List<Opportunity> oppExist = new List<Opportunity>([Select Id,
                                                                 Name 
                                                            From Opportunity
                                                           Where AccountId =: polInfo.account__c 
                                                             and RefSagittaID__c = null 
                                                           LIMIT 1]); 

      System.debug('Does the Opp Exist? ' + oppExist.size());
      



      //Create Opportunity 
      Opportunity createOpp = new Opportunity();


      //Policy Number 
      String polNumber = polInfo.Name;
   
      //Find Owner and Type of Business Account 
           List<Account> acctId = new List<Account>([Select OwnerId, 
                                                            RecordTypeId 
                                                       From Account 
                                                      Where Id =:polInfo.account__c LIMIT 1]); 
           
           List<RecordType> lookupRecId = new List<RecordType>([Select Id,
                                                                       Name 
                                                                  From RecordType 
                                                                 Where Id=:acctId.get(0).RecordTypeId LIMIT 1]);
          
          List<RecordType> recTypeList = new List<RecordType>();
           

           if (lookupRecId.get(0).Name == 'Individual') {
              recTypeList = [Select Id 
                               From RecordType 
                              Where Name = 'Personal Lines' LIMIT 1];
              System.debug('Inside IF Record Type' + recTypeList.get(0).Id);
               
           } else {
               recTypeList = [Select Id 
                                From RecordType 
                               Where Name = 'Commercial Lines' LIMIT 1];
              System.debug('Inside IF Record Type' + recTypeList.get(0).Id);  
           }
              System.debug('Outside IF Record Type' + recTypeList.get(0).Id);  
              System.debug('Opporunity Account' + polInfo.account__c);

      

      if (polNumber.containsIgnoreCase('APP') && !oppExist.isEmpty()){

        System.debug('Update Existing Opp  ' + oppExist.get(0).Name);

        Policy__c pol = new Policy__c(); 

           createOpp.Id              = oppExist.get(0).Id;
           createOpp.Name            = 'New ' + polInfo.Coverage_Detail__c + ' Opportunity'; 
           createOpp.AccountId       = polInfo.account__c; 
           createOpp.RecordTypeId    = recTypeList.get(0).Id;
           createOpp.StageName       = 'Marketing';
           createOpp.CloseDate       = polInfo.Effective_Date__c;
           createOpp.Amount          = polInfo.EstPremAmt__c;
           createOpp.RefSagittaID__c = polInfo.SagittaID__c;
           createOpp.OwnerId         = acctId.get(0).OwnerId; 
           createOpps.add(createOpp);

           pol.Id = polInfo.Id;
           pol.Opportunity__c = oppExist.get(0).Id;
           updatePolicy.add(pol);

      }


      if (polNumber.containsIgnoreCase('APP') && oppExist.isEmpty()){
           System.debug('Found New Policy Opportunity' + polInfo.Name);
           
         System.debug('Create a New Opp');

           //Set New Opportunity Values 
           createOpp.Name            = 'New ' + polInfo.Coverage_Detail__c + ' Opportunity'; 
           createOpp.AccountId       = polInfo.account__c; 
           createOpp.RecordTypeId    = recTypeList.get(0).Id;
           createOpp.StageName       = 'Prospecting';
           createOpp.CloseDate       = polInfo.Effective_Date__c;
           createOpp.Amount          = polInfo.EstPremAmt__c;
           createOpp.RefSagittaID__c = polInfo.SagittaID__c;
           createOpp.OwnerId         = acctId.get(0).OwnerId; 
           createOpps.add(createOpp);
           
       }


        if (createOpps.size()>=1){
           
            
              try {
                    System.debug('Upsert these Opps' + createOpps);
                    upsert createOpps;

                } catch(DmlException e) {
                    System.debug('The following exception has occurred during update: ' + e.getMessage());
                }
            
        }
          
        if (updatePolicy.size()>=1) {

              try {
                    System.debug('Updated these Policy Opp Fields' + updatePolicy);
                    update updatePolicy;

              } catch(DmlException e) {
                    System.debug('The following exception has occurred during update: ' + e.getMessage());
              }



        }

    }
    
}