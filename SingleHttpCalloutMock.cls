@isTest
public class SingleHttpCalloutMock implements HttpCalloutMock {
    Integer statusCode;
    String bodyAsString;
    Map<String,String> responseHeaders;
    public SingleHttpCalloutMock(Integer statusCode, String bodyAsString, Map<String,String> responseHeaders)
    {
        this.statusCode = statusCode;  
        this.bodyAsString = bodyAsString;
        this.responseHeaders = responseHeaders;
    }
    public HTTPResponse respond(HTTPRequest request)
    {
        HTTPResponse response = new HTTPResponse();
        response.setStatusCode(statusCode);
        if(responseHeaders != null)
        {
            for(String key : responseHeaders.keySet())
            {
                response.setHeader(key, responseHeaders.get(key));                
            }            
        }
        response.setBody(bodyAsString);
        return response;        
    }

}