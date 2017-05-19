public class LookUp {
	public static String LookUpCov(String Cov) {
	
	List<Coverages__c> lookupCoverage = new List<Coverages__c> ([Select Id from Coverages__c where Name =:Cov]);
	String covInfo = string.valueOf(lookupCoverage.get(0).Id);
	return covInfo;
	}
	
	public static String LookUpIns(String Ins) {
	
    List<Carrier__c> lookupCarrier = new List<Carrier__c> ([Select Id from Carrier__c where Code__c =:Ins]);
	String insInfo = string.valueOf(lookupCarrier.get(0).Id);
	return insInfo;
	}
    
}