public with sharing class ApexCallout {

    public static void getPexelPic(){

        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('callout:PexelsNC/v1/curated?per_page=1&page=688');
        req.setMethod('GET');

        Http http = new Http();
        
        HttpResponse resp = http.send(req);
        System.debug(resp.getBody());

    }

}