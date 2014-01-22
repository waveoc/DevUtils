public class DateValidator {
	private static final DateValidator SINGLETON = new DateValidator();
	private static Set<String> localeValues;
	
	public static String errorMessage;
	
	private DateValidator() {
		errorMessage = '';
		
		localeValues = new Set<String>();
		for (Schema.Picklistentry v_entry : User.fields.LocaleSidKey.getDescribe().getpicklistvalues()) {
			if (v_entry.isActive()) {
				localeValues.add(v_entry.getValue());
			}
		}
	}
	
	public static DateValidator getInstance() {
		return SINGLETON;
	}
	
	//isValid
	public static Boolean isValidDate(String p_date) {
		try {
			Date v_date = Date.parse(p_date);
			
			return true;
		} catch(Exception ex) {
			errorMessage = ex.getMessage();
			
			return false;
		}
		
		return false;
	}
	
	public static Boolean isValidDate(String p_date, String p_locale) {
		//If P-locale is valid Locale
		if (DateValidator.localeValues.contains(p_locale)) {
			User v_user = [
					SELECT LocaleSidKey 
					FROM User 
					WHERE Id = :UserInfo.getUserId()
					LIMIT 1];
			
			v_user.LocaleSidKey = p_locale;
			update v_user;
			
			return DateValidator.isValidDate(p_date);
		}
		return false;
	}
	
	//validate
	public static Date validate(String p_date) {
		return Date.today();
	}
	
	public static Date validate(String p_date, String p_format) {
		return Date.today();
	}
	
	//format
	
	
}