public with sharing class LeadHandler {
    public static void handle(List<Lead> leadList){
        //sort leads by zip code
        Map<String, List<Lead>> zipLeadMap = new Map<String, List<lead>>();
        for (lead l : leadList){
            List<Lead> tmpLeadList = zipLeadMap.get(l.PostalCode);
            if (tmpLeadList == null){ //create lead list if does not exists
                tmpLeadList = new List<Lead>();
            }
            tmpLeadList.add(l);
            zipLeadMap.put(l.PostalCode, tmpLeadList); //group leads by zipcode
        }

        //sort user by zip code
        Map<String, List<String>> zipAssignMap = new Map<String, List<String>>();
        for (ZipCode__c zip : [SELECT id, Zip_Code__c, Assigned__c FROM ZipCode__c WHERE Zip_Code__c in : zipLeadMap.keySet()]){
            String[] tmpAssignList = zipAssignMap.get(zip.Zip_Code__c);
            if (tmpAssignList == null)
                tmpAssignList = new String[]{}; //short hand list creation

            tmpAssignList.add(zip.Assigned__c);
            zipAssignMap.put(zip.Zip_Code__c, tmpAssignList); //group list of user id by zipcode
        }

        //assign user to zip code
        for (String zip : zipLeadMap.keySet()){
            List<String> assignList = zipAssignMap.get(zip);
            Integer index = 0;
            if (assignList.size() > 0){
                for (Lead l : zipLeadMap.get(zip)){
                    l.OwnerId = assignList[Math.mod(index, assignList.size())]; //repeat list index dynaimcally by size
                    index++;
                }
            }
        }
    }
}