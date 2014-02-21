/**
* @description 
*
* @author Maksim Fesenko
*/
@isTest
private class RegexValidatorTest {
	@isTest
	private static void testSingle() {
		Test.startTest();
		
		RegexValidator sensitive = new RegexValidator('^([abc]*)(?:\\-)([DEF]*)(?:\\-)([123]*)$');
		
		// isValid()
		System.assert(sensitive.isValid('ac-DE-1'), 'Sensitive isValid() valid');
		System.assert( ! sensitive.isValid('AB-de-1'), 'Sensitive isValid() invalid');
		
		// validate()
		System.assertEquals('acDE1', sensitive.validate('ac-DE-1'), 'Sensitive validate() valid');
		System.assertEquals(null, sensitive.validate('AB-de-1'), 'Sensitive validate() invalid');
		
		Test.stopTest();
	}
}