
@isTest
public class UpdateAllAmountOnAccountTest {

    @IsTest
    static void updateAccWithOneOppAmountTest(){
        //insert acc
        //insert opp with amount
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Test Opportunity ', 
                                        AccountId = acc.Id, 
                                        StageName = 'Prospecting', 
                                        CloseDate = Date.today(), 
                                        Amount = 0);
       
        Test.startTest();
        
        insert opp;
        Test.stopTest();
        Account accList = [SELECT Id, All_Amount__c FROM Account];
        System.assertEquals(0, accList.All_Amount__c);
        
    }

    //insert acc
    //insert opp without amount

    //insert acc
    //insert 5 opps at once
    @isTest
    static void updateAccWithFiveOppsAmountTest(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        List<Opportunity> oppList=new List<Opportunity>();
      for (Integer i=0;i<5;i++){

        Opportunity opp = new Opportunity(Name = 'Test Opportunity ' + i, 
                                        AccountId = acc.Id, 
                                        StageName = 'Prospecting', 
                                        CloseDate = Date.today(), 
                                        Amount = 200);
            oppList.add(opp);
      }
      Test.startTest();
      insert oppList;
      Test.stopTest();
      Account accc=[SELECT Id, All_Amount__c FROM Account];
      System.assertEquals(1000,accc.All_Amount__c);
    }

    //insert 5 acc;
    //insert 50 opps, 10 opps for each acc, try not adding amount value for few opps
    @isTest
    static void testSumData() {
       
       
        List<Account> accIn = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            Account testAcc = new Account(Name = 'Test Account ' + i);
            accIn.add(testAcc);
        }
        
       
        insert accIn;

        
        List<Opportunity> oppIn = new List<Opportunity>();
        for (Integer i = 0; i < accIn.size(); i++) {
            for (Integer j = 0; j < 10; j++) {
                if(j!=3&&j!=5){
                Opportunity opp = new Opportunity(Name = 'Test Opportunity ' + i, 
                                                  AccountId = accIn[i].Id, 
                                                  StageName = 'Prospecting', 
                                                  CloseDate = Date.today(), 
                                                  Amount = 1000);
                                oppIn.add(opp);
                }
                else{
                    Opportunity opp = new Opportunity(Name = 'Test Opportunity ' + i, 
                    AccountId = accIn[i].Id, 
                    StageName = 'Prospecting', 
                    CloseDate = Date.today(), 
                    Amount = 0);
                oppIn.add(opp);
                }
               
              
            }
        }

       Test.startTest();
        insert oppIn;
        Test.stopTest();

     

        List<Account> accList2 = [SELECT Id, All_Amount__c FROM Account];
        for (Account acc : accList2) {
            
            System.assertEquals(8000, acc.All_Amount__c);
        }
    }
    /**
     * if an account had 2 opps already, insert another opp will add values to existing sum.
     */
}