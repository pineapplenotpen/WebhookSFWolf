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

            RestResponse response = RestContext.response;
            String hashedval = request.headers.get('X-Hub-Signature-256');
            Blob hmac = Crypto.generateMac('hmacSHA256',requestBody, Blob.valueOf('webhookwolf'));
            String hmacstring = 'sha256='+EncodingUtil.convertToHex(hmac);
            String requestJSON = requestBody.toString();
            PushRequest requestParsed = (PushRequest) JSON.deserialize(requestJSON, PushRequest.class);

            if(hashedval == hmacstring){

                insert new Github_Webhook_Result__c(
                    Name = 'Test '+String.valueOf(Datetime.now()),
                    Pusher_Name__c = requestParsed.pusher.name,
                    Pusher_Email__c = requestParsed.pusher.email,
                    Commit_ID__c = requestParsed.commits[0].id,
                    Commit_Message__c = requestParsed.commits[0].message
                );
            }else{
                insert new Magic_Pineapple__Pineapple_Log__c(
                    Magic_Pineapple__Log_Message__c = hashedval + ' != ' + hmacstring,
                    Magic_Pineapple__Location__c = 'WebhookSubscriptionWolf.cls',
                    Magic_Pineapple__User_Id__c = UserInfo.getUserId()
                );
            }
            insert new Magic_Pineapple__Pineapple_Log__c(
                Magic_Pineapple__Log_Message__c = requestBody.toString().left(32768),
                Magic_Pineapple__Location__c = 'WebhookSubscriptionWolf.cls',
                Magic_Pineapple__User_Id__c = UserInfo.getUserId()
            );
            
            
        }catch(Exception e){
            system.debug('Exception occured: '+ e.getMessage());
            insert new Magic_Pineapple__Pineapple_Log__c(
                Magic_Pineapple__Log_Message__c = 'ERR: '+e.getMessage(),
                Magic_Pineapple__Location__c = 'WebhookSubscriptionWolf.cls',
                Magic_Pineapple__User_Id__c = UserInfo.getUserId()
            );
        }
    }

    global class PushRequest{
        global pusher pusher{get;set;}
        global commits[] commits {get;set;}
    }

    global class pusher{
        global String name {get;set;}
        global String email {get;set;}
    }

    global class commits{
        global String id {get;set;}
        global String message {get;set;}
    }
}