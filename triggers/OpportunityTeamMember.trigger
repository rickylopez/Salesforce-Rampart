trigger OpportunityTeamMember on OpportunityTeamMember (before insert, after insert) {
    for (OpportunityTeamMember opp : Trigger.New) {

    	if (Trigger.isBefore){ 
            
            if(opp.TeamMemberRole=='Marketing'){
        		List<User> userLookup = new List<User>([Select Name, Sagitta_User_Code__c
                                                From User 
                                                Where Id=:opp.UserId]);


            

	        	if(userLookup.size()>0){

	        	opp.Full_Name__c = userLookup.get(0).Name; 
	        	opp.OpportunityAccessLevel = 'Edit';
                opp.Member_User_Code__c = userLookup.get(0).Sagitta_User_Code__c;
                opp.Type__c = 'Init';
                System.debug('UserLookup :' + userLookup);


       			}

       		System.debug('Didnt Add Marketing Role');
       		

        	}

               if(opp.TeamMemberRole=='Sales Setup'){
                List<User> userLookup = new List<User>([Select Name
                                                From User 
                                                Where Id=:opp.UserId]);


            

                if(userLookup.size()>0){

                opp.Full_Name__c = userLookup.get(0).Name; 
                opp.OpportunityAccessLevel = 'Edit';
                opp.Type__c = 'Init';
                System.debug('UserLookup :' + userLookup);


                }

            System.debug('Didnt Add Marketing Role');
           

            }
    		
        

        }

        if (Trigger.isAfter){

            System.debug('Trigger isAfter');

        	if(opp.TeamMemberRole=='Marketing'){

                System.debug('Team Role is Marketing');
                String recordTypeName;
				List<Opportunity> oppMain = new List<Opportunity>([Select Id, RecordTypeId, StageName
    													   	  	   From Opportunity 
    													   	   	   Where Id =:opp.OpportunityId]);
                

                List<RecordType> recordInfo = new List<RecordType>([Select Id
                                                                    From RecordType
                                                                    Where Name = 'Commercial Lines' 
                                                                    LIMIT 1]);

                
                if(oppMain.get(0).RecordTypeId == recordInfo.get(0).Id)
                {
                    recordTypeName = 'Commercial Lines';
                } else
                {
                    recordTypeName = 'Personal Lines';
                }

				if(oppMain.size()>0 && recordTypeName =='Personal Lines'){
					Opportunity parentOpp = new Opportunity(Id=oppMain.get(0).Id, Mkt_User_FullName__c=opp.Full_Name__c,StageName='Quote');
				
                    if(parentOpp !=null){
						update parentOpp;
					}


				} 

                if(oppMain.size()>0 && recordTypeName =='Commercial Lines'){
                    Opportunity parentOpp = new Opportunity(Id=oppMain.get(0).Id, Mkt_User_FullName__c=opp.Full_Name__c);
                
                    if(parentOpp !=null){
                        update parentOpp;
                    }


                }

                if(oppMain.size()>0 && recordInfo.size()>0) {

                    OpportunityTeamMember myOppTeam = new OpportunityTeamMember(Id=opp.Id,Type__c=recordTypeName);
                    
                    if(myOppTeam !=null){
                        update myOppTeam;
                    }




                }



        	}

            if (opp.TeamMemberRole=='Sales Setup'){

                System.debug('Team Role is Sales Setup');
                String recordTypeName;
                System.debug('Record Type Before Query' + recordTypeName);
                List<Opportunity> oppMain = new List<Opportunity>([Select Id, RecordTypeId, StageName
                                                                   From Opportunity 
                                                                   Where Id =:opp.OpportunityId]);
                

                List<RecordType> recordInfo = new List<RecordType>([Select Id
                                                                    From RecordType
                                                                    Where Name = 'Commercial Lines' 
                                                                    LIMIT 1]);

                
                if(oppMain.get(0).RecordTypeId == recordInfo.get(0).Id)
                {
                    recordTypeName = 'Commercial Lines';

                    System.debug('Record Type After Query' + recordTypeName);
                } else
                {
                    recordTypeName = 'Personal Lines';

                    System.debug('Record Type After Query' + recordTypeName);
                }

                
                if(oppMain.size()>0 && recordTypeName =='Commercial Lines'){

                    
                    Opportunity parentOpp = new Opportunity(Id=oppMain.get(0).Id, Sales_Setup_User__c=opp.Full_Name__c);
                
                    System.debug('Update Opp' + parentOpp);
                    if(parentOpp !=null){
                        update parentOpp;
                    }


                }


            }
        	System.debug('Didnt Add Marketing Role');
        	break;
			
		}
    } 

}