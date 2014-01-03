/**
*/
@isTest
private class UnitTestUtilsTest {
	private static testMethod void testC() {
		System.assert(false, '---' + new UnitTestUtils().getRecord('Test1__c'));
	}
}