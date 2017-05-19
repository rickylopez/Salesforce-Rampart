@isTest
private class TestProductToSagittaPolicy {
	
	@isTest (SeeAllData=true) static void createProduct() {
		// Create Product Line
		
		//Get Date
		Date today = Date.today(); 


		//Create Account 
		Account acct = new Account(); 
		acct.Name = 'Testing Name';
		acct.BillingStreet = '2972 Anderson Circle SE';
		acct.BillingCity   = 'Smyrna';
		acct.BillingPostalCode = '30080';
		acct.BillingState = 'GA';
		acct.SagittaID__c = '21345';

		insert acct;


		//Create Opp and Assign Personal Lines Pricebook 
		Opportunity opp = new Opportunity();
		opp.Name = 'New Test Opp'; 
		opp.StageName = 'Marketing';
		opp.CloseDate = today; 
		opp.AccountId = acct.Id; 
		insert opp; 


		//Look up Price Book entry for Personal Auto (example Product)
		List<PricebookEntry> bookEntry = new List<PricebookEntry>([Select Id 
																   From PricebookEntry 
																   Where Name = 'Personal Auto' 
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
		

	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}