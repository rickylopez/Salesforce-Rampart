trigger UpdateOppLastNote on Note (after insert, after update) {

List<Opportunity> oppLstToUpdate=new List<Opportunity>();
    if(Trigger.isInsert){
        for(Note nt : Trigger.new){
            if(String.valueOf(nt.parentId).startsWith('006')){
                Opportunity opp=new Opportunity(Id=nt.parentId,Latest_Note__c=nt.Title + ': ' + nt.Body); 
                oppLstToUpdate.add(opp);
            }   
        }
    }if(Trigger.isUpdate){
        for(Note nt : Trigger.new){
            if(String.valueOf(nt.parentId).startsWith('006')){
                if(nt.Body != Trigger.oldMap.get(nt.Id).Body){
                   Opportunity opp=new Opportunity(Id=nt.parentId,Latest_Note__c=nt.Title + ': ' + nt.Body); 
                    oppLstToUpdate.add(opp);
                }
            }
        }
    }
    if(!oppLstToUpdate.isEmpty()){
        try{
            update oppLstToUpdate;
        }catch(DmlException de ){
            System.debug(de);
        }
    }


}