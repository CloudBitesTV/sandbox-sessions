@isTest
private with sharing class ApexCallout_Test {
    
    @isTest
    private static void testGetPexelPic() {
        Test.setMock(HttpCalloutMock.class, new PexelsCalloutMock());
        Test.startTest();

        String returnBody = ApexCallout.getPexelPic(10);

        Test.stopTest();

        System.Assert.isNotNull(returnBody, 'The return body should not be null');
    }

}