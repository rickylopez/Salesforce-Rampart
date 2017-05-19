public class XMLCleaner {

    Public Static String cleanXML(String xmlInput){
    
    
    String bodyXMLCleanUp = xmlInput.replace('&lt;', '<');
    String bodyXMLCleanUp2 = bodyXMLCleanUp.replace('&gt;', '>');
    String bodyXMLCleanup3 = bodyXMLCleanUp2.replace('amp;amp;','');
    String bodyXMLCleanUp4 = bodyXMLCleanUp3.replace('<PassThroughReqResponse xmlns="http://amsservices.com/">', '<PassThroughReqResponse>');
    String bodyXMLCleanUp5 = bodyXMLCleanUp4.replace('<?xml version="1.0"?>','');
    
    return bodyXMLCleanUp5;
    
	}
    
    
}