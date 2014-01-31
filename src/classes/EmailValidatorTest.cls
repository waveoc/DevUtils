/**
*	@description Test class for Emailvalidator.
*
*	@author Maksim Fesenko
*/
@isTest
private class EmailValidatorTest {
	@isTest
	private static void testEmailWithNumericAddress() {
		Test.startTest();
		
		EmailValidator v_emailValidator = EmailValidator.getInstance();
		
		System.assert(v_emailValidator.isValid('someone@[216.109.118.76]'));
		
		System.assert(v_emailValidator.isValid('someone@yahoo.com'));
		
		Test.stopTest();
	}
	
	@isTest
	private static void testEmailExtension() {
		Test.startTest();
		
		EmailValidator v_emailValidator = EmailValidator.getInstance();
		
		System.assert(v_emailValidator.isValid('jsmith@apache.org'));
		System.assert(v_emailValidator.isValid('jsmith@apache.com'));
		System.assert(v_emailValidator.isValid('jsmith@apache.net'));
		System.assert(v_emailValidator.isValid('jsmith@apache.info'));
		System.assert( ! v_emailValidator.isValid('jsmith@apache.'));
		System.assert( ! v_emailValidator.isValid('jsmith@apache.c'));
		System.assert(v_emailValidator.isValid('someone@yahoo.museum'));
		System.assert( ! v_emailValidator.isValid('someone@yahoo.mu-seum'));
		
		Test.stopTest();
	}
	
	@isTest
	private static void testEmailWithDash() {
		Test.startTest();
		
		EmailValidator v_emailValidator = EmailValidator.getInstance();
		
		System.assert(v_emailValidator.isValid('andy.noble@data-workshop.com'));
		System.assert( ! v_emailValidator.isValid('andy-noble@data-workshop.-com'));
		System.assert( ! v_emailValidator.isValid('andy-noble@data-workshop.c-om'));
		System.assert( ! v_emailValidator.isValid('andy-noble@data-workshop.co-m'));
		
		Test.stopTest();
	}
	
	@isTest
	private static void testEmailWithDotEnd() {
		Test.startTest();
		
		EmailValidator v_emailValidator = EmailValidator.getInstance();
		
		System.assert( ! v_emailValidator.isValid('andy.noble@data-workshop.com.'));
		
		Test.stopTest();
	}
	
	@isTest
	private static void testEmailWithBogusCharacter() {
		Test.startTest();
		
		EmailValidator v_emailValidator = EmailValidator.getInstance();
		
		System.assert( ! v_emailValidator.isValid('andy.noble@\\u008fdata-workshop.com'));
		
		// The ' character is valid in an email username.
		System.assert(v_emailValidator.isValid('andy.o\'reilly@data-workshop.com'));
		
		// But not in the domain name.
		System.assert( ! v_emailValidator.isValid('andy@o\'reilly.data-workshop.com'));
		
		// The + character is valid in an email username.
		System.assert(v_emailValidator.isValid('foo+bar@i.am.not.in.us.example.com'));
		
		// But not in the domain name
		System.assert( ! v_emailValidator.isValid('foo+bar@example+3.com'));
		
		// Domains with only special characters aren't allowed (VALIDATOR-286) 
		System.assert( ! v_emailValidator.isValid('test@%*.com'));
		System.assert( ! v_emailValidator.isValid('test@^&#.com'));
		
		Test.stopTest();
	}
	
	@isTest
	private static void testEmailWithCommas() {
		Test.startTest();
		
		EmailValidator v_emailValidator = EmailValidator.getInstance();
		
		System.assert( ! v_emailValidator.isValid('joeblow@apa,che.org'));
		System.assert( ! v_emailValidator.isValid('joeblow@apache.o,rg'));
		System.assert( ! v_emailValidator.isValid('joeblow@apache,org'));
		
		Test.stopTest();
	}
	
	@isTest
	private static void testEmailWithSpaces() {
		Test.startTest();
		
		EmailValidator v_emailValidator = EmailValidator.getInstance();
		
		System.assert( ! v_emailValidator.isValid('joeblow @apache.org')); // TODO - this should be valid?
		System.assert( ! v_emailValidator.isValid('joeblow@ apache.org'));
		System.assert(v_emailValidator.isValid(' joeblow@apache.org')); // TODO - this should be valid?
		System.assert(v_emailValidator.isValid('joeblow@apache.org '));
		System.assert( ! v_emailValidator.isValid('joe blow@apache.org '));
		System.assert( ! v_emailValidator.isValid('joeblow@apa che.org '));
		
		Test.stopTest();
	}
	
