/**
*	@description Test class for Numberic validator.
*
*	@author Maksim Fesenko
*/
@isTest
private class NumericValidatorTest {
	@isTest
	private static void test() {
		Test.startTest();
		
		NumericValidator v_numeric = NumericValidator.getInstance();
		
		Decimal d = 11.123456;
		d.setScale(2);
		System.assertEquals(d, v_numeric.validate('dssd11.123456', '##.##').toDecimal());
		
		Test.stopTest();
	}
}