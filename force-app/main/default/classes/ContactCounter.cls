/**
 * @description Account contact count controller
 */
public with sharing class ContactCounter {
  /**
   * @description Creates a list of Contact Count Objects from Contact List.
   */
  public static List<Contact_Count__c> getContactCounts(
    List<Contact> contacts
  ) {
    Map<String, List<Contact>> contactMap = new Map<String, List<Contact>>();

    // Construct contactMap contact lists for each uid.
    for (Contact c : contacts) {
      String uid =
        c.AccountId +
        '-' +
        c.Type__c +
        '-' +
        c.Department.trim().toUpperCase();

      if (!contactMap.containsKey(uid)) {
        contactMap.put(uid, new List<Contact>());
      }

      contactMap.get(uid).add(c);
    }

    Contact_Count__c[] contactCounts = new List<Contact_Count__c>();

    // Construct contact count list from each contact list in contactMap.
    for (String key : contactMap.keySet()) {
      Contact_Count__c cc = new Contact_Count__c();
      cc.Number_of_Contacts__c = contactMap.get(key).size();
      cc.Account__c = key.split('-')[0];
      cc.Type__c = key.split('-')[1];
      cc.State__c = key.split('-')[2];
      cc.Name = 'Contact Count ' + cc.Type__c + ' ' + cc.State__c;
      cc.UID__c = key;
      contactCounts.add(cc);
    }
    return contactCounts;
  }

  @InvocableMethod(
    label='Contact Count'
    category='Flow Actions'
    description='Counts account contacts and returns a list of Contact Counts'
  )
  public static List<FlowOutput> getContactCounts(List<FlowInput> flowInputs) {
    FlowOutput[] flowOutputs = new List<FlowOutput>();
    for (FlowInput f : flowInputs) {
      FlowOutput flowOutput = new FlowOutput();
      flowOutput.contactCounts = getContactCounts(f.contacts);
      flowOutputs.add(flowOutput);
    }
    return flowOutputs;
  }

  public class FlowInput {
    @InvocableVariable
    public List<Contact> contacts;
  }
  public class FlowOutput {
    @InvocableVariable
    public List<Contact_Count__c> contactCounts;
  }
}