	@isTest
	private static void testEmailWithSlashes() {
		Test.startTest();
		
		EmailValidator v_emailValidator = EmailValidator.getInstance();
		
		System.assert(v_emailValidator.isValid('joe!/blow@apache.org'), '/ and ! valid in username');
		System.assert( ! v_emailValidator.isValid('joe@ap/ache.org'), '/ not valid in domain');
		System.assert( ! v_emailValidator.isValid('joe@apac!he.org'), '! not valid in domain');
		
		Test.stopTest();
	}
	
	@isTest
	private static void testEmailUserName() {
		Test.startTest();
		
		EmailValidator v_emailValidator = EmailValidator.getInstance();
		
		System.assert(v_emailValidator.isValid('joe1blow@apache.org'));
		System.assert(v_emailValidator.isValid('joe$blow@apache.org'));
		System.assert(v_emailValidator.isValid('joe-@apache.org'));
		System.assert(v_emailValidator.isValid('joe_@apache.org'));
		System.assert(v_emailValidator.isValid('joe+@apache.org')); // + is valid unquoted
		System.assert(v_emailValidator.isValid('joe!@apache.org')); // ! is valid unquoted
		System.assert(v_emailValidator.isValid('joe*@apache.org')); // * is valid unquoted
		System.assert(v_emailValidator.isValid('joe\'@apache.org')); // ' is valid unquoted
		System.assert(v_emailValidator.isValid('joe%45@apache.org')); // % is valid unquoted
		System.assert(v_emailValidator.isValid('joe?@apache.org')); // ? is valid unquoted
		System.assert(v_emailValidator.isValid('joe&@apache.org')); // & ditto
		System.assert(v_emailValidator.isValid('joe=@apache.org')); // = ditto
		System.assert(v_emailValidator.isValid('+joe@apache.org')); // + is valid unquoted
		System.assert(v_emailValidator.isValid('!joe@apache.org')); // ! is valid unquoted
		System.assert(v_emailValidator.isValid('*joe@apache.org')); // * is valid unquoted
		System.assert(v_emailValidator.isValid('\'joe@apache.org')); // ' is valid unquoted
		System.assert(v_emailValidator.isValid('%joe45@apache.org')); // % is valid unquoted
		System.assert(v_emailValidator.isValid('?joe@apache.org')); // ? is valid unquoted
		System.assert(v_emailValidator.isValid('&joe@apache.org')); // & ditto
		System.assert(v_emailValidator.isValid('=joe@apache.org')); // = ditto
		System.assert(v_emailValidator.isValid('+@apache.org')); // + is valid unquoted
		System.assert(v_emailValidator.isValid('!@apache.org')); // ! is valid unquoted
		System.assert(v_emailValidator.isValid('*@apache.org')); // * is valid unquoted
		System.assert(v_emailValidator.isValid('\'@apache.org')); // ' is valid unquoted
		System.assert(v_emailValidator.isValid('%@apache.org')); // % is valid unquoted
		System.assert(v_emailValidator.isValid('?@apache.org')); // ? is valid unquoted
		System.assert(v_emailValidator.isValid('&@apache.org')); // & ditto
		System.assert(v_emailValidator.isValid('=@apache.org')); // = ditto
		
		//UnQuoted Special characters are invalid
		System.assert( ! v_emailValidator.isValid('joe.@apache.org')); // . not allowed at end of local part
		System.assert( ! v_emailValidator.isValid('.joe@apache.org')); // . not allowed at start of local part
		System.assert( ! v_emailValidator.isValid('.@apache.org')); // . not allowed alone
		System.assert(v_emailValidator.isValid('joe.ok@apache.org')); // . allowed embedded
		System.assert( ! v_emailValidator.isValid('joe..ok@apache.org')); // .. not allowed embedded
		System.assert( ! v_emailValidator.isValid('..@apache.org')); // .. not allowed alone
		System.assert( ! v_emailValidator.isValid('joe(@apache.org'));
		System.assert( ! v_emailValidator.isValid('joe)@apache.org'));
		System.assert( ! v_emailValidator.isValid('joe,@apache.org'));
		System.assert( ! v_emailValidator.isValid('joe;@apache.org'));
		
		Test.stopTest();
	}
}