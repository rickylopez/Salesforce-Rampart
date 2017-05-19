public with sharing class SagittaTime {
	public static String getTime() {

		

		//Get the Days from Date - Current # Day from Date
		Date fromDate  = Date.newInstance(1967,12,31);
		Date toDate    = Date.today();
		Long diffDays  = fromDate.daysBetween(toDate);
		System.Debug('diffDays: ' + diffDays);

		//Get Seconds from Midnight 
		DateTime now  = DateTime.now();
		System.Debug('Now: ' + now);
		Long numHours = now.hour();
		System.debug('Now: Number of hours' + numHours);
		Long numMinutes   = now.minute();
		System.debug('Translation Now: Number of Minutes' + numMinutes);
		Long numSeconds   = now.second();
		System.debug('Translation Now: Number of Seconds' + numSeconds);
		Long totalSeconds = numSeconds + (60 * numMinutes) + (60 * 60 * numHours);
		System.debug('Total Seconds :' +  totalSeconds );



		//Get Time to Query from MAIN 
		List<SagittaInfo__c> queryTime = new List<SagittaInfo__c>([select Query_Time__c from SagittaInfo__c where Name = 'MAIN']);
		System.debug('QueryTime: ' + queryTime);
		Long secondsMinus = totalSeconds - Integer.valueOf(queryTime.get(0).Query_Time__c); 
		
		//Check to see if the number is positive or negative 
		Boolean isNegative = secondsMinus < 0;
		System.debug('Seconds Postive or Negative: ' + isNegative);
		
		if(isNegative){
			System.debug('Seconds are negative. Setting to Zero');
			secondsMinus=0;
		}
		System.debug('Seconds Minus' + secondsMinus);
		String uniVerseTime = String.valueOf(diffDays) +  String.valueOf(secondsMinus);
		String currentUniTime = String.valueof(diffDays) + totalSeconds; 
		System.debug('Days from Epoch + Seconds from midnight' + uniVerseTime);

		return uniVerseTime;
	}
}