public class NumericValidator {
	private static final NumericValidator SINGLETON = new NumericValidator();
	private static Object value;
	
	private NumericValidator() {
		
	}
	
	public static NumericValidator getInstance() {
		return SINGLETON;
	}
	
	public static Boolean isValid(String p_value) {
		return false;
	}
	
	public static void validate(String p_value) {
		value = p_value;
	}
	
	public static Integer toInteger() {
		return Integer.valueOf(value);
	}
	
	public static Double toDouble() {
		return Double.valueOf(value);
	}
	
	public static Decimal toDecimal() {
		return Decimal.valueOf(String.valueOf(value));
	}
}