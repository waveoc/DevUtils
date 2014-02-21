/**
* @description URL validator
*/
@isTest
private class URLValidatorTest {
	@isTest
	private static void testValidate() {
		Test.startTest();
		
		long v_long = 100;
		URLValidator v_validator1 = new URLValidator(v_long);
		
		URLValidator v_validator = URLValidator.getInstance();
		
		System.assert( ! v_validator.isValid(null));
		
		System.assert( ! v_validator.isValid('фв'));
		
		System.assert( ! v_validator.isValid('h'));
		
		Test.stopTest();
	}
	
	@isTest
	private static void testValidScheme() {
		Test.startTest();
		
		URLValidator v_validator = new URLValidator(new List<String> {'https', 'http'});
		
		System.assert( ! v_validator.isValidScheme(null));
		
		System.assert( ! v_validator.isValidScheme('ф'));
		
		System.assert( ! v_validator.isValidScheme('h'));
		
		System.assert( ! v_validator.isValidScheme('ftp'));
		
		Test.stopTest();
	}
	
	@isTest
	private static void testValidAuthority() {
		Test.startTest();
		
		URLValidator v_validator = new URLValidator(new List<String>());
		
		System.assert( ! v_validator.isValidAuthority(null));
		
		System.assert( ! v_validator.isValidAuthority('фв'));
		
		System.assert( ! v_validator.isValidAuthority('h'));
		
		Test.stopTest();
	}
	
	@isTest
	private static void testValidPath() {
		Test.startTest();
		
		URLValidator v_validator = new URLValidator(new List<String>());
		
		System.assert( ! v_validator.isValidPath(null));
		
		System.assert( ! v_validator.isValidPath('фв'));
		
		System.assert( ! v_validator.isValidPath('h'));
		
		Test.stopTest();
	}
	
	@isTest
	private static void testValidQuery() {
		Test.startTest();
		
		URLValidator v_validator = new URLValidator(new List<String>());
		
		System.assert(v_validator.isValidQuery(null));
		
		System.assert(v_validator.isValidQuery('h'));
		
		Test.stopTest();
	}
	
	@isTest
	private static void testValidFragment() {
		Test.startTest();
		
		URLValidator v_validator = new URLValidator(new List<String>());
		
		System.assert(v_validator.isValidFragment(null));
		
		System.assert(v_validator.isValidFragment('h'));
		
		Test.stopTest();
	}
}