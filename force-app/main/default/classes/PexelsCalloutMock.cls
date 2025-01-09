public with sharing class PexelsCalloutMock implements HttpCalloutMock {
    
    public HttpResponse respond(HttpRequest request) {
        HttpResponse resp = new HttpResponse();
        resp.setBody('success');
        resp.setStatusCode(200);
        return resp;
    }

}