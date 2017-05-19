@isTest(seeAllData=true) 
private class TestNewOpp {
	
	@isTest static void test_method_one() {

		DateTime dT = System.now();
		Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());

		//Lookup RecordType Id
		RecordType typeOfRecord = [Select Id
							         From RecordType
						            Where Name = 'Individual' LIMIT 1];

		RecordType busRecord = [Select Id
							         From RecordType
						            Where Name = 'Business' LIMIT 1];				            
		//Lookup House User
		User acctOwner = [Select Id
				            From User
					       Where Sagitta_User_Code__c = 'HO' LIMIT 1];

		
		// Create Account With Parameters
		// list Accounts to Update 

		List<Account> testAccts = new List<Account>(); 

		Account myAccount      = new Account(); 
		myAccount.Name         = 'Test Account';
		myAccount.Email__c     = 'testing@rampartinsurance.com';
		myAccount.Phone        = '5555555555';
		myAccount.Phone_2__c   = '5555555556';
		myAccount.Fax          = '5555555556';
		myAccount.WebSite      = 'www.espn.com'; 
		myAccount.RecordTypeId = typeOfRecord.Id;  
		myAccount.OwnerId      = acctOwner.Id; 
		myAccount.BillingStreet = '150 Way';
		myAccount.BillingPostalCode = '30080';
		myAccount.BillingCity = 'Smyrna';
		myAccount.BillingState = 'GA'; 
		myAccount.Preferred_Method_of_Contact__c = 'Email';
		testAccts.add(myAccount);
 		 
		insert testAccts;




		Account latestAccount = [Select Id, 
										RecordTypeId
								   From Account 
								  Where Id=: myAccount.Id LIMIT 1];


		//Create Coverage for Test
		Coverages__c testCov = new Coverages__c(); 
		testCov.Name = 'TEST1';
		testCov.Description__c = 'Testing Coverage Detail';
		insert testCov;

		Coverages__c latestCov = [Select Id 
								    From Coverages__c 
								   Where Id =: testCov.Id LIMIT 1];

		

		//Create Policy
		Policy__c myPolicy  = new Policy__c();
		myPolicy.Name       = 'APP12345';
		myPolicy.Account__c = latestAccount.Id;
		myPolicy.EstPremAmt__c = 10000;
		myPolicy.Effective_Date__c = myDate;
		myPolicy.SagittaID__c =  '10000';
		myPolicy.Coverages__c = latestCov.Id;
		insert myPolicy;




	}
	
	@isTest static void coverOppSync() {

		DateTime dT = System.now();
		Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());

		//Lookup RecordType Id
		RecordType typeOfRecord = [Select Id
							         From RecordType
						            Where Name = 'Individual' LIMIT 1];

		RecordType busRecord = [Select Id
							         From RecordType
						            Where Name = 'Business' LIMIT 1];				            
		//Lookup House User
		User acctOwner = [Select Id
				            From User
					       Where Sagitta_User_Code__c = 'HO' LIMIT 1];

		
		// Create Account With Parameters
		// list Accounts to Update 

		List<Account> testAccts = new List<Account>(); 

		Account myAccount      = new Account(); 
		myAccount.Name         = 'Test Account';
		myAccount.Email__c     = 'testing@rampartinsurance.com';
		myAccount.Phone        = '5555555555';
		myAccount.Phone_2__c   = '5555555556';
		myAccount.Fax          = '5555555556';
		myAccount.WebSite      = 'www.espn.com'; 
		myAccount.RecordTypeId = typeOfRecord.Id;  
		myAccount.OwnerId      = acctOwner.Id; 
		myAccount.Preferred_Method_of_Contact__c = 'Email';
		myAccount.BillingStreet = '150 Way';
		myAccount.BillingPostalCode = '30080';
		myAccount.BillingCity = 'Smyrna';
		myAccount.BillingState = 'GA'; 
		testAccts.add(myAccount);
 		
		insert testAccts;


		Account latestAccount = [Select Id, 
										RecordTypeId
								   From Account 
								  Where Id=: myAccount.Id LIMIT 1];


		Opportunity newOpp = new Opportunity(); 
		newOpp.Name = 'Testing New Opp';
		newOpp.AccountId = latestAccount.Id; 
		newOpp.StageName = 'Prospecting';
		newOpp.CloseDate = myDate;
		insert newOpp; 


		//Create Coverage for Test
		Coverages__c testCov = new Coverages__c(); 
		testCov.Name = 'TEST1';
		testCov.Description__c = 'Testing Coverage Detail';
		insert testCov;

		Coverages__c latestCov = [Select Id 
								    From Coverages__c 
								   Where Id =: testCov.Id LIMIT 1];

		

		//Create Policy
		Policy__c myPolicy  = new Policy__c();
		myPolicy.Name       = 'APP12345';
		myPolicy.Account__c = latestAccount.Id;
		myPolicy.EstPremAmt__c = 10000;
		myPolicy.Effective_Date__c = myDate;
		myPolicy.SagittaID__c =  '10001';
		myPolicy.Coverages__c = latestCov.Id;
		insert myPolicy;




	}
	
}