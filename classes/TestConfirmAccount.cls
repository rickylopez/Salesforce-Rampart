@isTest
private class TestConfirmAccount {



	
	@isTest static void createIndAccount() {

		RecordType indRecord = [Select Id
							         From RecordType
						            Where Name = 'Individual' LIMIT 1];

				            
		//Lookup House User
		User acctOwner = [Select Id
				            From User
					       Where Sagitta_User_Code__c = 'HO' LIMIT 1];
		

		Account acctInd = new Account();

		acctInd.Name         = 'Test Account';
		acctInd.Email__c     = 'testing@rampartinsurance.com';
		acctInd.Phone        = '5555555555';
		acctInd.Phone_2__c   = '5555555556';
		acctInd.Fax          = '5555555556';
		acctInd.WebSite      = 'www.espn.com'; 
		acctInd.RecordTypeId = indRecord.Id; 
		acctInd.BillingStreet = '150 Way';
		acctInd.BillingPostalCode = '30080';
		acctInd.BillingCity = 'Smyrna';
		acctInd.BillingState = 'GA'; 
		acctInd.OwnerId      = acctOwner.Id; 
		acctInd.Net_Commision__c = 40; 
		acctInd.Preferred_Method_of_Contact__c = 'Email'; 
		acctInd.FEIN__c = '100'; 
		acctInd.Business_Start_Date__c = date.valueOf('2016-01-01');
		acctInd.Inspection_Contact__c = 'John Smith';
		acctInd.Inspection_Phone_Number__c = '5555555556';
		acctInd.Inspection_Phone_Extension_Number__c = '1345';
		acctInd.Accounting_Contact__c = 'Susan Smith';
		acctInd.Accounting_Phone_Number__c = '5555555556';
		acctInd.Accounting_Phone_Extension_Number__c = '2345';
		acctInd.Phone_Ext__c = '5555';
		insert acctInd; 
	}
	
	@isTest static void createBusAccount() {
		RecordType busRecord = [Select Id
							         From RecordType
						            Where SobjectType = 'Account' 
						              And Name = 'Business' LIMIT 1];	

		User acctOwner = [Select Id
				            From User
					       Where Sagitta_User_Code__c = 'HO' LIMIT 1];
					       


		Account acctBus = new Account();
		acctBus.Name         = 'Test Account';
		acctBus.Email__c     = 'testing@rampartinsurance.com';
		acctBus.Phone        = '5555555555';
		acctBus.Phone_2__c   = '5555555556';
		acctBus.Fax          = '5555555556';
		acctBus.WebSite      = 'www.espn.com'; 
		acctBus.RecordTypeId = busRecord.Id; 
		acctBus.BillingStreet = '150 Way';
		acctBus.BillingPostalCode = '30080';
		acctBus.BillingCity = 'Smyrna';
		acctBus.BillingState = 'GA'; 
		acctBus.OwnerId      = acctOwner.Id; 
		acctBus.Net_Commision__c = 40;
		acctBus.FEIN__c = '100'; 
		acctBus.Preferred_Method_of_Contact__c = 'Email'; 
		acctBus.Business_Start_Date__c = date.valueOf('2016-01-01');
		acctBus.Inspection_Contact__c = 'John Smith';
		acctBus.Inspection_Phone_Number__c = '5555555556';
		acctBus.Inspection_Phone_Extension_Number__c = '1345';
		acctBus.Accounting_Contact__c = 'Susan Smith';
		acctBus.Accounting_Phone_Number__c = '5555555556';
		acctBus.Accounting_Phone_Extension_Number__c = '2345';
		acctBus.Phone_Ext__c = '5555';


		insert acctBus; 			            	
		// Implement test code
	}
	
}