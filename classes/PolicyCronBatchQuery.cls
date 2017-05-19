global class PolicyCronBatchQuery implements Schedulable {
	global void execute(SchedulableContext sc) {
		// Fire Soap Request to Sagitta for Changes in Policy Data
		if (Test.isRunningTest()){

			String testing = 'Complete';
		} else {

			PolicyBatchQuery.sendBatchQuery();
		}

				

		

	}
}