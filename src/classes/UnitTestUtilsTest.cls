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
		
		Account v_account = (Account)(new UnitTestUtils().createRecord('Account')
				.addField('Name', 'TestAccount').getSObjectRecord());
		insert v_account;
		
		System.assertNotEquals(null, v_account.Id, 'Account should was inserted.');
		
		Account v_accountParams = (Account)(new UnitTestUtils().createRecord('Account')
				.addFields(new Map<String, Object> {'Name' => 'TestAccount'}).getSObjectRecord());
		insert v_accountParams;
		
		System.assertEquals('TestAccount', v_accountParams.Name, 'Account should was inserted.');
		
		List<Account> v_accountList = (List<Account>)new UnitTestUtils().createRecords('Account', 3);
		for (Account v_acc : v_accountList) {
			v_acc.Name = 'test account';
		}
		insert v_accountList;
		
		System.assertEquals(3, v_accountList.size());
		
		Test.stopTest();
	}
}