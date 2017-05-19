trigger AssociatePolicyToOpp on Opportunity (after insert, after update) {

//Policies to Update
List<Policy__c> updatePols  = new List<Policy__c>();
List<Opportunity> updateOpp = new List<Opportunity>();
  
    for (Opportunity opp : Trigger.new) {
    
    //Create New Policy Object 
    Policy__c updatePol = new Policy__c();

    //Create New Opp Object 
    Opportunity oppStage = new Opportunity();
    
    //Lookup RefSagittaID
    List<Policy__c> queryId = new List<Policy__c>([select Id from Policy__c where SagittaID__c =:opp.RefSagittaId__c]);
        if(opp.RefSagittaID__c != null && opp.StageName == 'Prospecting'){
            if (queryId.size()==1) {
                updatePol.Id = queryId.get(0).Id;
                updatePol.Opportunity__c = opp.Id;
                updatePols.add(updatePol);
                
                //Update Opp Stage Name
                oppStage.StageName = 'Marketing';
                oppStage.Id        = opp.Id;
                updateOpp.add(oppStage);
            }
        }
    

    }
    
    if (updatePols.size()>=1){
        for (Policy__c pol : updatePols) {
        
            try {
                update pol; 
                update updateOpp;
                } catch(DmlException e) {
            System.debug('The following exception has occurred during update: ' + e.getMessage());
                }    
            }
    }

}