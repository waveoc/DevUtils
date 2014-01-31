/**
*	@description Test Domain Validator.
*
*	@author Maksim Fesenko
*/
@isTest
public class DomainValidatorTest {
	@isTest
	private static void testValidDomains() {
		Test.startTest();
		
		DomainValidator v_domain = DomainValidator.getInstance();
		
		System.assert(v_domain.isValid('apache.org'), 'apache.org should be valid.');
		
		System.assert(v_domain.isValid('www.google.com'), 'www.google.com should be valid.');
		
		System.assert(v_domain.isValid('test-domain.com'), 'test-domain.com should be valid.');
		
		System.assert(v_domain.isValid('test---domain.com'), 'test---domain.com should be valid.');
		
		System.assert(v_domain.isValid('test-d-o-m-ain.com'), 'test-d-o-m-ain.comm should be valid.');
		
		System.assert(v_domain.isValid('as.uk'), 'as.uk should be valid.');
		
		System.assert(v_domain.isValid('ApAchE.Org'), 'ApAchE.Org should be valid.');
		
		System.assert(v_domain.isValid('z.com'), 'z.com should be valid.');
		
		System.assert(v_domain.isValid('i.have.an-example.domain.name'), 'i.have.an-example.domain.name should be valid.');
		
		Test.stopTest();
	}
	
	@isTest
	private static void testInvalidDomains() {
		Test.startTest();
		
		DomainValidator v_domain = DomainValidator.getInstance();
		
		System.assert( ! v_domain.isValid('.org'), '.org should not be valid.');
		
		System.assert( ! v_domain.isValid(' apache.org '), ' apache.org should not be valid.');
		
		System.assert( ! v_domain.isValid('apa che.org'), 'apa che.org should not be valid.');
		
		System.assert( ! v_domain.isValid('-testdomain.name'), '-testdomain.name should not be valid.');
		
		System.assert( ! v_domain.isValid('testdomain-.name'), 'testdomain-.name should not be valid.');
		
		System.assert( ! v_domain.isValid('---c.com'), '---c.com should not be valid.');
		
		System.assert( ! v_domain.isValid('c--.com'), 'c--.com should not be valid.');
		
		System.assert( ! v_domain.isValid('apache.rog'), 'apache.rog should not be valid.');
		
		System.assert( ! v_domain.isValid('http://www.apache.org'), 'http://www.apache.org should not be valid.');
		
		Test.stopTest();
	}
	
	@isTest
	private static void testTopLevelDomains() {
		Test.startTest();
		
		DomainValidator v_domain = DomainValidator.getInstance();
		
		System.assert(v_domain.isValidInfrastructureTld('arpa'), '.arpa should validate as iTLD');
		
		System.assert( ! v_domain.isValidInfrastructureTld('com'), '.com shouldn\'t validate as iTLD');
		
		System.assert(v_domain.isValidGenericTld('name'), '.name should validate as gTLD');
		
		System.assert( ! v_domain.isValidGenericTld('us'), '.us shouldn\'t validate as gTLD');
		
		System.assert(v_domain.isValidCountryCodeTld('uk'), '.uk should validate as ccTLD');
		
		System.assert( ! v_domain.isValidCountryCodeTld('org'), '.org shouldn\'t validate as ccTLD');
		
		System.assert(v_domain.isValidTld('COM'), '.COM should validate as TLD');
		
		System.assert(v_domain.isValidTld('BiZ'), '.BiZ should validate as TLD');
		
		Test.stopTest();
	}
}