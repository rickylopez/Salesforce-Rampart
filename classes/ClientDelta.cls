global class ClientDelta {
    
@future (callout=true)
@RemoteAction
global static void sendQuery(Set<ID> ids) {    

   	
        //Login credentials for Saggita 
        String account             = 'gemdata';
        String username            = 'wksmt';
        String password            = 'adminwk';
        String serverpool          = 'websvc';
        
    	// Map Policy ID        
		Map<ID, Policy__c> mapPolicy = getPolicies(ids);

        
        for(Policy__c policy : mapPolicy.values()) {        

    
        // Create XmlStreamWriter Instance 
        XmlStreamWriter writer = new XmlStreamWriter();    
            
        
            
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
            
            			
                            writer.writeStartElement(null,'Files',null);
                        	    writer.writeStartElement(null,'File',null);
                                writer.writeAttribute(null,null,'name', 'POLICIES');
                            	    writer.writeStartElement(null,'Items',null);
            							writer.writeStartElement(null,'Item',null);
            								writer.writeAttribute(null,null,'key', policy.SagittaID__c);
                                            writer.writeEndElement(); // Item Close
                                        writer.writeEndElement(); // Items Close
                                    writer.writeEndElement(); // File Close
                                writer.writeEndElement(); // Files Close
                            writer.writeEndElement(); // INPUT Close
                    writer.writeEndElement(); // XMLinput Close
                writer.writeEndElement(); // PassThroughReq Close
            writer.writeEndElement(); // Soap Body Close
         writer.writeEndElement(); // Envelope Body Close    
        
        // Write XML to String Variable 
        string xml = writer.getXmlString();
        system.debug('XML output' + xml);
        
        //End XmlStreamWriter 
        writer.close();


    
        // Create instance of HttpRequest, HttpResponse, and Http. Preparing to send to XML to Saggita
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        // Set Method, Endpoint, Header, and Body details for SOAP request. 
        req.setMethod('POST');
        req.setEndpoint('http://167.206.227.216/sagittaws/transporter.asmx');
        req.setHeader('Content-Type', 'text/xml');
        req.setHeader('SOAPAction','http://amsservices.com/PassThroughReq');
        req.setBody(xml);
                   
         //Execute Callout 
        try {        
                res = http.send(req);

        } catch (System.CalloutException e) {
           
            System.debug('Callout error: '+ e);
            System.debug('Response to String' + res.toString());
         
            }           
        
    	// Variables for reading Sagitta response     
        Boolean foundId   = false;
        Boolean foundCode = false;
        Boolean foundWrtPremAmt = false;
        Boolean foundWrtAgcyCom = false;
        Boolean foundWrtProdComAmt = false;  
        Boolean foundProducer1 = false;
        Boolean foundProducer2 = false;    
        String theSagittaIdValue; 
        String theSagittaCodeValue; 
        String wrtPremAmt;
        String WrtAgcyCom;
        String WrtProdComAmt;
        String producer1;
        String producer2;

            
		// Creating XMLStreamReader to read the response - Looking for SagittaID and Sagitta Client Code        
        String bodyXML = res.getBody(); //grab the body of the response
        String bodyXMLCleanUp = bodyXML.replace('&lt;', '<');
        String bodyXMLCleanUp2 = bodyXMLCleanUp.replace('&gt;', '>'); 
        String bodyXMLCleanUp3 = bodyXMLCleanUp2.replace('<PassThroughReqResponse xmlns="http://amsservices.com/">', '<PassThroughReqResponse>');
        String bodyXMLCleanUp4 = bodyXMLCleanUp3.replace('<?xml version="1.0"?>','');
        String bodyXMLFinal = bodyXMLCleanUp4;
        System.debug('XML Response' + bodyXMLFinal);
        
           
        XmlStreamReader reader = new XmlStreamReader(bodyXMLFinal); //construct an XmlStreamReader object            
        System.debug('Reader XML' + reader);
           
            
            while (reader.hasNext()) { //while there are more XML events
                System.debug('While read has next' + reader.hasNext());
            if (reader.getEventType() == XmlTag.START_ELEMENT) { //if this is the opening tag
                

                //Loop through to look for SagittaId
                if ('SagittaClientCode' == reader.getlocalName()) {
                    System.debug('Inside first loop');
                    while(reader.hasNext() && !foundId) { //while there are more XML events
                        if (reader.getEventType() == XmlTag.END_ELEMENT) { //if this is the closing tag
                            break; //exist the loop
                        } else if (reader.getEventType() == XmlTag.CHARACTERS) { //if this is the content between the tags
                            theSagittaIdValue = reader.getText();
                           // grab the content
                            if(theSagittaIdValue != null) {
              					policy.SagittaID__c = theSagittaIdValue;
               					update policy;
                                foundId = true;
                                System.debug('Sagitta Client: Insert' + ':' + theSagittaCodeValue );
           					}
                        }
                        reader.next(); //advance to the next XML event
                    }
                }

                //Loop through to look for Sagitta Policy Number
                if ('PolicyNumber' == reader.getLocalName()) { //if the tag is POlicy Number
                    System.debug('Inside second loop');
                    while(reader.hasNext() && !foundCode) { //while there are more XML events
                        if (reader.getEventType() == XmlTag.END_ELEMENT) { //if this is the closing tag
                            break; //exist the loop
                        } else if (reader.getEventType() == XmlTag.CHARACTERS) { //if this is the content between the tags
                            theSagittaCodeValue = reader.getText();
                            //grab the content
                            if (theSagittaCodeValue != null) { 
                				policy.Name = theSagittaCodeValue;
                                policy.SendQuery__c = false;
                                foundCode = true;
                                System.debug('Above Insert Policy Number Code Value: Insert' + ':' + theSagittaCodeValue );
                			    update policy;
                                System.debug('Policy Number Code Value: Insert' + ':' + theSagittaCodeValue );
        
           					}
                        }
                        reader.next(); //advance to the next XML event
                    }
                }
                
                  //Loop through to look for Sagitta Policy Number
                if ('WrittenPremiumAmt' == reader.getLocalName()) { //if the tag is POlicy Number
                    System.debug('Inside second loop');
                    while(reader.hasNext() && !foundWrtPremAmt) { //while there are more XML events
                        if (reader.getEventType() == XmlTag.END_ELEMENT) { //if this is the closing tag
                            break; //exist the loop
                        } else if (reader.getEventType() == XmlTag.CHARACTERS) { //if this is the content between the tags
                            wrtPremAmt = reader.getText();
                            //grab the content
                            if (wrtPremAmt != null) { 
                                decimal wrtPremAmtDec = decimal.valueOf(wrtPremAmt);
                				policy.Written_Premium__c = wrtPremAmtDec;
                                foundWrtPremAmt = true;
                                update policy;
                               
           					}
                        }
                        reader.next(); //advance to the next XML event
                    }
                }
                
                    if ('WrittenAgcyCommissionAmt' == reader.getLocalName()) { //if the tag is POlicy Number
                    System.debug('Inside second loop');
                    while(reader.hasNext() && !foundWrtAgcyCom) { //while there are more XML events
                        if (reader.getEventType() == XmlTag.END_ELEMENT) { //if this is the closing tag
                            break; //exist the loop
                        } else if (reader.getEventType() == XmlTag.CHARACTERS) { //if this is the content between the tags
                            WrtAgcyCom = reader.getText();
                            //grab the content
                            if (WrtAgcyCom != null) { 
                                decimal WrtAgcyComDec = decimal.valueOf(WrtAgcyCom);
                				policy.Written_Agency_Comm__c = WrtAgcyComDec;
                                foundWrtAgcyCom = true;
                                update policy;
                               
           					}
                        }
                        reader.next(); //advance to the next XML event
                    }
                }
                
                   if ('WrittenProducerCommissionAmt' == reader.getLocalName()) { //if the tag is POlicy Number
                    System.debug('Inside second loop');
                    while(reader.hasNext() && !foundWrtProdComAmt) { //while there are more XML events
                        if (reader.getEventType() == XmlTag.END_ELEMENT) { //if this is the closing tag
                            break; //exist the loop
                        } else if (reader.getEventType() == XmlTag.CHARACTERS) { //if this is the content between the tags
                            WrtProdComAmt = reader.getText();
                            //grab the content
                            if (WrtAgcyCom != null) { 
                                decimal WrtProdComAmtDec = decimal.valueOf(WrtProdComAmt);
                				policy.Written_Prod_Comm__c = WrtProdComAmtDec;
                                foundWrtProdComAmt = true;
                                update policy;
                               
           					}
                        }
                        reader.next(); //advance to the next XML event
                    }
                }

                   if ('Producer1Cd' == reader.getLocalName()) { //if the tag is POlicy Number
                    System.debug('Inside second loop');
                    while(reader.hasNext() && !foundProducer1) { //while there are more XML events
                        if (reader.getEventType() == XmlTag.END_ELEMENT) { //if this is the closing tag
                            break; //exist the loop
                        } else if (reader.getEventType() == XmlTag.CHARACTERS) { //if this is the content between the tags
                            producer1 = reader.getText();
                            //grab the content
                            if (producer1 != null) { 
                                //decimal WrtProdComAmtDec = decimal.valueOf(producer1);
                                policy.Producer_1__c = producer1;
                                foundProducer1 = true;
                                update policy;
                               
                            }
                        }
                        reader.next(); //advance to the next XML event
                    }
                }
                
                    if ('Producer2Cd' == reader.getLocalName()) { //if the tag is POlicy Number
                    System.debug('Inside second loop');
                    while(reader.hasNext() && !foundProducer2) { //while there are more XML events
                        if (reader.getEventType() == XmlTag.END_ELEMENT) { //if this is the closing tag
                            break; //exist the loop
                        } else if (reader.getEventType() == XmlTag.CHARACTERS) { //if this is the content between the tags
                            producer1 = reader.getText();
                            //grab the content
                            if (producer2 != null) { 
                                //decimal WrtProdComAmtDec = decimal.valueOf(producer1);
                                policy.Producer_2__c = producer2;
                                foundProducer2 = true;
                                update policy;
                               
                            }
                        }
                        reader.next(); //advance to the next XML event
                    }
                }
            }
        
        reader.next(); //advance to the next XML event
        
}
    
       
        
        }



}
    
// Mapping Account fields 
	private static Map<Id, Policy__c> getPolicies(Set<ID> ids){
        Map<Id, Policy__c> policies;
            policies = new Map<ID, Policy__c>([Select ID, Name, SagittaID__c,Insuror_Name__c,SendQuery__c
                                             from Policy__c 
                                             where ID in :ids ]);
            
              
            return policies;
    }     
    
}