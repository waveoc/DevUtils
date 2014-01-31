/**
*	@description Test class for Emailvalidator.
*
*	@author Maksim Fesenko
*/
@isTest
private class EmailValidatorTest {
	private static testMethod void test() {
		Test.startTest();
		
		EmailValidator v_emailValidator = EmailValidator.getInstance();
		
		System.assert(v_emailValidator.isValid('asds@asds.com'), '-----');
		
		System.assert( ! v_emailValidator.isValid('asdsasds.com'), '-----');
		
		System.assert( ! v_emailValidator.isValid('asds@asds!com'), '-----');
		
		Test.stopTest();
	}
}