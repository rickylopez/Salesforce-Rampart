@isTest
public class TestClientQueryCallout {



     @isTest (SeeAllData=true)
     static void testCallout() {
     
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockClientQueryResponse());
        
      
        // Call method to test. Since @future callout need Test.startTest() and Tast.stopTest();  
        Test.startTest();
        ClientBatchQuery.sendBatchQuery();
        Test.stopTest();
        
        //Create new HttpRequest Instance and populate response with MockResponse
        HttpRequest req = new HttpRequest();
        MockClientQueryResponse mock = new MockClientQueryResponse();
        HttpResponse res = mock.respond(req);
        
        
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'text/xml');
        String actualValue = res.getBody();
        String expectedValue = '<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body> <PassThroughReqResponse xmlns=\"http://amsservices.com/\"> <PassThroughReqResult> <PickResponse> <Files><File sagfile="WORK.7733454"><Item sagitem="WEBSERVICE.TAGS*WORK.7733454"><a1>CLIENT.CODE</a1><a2>CAT.CODE.1</a2><a3>CLIENT.NAME</a3><a4>ADDR1</a4><a5>ADDRESS.#2</a5><a6>CITY</a6><a7>STATE</a7><a8>ZIP.CODE</a8><a9>STATUS</a9><a10>PRIME.PROD</a10><a11>PRIME.SERVICER.NAME</a11><a12>PHONE1</a12><a13>PHONE2</a13><a14>0.52</a14></Item></File><File sagfile=\"WORK.7864470\"> <Item sagitem=\"579615\"> <a1>TESTINGNEW</a1> <a2>ZIMJO1</a2> <a3>08/08/16</a3> <a4>08/08/17</a4> <a5>ARA</a5> <a6>CER</a6> <a7>A</a7> <a9>Agency Bill</a9> <a14>NEW</a14> <a15>12:06:46</a15> </Item> </File><File sagfile="WORK.7733454"><Item sagitem="59655"><a1>TESTRICKY</a1><a2>PER</a2><a3>Ricky Lopez</a3><a4>2972 Anderson Circle SE</a4><a6>Smyrna</a6><a7>GA</a7><a8>30080</a8><a10>RAL</a10><a11>Rick Lopez</a11></Item><Item sagitem="59655"><a1>TESTRICKY</a1><a2>PER</a2><a3>Ricky Lopez</a3><a4>2972 Anderson Circle SE</a4><a6>Smyrna</a6><a7>GA</a7><a8>30080</a8><a10>HO</a10><a11>Rick Lopez</a11></Item></File></Files> </PickResponse></PassThroughReqResult> </PassThroughReqResponse> </soap:Body></soap:Envelope>';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
}