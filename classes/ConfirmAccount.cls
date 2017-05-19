public class ConfirmAccount{
    public static Boolean AsyncFlag = false;


    @Future(callout=true)
    
    public static void confirmAccountName(Set<ID> ids) { 
            

        Map<ID, Account> mapAccnt = getAccounts(ids);
        
        System.debug('Map Values: ' + mapAccnt); 
            
        //Initialize Sagitta Services 
        SagittaServices.Results sResult;
        SagittaServices.TransporterSoap port               = new SagittaServices.TransporterSoap();
        SagittaServices.AuthenticationHeader authHeader    = new SagittaServices.AuthenticationHeader(); 
        SagittaServices.Post post                          = new SagittaServices.Post();
            
        // Update Accounts Confirmed with Client Code and Sagitta ID
        List<Account> updAcct = new List<Account>(); 

        
        for(Account accnt : mapAccnt.values()) {
        
            
        //Find Primary Contact Information
        List<Contact> primaryContact = [Select Id, Email from Contact where AccountId=:accnt.Id LIMIT 1];   
            
        //Creating instances for complex data types. Postal Code, Producers, Servicers, Categeory Codes
        SagittaServices.clientInsertMap accounts   = new SagittaServices.clientInsertMap();
                
        //Get Sagitta Code from Account Owner 
        List<User> accountOwner = [Select Sagitta_User_Code__c From User where id =: accnt.ownerid];
        
        //Set Producer Code        
        String prodCode = string.valueOf(accountOwner[0].Sagitta_User_Code__c);
        SagittaServices.ProducerCd prod  = new SagittaServices.ProducerCd();
        prod.Producer1Cd = prodCode;

        //Servicer Codes
        SagittaServices.ServicerCd serv  = new SagittaServices.ServicerCd();
        serv.Servicer1Cd = 'HO';
                
        //---------------------Category Codes---------------------------------------------------
        String catCode1; 
            if (accnt.RecordType.Name == 'Business') {
                
                // Set Cat Code to COM
                catCode1 = 'COM';

                //Set Login Credentials to AuthHeader for SFCL User
                    authHeader.Account    = 'gemdata';
                    authHeader.Username   = 'wksmt';
                    authHeader.Password   = 'adminwk';
                    authHeader.Serverpool = 'websvc';  
                    port.AuthenticationHeader = authHeader;
            } else {

                // Set Cat Code to PER
                catCode1 = 'PER';

                //Set Login Credentials to AuthHeader for SFCL User
                    authHeader.Account    = 'gemdata';
                    authHeader.Username   = 'wksmt';
                    authHeader.Password   = 'adminwk';
                    authHeader.Serverpool = 'websvc'; 
                    port.AuthenticationHeader = authHeader; 
            }

        SagittaServices.CatCd catCode  = new SagittaServices.CatCd();
        catCode.Cat1Cd = catCode1; 


        //-----------------------Postal Code - Commercial or Personal ----------------------------
        String postalCode;
        postalCode = accnt.BillingPostalCode;  
        SagittaServices.Post postCodes = new SagittaServices.Post(); 
        postCodes.PostalCode = postalCode;
                

              

        //Generate Unique ID for GUID over to Sagitta 
        String genGuid = string.ValueOf(Datetime.now().formatGMT('yyyyMMddHHmmssSSS'));
        
        /*       
        //Set Login Credentials to AuthHeader
        authHeader.Account    = 'gemdata';
        authHeader.Username   = 'wksmt';
        authHeader.Password   = 'adminwk';
        authHeader.Serverpool = 'websvc';    
        port.AuthenticationHeader = authHeader;    
        */

        //------------------------Client Insert Map-------------------------------------------
                
        accounts.Guid = genGuid;
        
        //Keywords that need to be removed from beginning name 
        List<String> nameKeywords = new List<String>();
        nameKeywords.add('A ');
        nameKeywords.add('The ');
        String leftName = accnt.Name.left(4);
        String replacement = '';
        String accountName; 
        System.debug('Left Name :' + leftName);
        System.debug('Name:' + accnt.Name);
                
            for(Integer i=0; i<nameKeywords.size(); i++){
                if(leftName.contains(nameKeywords.get(i))){
                    String target = nameKeywords.get(i);
                    accountName = accnt.Name.replace(target, replacement);
                    System.debug('Replace Named:' + accountName);
                }  else {

                     accountName = accnt.Name; 
                }

                            
            }
                    
        //DBA Name
        System.debug('Trimmed Account Name' + accountName);
        System.debug('DBA Name: ' + accnt.DBA__c);
                
            if (accnt.DBA__c == null){
                accounts.ClientName = accountName; 
            } else {
                accounts.ClientName = accnt.DBA__c;     
            }
                
        accounts.DivisionNumber  = 01;
        accounts.CommentaryRemarkText = accnt.Name; 
        
        //replace charage return in BillingStreet
        String street = accnt.BillingStreet.replace('\r', ' ');
        Integer streetLength = street.length(); 
        System.debug('Length of Address:' + streetLength);
        if (streetLength > 39) {
            accounts.Addr1 = street.substring(0,39);
            accounts.Addr2 = street.substring(39,streetLength);
        } else {
            accounts.Addr1 = street;

        }

       
        //Capitalize State
        String state = accnt.BillingState;
        accounts.City            = accnt.BillingCity;       
        accounts.StateProvCd     = state.capitalize(); 
        accounts.PostCd          = postCodes; 
        accounts.Phone1Number    = long.ValueOf(accnt.Phone.replaceAll('\\D', ''));
        accounts.ContactMethod   = 'Email';
        accounts.EmailAddr 		 = accnt.Email__c;
        //accounts.CommentaryRemarkText = 'c/o' + ' ' + accnt.Care_Of__c; 
            	      
        accounts.ProducerCd      = prod; 
        accounts.ServicerCd      = serv; 
        accounts.CatCd           = catCode; 
                
        if (accnt.Phone_2__c != null){
            accounts.Phone2Number  = long.ValueOf(accnt.Phone_2__c.replaceAll('\\D', ''));
        }

        if (accnt.Fax != null) {
            accounts.FaxNumber = accnt.Fax.replaceAll('\\D', '');   
        }
                
        if (accnt.Website != null) {
            accounts.WebSiteLink = accnt.Website;  
        }

        if (accnt.Net_Commision__c != null) {
            accounts.NetCommissionPct = accnt.Net_Commision__c;
        }

        if (accnt.FEIN__c != null) {
            accounts.FEIN = Integer.valueOf(accnt.FEIN__c);
        }
                
        if (accnt.Business_Start_Date__c != null) {
            accounts.DateBusinessStarted = accnt.Business_Start_Date__c;
        }

        if (accnt.Inspection_Contact__c != null) {
            accounts.InspectionContact = accnt.Inspection_Contact__c;
        }
                
        if (accnt.Inspection_Phone_Number__c !=null) {
            accounts.InspectionPhoneNumber = long.ValueOf(accnt.Inspection_Phone_Number__c.replaceAll('\\D', ''));
        }

        if (accnt.Inspection_Phone_Extension_Number__c != null) {
            accounts.InspectionPhoneExtensionNumber = Integer.valueOf(accnt.Inspection_Phone_Extension_Number__c);    
        }
            
        if (accnt.Accounting_Contact__c !=null) {
            accounts.AccountingContact = accnt.Accounting_Contact__c;
        }
                
        if (accnt.Accounting_Phone_Number__c != null) {
            accounts.AccountingPhoneNumber = long.ValueOf(accnt.Accounting_Phone_Number__c.replaceAll('\\D', ''));
        }

        if (accnt.Accounting_Phone_Extension_Number__c != null) {
            accounts.AccountingPhoneExtensionNumber = Integer.valueOf(accnt.Accounting_Phone_Extension_Number__c);
        }
                
        if (accnt.Phone_Ext__c !=null ) {
            accounts.Phone1ExtensionNumber  = Integer.valueOf(accnt.Phone_Ext__c);
        }

        if (accnt.Phone_2_Ext__c !=null) {
            accounts.Phone2ExtensionNumber = Integer.valueOf(accnt.Phone_2_Ext__c);
        }

        System.debug('Client Insert This Account' + accounts); 
        


        try {
        
            sResult = port.clientInsert(accounts);               
            System.debug('Success:'+sResult.Success+'SagittaId:'+sResult.SagittaId+'SagittaCode:'+sResult.SagittaCode+'Errors:'); 

            //If Succesful, update Account record with Sagitta ID and Client Code 
            Account replyAcct = new Account(); 
            
            if(sResult.SagittaId != null & sResult.SagittaCode !=null) {

                replyAcct.id = accnt.id; 
                replyAcct.SagittaID__c = string.ValueOf(sResult.SagittaId); 
                replyAcct.Client_Code__c = sResult.SagittaCode;
                replyAcct.FireTrigger__c = 'False';
                replyAcct.Account_Status__c = 'Active'; 
                replyAcct.SendAccount__c = False;
                replyAcct.ErrorMsg__c = string.ValueOf(sResult.Success); 
                updAcct.add(replyAcct); 
                
            }  else {
                replyAcct.id = accnt.id; 
                replyAcct.ErrorMsg__c = string.ValueOf(sResult); 
                updAcct.add(replyAcct); 

                Case c = new Case(); 
                    c.AccountId       = accnt.Id; 
                    c.Subject         = 'Account to Sagitta Error: ' + accnt.Name;
                    c.Description     = string.ValueOf(sResult);
                    c.Origin          = 'Web';
                    c.Type            = 'Problem';
                    c.Reason          = 'Integration Issue';
                    c.Application__c  = 'Salesforce';
                    c.Priority        = 'High';
                
                insert c; 

            }
            
            upsert updAcct;
            AsyncFlag = true; 
                
            
        } catch (Exception ex) {

           
            System.debug('ERROR: '+ ex);
           
            
        
        }
    

    }
    


   }

    private static Map<Id, Account> getAccounts(Set<ID> ids){
        Map<Id, Account> accounts;
        accounts = new Map<ID, Account>([Select ID, DBA__c, Care_Of__c, Name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,BillingStreet,BillingCity,BillingState,FEIN__c, BillingPostalCode,Phone,Phone_2__c,Email__c,Fax,Website,
                                         Billing_Payment_Type__c,Sic,Preferred_Method_of_Contact__c,Net_Commision__c,Business_Start_Date__c,Inspection_Contact__c,
                                         Inspection_Phone_Number__c,Accounting_Contact__c,Accounting_Phone_Number__c, Accounting_Phone_Extension_Number__c,Inspection_Phone_Extension_Number__c,Phone_2_Ext__c,
                                         Phone_Ext__c,  ownerid,RecordType.Name,ErrorMsg__c
                                         
                                         from Account 
                                         where ID in :ids 
                                         and recordtypeid in (Select Id from RecordType where sobjecttype = 'Account')]);
        System.debug('Account Map Private' + accounts);
        return accounts;
    }
    
  
    
    
}