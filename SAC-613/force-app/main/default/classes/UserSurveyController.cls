public with sharing class UserSurveyController {

    public static List<Survey__c> getSurveys(Id userId) {
        // Get the logged in user's preferences, specialty, and location
        User user = [SELECT Id, Preferences__c, Specialty__c, Location__c FROM User WHERE Id=:userId];

        // Query for surveys that match the user's criteria
        List<Survey__c> surveys = [SELECT Id, Name, Status__c FROM Survey__c WHERE Status__c = 'Active' AND (Preferences__c = :user.Preferences__c OR Specialty__c = :user.Specialty__c OR Location__c = :user.Location__c) AND Id NOT IN (SELECT Survey__c FROM Survey_Response__c WHERE User__c = :userId)];

        return surveys;
    }

    public static void skipSurvey(Id surveyId, Id userId) {
        // Create a new Survey Response record
        Survey_Response__c surveyResponse = new Survey_Response__c(Survey__c = surveyId, User__c = userId);
        insert surveyResponse;
    }

    public static List<Survey_Response__c> getSurveyReports(Id userId){
        // Query for survey responses for the specified user
        List<Survey_Response__c> surveyResponses = [SELECT Id, Survey__r.Name, Survey__r.Status__c, Response__c FROM Survey_Response__c WHERE User__c = :userId];

        return surveyResponses;
    }

}