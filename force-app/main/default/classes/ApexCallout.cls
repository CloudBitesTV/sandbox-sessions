public with sharing class ApexCallout {

    private static final String namedCredential = 'callout:PexelsNC';
    private static final String endpoint = '/v1/curated?per_page=1&page=';

    @AuraEnabled(cacheable=true)
    public static String getPexelPic(Integer pageNumber){

        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(namedCredential + endpoint + pageNumber);
        req.setMethod('GET');

        Http http = new Http();
        
        HttpResponse resp = http.send(req);
        System.debug(resp.getBody());

        return resp.getBody();
    }

}