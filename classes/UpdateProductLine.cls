public with sharing class UpdateProductLine {
	

	public static void updateProducts(List<OpportunityLineItem> updProdLine){
		System.debug('List of Products' + updProdLine);
		List<OpportunityLineItem> upsertProdLines = updProdLine;
        upsert upsertProdLines;
        




	}
}