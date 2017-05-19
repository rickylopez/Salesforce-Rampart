@isTest
private class TestAddProducer2AccountSharing {
	
	@isTest static void test_method_one() {
		// Implement test code
		List<Account> updateAccts = new List<Account>();

		Profile lookupProfile = [Select Id from Profile where Name = 'Rampart - Producer User' LIMIT 1];
		//Producer 1
		User testUser = new User(); 

		testUser.LastName             = 'Smith';
		testUser.Alias                = 'Smith'; 
		testUser.Email                = 'testSmith@test.com'; 
		testUser.Username             = 'testSmith@tests.com';
		testUser.CommunityNickname    = 'Smith';
		testUser.Sagitta_User_Code__c = 'SMITH';
		testUser.TimeZoneSidKey       = 'America/New_York';
		testUser.LocaleSidKey         = 'en_US';
		testUser.EmailEncodingKey     = 'ISO-8859-1';
		testUser.ProfileId            =  lookupProfile.Id;
		testUser.LanguageLocaleKey    = 'en_US';
		insert testUser; 

		//Producer 2
		User testUser2 = new User();
		
		testUser2.LastName             = 'Allen';
		testUser2.Alias                = 'Allen'; 
		testUser2.Email                = 'testAllen@test.com'; 
		testUser2.Username             = 'testAllen@tests.com';
		testUser2.CommunityNickname    = 'Allen';
		testUser2.Sagitta_User_Code__c = 'Allen';
		testUser2.TimeZoneSidKey       = 'America/New_York';
		testUser2.LocaleSidKey         = 'en_US';
		testUser2.EmailEncodingKey     = 'ISO-8859-1';
		testUser2.ProfileId            =  lookupProfile.Id;
		testUser2.LanguageLocaleKey    = 'en_US';
		insert testUser2;


		//Reload Producer 1 and 2 User objects 
		User producer1 = [Select Id, Sagitta_User_Code__c from User where Sagitta_User_Code__c = 'SMITH' LIMIT 1];
		User producer2 = [Select Id, Sagitta_User_Code__c from User where Sagitta_User_Code__c = 'Allen' LIMIT 1];
		
		//Create Account 
		Account acctWithProd2 = new Account();

		acctWithProd2.Name                           = 'Test Account1';
		acctWithProd2.Email__c                       = 'testing@rampartinsurance.com';
		acctWithProd2.Phone                          = '5555555555';
		acctWithProd2.BillingStreet                 = '150 Way';
		acctWithProd2.BillingPostalCode             = '30080';
		acctWithProd2.BillingCity                   = 'Smyrna';
		acctWithProd2.BillingState                  = 'GA'; 
		acctWithProd2.SagittaID__c                      = 'rl1';
		acctWithProd2.OwnerId                        = producer1.Id; 
		acctWithProd2.X2nd_Producer__c               = 'Allen';
		acctWithProd2.Preferred_Method_of_Contact__c = 'Email'; 
		
		insert acctWithProd2; 

		//Create Account with No Second Producer 
		Account acctWithOutProd2 = new Account();

		acctWithOutProd2.Name                           = 'Test Account2';
		acctWithOutProd2.Email__c                       = 'testing@rampartinsurance.com';
		acctWithOutProd2.Phone                          = '5555555555';
		acctWithOutProd2.BillingStreet                 = '150 Way';
		acctWithOutProd2.BillingPostalCode             = '30080';
		acctWithOutProd2.SagittaID__c                  	    = 'rl2';
		acctWithOutProd2.BillingCity                   = 'Smyrna';
		acctWithOutProd2.BillingState                  = 'GA'; 
		acctWithOutProd2.OwnerId                        = producer1.Id; 
		//acctWithOutProd2.X2nd_Producer__c               = 'Allen';
		acctWithOutProd2.Preferred_Method_of_Contact__c = 'Email'; 
		
		insert acctWithOutProd2; 

		//Create Account With HO Account as Second Producer 
		Account acctWithHO = new Account();

		acctWithHO.Name                           = 'Test Account3';
		acctWithHO.Email__c                       = 'testing@rampartinsurance.com';
		acctWithHO.Phone                          = '5555555555';
		acctWithHO.SagittaID__c                   = 'rl3';
		acctWithHO.BillingStreet                 = '150 Way';
		acctWithHO.BillingPostalCode             = '30080';
		acctWithHO.BillingCity                   = 'Smyrna';
		acctWithHO.BillingState                  = 'GA'; 
		acctWithHO.OwnerId                        = producer1.Id; 
	    acctWithHO.X2nd_Producer__c               = 'HO';
		acctWithHO.Preferred_Method_of_Contact__c = 'Email'; 
		
		insert acctWithHO; 

		Account lookupUpdateAcct1 = [Select Id from Account where SagittaID__c = 'rl1' LIMIT 1];
		Account lookupUpdateAcct2 = [Select Id from Account where SagittaID__c = 'rl2' LIMIT 1];
		Account lookupUpdateAcct3 = [Select Id from Account where SagittaID__c = 'rl3' LIMIT 1];
		
		Account updateAcct1 = new Account(); 
		updateAcct1.Email__c = 'hello@email.com';
		updateAcct1.Id       = lookupUpdateAcct1.Id; 
		updateAccts.add(updateAcct1);

		Account updateAcct2 = new Account(); 
		updateAcct2.Email__c = 'hello@email.com';
		updateAcct2.Id       = lookupUpdateAcct2.Id; 
		updateAccts.add(updateAcct2);

		Account updateAcct3 = new Account(); 
		updateAcct3.Email__c = 'hello@email.com';
		updateAcct3.Id       = lookupUpdateAcct3.Id; 
		updateAccts.add(updateAcct3);

		update updateAccts; 
	}
	
	
	
}