public with sharing class RegexValidator {
	private final Pattern[] patterns;

	/**
	*	@description Construct a <i>case sensitive</i> validator for a single regular expression.
	*
	*	@param regex The regular expression this validator will validate against
	*/
	public RegexValidator(String p_regex) {
		this(p_regex, true);
	}

	/**
	*	@description Construct a validator for a single regular expression with the specified case sensitivity.
	*
	*	@param regex The regular expression this validator will validate against
	*	@param caseSensitive when <code>true</code> matching is <i>case sensitive</i>, 
	*		otherwise matching is <i>case in-sensitive</i>
	*/
	public RegexValidator(String p_regex, boolean p_caseSensitive) {
		this(new String[] {p_regex}, p_caseSensitive);
	}
	
	/**
	*	@description Construct a <i>case sensitive</i> validator that matches any one 
	*			of the set of regular expressions.
	*
	*	@param regexs The set of regular expressions this validator will validate against
	*/
	public RegexValidator(String[] p_regexs) {
		this(p_regexs, true);
	}
	
	/**
	*	@description Construct a validator that matches any one of the set of regular
	*			expressions with the specified case sensitivity.
	*
	*	@param regexs The set of regular expressions this validator will validate against
	*	@param caseSensitive when <code>true</code> matching is <i>case
	*			sensitive</i>, otherwise matching is <i>case in-sensitive</i>
	*/
	public RegexValidator(String[] p_regexs, boolean p_caseSensitive) {
		if (p_regexs == null || p_regexs.size() == 0) {
			throw new IllegalArgumentException('Regular expressions are missing');
		}
		
		this.patterns = new Pattern[p_regexs.size()];
		for (Integer i = 0; i < p_regexs.size(); i++) {
			if (p_regexs[i] == null || p_regexs.get(i).length() == 0) {
				throw new IllegalArgumentException('Regular expression[' + i + '] is missing');
			}
			this.patterns.set(i, Pattern.compile(p_regexs.get(i)));
		}
	}
	
	/**
	*	@description Validate a value against the set of regular expressions.
	*
	*	@param value The value to validate.
	*	@return <code>true</code> if the value is valid otherwise <code>false</code>.
	*/
	public boolean isValid(String p_value) {
		if (p_value == null) {
			return false;
		}
		
		for (Integer i = 0; i < this.patterns.size(); i++) {
			if (this.patterns.get(i).matcher(p_value).matches()) {
				return true;
			}
		}
		
		return false;
	}
	
	/**
	*	@description Validate a value against the set of regular expressions returning the array of matched groups.
	*
	*	@param value The value to validate.
	*	@return String array of the <i>groups</i> matched if valid or <code>null</code> if invalid
	*/
	public String[] match(String p_value) {
		if (p_value == null) {
			return null;
		}
		
		for (Integer i = 0; i < this.patterns.size(); i++) {
			Matcher v_matcher = patterns.get(i).matcher(p_value);
			if (v_matcher.matches()) {
				Integer v_count = v_matcher.groupCount();
				String[] v_groups = new String[v_count];
				for (Integer j = 0; j < v_count; j++) {
					v_groups.set(j, v_matcher.group(j+1));
				}
				
				return v_groups;
			}
		}
		
		return null;
	}
	
	/**
	* Validate a value against the set of regular expressions
	* returning a String value of the aggregated groups.
	*
	* @param value The value to validate.
	* @return Aggregated String value comprised of the
	* <i>groups</i> matched if valid or <code>null</code> if invalid
	*/
	public String validate(String value) {
		if (value == null) {
			return null;
		}
		for (Integer i = 0; i < patterns.size(); i++) {
			Matcher matcher = patterns[i].matcher(value);
			if (matcher.matches()) {
				Integer count = matcher.groupCount();
				if (count == 1) {
					return matcher.group(1);
				}
				String buffer = '';
				for (Integer j = 0; j < count; j++) {
					String component = matcher.group(j+1);
					if (component != null) {
						buffer += component;
					}
				}
				return buffer;
			}
		}
		return null;
	}

	/**
	* Provide a String representation of this validator.
	* @return A String representation of this validator
	*/
	public override String toString() {
		String buffer = 'RegexValidator{';
		for (Integer i = 0; i < patterns.size(); i++) {
			if (i > 0) {
				buffer += ',';
			}
			buffer += patterns[i].pattern();
		}
		buffer += '}';
		return buffer;
	}
}