trigger OpportunityTrigger on Opportunity (before update, after update) {


	for (Opportunity opp : Trigger.new) {

		if (Trigger.isBefore){
			List<OpportunityTeamMember> teamList = new List<OpportunityTeamMember>([Select Id, Name,TeamMemberRole, Full_Name__c
																					From OpportunityTeamMember
																					Where OpportunityId=:opp.Id 
																					AND TeamMemberRole ='Marketing'
																				  ]);

			List<OpportunityLineItem> oppProducts = new List<OpportunityLineItem>([Select ProductCode 
																				   From OpportunityLineItem 
																				   Where OpportunityId=:opp.Id]); 

			System.debug('List of Products: ' + oppProducts);

			String stringOfProducts; 
			String newDesc;
			System.debug('Size of List for Products: ' + oppProducts.size());	
			if (oppProducts.size()> 0) {
				
				System.debug('Inside If about to begin Loop: ' + oppProducts.size());
				for (Integer i = 0; i < oppProducts.size(); i++) {
				
					stringOfProducts += oppProducts.get(i).ProductCode + ' '; 
					newDesc = stringOfProducts.remove('null');
					System.debug('String of Products' + stringOfProducts);

				}

			opp.Description = newDesc; 
			

			
			} 
			
			if (teamList.size() > 0) {
			System.debug('Full Name' + teamList.get(0).Full_Name__c);
			opp.Mkt_User_FullName__c = teamList.get(0).Full_Name__c; 
			}
		}

		if (Trigger.isAfter) {
			List<OpportunityTeamMember> listOfOppTeamMemToUpdate = new List<OpportunityTeamMember>();
			List<Opportunity> oppToUpdate = new List<Opportunity>();
			List<OpportunityTeamMember> teamList = new List<OpportunityTeamMember>([Select Id, Name,TeamMemberRole
																					From OpportunityTeamMember
																					Where OpportunityId=:opp.Id 
																					
																				  ]);

			String recordTypeName;
			List<RecordType> recordInfo = new List<RecordType>([Select Id
                                                                    From RecordType
                                                                    Where Name = 'Commercial Lines' 
                                                                    LIMIT 1]);

                
            if(opp.RecordTypeId == recordInfo.get(0).Id)
           		{
                  recordTypeName = 'Commercial Lines';
                } 
                	else
                {
                    recordTypeName = 'Personal Lines';
                }

			if (teamList.size() > 0) {
				
				for (Integer i = 0; i < teamList.size(); i++) {

					OpportunityTeamMember oppTeamMem = new OpportunityTeamMember(); 
						oppTeamMem.Id = teamList.get(i).Id; 
						oppTeamMem.Full_Name__c = teamList.get(i).Name; 
						oppTeamMem.Stage__c = opp.StageName; 
						oppTeamMem.Type__c = recordTypeName;
						listOfOppTeamMemToUpdate.add(oppTeamMem);




				}

				
		


			}




			if (listOfOppTeamMemToUpdate.size() > 0){

				update listOfOppTeamMemToUpdate; 

			}

			

		}
		
			
				
			
			
		

		

		


	}
	
	

}