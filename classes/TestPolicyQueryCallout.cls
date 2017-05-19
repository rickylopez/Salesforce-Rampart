@isTest
public class TestPolicyQueryCallout {



     @isTest (SeeAllData=true)
     static void testCallout() {
     
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockPolicyQueryResponse());
        
      
        // Call method to test. Since @future callout need Test.startTest() and Tast.stopTest();  
        Test.startTest();
        PolicyBatchQuery.sendBatchQuery();
        Test.stopTest();
        
        //Create new HttpRequest Instance and populate response with MockResponse
        HttpRequest req = new HttpRequest();
        MockPolicyQueryResponse mock = new MockPolicyQueryResponse();
        HttpResponse res = mock.respond(req);
        
        
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'text/xml');
        String actualValue = res.getBody();
        String expectedValue ='<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body> <PassThroughReqResponse xmlns=\"http://amsservices.com/\"> <PassThroughReqResult> <PickResponse> <Files> <File sagfile="WORK.7864436"><Item sagitem="WEBSERVICE.TAGS*WORK.7864436"><a1>CLIENT.CODE</a1><a2>POLICY.NUMBER</a2><a3>EFF.DATE</a3><a4>EXP.DATE</a4><a5>COV</a5><a6>INS</a6><a7>TERM</a7><a8>POLICY.STATUS</a8><a9>BILLING.METHOD</a9><a10>31</a10><a11>32</a11><a12>33</a12><a13>NEW.REN</a13><a14>CHG.TIME</a14></Item></File><File sagfile="WORK.7864436"><Item sagitem="579624"><a1>KAPJE5</a1><a2>APP114859081</a2><a3>09/15/16</a3><a4>09/15/17</a4><a5>MP3</a5><a6>CHB</a6><a7>A</a7><a7>C</a7><a7>E</a7><a7>4</a7><a7>N</a7><a7>Q</a7><a7>S</a7><a7>3</a7><a7>2</a7><a8>Active</a8><a9>Agency Bill</a9><a10>3456</a10><a11>1230</a11><a12>1456</a12><a13>NEW</a13><a13>REN</a13><a14>10,244.50</a14><a15>40</a15><a16>5,045.45</a16></Item></File></Files> </PickResponse></PassThroughReqResult> </PassThroughReqResponse> </soap:Body></soap:Envelope>';
        
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
}