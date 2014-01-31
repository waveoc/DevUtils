public class EmailValidator {
	private static final String SPECIAL_CHARS = '\\p{Cntrl}\\(\\)<>@,;:\'\\\\\\\"\\.\\[\\]';
	private static final String VALID_CHARS = '[^\\s' + SPECIAL_CHARS + ']';
	private static final String QUOTED_USER = '(\'[^\']*\')';
	private static final String WORD = '((' + VALID_CHARS + '|\')+|' + QUOTED_USER + ')';

	private static final String LEGAL_ASCII_REGEX = '^\\p{ASCII}+$';
	private static final String EMAIL_REGEX = '^\\s*?(.+)@(.+?)\\s*$';
	private static final String IP_DOMAIN_REGEX = '^\\[(.*)\\]$';
	private static final String USER_REGEX = '^\\s*' + WORD + '(\\.' + WORD + ')*$';

	private static final Pattern MATCH_ASCII_PATTERN = Pattern.compile(LEGAL_ASCII_REGEX);
	private static final Pattern EMAIL_PATTERN = Pattern.compile(EMAIL_REGEX);
	private static final Pattern IP_DOMAIN_PATTERN = Pattern.compile(IP_DOMAIN_REGEX);
	private static final Pattern USER_PATTERN = Pattern.compile(USER_REGEX);
	
	private final Boolean allowLocal;

	/**
	*	@description Singleton instance of this class, which doesn't consider local addresses as valid.
	*/
	private static final EmailValidator EMAIL_VALIDATOR = new EmailValidator(false);
	
	/**
	*	@description Singleton instance of this class, which does consider local addresses valid.
	*/
	private static final EmailValidator EMAIL_VALIDATOR_WITH_LOCAL = new EmailValidator(true);
	
	/**
	*	@description Returns the Singleton instance of this validator.
	*
	*	@return singleton instance of this validator.
	*/
	public static EmailValidator getInstance() {
		return EMAIL_VALIDATOR;
	}
	
	/**
	*	@description Returns the Singleton instance of this validator, with local validation as required.
	*
	*	@param allowLocal Should local addresses be considered valid?
	*	@return singleton instance of this validator
	*/
	public static EmailValidator getInstance(Boolean p_allowLocal) {
		if (p_allowLocal) {
			return EMAIL_VALIDATOR_WITH_LOCAL;
		}
		
		return EMAIL_VALIDATOR;
	}
	
	/**
	*	@description Protected constructor for subclasses to use.
	*
	*	@param allowLocal Should local addresses be considered valid?
	*/
	private EmailValidator(Boolean p_allowLocal) {
		this.allowLocal = p_allowLocal;
	}
	
	/**
	*	@description Checks if a field has a valid e-mail address.
	*
	*	@param email The value validation is being performed on. 
	*		A <code>null</code> value is considered invalid.
	*	@return true if the email address is valid.
	*/
	public Boolean isValid(String p_email) {
		if (p_email == null) {
			return false;
		}
		
		Matcher v_asciiMatcher = MATCH_ASCII_PATTERN.matcher(p_email);
		if ( ! v_asciiMatcher.matches()) {
			return false;
		}
		
		// Check the whole email address structure
		Matcher v_emailMatcher = EMAIL_PATTERN.matcher(p_email);
		if ( ! v_emailMatcher.matches()) {
			return false;
		}
		
		if (p_email.endsWith('.')) {
			return false;
		}
		
		if ( ! isValidUser(v_emailMatcher.group(1))) {
			return false;
		}
		
		if ( ! isValidDomain(v_emailMatcher.group(2))) {
			return false;
		}
		
		return true;
	}
	
	/**
	*	@description Returns true if the domain component of an email address is valid.
	*
	*	@param domain being validated.
	*	@return true if the email address's domain is valid.
	*/
	private Boolean isValidDomain(String p_domain) {
		// see if domain is an IP address in brackets
		Matcher v_ipDomainMatcher = IP_DOMAIN_PATTERN.matcher(p_domain);
		
		if (v_ipDomainMatcher.matches()) {
			InetAddressValidator v_inetAddressValidator = InetAddressValidator.getInstance();
			return v_inetAddressValidator.isValid(v_ipDomainMatcher.group(1));
		} else {
			// Domain is symbolic name
			DomainValidator v_domainValidator = DomainValidator.getInstance(allowLocal);
			return v_domainValidator.isValid(p_domain);
		}
	}
	
	/**
	*	@description Returns true if the user component of an email address is valid.
	*
	*	@param user being validated
	*	@return true if the user name is valid.
	*/
	private Boolean isValidUser(String p_user) {
		return USER_PATTERN.matcher(p_user).matches();
	}
}