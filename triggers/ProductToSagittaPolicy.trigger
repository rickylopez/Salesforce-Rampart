trigger ProductToSagittaPolicy on OpportunityLineItem (after insert, after update) {
	  
	Set<ID> ids = new Set<ID>();

	for (OpportunityLineItem newOppLine : trigger.new) 
	{
		
		if (newOppLine.Send_To_Sagitta_As_Policy__c && newOppLine.Sagitta_ID__c == null)
		{
	        System.debug('Send Product' + newOppLine.Id);
	        ids.add(newOppLine.id);
	    }
	
	} 
	        
	if ((ids.size() > 0)) 
	{
		System.debug('Send These IDs' + ids);
		InsertSagittaPolicy.SendToSagitta(ids);
	}         


}