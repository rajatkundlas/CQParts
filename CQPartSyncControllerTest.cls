@isTest
private class CQPartSyncControllerTest {
    
    @testSetup
    private static void testSetupData()
    {
        Account accountRecord1 = new Account();
        accountRecord1.Name = 'High Volume';
        insert accountRecord1;
        Account accountRecord2 = new Account();
        accountRecord2.Name = 'Low Volume';
        insert accountRecord2;
    }
    
    @isTest
    private static void testSyncPartsCalloutPositive()
    {
        Map<String,String> responseHeaders = new Map<String,String>();
        responseHeaders.put('Content-type', 'application/json');
        responseHeaders.put('x-api-key', System.Label.CQ_Part_Api_Key);
		String responseBody = '[{"_id": "629989816a50f02a0000b83e", "Part Name": "Pressure Adapt", "Total Quantity Shipped": 12,"Part Number": "PA-001", "Part Risk Level": 3, "Part Description": "PA Description", "SKU": "A", "Related Parts": "619683d69402c24f000237e9; 629989816a50f02a0000b83e"}, {"_id": "62998ecc6a50f02a0000b87d", "Part Name": "Pressure Sensor", "Total Quantity Shipped": 100,"Part Description": "PRS Desciprtion","Part Risk Level": 3,"Part Number": "PRS-001", "SKU": "B", "Related Parts": "619643769402c24f000229ec; 62998ecc6a50f02a0000b87d; 619643919402c24f000229ef"}]';
        Test.setMock(HttpCalloutMock.class, new SingleHttpCalloutMock(200, responseBody, responseHeaders));
        
        Test.startTest();
            CQPartSyncController.syncPartsCallout();
        Test.stopTest();
        
        List<SQX_Part__c> listOfCQParts = [SELECT Id, Name, Part_Number__c, Related_Account__r.Name FROM SQX_Part__c];
        Assert.areEqual(true, !listOfCQParts.isEmpty());
    }

    @isTest
    private static void testSyncPartsCalloutNegative()
    {
        Map<String,String> responseHeaders = new Map<String,String>();
        responseHeaders.put('Content-type', 'application/json');
        responseHeaders.put('x-api-key', System.Label.CQ_Part_Api_Key);
		String responseBody = '';
        Test.setMock(HttpCalloutMock.class, new SingleHttpCalloutMock(200, responseBody, responseHeaders));
        
        Test.startTest();
            CQPartSyncController.syncPartsCallout();
        Test.stopTest();
        
        List<SQX_Part__c> listOfCQParts = [SELECT Id, Name, Part_Number__c, Related_Account__r.Name FROM SQX_Part__c];
        Assert.areEqual(true, !listOfCQParts.isEmpty());
    }     
}