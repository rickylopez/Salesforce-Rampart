public class PolicyBatchQuery {

Static Boolean isQuote = false; 
@future (callout=true)
public static void sendBatchQuery() {    

    
    //Get Sagitta Info Main Record Data
    

    List<SagittaInfo__c> sagittaSettings = new List<SagittaInfo__c>([Select Id, Name, account__c, username__c, password__c, serverpool__c, Date__c, GTTIME__C,LTTIME__c, Sent__c,Policy_Sync_Minutes__c,UniVerse_Time__c
                                                                 from SagittaInfo__c where Name = 'MAIN']);

    System.debug('UniverseTime' + sagittaSettings.get(0).UniVerse_Time__c);

    String universeTime = SagittaTime.getTime();
    System.debug('UniverseTime to Query' + universeTime);
    //Set login credentials for Saggita 
    String account    = sagittaSettings.get(0).account__c;
    String username   = sagittaSettings.get(0).username__c;
    String password   = sagittaSettings.get(0).password__c;
    String serverpool = sagittaSettings.get(0).serverpool__c;

    
    // Create XmlStreamWriter  
    XmlStreamWriter writer = new XmlStreamWriter();    
            
    //Build PassThroughReq Soap XML 
        writer.writeStartDocument('utf-8','1.0');  
            writer.writeStartElement(null,'soap12:Envelope',null);
            writer.writeAttribute(null,null,'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
            writer.writeAttribute(null,null,'xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
            writer.writeAttribute(null,null, 'xmlns:soap12', 'http://www.w3.org/2003/05/soap-envelope');
                    
            writer.writeStartElement(null,'soap12:Body', null);
                writer.writeStartElement(null,'PassThroughReq',null);
                writer.writeAttribute(null,null,'xmlns', 'http://amsservices.com/');
                    writer.writeStartElement(null,'XMLinput',null);
                        writer.writeStartElement(null,'INPUT',null);
                                writer.writeStartElement(null,'Account',null);
                                writer.writeAttribute(null,null,'value', account);
                                writer.writeEndElement(); // Account Close
                                writer.writeStartElement(null,'Username',null);
                                writer.writeAttribute(null,null,'value', username);
                                writer.writeEndElement(); // Username Close
                                writer.writeStartElement(null,'Password',null);
                                writer.writeAttribute(null,null,'value', password);
                                writer.writeEndElement(); // Password Close
                                writer.writeStartElement(null,'Serverpool',null);
                                writer.writeAttribute(null,null,'value', serverpool);
                                writer.writeEndElement(); // Serverpool Close
                                writer.writeStartElement(null,'Access',null);
                                writer.writeAttribute(null,null,'statement', 'LIST POLICIES WITH AUDIT.DATE.TIME GE \\' + universeTime + '\\ *OUTPUT* CLIENT.CODE POLICY.NUMBER EFF.DATE EXP.DATE COV INS TERM POLICY.STATUS BILLING.METHOD WRITPREM AGENCYCOM PRODCOM  NEW.REN EST.PREM.AMT EST.COMM.PCT EST.COMM.AMT Producer1Cd Servicer1Cd POL.SECOND.PROD CAN.DATE CANCEL.REASON 22.3 REI.DATE REINSTATEMENT.REASON CANCELLATION_REQUEST_DATE_ADDL CANCELLATION_AMOUNT_ADDL FINANCING_ADDL P.PAYEE LAST.USER');
                                writer.writeEndElement(); // Access Close
                        writer.writeEndElement(); // INPUT Close
                        writer.writeEndElement(); // XMLinput Close
                    writer.writeEndElement(); // PassThroughReq Close
                writer.writeEndElement(); // Soap Body Close
            writer.writeEndElement(); // Envelope Body Close    
            
    // Write XML to String Variable
    string xml = writer.getXmlString();
            
    //End XmlStreamWriter 
    writer.close();
    
    // Create instance of HttpRequest, HttpResponse, and Http. Preparing to send to XML to Saggita
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http http = new Http();
            
    // Set Method, Endpoint, Header, and Body details for SOAP request. 
    req.setMethod('POST');
    req.setEndpoint('http://167.206.227.216/sagittaws/transporter.asmx');
    //167.206.227.216 - Production DEV = 167.206.227.210
    req.setHeader('Content-Type', 'text/xml');
    req.setHeader('SOAPAction','http://amsservices.com/PassThroughReq');
    req.setBody(xml);
                       
    //Execute Callout 
    try {        
        res = http.send(req);
    }   catch (System.CalloutException e) {
        System.debug('Callout error: '+ e);
        System.debug('Response to String' + res.toString());
    }           
        
    // Clean XMl response from Sagitta - Call cleanXML method 
    String bodyXMLFinal = XMLCleaner.cleanXML(res.getBody());        
    
    //Create List of all Policy Records and Attributes to Update and Insert 
    List<Policy_Staging__c> policyUpsert = new List<Policy_Staging__c>();
    
    //Attribute for SagittaID 
    String itemAttribute;
    
    //Create DOM to read XML response 
    String toParse = bodyXMLFinal;
    DOM.Document doc = new DOM.Document();
    doc.load(toParse);
    
    //Get Root 
    DOM.XMLNode root = doc.getRootElement();
    String nms = root.getNameSpace();
    System.Debug('namespace: ' + nms); // http://www.w3.org/2003/05/soap-envelope

        DOM.XMLNode body = root.getChildElement('Body', nms); // Gets the body of the XML 
        System.Debug('body: ' + body); 
        List<DOM.XMLNode> bodyChildrenList = body.getChildElements();

            for (DOM.XMLNode passThroughReqResponse : bodyChildrenList) {
            System.Debug('passThroughReqResponse: ' + passThroughReqResponse.getName());
            List<DOM.XMLNode> passThroughReqResultList = passThroughReqResponse.getChildElements();

                for (DOM.XMLNode passThroughReqResult : passThroughReqResultList) {
                System.Debug('passThroughReqResult: ' + passThroughReqResult.getName());
                List<DOM.XMLNode> pickResponseList = passThroughReqResult.getChildElements();

                    for (DOM.XMLNode pickResponse : pickResponseList) {
                    System.Debug('pickResponse: ' + pickResponse.getName());
                    List<DOM.XMLNode> filesList = pickResponse.getChildElements();
                                
                        for (DOM.XMLNode files : filesList) {
                        System.Debug('files: ' + files.getName());
                        List<DOM.XMLNode> fileList = files.getChildElements();
                                   
                            for (DOM.XMLNode file : fileList) {
                            System.Debug('file: ' + file.getName());
                            List<DOM.XMLNode> itemList = file.getChildElements();
                     
                                for (DOM.XMLNode item : itemList) {
                                System.Debug('item: ' + item.getName());
                                itemAttribute = item.getAttributeValue('sagitem', null);
                                System.Debug('item attribute sagitem: ' + itemAttribute);
                                
                                
                                //Create Instance of Policy Staging Object
                                Policy_Staging__c policyDetails = new Policy_Staging__c();
                                //Policy Sync Status
                                policyDetails.Sync_Status__c = 'Staged';

                                    if (!itemAttribute.startsWith('WEBSERVICE')) {
                                    System.debug('Item is not WEBSERVICE' + itemAttribute + ' Entering Data');
                                    System.debug ('Updated Policy Details: ' + policyDetails);
                                    System.debug('Running query on : ' + itemAttribute);
                                    //List<Policy__c> lookUpID = new List<Policy__c> ([Select Id from Policy__c where SagittaID__c =:itemAttribute]);
                                    //System.debug('Results for queory on : ' + itemAttribute + ': ' + lookUpID);
                                    
                                        /*if (!lookupId.isEmpty()) {
                                        System.debug('ID IS NOT EMPTY: ' + lookupID);
                                        policyDetails.Id = string.valueOf(lookupID.get(0).Id);
                                        System.debug('Adding ID to Policy Object: ' + lookupID);
                                        System.debug ('Updated Policy Details: ' + policyDetails);
                                        }*/

                                        policyDetails.SagittaID__c = itemAttribute;
                                        List<DOM.XMLNode> aList = item.getChildElements();
                                       
                                            for (DOM.XMLNode a : aList) {
                                            String aPosition = a.getName();
                                            String aText = a.getText();
                                            System.Debug('a: ' + aPosition);
                                            System.Debug('text: ' + aText);
                                                
                                                if (aPosition != null && aPosition == 'a1') {
                                                    //Client Code
                                                    policyDetails.Client_Code__c = aText;
                                                }

                                                if (aPosition != null && aPosition == 'a2') {
                                                    //Policy Number
                                                    policyDetails.Name = aText;
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a3') {
                                                    //Effective Date
                                                    policyDetails.EffDate__c = date.parse(aText);
                                                    
                                                    
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a4') {
                                                    //Expiration Date
                                                    policyDetails.ExpDate__c = date.parse(aText);
                                              
                                                }  
                                                if (aPosition != null && aPosition == 'a5') {
                                                    //Coverages
                                                    policyDetails.Coverage__c = aText;
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a6') {
                                                    //Insuror
                                                    policyDetails.Carrier__c = aText;
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a7') {
                                                    //Term
                                                    if (aText == 'A'){
                                                        aText = 'Annual';
                                                    } else if (aText == 'C') {
                                                        aText = 'Continuous';
                                                    } else if (aText == 'E'){
                                                        aText = 'Event';
                                                    } else if (aText == '4'){
                                                        aText = 'Four Year';
                                                    } else if (aText == 'N'){
                                                        aText = 'Non-Standard';
                                                    } else if (aText == 'Q'){
                                                       aText = 'Quarterly';
                                                    } else if (aText == 'S'){
                                                       aText = 'Semi-Annual';
                                                    } else if (aText == '3'){
                                                       aText = 'Three Year';
                                                    } else if (aText == '2'){
                                                       aText = 'Two Year';           
                                                    }
                                                    
                                                    policyDetails.Policy_Term__c = aText;
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a8') {
                                                    //Policy Status
                                                    if (aText == ''){
                                                        policyDetails.Policy_Status__c = 'Active';
                                                    } else {
                                                        policyDetails.Policy_Status__c = aText;
                                                    }
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a9') {
                                                    //Billing Method
                                                    policyDetails.Billing_Method__c = aText;
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a10') {
                                                    //Written Premium
                                                    String writPrem = aText.replace(',','');
                                                    policyDetails.WrittenPrem__c = Decimal.valueOf(writPrem);
                                
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a11') {
                                                   //Written Agency Prem
                                                    String agencyPrem = aText.replace(',','');
                                                    policyDetails.WrittenAgencyCom__c = Decimal.valueOf(agencyPrem);
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a12') {
                                                    //Written Producer Prem
                                                    String prodPrem = aText.replace(',','');
                                                    policyDetails.WrittenProdCom__c = Decimal.valueOf(prodPrem);
                                                   
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a13') {
                                                    //New or Renewal 
                                                    if (aText == 'NEW') {
                                                        aText = 'New Business';
                                                    } else {
                                                        aText = 'Renewal';
                                                    }
                                                    policyDetails.Transaction_Type__c = aText;
                                            
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a17') {
                                                    //Producer1Code
                                                    policyDetails.Producer_Code_1__c = aText;
                                                }

                                                  if (aPosition != null && aPosition == 'a18') {
                                                    //Servicer
                                                    policyDetails.Servicer_1_Code__c = aText;
                                                    
                                                }
                                                  if (aPosition != null && aPosition == 'a19') {
                                                    //Producer2Code
                                                    policyDetails.Producer_2_Code__c = aText;
                                                    
                                                    
                                                }
                                                 if (aPosition != null && aPosition == 'a20') {
                                                    //CAN.DATE
                                                    policyDetails.Cancellation_Date__c = date.parse(aText);
                                                         
                                                    
                                                }
                                                 if (aPosition != null && aPosition == 'a21') {
                                                    //CANCEL.REASON
                                                    policyDetails.Cancellation_Reason__c = aText;
                                                    
                                                    
                                                }
                                                 if (aPosition != null && aPosition == 'a22') {
                                                    //Cancel Method 22.3
                                                    policyDetails.Cancellation_Method__c = aText;
                                                    
                                                    
                                                }
                                                 if (aPosition != null && aPosition == 'a23') {
                                                    //REI.DATE
                                                    policyDetails.Reinstatement_Date__c = date.parse(aText);
                                                    
                                                    
                                                }
                                                if (aPosition != null && aPosition == 'a24') {
                                                    //REINSTATEMENT.REASON
                                                    policyDetails.Reinstatement_Reason__c = aText;
                                                       
                                                    
                                                }

                                                if (aPosition != null && aPosition == 'a25') {
                                                    //Cancellation Request Date
                                                    policyDetails.Cancellation_Request_Date__c = date.parse(aText);
                                                       
                                                   
                                                }
                                                 if (aPosition != null && aPosition == 'a26') {
                                                    // CANCELLATION_AMOUNT_ADDL
                                                    String canAmount = aText.replace(',','');
                                                    policyDetails.Cancellation_Amount__c = Decimal.valueOf(canAmount);
                                                                                                     
                                                }

                                                if (aPosition != null && aPosition == 'a27') {
                                                    //Financing
                                                    policyDetails.Financing__c =aText;
                                                       
                                                   
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a28') {
                                                    //PAYEE
                                                    policyDetails.Payee__c =aText;
                                                       
                                                   
                                                }

                                                if (aPosition != null && aPosition == 'a29') {
                                                    //Last User
                                                    policyDetails.Last_User__c =aText;
                                                       
                                                   
                                                }

                                                //End of A# lists
                                                 
                                            } // End For aList 
                                             
                                    } //If Sagitta ID Exists 
                                       System.debug('Does Policy Details Exist?' + policyDetails);
                                            if (policyDetails.Name != null) {
                                                System.debug('Yes, add to PolicyUpsert List' + policyDetails);
                                                System.debug('Policy Upsert List Before Add' + policyUpsert);
                                                policyUpsert.add(policyDetails);
                                                System.debug('Policy Upsert List After Add' + policyUpsert);
                                            }    
                                
                                } //item 
                            } // file
                        } //files
                    } //pickResponse
                } //passThroughReqResult
            } //passThroughReqResponse

    try {
    System.debug('Upsert These Records' + policyUpsert);
    upsert policyUpsert;
    } catch(DmlException e) {
    System.debug('The following exception has occurred during Upsert: ' + e.getMessage());
    }
  
   
    //Update Latest Request Date, GTTIME, LTTIME for next Policy Delta Sync 
    SagittaInfo__c sagInfo = new SagittaInfo__c();
        sagInfo.Id         = sagittaSettings.get(0).Id;
        sagInfo.Date__c = string.valueOf(System.now());
        sagInfo.Sent__c    = false;
        update sagInfo; 

            
    } 
}