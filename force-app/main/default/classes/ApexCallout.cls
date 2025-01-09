public with sharing class ApexCallout {

    private static final String PEXELS_NAMED_CREDENTIAL = 'callout:PexelsNC';
    private static final String API_ENDPOINT = '/v1/curated?per_page=1&page=';

    @AuraEnabled(cacheable=true)
    public static String getPexelPic(Integer pageNumber){

        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(PEXELS_NAMED_CREDENTIAL + API_ENDPOINT + pageNumber);
        req.setMethod('GET');

        Http http = new Http();
        
        HttpResponse resp = http.send(req);

        return resp.getBody();
    }

}