@isTest
private class TestSagittaTime {
	
	@isTest static void testTimePositive() {
		// Implement test code
		Test.startTest();
		SagittaInfo__c info = new SagittaInfo__c(Name='MAIN',Query_Time__c =360);
		insert info;

		SagittaTime.getTime();
		Test.stopTest();



	}
	
	@isTest static void testTimeNegative() {
		// Implement test code
		Test.startTest();
		SagittaInfo__c info = new SagittaInfo__c(Name='MAIN',Query_Time__c =172800);
		insert info;

		SagittaTime.getTime();
		Test.stopTest();
	}
	
}