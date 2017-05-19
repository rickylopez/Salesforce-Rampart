@isTest
private class TestCaseTrigger {
	
	@isTest static void createCases() {
		// Implement test code
			List<String> app = new List<String>();
			app.add('WorkSmart');
			app.add('Citrix');
			app.add('Lync');
			app.add('Outlook');
			app.add('Sagitta');
			app.add('Facilities');
			app.add('Mobile');
			app.add('Monitor');
			app.add('Network');
			app.add('Password');
			app.add('Printers');
			app.add('RightFax');
			app.add('Word');
			app.add('Website');
			app.add('Salesforce');


	List<Case> cases = new List<Case>();

		for(Integer i = 0; i < app.size();i++) {
				

				Case testCase = new Case(); 
				testCase.Status = 'New';
				testCase.Origin = 'Email';
				testCase.Subject = 'Testing New Case Creation';
				testCase.Description = 'I need help with ' + app.get(i); 

				cases.add(testCase);

		}

	for (Integer i = 0; i < cases.size();i++){
		try {
	       		
	       		insert cases.get(i); 		

	                
	        }	catch(DmlException e) {
	        	System.debug('The following exception has occurred during update: ' + cases.get(i).Id + e.getMessage());
	            }   
	
	}	



	}

}