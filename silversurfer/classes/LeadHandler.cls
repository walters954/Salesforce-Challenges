public class LeadHandler {
    
    public static void handle(List<Lead> leadList){
        //sort leads by zip
        Map<String, List<Lead>> zipLeadMap = new Map<String, List<Lead>>();
        for (lead l : leadList){
            List<Lead> tmpLeadList = zipLeadMap.get(l.PostalCode);
            if (tmpLeadList == null){
                tmpLeadList = new List<Lead>();
            }
            tmpLeadList.add(l);
            zipLeadMap.put(l.PostalCode, tmpLeadList);
        }
        
        //sort assignee by zip
        Map<String, List<String>> zipAssignMap = new Map<String, List<String>>();
        for (ZipCode__c zip : [SELECT id, ZipCode__c, Assigned__c FROM ZipCode__c WHERE ZipCode__c in :zipLeadMap.keySet()]){
            List<String> tmpAssignList = zipAssignMap.get(zip.ZipCode__c);
            if (tmpAssignList == null){
                tmpAssignList = new List<String>();
            }  
            tmpAssignList.add(zip.Assigned__c);
            zipAssignMap.put(zip.ZipCode__c, tmpAssignList);
        }
        
        //assignment
        for (String zip : zipLeadMap.keySet()){
            List<String> assignList = zipAssignMap.get(zip);   
            Integer index = 0;
            if (assignList.size() > 0){
                for (Lead l : zipLeadMap.get(zip)){
                    l.OwnerId = assignList[Math.mod(index,assignList.size())];
                    index ++;
                } 
            }
            
        }
    }
    
}