public class InsertSagittaPolicy{
    public static Boolean AsyncFlag = false;


    @Future(callout=true)
    public static void SendToSagitta(Set<ID> ids) { 
            

        Map<ID, OpportunityLineItem> mapProducts = getProducts(ids);
        
        System.debug('Map Values: ' + mapProducts); 
            
        //Initialize Sagitta Services 
        SagittaServices.Results sResult;
        SagittaServices.TransporterSoap port               = new SagittaServices.TransporterSoap();
        SagittaServices.AuthenticationHeader authHeader    = new SagittaServices.AuthenticationHeader(); 
        SagittaServices.Post post                          = new SagittaServices.Post();
            
        // Update Accounts Confirmed with Client Code and Sagitta ID
        List<OpportunityLineItem> updProdLine = new List<OpportunityLineItem>();
        
        

        Integer sizeOfMap = mapProducts.size();
            for(OpportunityLineItem oppLine : mapProducts.values()) {
            
                //Creating instances for complex data types. Postal Code, Producers, Servicers, Categeory Codes
                SagittaServices.policyInsertMap policy   = new SagittaServices.policyInsertMap();

                        
                //Get Sagitta Code from Account Owner 
                List<User> accountOwner = [Select Sagitta_User_Code__c From User where id =: oppLine.CreatedById];
                
                //Get Sagitta Coe from Marketing Team Member
                List<OpportunityTeamMember> teamSagittaCode = [Select Id,Member_User_Code__c from OpportunityTeamMember where OpportunityId=
                                                               :oppLine.Id and TeamMemberRole = 'Marketing' LIMIT 1];
                String teamSagCode; 
                System.debug('Searching for Marketing Saggita Code: ' + teamSagittaCode);
                if (teamSagittaCode.size() > 0) {
                    
                    teamSagCode = teamSagittaCode.get(0).Member_User_Code__c;
                    System.debug('Marketing Saggita Code: ' + teamSagCode);
                    
                } else {
                    
                    teamSagCode =accountOwner.get(0).Sagitta_User_Code__c;
                    System.debug('Cant Find Marketing Saggita Code: ' + teamSagCode);
                }
                 //Set Producer Code        
                String prodCode = oppLine.Account_Owner_Sagitta_ID__c; 
                SagittaServices.ProducerCd prod  = new SagittaServices.ProducerCd();
                prod.Producer1Cd = prodCode;

                //Servicer Codes
                SagittaServices.ServicerCd serv = new SagittaServices.ServicerCd();
                serv.Servicer1Cd = 'HO';
                
                //Sagitta ID
        		SagittaServices.ClientInfo sagID = new SagittaServices.ClientInfo();
                sagID.ClientId = long.valueOf(oppLine.Account_Sagitta_ID__c);

                //Generate Unique ID for GUID over to Sagitta 
                String genGuid = string.ValueOf(Datetime.now().formatGMT('yyyyMMddHHmmssSSS'));
                        
                //Transaction Info
                SagittaServices.NBSTransactionInfo transInfo = new SagittaServices.NBSTransactionInfo(); 
                transInfo.TransactionType = 'NBS'; 
                transInfo.TransactionDate = oppLine.ServiceDate;
                transInfo.FollowupDays    = 0;

                //Set Login Credentials to AuthHeader
                authHeader.Account    = 'gemdata';
                authHeader.Username   = 'wksmt';
                authHeader.Password   = 'adminwk';
                authHeader.Serverpool = 'websvc';    
                port.AuthenticationHeader = authHeader;    


                //------------------------Policy Insert Map-------------------------------------------
                        
                policy.Guid         = genGuid;
                policy.Producer     = prod; 
                policy.ServicerCd   = 'HO'; 
                policy.PolicyNumber = 'APP' + oppLine.ProductCode + teamSagCode;
                policy.DivisionCd   = 01;
                policy.ClientInfo   = sagId; 
               
                   if(oppLine.Opportunity_Record_Type_Name__c == 'Commercial Lines'){
                            policy.DepartmentCd = '02';

                    } else {
                            policy.DepartmentCd = '01';

                    }
               
                Date effDate = oppLine.ServiceDate;
                Date expDate = effDate.addYears(1);
                policy.PolicyEffectiveDt = effDate;
                policy.CoverageCd   = oppLine.ProductCode; 
                policy.InsurerName  = 'QQQ'; 
                policy.PolicyExpirationDt = expDate;
                policy.TransactionInformation = transInfo; 

                System.debug('Policy Insert This Opportunity Product Line' + policy); 
                


                try {
                
                    sResult = port.policyInsert(policy);               
                    System.debug('Success:'+sResult.Success+'SagittaId:'+sResult.SagittaId+'SagittaCode:'+sResult.SagittaCode+'Errors:'); 

                    //If Succesful, update Account record with Sagitta ID and Client Code 
                    OpportunityLineItem replyOppLine = new OpportunityLineItem(); 
                    
                    if(sResult.SagittaId != null) {

                        replyOppLine.id = oppLine.id; 
                        replyOppLine.Sagitta_ID__c = string.ValueOf(sResult.SagittaId); 
                        replyOppLine.Send_To_Sagitta_As_Policy__c = false;
                        replyOppLine.Expiration_Date__c = expDate;
                        updProdLine.add(replyOppLine); 
                        
                    }  else {
                        replyOppLine.id = oppLine.id; 
                        replyOppLine.ErrorMsg__c = string.ValueOf(sResult); 
                        replyOppLine.Send_To_Sagitta_As_Policy__c = false; 
                        updProdLine.add(replyOppLine); 

                        

                    }
                } catch (Exception ex) {
                    System.debug('ERROR: '+ ex);
                }
    

            }
        

        UpdateProductLine.updateProducts(updProdLine);         


   }

    private static Map<Id, OpportunityLineItem> getProducts(Set<ID> ids){
        Map<Id, OpportunityLineItem> oppProducts;
        oppProducts = new Map<ID, OpportunityLineItem>([SELECT Id, 
                                                        OpportunityId, 
                                                        SortOrder, 
                                                        PricebookEntryId, 
                                                        Product2Id, 
                                                        ProductCode, 
                                                        Name, 
                                                        Quantity, 
                                                        TotalPrice, 
                                                        UnitPrice, 
                                                        ListPrice, 
                                                        ServiceDate, 
                                                        HasRevenueSchedule, 
                                                        HasQuantitySchedule, 
                                                        Description, 
                                                        HasSchedule, 
                                                        CreatedDate, 
                                                        CreatedById, 
                                                        LastModifiedDate, 
                                                        LastModifiedById, 
                                                        SystemModstamp, 
                                                        IsDeleted, 
                                                        Opportunity__c, 
                                                        Stage__c, 
                                                        Producer__c, 
                                                        Account__c, 
                                                        Carrier_Account__c, 
                                                        Account_Owner_Sagitta_ID__c, 
                                                        Account_Sagitta_ID__c,
                                                        Sagitta_ID__c,
                                                        ErrorMsg__c,
                                                        Carrier_Code__c,
                                                        Opportunity_Record_Type_Name__c,
                                                        Expiration_Date__c,
                                                        Send_To_Sagitta_As_Policy__c
                                                    FROM OpportunityLineItem
                                                    Where ID in :ids 
                                                    ]);
        System.debug('Product Map Private' + oppProducts);
        return oppProducts;
    }
    
  
    
    
}