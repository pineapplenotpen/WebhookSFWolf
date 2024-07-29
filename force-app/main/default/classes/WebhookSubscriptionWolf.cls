/**
 * @description       : 
 * @author            : maksym.kishchuk@redtag.pro
 * @group             : 
 * @last modified on  : 07-29-2024
 * @last modified by  : maksym.kishchuk@redtag.pro
**/
@RestResource(urlMapping='/api/Webhooks/pushDetailsWolf/*')
global with sharing class WebhookSubscriptionWolf {

    @HttpPost
    global static void handlePostRequest(){
        try{

            RestRequest request = RestContext.request;

            Blob requestBody = request.requestBody;
            system.debug(requestBody);
            system.debug(String.valueOf(requestBody));

            RestResponse response = RestContext.response;
            system.debug(response.responseBody);
            system.debug(String.valueOf(response.responseBody));
        }catch(Exception e){
            system.debug('Exception occured: '+ e.getMessage());
        }
    }
}