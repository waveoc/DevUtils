/**
* @description Number validator.
*
* @author Maksim Fesenko
*/
public class NumericValidator {
	private static final NumericValidator SINGLETON = new NumericValidator();
	private Decimal value;
	
	public static String errorMessage;
	
	/**
	* @description Empty constructor
	*/
	private NumericValidator() {
	}
	
	/**
	* @description Get instance of this class.
	*
	* @return NumericValidator is instance of this class.
	*/
	public static NumericValidator getInstance() {
		return SINGLETON;
	}
	
	/**
	* @description Validate string value and convert to number variable.
	*
	* @param p_value is string value.
	* @return NumberValidator is instance of this class.
	*/
	public NumericValidator validate(String p_value) {
		if (p_value.isNumeric()) {
			value = Decimal.valueOf(p_value);
		} else {
			String v_tempValue = '';
			Map<String, Boolean> characterMap = new Map<String, Boolean> {
				'.' => false
			};
			
			for (Integer i = 0; i < p_value.length(); i++) {
				String v_tempChar = p_value.substring(i, i + 1);
				if (v_tempChar.isNumeric()) {
					v_tempValue += v_tempChar;
				} else if (characterMap.get(v_tempChar) != null && ! characterMap.get(v_tempChar)) {
					v_tempValue += v_tempChar;
					
					characterMap.put(v_tempChar, true);
				}
			}
			
			try {
				value = Decimal.valueOf(v_tempValue);
			} catch(Exception ex) {
				errorMessage = ex.getMessage();
			}
		}
		
		return this;
	}
	
	/**
	* @description Validate method with formatstyle.
	*
	* @param p_value is string variable.
	* @param p_format is format variable.
	* @return NumericValidator is instance of this class.
	*/
	public NumericValidator validate(String p_value, String p_format) {
		this.validate(p_value);
		
		Integer v_indexScale = p_format.indexOf('.');
		if (v_indexScale != -1) {
			//p_format.length() - v_indexScale - 1;
			//Add or remove some zero
			
		}
		
		return this;
	}
	
	/**
	* @description Convert numeric value to Integer.
	*
	* @return Integer is value after converting.
	*/
	public Integer toInteger() {
		return Integer.valueOf(value);
	}
	
	/**
	* @description Convert numeric value to Double.
	*
	* @return Double is value after converting.
	*/
	public Double toDouble() {
		return Double.valueOf(value);
	}
	
	/**
	* @description Convert numeric value to Decimal.
	*
	* @return Decimal is value after converting.
	*/
	public Decimal toDecimal() {
		return value;
	}
}