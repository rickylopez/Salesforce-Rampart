trigger PolicyQuery on Policy__c (after update) {

Boolean isFuture = System.isFuture();
System.debug('Is Future?' + isFuture);
System.debug('Is After?' + Trigger.isAfter);
List<Opportunity> updateOpp = new List<Opportunity>();

for (Policy__c policyUpdate : Trigger.new) {
        if (policyUpdate.SendQuery__c) {
            
            Set<ID> ids = new Set<ID>();
                ids.add(policyUpdate.id); 
            
            // make the asynchronous web service callout
           
            if ((ids.size() > 0) && (!isFuture)) {
            System.debug('Final IF' + ids);
            ClientDelta.sendQuery(ids);
            }
                
            
        }

        if(Trigger.isAfter && policyUpdate.Transaction_Type__c == 'New Business' && policyUpdate.Opportunity__c != null && policyUpdate.Written_Premium__c != null && !String.valueOf(policyUpdate.Name).startsWith('APP')){
        System.debug('Found Closed Won Opp');

        //Create Opporunity   
        Opportunity newOpp = new Opportunity();
        
        //Find Policy Opportunity Id 
        List<Opportunity> opp = new List<Opportunity>([Select Id, StageName, ClosedWonEmail__c
                                                         from Opportunity 
                                                        where Id=:policyUpdate.Opportunity__c
                                                        Limit 1]);
        System.debug('List Opp Results' + opp);
        //If Opportunity Exsists
            if(opp.size() > 0){
                if(opp.get(0).StageName != 'Closed Won' && opp.get(0).StageName != 'Closed Lost'){
                    newOpp.Id = opp.get(0).ID;
                    newOpp.StageName = 'Closed Won';
                    newOpp.Amount = policyUpdate.Written_Premium__c;
                    updateOpp.add(newOpp);
                }
            }


        }
    System.debug('Update These Opps Before If' + updateOpp);
    if(updateOpp.size() > 0){
        System.debug('Update these Opps' + updateOpp);
        update updateOpp; 
    }

    }

   
    
}