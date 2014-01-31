public class NumericValidator {
	private static final NumericValidator SINGLETON = new NumericValidator();
	private Decimal value;
	
	public static String errorMessage;
	
	private NumericValidator() {
	}
	
	public static NumericValidator getInstance() {
		return SINGLETON;
	}
	
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
	
	public NumericValidator validate(String p_value, String p_format) {
		this.validate(p_value);
		
		Integer v_indexScale = p_format.indexOf('.');
		if (v_indexScale != -1) {
			//p_format.length() - v_indexScale - 1;
			//Add or remove some zero
			
		}
		
		return this;
	}
	
	public Integer toInteger() {
		return Integer.valueOf(value);
	}
	
	public Double toDouble() {
		return Double.valueOf(value);
	}
	
	public Decimal toDecimal() {
		return value;
	}
}