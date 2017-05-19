trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

//List of Applications to Check against description 
            List<String> app = new List<String>();
            app.add('WorkSmart');
            app.add('Citrix');
            app.add('Lync');
            app.add('Outlook');
            app.add('Sagitta');
            app.add('Facilities');
            app.add('Mobile');
            app.add('Monitor');
            app.add('Network');
            app.add('Password');
            app.add('Printers');
            app.add('RightFax');
            app.add('Word');
            app.add('Website');
            app.add('Salesforce');
            


    for (Case so : Trigger.new) {
        //friends remind friends to bulkify
        if(Trigger.isBefore){
            
            //Store Description in String Value
        if(so.Description != null) { 
            String caseDesc = so.Description; 
            String appDetail; 
            //Check to see if keyword is in 
            for(Integer i = 0; i < app.size();i++){
                String valueApp = string.valueOf(app.get(i));
                if(caseDesc.containsIgnoreCase(valueApp)){
                
                    so.Application__c =  string.valueOf(app.get(i));

                }

            }
            
        }
            



        }


    }

}