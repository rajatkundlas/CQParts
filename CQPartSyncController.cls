public class CQPartSyncController {
    
    @AuraEnabled
    public static void syncPartsCallout()
    {
        try {
            Id highVolumeAccountId;
            Id lowVolumeAccountId;
            List<Account> listOfAccounts = [SELECT Id, Name FROM Account WHERE Name = 'High Volume' OR Name = 'Low Volume'];
            if(!listOfAccounts.isEmpty())
            {
                for(Account accountRecord : listOfAccounts)
                {
                    if(accountRecord.Name == 'High Volume')
                    {
                        highVolumeAccountId = accountRecord.Id;
                    }
                    if(accountRecord.Name == 'Low Volume')
                    {
                        lowVolumeAccountId = accountRecord.Id;
                    }
                }
            }
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:CQ_Part');
            request.setMethod('GET');
            request.setHeader('Content-type', 'application/json');
            request.setHeader('x-api-key', System.Label.CQ_Part_Api_Key);
            HttpResponse response = http.send(request);
            
            // If the request is successful, deserialize the JSON response.
            if(response.getStatusCode() == 200) {
                List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
                List<SQX_Part__c> listOfCQPartRecord = new List<SQX_Part__c>();
                
                for(Object res: results) {
                    Map<String,Object> mapVar = (Map<String,Object>)res;
                    SQX_Part__c cqPartRecord = new SQX_Part__c();
                    
                    cqPartRecord.Name = (String)mapVar.get('Part Name');
                    cqPartRecord.Part_Number__c = (String)mapVar.get('_id');
                    cqPartRecord.Active__c = true;
                    cqPartRecord.Related_Account__c = (Integer)mapVar.get('Total Quantity Shipped') < 99 ? lowVolumeAccountId : highVolumeAccountId;
                    listOfCQPartRecord.add(cqPartRecord);
                }
                if(!listOfCQPartRecord.isEmpty())
                {
                    upsert listOfCQPartRecord Part_Number__c;
                }
            }
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }    
}