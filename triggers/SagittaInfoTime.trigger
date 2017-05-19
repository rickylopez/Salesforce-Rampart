trigger SagittaInfoTime on SagittaInfo__c (before update) {


//Get the Days from Date
Date fromDate  = Date.newInstance(1967,12,31);
Date toDate    = Date.today();
Long diffDays  = fromDate.daysBetween(toDate);
System.Debug('diffDays: ' + diffDays);

//Get Seconds from Midnight 
DateTime now = DateTime.now();
System.Debug('Now: ' + now);
Long numHours     = now.hour();
System.debug('Now: Number of hours' + numHours);
//Adding 3 hours to adjust for time zone shift
Long numHoursPlus = numHours;
System.debug('Translation Now: Number of hours' + numHoursPlus);
Long numMinutes   = now.minute();
System.debug('Translation Now: Number of Minutes' + numMinutes);
Long numSeconds   = now.second();
System.debug('Translation Now: Number of Seconds' + numSeconds);
Long totalSeconds = numSeconds + (60 * numMinutes) + (60 * 60 * numHoursPlus);
System.debug('Total Seconds :' +  totalSeconds );

//Get Time to Query from MAIN 
List<SagittaInfo__c> queryTime = new List<SagittaInfo__c>([select Query_Time__c from SagittaInfo__c where Name = 'MAIN']);
Long secondsMinus = totalSeconds - Integer.valueOf(queryTime.get(0).Query_Time__c); 
System.debug('Seconds Minus' + secondsMinus);
String  uniVerseTime = String.valueOf(diffDays) +  String.valueOf(secondsMinus);
String currentUniTime = String.valueof(diffDays) + totalSeconds; 
System.debug('Days from Epoch + Seconds from midnight' + uniVerseTime);

    for (SagittaInfo__c so : Trigger.new) {
        so.Date__c = String.valueOf(now);
        so.Client_Date__c = String.valueOf(now); 
        so.UniVerse_Time__c = uniVerseTime;
        so.Sent__c = true; 
        so.Client_Sync_Sent__c = true; 
        so.Current_UniVerse_Time__c = currentUniTime;

    } 




}