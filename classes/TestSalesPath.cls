@isTest
private class TestSalesPath {
	
	@isTest (SeeAllData=true) static void createOppAndTeamCL() {
		

		List<RecordType> recType = new List<RecordType>([Select Id From RecordType where Name = 'Business']);
		Date today = Date.today(); 
		
		//Create Account 
		Account acct = new Account(); 
		acct.Name = 'Testing Name';
		acct.BillingStreet = '2972 Anderson Circle SE';
		acct.BillingCity   = 'Smyrna';
		acct.BillingPostalCode = '30080';
		acct.BillingState = 'GA';
		acct.SagittaID__c = '21345';
		acct.RecordTypeId = recType.get(0).Id;

		insert acct;

		List<RecordType> recOppType = new List<RecordType>([Select Id from RecordType where Name = 'Commercial Lines']);
		List<Pricebook2> priceBook = new List<Pricebook2>([Select Id from Pricebook2 where Name = 'Commercial Lines']);
		//Create Opp 
		Opportunity opp = new Opportunity();
		opp.Name = 'New Test Opp'; 
		opp.StageName = 'Marketing';
		opp.CloseDate = today; 
		opp.RecordTypeId = recOppType.get(0).Id;
		opp.AccountId = acct.Id; 
		opp.Pricebook2Id = priceBook.get(0).Id; 
		insert opp; 

		//Look up Price Book entry for Personal Auto (example Product)
		List<PricebookEntry> bookEntry = new List<PricebookEntry>([Select Id 
																   From PricebookEntry 
																   Where Pricebook2Id=:priceBook.get(0).Id
																   And IsActive = true
																   Limit 1]);
		
		System.debug('Look Up PriceBookEntry Id: ' + bookEntry);
		OpportunityLineItem prod = new OpportunityLineItem();
		prod.PriceBookEntryId = bookEntry.get(0).Id; 
		prod.OpportunityId = opp.Id;
		prod.Send_To_Sagitta_As_Policy__c = true; 
		prod.ServiceDate = today;
		prod.Expiration_Date__c = today.addYears(1);
		insert prod; 


		List<User> lookupUser = new List<User>([Select Id from User where Alias = 'HO' LIMIT 1]);
		//Create Opp Team Member
		OpportunityTeamMember oppTeam = new OpportunityTeamMember();
		oppTeam.OpportunityId = opp.Id; 
		oppTeam.UserId = lookupUser.get(0).Id; 
		oppTeam.TeamMemberRole = 'Marketing';
		oppTeam.OpportunityAccessLevel = 'Edit';
		insert oppTeam;


	}
	
	@isTest (SeeAllData=true) static void createOppAndTeamPL() {
		// Implement test code
		Date today = Date.today(); 
		
		List<RecordType> recType = new List<RecordType>([Select Id from RecordType where Name = 'Individual']);

		//Create Account 
		Account acct = new Account(); 
		acct.Name = 'Testing Name';
		acct.RecordTypeId = recType.get(0).Id;
		acct.BillingStreet = '2972 Anderson Circle SE';
		acct.BillingCity   = 'Smyrna';
		acct.BillingPostalCode = '30080';
		acct.BillingState = 'GA';
		acct.SagittaID__c = '21345';

		insert acct;


		List<RecordType> recOppType = new List<RecordType>([Select Id from RecordType where Name = 'Personal Lines']);
		List<Pricebook2> priceBook = new List<Pricebook2>([Select Id from Pricebook2 where Name = 'Personal Lines']);
		//Create Opp 
		Opportunity opp = new Opportunity();
		opp.Name = 'New Test Opp'; 
		opp.StageName = 'Quote';
		opp.CloseDate = today; 
		opp.AccountId = acct.Id;
		opp.Pricebook2Id = priceBook.get(0).Id;  
		opp.RecordTypeId = recOppType.get(0).Id; 
		insert opp; 

		//Look up Price Book entry for Personal Auto (example Product)
		List<PricebookEntry> bookEntry = new List<PricebookEntry>([Select Id 
																   From PricebookEntry 
																   Where Pricebook2Id=:priceBook.get(0).Id
																   And IsActive = true
																   Limit 1]);
		
		System.debug('Look Up PriceBookEntry Id: ' + bookEntry);
		OpportunityLineItem prod = new OpportunityLineItem();
		prod.PriceBookEntryId = bookEntry.get(0).Id; 
		prod.OpportunityId = opp.Id;
		prod.Send_To_Sagitta_As_Policy__c = true; 
		prod.ServiceDate = today;
		prod.Expiration_Date__c = today.addYears(1);
		insert prod; 


		List<User> lookupUser = new List<User>([Select Id from User where Alias = 'HO' LIMIT 1]);
		//Create Opp Team Member
		OpportunityTeamMember oppTeam = new OpportunityTeamMember();
		oppTeam.OpportunityId = opp.Id; 
		oppTeam.UserId = lookupUser.get(0).Id; 
		oppTeam.TeamMemberRole = 'Marketing';
		oppTeam.OpportunityAccessLevel = 'Edit';
		insert oppTeam;

		OpportunityTeamMember updOppTeam = new OpportunityTeamMember();
		updOppTeam.Id = oppTeam.Id; 
		updOppTeam.TeamMemberRole = 'Sales Setup';
		updOppTeam.Full_Name__c = 'Test Person';
		update updOppTeam; 



	}
	
}