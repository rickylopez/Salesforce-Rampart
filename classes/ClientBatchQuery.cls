public with sharing class ClientBatchQuery {
	
@future (callout=true)
public static void sendBatchQuery() {    
   	
    //Get Sagitta Info MAIN Record Data
    String account;
    String username;
    String password;
    String serverpool;
    List<SagittaInfo__c> sagittaSettings = new List<SagittaInfo__c>([Select Id, Name, account__c, username__c, password__c, serverpool__c, Client_Date__c, Client_GTTIME__c,Client_LTTIME__c, 
                                                                    Client_Sync_Sent__c,Client_Sync_Minutes__c,UniVerse_Time__c,Current_UniVerse_Time__c
                                                                    from SagittaInfo__c where Name = 'MAIN']);
    
    String universeTime = SagittaTime.getTime();
    System.debug('UniverseTime to Query' + universeTime);
    //Set login credentials for Saggita 
    if (sagittaSettings.size()>0){
     account    = sagittaSettings.get(0).account__c;
     username   = sagittaSettings.get(0).username__c;
     password   = sagittaSettings.get(0).password__c;
     serverpool = sagittaSettings.get(0).serverpool__c;
    } 

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
                                writer.writeAttribute(null,null,'statement', 'LIST CLIENTS WITH AUDIT.DATE.TIME GT \\'+ universeTime +'\\ *OUTPUT* CLIENT.CODE CAT.CODE.1 CLIENT.NAME ADDR1 ADDR2 CITY STATE ZIP.CODE PRIME.PROD PRIME.SERVICER.NAME PHONE1 PHONE2 EMAIL.ADDRESS PROD_2 LAST.ENTRY.DATE');
                                writer.writeEndElement(); // Access Close
                        writer.writeEndElement(); // INPUT Close
                        writer.writeEndElement(); // XMLinput Close
                    writer.writeEndElement(); // PassThroughReq Close
                writer.writeEndElement(); // Soap Body Close
            writer.writeEndElement(); // Envelope Body Close    
            
    // Write XML to String Variable
    string xml = writer.getXmlString();
    System.debug('XML OUTPUT' + xml);      
    //End XmlStreamWriter 
    writer.close();
    
    // Create instance of HttpRequest, HttpResponse, and Http. Preparing to send to XML to Saggita
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http http = new Http();
            
    // Set Method, Endpoint, Header, and Body details for SOAP request. 
    req.setMethod('POST');
    req.setEndpoint('http://167.206.227.216/sagittaws/transporter.asmx');
    //Prod 167.206.227.216 Dev 167.206.227.210
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
        
    // Creating XMLStreamReader to read the response - Looking for SagittaID and Sagitta Client Code        
    // Clean XMl response from Sagitta - Call cleanXML method  
    String bodyXMLFinal = XMLCleaner.cleanXML(res.getBody());
    System.debug('XML Clean?' +bodyXMLFinal );
        
    

    //Create List of all Policy Records and Attributes to Update and Insert 
    List<Client_Staging__c> clientUpsert = new List<Client_Staging__c>();

    String address1; 
    String address2;
        
    String toParse = bodyXMLFinal;
    String fileAttrValue; 
    String itemAttribute;
    
    //Create DOM to read XML response 
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
                                //Account accountDetails = new Account();
                                Client_Staging__c accountDetails = new Client_Staging__c();
                                accountDetails.Sync_Status__c = 'Staged';

                                    if (!itemAttribute.startsWith('WEBSERVICE')) {
                                    System.debug('Item is not WEBSERVICE' + itemAttribute + ' Entering Data');
                                    System.debug ('Updated Client Details: ' + accountDetails);
                                    accountDetails.SagittaId__c = itemAttribute;
                                    
                                    List<DOM.XMLNode> aList = item.getChildElements();
                                       
                                            for (DOM.XMLNode a : aList) {
                                            String aPosition = a.getName();
                                            String aText = a.getText();
                                            System.Debug('a: ' + aPosition);
                                            System.Debug('text: ' + aText);
                                                
                                                if (aPosition != null && aPosition == 'a1') {
                                                	//Client Code
                                                	accountDetails.Client_Code__c = aText;
                                                	//accountDetails.Preferred_Method_of_Contact__c = 'Email';
                                                }

                                                if (aPosition != null && aPosition == 'a2') {
                                                    //Category Code 
                                                    String catCode;
                                                    if (aText == 'COM' || aText == 'LL' || aText =='NH') {
                                                    	catCode = 'Business';
                                                    } else {
                                                    	catCode = 'Individual';
                                                    }
                                                    accountDetails.Category_Code__c = catCode;
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a3') {
                                                    //Account Name
                                                    accountDetails.Name = aText;
                                                    System.debug('Adding Account Name to Account Object: ' + aText);
                                                    System.debug ('Updated Account Details: ' + accountDetails);
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a4') {
                                                    //Address 1
                                                    address1 = aText; 
                                                    accountDetails.Address_1__c = address1; 
                                                    //accountDetails.BillingStreet = aText;
                                                    System.debug('Adding Address 1 to Account Object: ' + aText);
                                                    System.debug ('Updated Account Details: ' + accountDetails);
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a5') {
                                                    //Address 2
                                                    address2 = aText; 
                                                    String fullAddress = address1 + ' ' + address2;
                                                    accountDetails.Address_1__c = fullAddress; 
                                                    System.debug('Adding Coverages to Policy Object: ' + aText);
                                                    System.debug ('Updated Policy Details: ' + accountDetails);
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a6') {
                                                    //City
                                                    accountDetails.City__c = aText;
                                                    System.debug('Adding City to Account Object: ' + aText);
                                                    System.debug ('Updated Account Details: ' + accountDetails);
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a7') {
                                                    //State
                                                    accountDetails.State__c = aText;
                                                    System.debug('Adding State to Account Object: ' + aText);
                                                    System.debug ('Updated Account Details: ' + accountDetails);
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a8') {
                                                    //ZipCode
                                                    accountDetails.Zip_Code__c = aText;
                                                    System.debug('Adding Zip Code to Account Object: ' + aText);
                                                    System.debug ('Updated Account Details: ' + accountDetails);
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a9') {
                                                    //Producer Code 
                                                    String prodCode = aText;
                                                    accountDetails.Producer_Code__c = prodCode; 
                                                    
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a10') {
                                                    //Account Executive 
                                                    accountDetails.Account_Executive__c = aText;
                                                    System.debug('Adding Account Exec to Account Object: ' + aText);
                                                    System.debug ('Updated Account Details: ' + accountDetails);
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a11') {
                                                    //Phone1
                                                    accountDetails.Phone_1__c = aText;
                                                    System.debug('Adding Phone to Account Object: ' + aText);
                                                    System.debug ('Updated Account Details: ' + accountDetails);
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a12') {
                                                    //Phone2
                                                    accountDetails.Phone_2__c = aText;
                                                    System.debug('Adding Phone 2 to Account Object: ' + aText);
                                                    System.debug ('Updated Account Details: ' + accountDetails);
                                                }
                                                
                                                if (aPosition != null && aPosition == 'a13') {
                                                    //Email 
                                                    accountDetails.Email__c = aText;
                                                    System.debug('Adding Status to Account Object: ' + aText);
                                                    System.debug ('Updated Account Details: ' + accountDetails);
                                                }

                                                if (aPosition != null && aPosition == 'a14') {
                                                    //Producer2 
                                                    accountDetails.Producer_Code_2__c = aText;
                                                    System.debug('Adding Producer 2 to Account Object: ' + aText);
                                                    System.debug ('Updated Account Details: ' + accountDetails);
                                                }

                                                //End of A# lists
                                                 
                                            } // End For aList 
                                             
                                    } //If Sagitta ID Exists    
                                        System.debug('Does Account` Details Exist?' + accountDetails);
                                            if (accountDetails.Name != null) {
                                                System.debug('Yes, add to clientUpsert List' + accountDetails);
                                                System.debug('Account Upsert List Before Add' + clientUpsert);
                                                clientUpsert.add(accountDetails);
                                                System.debug('Account Upsert List After Add' + clientUpsert);
                                            }    
                                
                                } //item 
                            } // file
                        } //files
                    } //pickResponse
                } //passThroughReqResult
            } //passThroughReqResponse

    try {
    System.debug('Upsert These Records' + clientUpsert);
    Insert clientUpsert;
	} catch(DmlException e) {
    System.debug('The following exception has occurred during Upsert: ' + e.getMessage());
	}
	System.debug('Succesfully Upserted the Following.' + clientUpsert);
    
    //Update Latest Request Date, GTTIME, LTTIME for next Policy Delta Sync 
    SagittaInfo__c sagInfo = new SagittaInfo__c();
        sagInfo.Id                  = sagittaSettings.get(0).Id;
        sagInfo.Client_Sync_Sent__c = false;
        sagInfo.Client_Date__c = string.valueOf(System.now()); 
        
        update sagInfo; 

            
    } 

}