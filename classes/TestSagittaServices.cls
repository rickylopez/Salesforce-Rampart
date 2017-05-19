@isTest
private with sharing class TestSagittaServices {

	private class ServicesMock implements WebServiceMock {
	       public void doInvoke(
	              Object stub, Object request, Map<String, Object> response,
	              String endpoint, String soapAction, String requestName,
	              String responseNS, String responseName, String responseType)
	          {
	              if(request instanceof SagittaServices.policyDelete_element)
	                  response.put('response_x', new SagittaServices.policyDeleteResponse_element());
	              else if(request instanceof SagittaServices.importResults_element)
					  response.put('response_x', new SagittaServices.importResultsResponse_element());
	              else if(request instanceof SagittaServices.rolodexStartsWith_element)
					  response.put('response_x', new SagittaServices.rolodexStartsWithResponse_element());
	              else if(request instanceof SagittaServices.invoiceVoid_element)
					  response.put('response_x', new SagittaServices.invoiceVoidResponse_element());
	              else if(request instanceof SagittaServices.PassThroughImp_element)
					  response.put('response_x', new SagittaServices.PassThroughImpResponse_element());
	              else if(request instanceof SagittaServices.insurerReceiptUpdate_element)
					  response.put('response_x', new SagittaServices.insurerReceiptUpdateResponse_element());
	              else if(request instanceof  SagittaServices.customProcessUsher_element)
					  response.put('response_x', new SagittaServices.customProcessUsherResponse_element());
	              else if(request instanceof  SagittaServices.insurerReceiptInsert_element)
					  response.put('response_x', new SagittaServices.insurerReceiptInsertResponse_element());
	              else if(request instanceof  SagittaServices.invoiceGetByCriteriaV1_element)
					  response.put('response_x', new SagittaServices.invoiceGetByCriteriaV1Response_element());
	              else if(request instanceof  SagittaServices.invoiceGetPdf_element)
					  response.put('response_x', new SagittaServices.invoiceGetPdfResponse_element());
				  else if(request instanceof  SagittaServices.paymentInsert_element)
					  response.put('response_x', new SagittaServices.paymentInsertResponse_element());
	 			  else if(request instanceof  SagittaServices.paymentUpdate_element)
					  response.put('response_x', new SagittaServices.paymentUpdateResponse_element());
	              else if(request instanceof  SagittaServices.invoicePost_element)
					  response.put('response_x', new SagittaServices.invoicePostResponse_element());
                  else if(request instanceof  SagittaServices.clientInsert_element)
					  response.put('response_x', new SagittaServices.clientInsertResponse_element());
			      else if(request instanceof  SagittaServices.insurerReceiptDelete_element )
					  response.put('response_x', new  SagittaServices.insurerReceiptDeleteResponse_element ());
                  else if(request instanceof  SagittaServices.clientUpdate_element)
					  response.put('response_x', new SagittaServices.clientUpdateResponse_element());
                  else if(request instanceof  SagittaServices.rolodexContains_element)
					  response.put('response_x', new SagittaServices.rolodexContainsResponse_element());
	              else if(request instanceof SagittaServices.cashReceiptInsert_element)
					  response.put('response_x', new SagittaServices.cashReceiptInsertResponse_element());
	              else if(request instanceof SagittaServices.PassThroughReq_element)
					  response.put('response_x', new SagittaServices.PassThroughReqResponse_element());
	              else if(request instanceof SagittaServices.policyUpdate_element)
					  response.put('response_x', new SagittaServices.policyUpdateResponse_element());
	              else if(request instanceof SagittaServices.policyInsert_element)
					  response.put('response_x', new SagittaServices.policyInsertResponse_element());
	              else if(request instanceof SagittaServices.invoiceInsert_element)
				      response.put('response_x', new SagittaServices.invoiceInsertResponse_element());
	              else if(request instanceof SagittaServices.commissionStatementInsert_element)
					  response.put('response_x', new SagittaServices.commissionStatementInsertResponse_element());
	              else if(request instanceof SagittaServices.invoiceDelete_element)
					  response.put('response_x', new SagittaServices.invoiceDeleteResponse_element());
	                              
						            
						 
						     


 
 
           




	              return;
	          }
	  }	

	private static testMethod void coverTypes() {
		

			new SagittaServices.ArrayOfContainsArray();
			new SagittaServices.policyDeleteResponse_element();
			new SagittaServices.Policies();
			new SagittaServices.clientUpdateResponse_element();
			new SagittaServices.InsurerReceivablePostingsInsert();
			new SagittaServices.containsArray();
			new SagittaServices.clientInsert_element();
			new SagittaServices.clientInsertMap();
			new SagittaServices.PolSerial();
			new SagittaServices.BusinessNatureUpdate();
			new SagittaServices.InvoicePostingsUpdate();
			new SagittaServices.ArrayOfPolSerial();
			new SagittaServices.invoicePdfMap();
			new SagittaServices.paymentUpdateMap();
			new SagittaServices.clientUpdate_element();
			new SagittaServices.VendorTempAddress();
			new SagittaServices.invoiceGetByCriteriaV1Response_element();
			new SagittaServices.ArrayOfInvoicePostingsInsert();
			new SagittaServices.invoiceVoidResponse_element();
			new SagittaServices.Status();
			new SagittaServices.ProducerInfo();
			new SagittaServices.policyInsertMap();
			new SagittaServices.SicCd();
			new SagittaServices.ServicerCdUpdate();
			new SagittaServices.TelephoneNum();
			new SagittaServices.rolodexContainsResponse_element();
			new SagittaServices.GeneralInfoRemarkInfoUpdate();
			new SagittaServices.ArrayOfGLInformation();
			new SagittaServices.InvoiceGetByCriteriaResultsV1();
			new SagittaServices.invoiceVoidInsertMap();
			new SagittaServices.commissionStatementInsertResponse_element();
			new SagittaServices.startsWithArray();
			new SagittaServices.PersonalSupplementalInfo();
			new SagittaServices.AuthenticationHeader(); 
			new SagittaServices.PolicyRemarkInfo();
			new SagittaServices.InvoiceGetByCriteria();
			new SagittaServices.clientUpdateMap();
			new SagittaServices.ArrayOfInsurerReceivablePostingsInsert();
			new SagittaServices.PersonalSupplementalInfoUpdate();
			new SagittaServices.ArrayOfAddlTransactions();
			new SagittaServices.invoiceGetPdf_element();
			new SagittaServices.insurerReceiptUpdateResponse_element();
			new SagittaServices.InvoiceInfoByCriteriaV1();
			new SagittaServices.ArrayOfProducerInfo();
			new SagittaServices.General1QuestionInfoUpdate();
			new SagittaServices.insurerReceiptUpdateMap();
			new SagittaServices.CustomData();
			new SagittaServices.InvoiceInfo();
			new SagittaServices.TransactionInfo();
			new SagittaServices.TransactionData();
			new SagittaServices.insurerReceiptDelete_element();
			new SagittaServices.invoicePostResponse_element();
			new SagittaServices.StatusCd();
			new SagittaServices.InsuredInfo();
			new SagittaServices.CatCd();
			new SagittaServices.ArrayOfInvoicePaymentInfo();
			new SagittaServices.PassThroughReq_element();
			new SagittaServices.invoiceInsert_element();
			new SagittaServices.InvoicePostingsInsert();
			new SagittaServices.ArrayOfUsherInformation();
			new SagittaServices.ArrayOfProducerData();
			new SagittaServices.Results();
			new SagittaServices.StatusCdUpdate();
			new SagittaServices.policyUpdateMap();
			new SagittaServices.policyInsertResponse_element();
			new SagittaServices.PolicyRemarkInfoUpdate();
			new SagittaServices.PayeeData();
			new SagittaServices.DeleteResults();
			new SagittaServices.ArrayOfLong();
			new SagittaServices.cashReceiptInsertResponse_element();
			new SagittaServices.PassThroughImp_element();
			new SagittaServices.InsurerReceivablePostingsUpdate();
			new SagittaServices.ArrayOfProducerPaymentInfo();
			new SagittaServices.CoInsuredInfoUpdate();
			new SagittaServices.ArrayOfPayeeData();
			new SagittaServices.ProducerPaymentInfo();
			new SagittaServices.policyInsert_element();
			new SagittaServices.ArrayOfInvoiceInformation();
			new SagittaServices.cashReceiptInsert_element();
			new SagittaServices.clientInsertResponse_element();
			new SagittaServices.paymentUpdate_element();
			new SagittaServices.PDFResults();
			new SagittaServices.CustomTrapdoor();
			new SagittaServices.CatCdUpdate();
			new SagittaServices.policyUpdate_element();
			new SagittaServices.paymentInsertResponse_element();
			new SagittaServices.PreviousPostalInfoUpdate();
			new SagittaServices.ArrayOfCustomTrapdoor();
			new SagittaServices.InsuredInfoUpdate();
			new SagittaServices.invoicePost_element();
			new SagittaServices.paymentInsert_element();
			new SagittaServices.commissionStatementInsert_element();
			new SagittaServices.ProducerCdUpdate();
			new SagittaServices.NatureBusinessInfo();
			new SagittaServices.SicCdUpdate();
			new SagittaServices.invoiceVoid_element();
			new SagittaServices.insurerReceiptInsertMap();
			new SagittaServices.ArrayOfErrors();
			new SagittaServices.General1QuestionInfo();
			new SagittaServices.customProcessUsherResponse_element();
			new SagittaServices.PostResults();
			new SagittaServices.InvoiceInformation();
			new SagittaServices.Errors();
			new SagittaServices.insurerReceiptInsert_element();
			new SagittaServices.insurerReceiptDeleteResponse_element();
			new SagittaServices.UsherInformation();
			new SagittaServices.invoiceGetPdfResponse_element();
			new SagittaServices.rolodexStartsWith_element();
			new SagittaServices.ArrayOfStartsWithArray();
			new SagittaServices.GeneralInfoRemarkInfo();
			new SagittaServices.importResults_element();
			new SagittaServices.ServicerCd();
			new SagittaServices.NatureBusinessInfoUpdate();
			new SagittaServices.ClientInfo();
			new SagittaServices.customProcessUsherMap();
			new SagittaServices.ArrayOfInvoicePostingsUpdate();
			new SagittaServices.policyDelete_element();
			new SagittaServices.invoiceInsertResponse_element();
			new SagittaServices.paymentInsertMap();
			new SagittaServices.invoiceDelete_element();
			new SagittaServices.PreviousPostalInfo();
			new SagittaServices.invoiceInsertMap();
			new SagittaServices.insurerReceiptUpdate_element();
			new SagittaServices.InvoicePaymentInfo();
			new SagittaServices.ArrayOfInsurerReceivablePostingsUpdate();
			new SagittaServices.rolodexStartsWithResponse_element();
			new SagittaServices.ArrayOfInvoiceInfoByCriteriaV1();
			new SagittaServices.rolodexContains_element();
			new SagittaServices.ArrayOfStatus();
			new SagittaServices.CoInsuredInfo();
			new SagittaServices.XMLinput_element();
			new SagittaServices.BusinessNature();
			new SagittaServices.NBSTransactionInfo();
			new SagittaServices.GLInformation();
			new SagittaServices.ArrayOfInvoiceTransactionData();
			new SagittaServices.PostUpdate();
			new SagittaServices.invoicePostInsertMap();
			new SagittaServices.ProducerData();
			new SagittaServices.insurerReceiptDeleteMap();
			new SagittaServices.InvoiceTransactionData();
			new SagittaServices.PassThroughImpResponse_element();
  			new SagittaServices.insurerReceiptInsertResponse_element();
  			new SagittaServices.InvoiceTransactionInfo();
  			new SagittaServices.commissionStatementInsertMap();
  			new SagittaServices.PassThroughReqResponse_element();
  			new SagittaServices.invoiceGetByCriteriaV1_element();
  			new SagittaServices.Post();
  			new SagittaServices.importResultsResponse_element();
  			new SagittaServices.startsWithInfoMap();
  			new SagittaServices.paymentUpdateResponse_element();
            new SagittaServices.invoiceDeleteInsertMap();
            new SagittaServices.AddlTransactions();
            new SagittaServices.policyUpdateResponse_element();
            new SagittaServices.ArrayOfInvoiceTransactionInfo();
            new SagittaServices.customProcessUsher_element();
            new SagittaServices.StreetAddress();
            new SagittaServices.VoidResults();
            new SagittaServices.invoiceDeleteResponse_element();
            new SagittaServices.ArrayOfString();
            new SagittaServices.cashReceiptInsertMap();
            new SagittaServices.ProducerCd();
            new SagittaServices.containsInfoMap();
            new SagittaServices.ArrayOfPolicies();
            new SagittaServices.ArrayOfCustomData();
            new SagittaServices.TransporterSoap();
            new SagittaServices.startsWithInfoMap();
            new SagittaServices.VoidResults();
            
       
	}
	
	
	private static testMethod void coverMethods() {
		System.Test.setMock(WebServiceMock.class, new ServicesMock());
        new SagittaServices.TransporterSoap().policyDelete(null, null, null);
        new SagittaServices.TransporterSoap().importResults(null);
        new SagittaServices.TransporterSoap().rolodexStartsWith(null);
        new SagittaServices.TransporterSoap().invoiceVoid(null);
        new SagittaServices.TransporterSoap().PassThroughImp(null);
        new SagittaServices.TransporterSoap().insurerReceiptUpdate(null);
        new SagittaServices.TransporterSoap().customProcessUsher(null);
        new SagittaServices.TransporterSoap().insurerReceiptInsert(null);
        new SagittaServices.TransporterSoap().invoiceGetByCriteriaV1(null);
        new SagittaServices.TransporterSoap().invoiceGetPdf(null);
        new SagittaServices.TransporterSoap().paymentInsert(null);
      	new SagittaServices.TransporterSoap().paymentUpdate(null);
      	new SagittaServices.TransporterSoap().invoicePost(null);
      	new SagittaServices.TransporterSoap().clientInsert(null);
		new SagittaServices.TransporterSoap().insurerReceiptDelete(null);
		new SagittaServices.TransporterSoap().clientUpdate(null);
		new SagittaServices.TransporterSoap().rolodexContains(null);
		new SagittaServices.TransporterSoap().cashReceiptInsert(null);
		new SagittaServices.TransporterSoap().PassThroughReq(null);
		new SagittaServices.TransporterSoap().policyUpdate(null);
		new SagittaServices.TransporterSoap().policyInsert(null);
        new SagittaServices.TransporterSoap().invoiceInsert(null);
    	new SagittaServices.TransporterSoap().commissionStatementInsert(null);
        new SagittaServices.TransporterSoap().invoiceDelete(null);
    


    }



	


	
	
}