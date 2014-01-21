/**
*	@description Test Utils methods for creating test records.
*
*	@author Maksim Fesenko
*/
@isTest
private class UnitTestUtilsTest {
	@isTest
	private static void testCreateRecords() {
		Test.startTest();
		
		Account v_account = new UnitTestUtils().createAccount().getRecord();
		
		Account v_accountInserted = new UnitTestUtils().createAccount().insertRecord();
		System.assertNotEquals(null, v_accountInserted.Id, 'Account should was inserted.');
		
		Account v_accountParams = new UnitTestUtils()
				.createAccount(new Map<String, Object> {'Name' => 'TestAccount'}).insertRecord();
		System.assertEquals('TestAccount', v_accountParams.Name, 'Account should was inserted.');
		
		Contact v_contact = new UnitTestUtils().createContact().getRecord();
		
		Contact v_contactInserted = new UnitTestUtils().createContact().insertRecord();
		System.assertNotEquals(null, v_contactInserted.Id, 'Contact should was inserted.');
		
		Contact v_contactParams = new UnitTestUtils()
				.createContact(new Map<String, Object> {'LastName' => 'TestLastName'}).insertRecord();
		System.assertEquals('TestLastName', v_contactParams.LastName, 'Contact should was inserted.');
		
		Opportunity v_opportunity = new UnitTestUtils().createOpportunity().getRecord();
		
		Opportunity v_opportunityInserted = new UnitTestUtils().createOpportunity().insertRecord();
		System.assertNotEquals(null, v_opportunityInserted.Id, 'Opportunity should was inserted.');
		
		Opportunity v_opportunityParams = new UnitTestUtils()
				.createOpportunity(new Map<String, Object> {'Name' => 'TestOpportunity'}).insertRecord();
		System.assertEquals('TestOpportunity', v_opportunityParams.Name, 'Opportunity should was inserted.');
		
		Lead v_lead = new UnitTestUtils().createLead().getRecord();
		
		Lead v_leadInserted = new UnitTestUtils().createLead().insertRecord();
		System.assertNotEquals(null, v_leadInserted.Id, 'Lead should was inserted.');
		
		Lead v_leadParams = new UnitTestUtils()
				.createLead(new Map<String, Object> {'LastName' => 'TestLead'}).insertRecord();
		System.assertEquals('TestLead', v_leadParams.LastName, 'Lead should was inserted.');
		
		Case v_Case = new UnitTestUtils().createCase().getRecord();
		
		Case v_CaseInserted = new UnitTestUtils().createCase().insertRecord();
		System.assertNotEquals(null, v_CaseInserted.Id, 'Case should was inserted.');
		
		Case v_CaseParams = new UnitTestUtils()
				.createCase(new Map<String, Object> {'Subject' => 'TestCase'}).insertRecord();
		System.assertEquals('TestCase', v_CaseParams.Subject, 'Case should was inserted.');
		
		Contract v_contract = new UnitTestUtils().createContract().getRecord();
		
		Contract v_contractInserted = new UnitTestUtils().createContract().insertRecord();
		System.assertNotEquals(null, v_contractInserted.Id, 'Contract should was inserted.');
		
		Contract v_contractParams = new UnitTestUtils()
				.createContract(new Map<String, Object> {'StartDate' => Date.today()}).insertRecord();
		System.assertEquals(Date.today(), v_contractParams.StartDate, 'Contract should was inserted.');
		
		Product2 v_product = new UnitTestUtils().createProduct2().getRecord();
		
		Product2 v_productInserted = new UnitTestUtils().createProduct2().insertRecord();
		System.assertNotEquals(null, v_productInserted.Id, 'Product2 should was inserted.');
		
		Product2 v_productParams = new UnitTestUtils()
				.createProduct2(new Map<String, Object> { 'Name' => 'TestProduct2'}).insertRecord();
		System.assertEquals('TestProduct2', v_productParams.Name, 'Product2 should was inserted.');
		
		Test.stopTest();
	}
}