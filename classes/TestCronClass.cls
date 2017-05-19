@isTest(seeAllData=true)
private class TestCronClass {
	
	@isTest static void executeCrons() {
		
		String sch = '0 0 23 * * ?';

		Test.StartTest();
			
			ClientDetlaCron clientCron = new ClientDetlaCron();
			System.schedule('Test Client Cron', sch, clientCron);
			
			PolicyCronBatchQuery policyCron = new PolicyCronBatchQuery(); 
			System.schedule('Test Policy Cron', sch, policyCron);
		

		Test.stopTest();
	

	}
	
	
}