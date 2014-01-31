/**
*	@description Test Domain Validator.
*
*	@author Maksim Fesenko
*/
@isTest
public class DomainValidatorTest {
	@isTest
	private static void test() {
		Test.startTest();
		
		DomainValidator v_domain = DomainValidator.getInstance();
		
		System.assert(v_domain.isValid('www.google.com'), '-----');
		
		System.assert( ! v_domain.isValid('www.go  ogle.com'), '-----');
		
		Test.stopTest();
	}
}