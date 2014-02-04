/**
* @description URL validator.
*
* @author Maksim Fesenko
*/
public with sharing class URLValidator {
	/**
	* @description Allows all validly formatted schemes to pass validation instead of 
	* supplying a set of valid schemes.
	*/
	public static final long ALLOW_ALL_SCHEMES = 1 << 0;

	/**
	* @description Allow two slashes in the path component of the URL.
	*/
	public static final long ALLOW_2_SLASHES = 1 << 1;

	/**
	* @description Enabling this options disallows any URL fragments.
	*/
	public static final long NO_FRAGMENTS = 1 << 2;

	/**
	* @description Allow local URLs, such as http://localhost/ or http://machine/ .
	* 		This enables a broad-brush check, for complex local machine name 
	* 		validation requirements you should create your validator with 
	* 		a {@link RegexValidator} instead ({@link #UrlValidator(RegexValidator, long)})
	*/
	public static final long ALLOW_LOCAL_URLS = 1 << 3;

	/**
	* @description Drop numeric, and  '+-.' for now
	*/
	private static final String AUTHORITY_CHARS_REGEX = '\\p{Alnum}\\-\\.';

	/**
	* @description This expression derived/taken from the BNF for URI (RFC2396).
	*/
	private static final String URL_REGEX = '^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?';
	
	private static final Pattern URL_PATTERN = Pattern.compile(URL_REGEX);

	/**
	* @description Schema/Protocol (ie. http:, ftp:, file:, etc).
	*/
	private static final Integer PARSE_URL_SCHEME = 2;

	/**
	* @description Includes hostname/ip and port number.
	*/
	private static final Integer PARSE_URL_AUTHORITY = 4;

	private static final Integer PARSE_URL_PATH = 5;

	private static final Integer PARSE_URL_QUERY = 7;

	private static final Integer PARSE_URL_FRAGMENT = 9;

	/**
	* @description Protocol (ie. http:, ftp:,https:).
	*/
	private static final String SCHEME_REGEX = '^\\p{Alpha}[\\p{Alnum}\\+\\-\\.]*';
	private static final Pattern SCHEME_PATTERN = Pattern.compile(SCHEME_REGEX);

	private static final String AUTHORITY_REGEX = '^([' + AUTHORITY_CHARS_REGEX + ']*)(:\\d*)?(.*)?';
	
	private static final Pattern AUTHORITY_PATTERN = Pattern.compile(AUTHORITY_REGEX);

	private static final Integer PARSE_AUTHORITY_HOST_IP = 1;

	private static final Integer PARSE_AUTHORITY_PORT = 2;

	/**
	* @description Should always be empty.
	*/
	private static final Integer PARSE_AUTHORITY_EXTRA = 3;

	private static final String PATH_REGEX = '^(/[-\\w:@&?=+,.!/~*"%$_;\\(\\)]*)?$';
	private static final Pattern PATH_PATTERN = Pattern.compile(PATH_REGEX);

	private static final String QUERY_REGEX = '^(.*)$';
	private static final Pattern QUERY_PATTERN = Pattern.compile(QUERY_REGEX);

	private static final String LEGAL_ASCII_REGEX = '^\\p{ASCII}+$';
	private static final Pattern ASCII_PATTERN = Pattern.compile(LEGAL_ASCII_REGEX);

	private static final String PORT_REGEX = '^:(\\d{1,5})$';
	private static final Pattern PORT_PATTERN = Pattern.compile(PORT_REGEX);

	/**
	* @description Holds the set of current validation options.
	*/
	private final long options;

	/**
	* @description The set of schemes that are allowed to be in a URL.
	*/
	private final Set<String> allowedSchemes;

	/**
	* @description Regular expressions used to manually validate authorities if IANA 
	* 		domain name validation isn't desired.
	*/
	private final RegexValidator authorityValidator;

	/**
	* @description If no schemes are provided, default to this set.
	*/
	private static final List<String> DEFAULT_SCHEMES = new List<String> {'http', 'https', 'ftp'};

	/**
	* @description Singleton instance of this class with default schemes and options.
	*/
	private static final UrlValidator DEFAULT_URL_VALIDATOR = new UrlValidator();

	/**
	* @description Returns the singleton instance of this class with default schemes and options.
	* @return singleton instance with default schemes and options
	*/
	public static UrlValidator getInstance() {
		return DEFAULT_URL_VALIDATOR;
	}

	/**
	* @description Create a UrlValidator with default properties.
	*/
	public UrlValidator() {
		this(new List<String>());
	}

	/**
	* @description Behavior of validation is modified by passing in several strings options:
	* @param schemes Pass in one or more url schemes to consider valid, passing in
	* 	a null will default to 'http,https,ftp' being valid.
	* 	If a non-null schemes is specified then all valid schemes must
	* 	be specified. Setting the ALLOW_ALL_SCHEMES option will
	* 	ignore the contents of schemes.
	*/
	public UrlValidator(List<String> schemes) {
		this(schemes, 0L);
	}

	/**
	* @description Initialize a UrlValidator with the given validation options.
	* @param options The options should be set using the public constants declared in
	* 		this class.  To set multiple options you simply add them together.  For example,
	* 		ALLOW_2_SLASHES + NO_FRAGMENTS enables both of those options.
	*/
	public UrlValidator(long p_options) {
		this(null, null, p_options);
	}

	/**
	* @description Behavior of validation is modified by passing in options:
	* @param schemes The set of valid schemes.
	* @param options The options should be set using the public constants declared in
	* 		this class.  To set multiple options you simply add them together.  For example,
	* 		ALLOW_2_SLASHES + NO_FRAGMENTS enables both of those options.
	*/
	public UrlValidator(List<String> p_schemes, long p_options) {
		this(p_schemes, null, p_options);
	}

	/**
	* @description Initialize a UrlValidator with the given validation options.
	* @param authorityValidator Regular expression validator used to validate the authority part
	* @param options Validation options. Set using the public constants of this class.
	* 		To set multiple options, simply add them together:
	* 		<p><code>ALLOW_2_SLASHES + NO_FRAGMENTS</code></p>
	* 		enables both of those options.
	*/
	public UrlValidator(RegexValidator p_authorityValidator, long p_options) {
		this(null, p_authorityValidator, p_options);
	}

	/**
	* @description Customizable constructor. Validation behavior is modifed by passing in options.
	* @param schemes the set of valid schemes
	* @param authorityValidator Regular expression validator used to validate the authority part
	* @param options Validation options. Set using the public constants of this class.
	* 		To set multiple options, simply add them together:
	* 		<p><code>ALLOW_2_SLASHES + NO_FRAGMENTS</code></p>
	* 		enables both of those options.
	*/
	public UrlValidator(List<String> p_schemes, RegexValidator p_authorityValidator, long p_options) {
		this.options = p_options;
		
		if (isOn(ALLOW_ALL_SCHEMES)) {
			this.allowedSchemes.clear();
		} else {
			if (p_schemes == null) {
				p_schemes = DEFAULT_SCHEMES;
			}
			this.allowedSchemes = new Set<String>();
			this.allowedSchemes.addAll(p_schemes);
		}
		
		this.authorityValidator = p_authorityValidator;
	}
	
	/**
	* @description Checks if a field has a valid url address.
	*
	* @param value The value validation is being performed on.  A <code>null</code>
	* 		value is considered invalid.
	* @return true if the url is valid.
	*/
	public boolean isValid(String p_value) {
		if (p_value == null) {
			return false;
		}
		
		if ( ! ASCII_PATTERN.matcher(p_value).matches()) {
			return false;
		}
		
		// Check the whole url address structure
		Matcher v_urlMatcher = URL_PATTERN.matcher(p_value);
		if ( ! v_urlMatcher.matches()) {
			return false;
		}
		
		String v_scheme = v_urlMatcher.group(PARSE_URL_SCHEME);
		if ( ! isValidScheme(v_scheme)) {
			return false;
		}
		
		String v_authority = v_urlMatcher.group(PARSE_URL_AUTHORITY);
		if ('file'.equals(v_scheme) && ''.equals(v_authority)) {
			// Special case - file: allows an empty authority
		} else {
			// Validate the authority
			if ( ! isValidAuthority(v_authority)) {
				return false;
			}
		}
		
		if ( ! isValidPath(v_urlMatcher.group(PARSE_URL_PATH))) {
			return false;
		}
		
		if ( ! isValidQuery(v_urlMatcher.group(PARSE_URL_QUERY))) {
			return false;
		}
		
		if ( ! isValidFragment(v_urlMatcher.group(PARSE_URL_FRAGMENT))) {
			return false;
		}
		
		return true;
	}
	
	/**
	* @descriptin Validate scheme. If schemes[] was initialized to a non null, 
	* 		then only those scheme's are allowed.  Note this is slightly different than for the constructor.
	* @param scheme The scheme to validate.  A <code>null</code> value is considered invalid.
	* @return true if valid.
	*/
	public boolean isValidScheme(String p_scheme) {
		if (p_scheme == null) {
			return false;
		}
		
		if ( ! SCHEME_PATTERN.matcher(p_scheme).matches()) {
			return false;
		}
		
		if (isOff(ALLOW_ALL_SCHEMES)) {
			if ( ! this.allowedSchemes.contains(p_scheme)) {
				return false;
			}
		}
		
		return true;
	}
	
	/**
	* @description Returns true if the authority is properly formatted.  An authority is the combination
	* 		of hostname and port.  A <code>null</code> authority value is considered invalid.
	* @param authority Authority value to validate.
	* @return true if authority (hostname and port) is valid.
	*/
	public boolean isValidAuthority(String p_authority) {
		if (p_authority == null) {
			return false;
		}
		
		// check manual authority validation if specified
		if (authorityValidator != null) {
			if (authorityValidator.isValid(p_authority)) {
				return true;
			}
		}
		
		Matcher v_authorityMatcher = AUTHORITY_PATTERN.matcher(p_authority);
		if ( ! v_authorityMatcher.matches()) {
			return false;
		}
		
		String v_hostLocation = v_authorityMatcher.group(PARSE_AUTHORITY_HOST_IP);
		// check if authority is hostname or IP address:
		// try a hostname first since that's much more likely
		DomainValidator v_domainValidator = DomainValidator.getInstance(isOn(ALLOW_LOCAL_URLS));
		if ( ! v_domainValidator.isValid(v_hostLocation)) {
			// try an IP address
			InetAddressValidator v_inetAddressValidator = InetAddressValidator.getInstance();
			if ( ! v_inetAddressValidator.isValid(v_hostLocation)) {
				// isn't either one, so the URL is invalid
				return false;
			}
		}
		
		String v_port = v_authorityMatcher.group(PARSE_AUTHORITY_PORT);
		if (v_port != null) {
			if ( ! PORT_PATTERN.matcher(v_port).matches()) {
				return false;
			}
		}
		
		String v_extra = v_authorityMatcher.group(PARSE_AUTHORITY_EXTRA);
		if (v_extra != null && v_extra.trim().length() > 0){
			return false;
		}
		
		return true;
	}
	
	/**
	* @description Returns true if the path is valid.  A <code>null</code> value is considered invalid.
	*
	* @param path Path value to validate.
	* @return true if path is valid.
	*/
	public boolean isValidPath(String p_path) {
		if (p_path == null) {
			return false;
		}
		
		if ( ! PATH_PATTERN.matcher(p_path).matches()) {
			return false;
		}
		
		Integer v_slash2Count = countToken('//', p_path);
		if (isOff(ALLOW_2_SLASHES) && (v_slash2Count > 0)) {
			return false;
		}
		
		Integer v_slashCount = countToken('/', p_path);
		Integer v_dot2Count = countToken('..', p_path);
		if (v_dot2Count > 0) {
			if ((v_slashCount - v_slash2Count - 1) <= v_dot2Count) {
				return false;
			}
		}
		
		return true;
	}
	
	/**
	* @description Returns true if the query is null or it's a properly formatted query string.
	*
	* @param query Query value to validate.
	* @return true if query is valid.
	*/
	public boolean isValidQuery(String p_query) {
		if (p_query == null) {
			return true;
		}
		
		return QUERY_PATTERN.matcher(p_query).matches();
	}
	
	/**
	* @description Returns true if the given fragment is null or fragments are allowed.
	*
	* @param fragment Fragment value to validate.
	* @return true if fragment is valid.
	*/
	public boolean isValidFragment(String p_fragment) {
		if (p_fragment == null) {
			return true;
		}
		
		return isOff(NO_FRAGMENTS);
	}
	
	/**
	* @description Returns the number of times the token appears in the target.
	*
	* @param token Token value to be counted.
	* @param target Target value to count tokens in.
	* @return the number of tokens.
	*/
	public Integer countToken(String p_token, String p_target) {
		Integer v_tokenIndex = 0;
		Integer v_count = 0;
		while (v_tokenIndex != -1) {
			v_tokenIndex = p_target.indexOf(p_token, v_tokenIndex);
			if (v_tokenIndex > -1) {
				v_tokenIndex++;
				v_count++;
			}
		}
		
		return v_count;
	}
	
	/**
	* @description Tests whether the given flag is on.  If the flag is not a power of 2
	* 		(ie. 3) this tests whether the combination of flags is on.
	*
	* @param flag Flag value to check.
	* @return whether the specified flag value is on.
	*/
	private boolean isOn(long p_flag) {
		return (this.options & p_flag) > 0;
	}
	
	/**
	* @description Tests whether the given flag is off.  If the flag is not a power of 2
	* 		(ie. 3) this tests whether the combination of flags is off.
	*
	* @param flag Flag value to check.
	* @return whether the specified flag value is off.
	*/
	private boolean isOff(long p_flag) {
		return (this.options & p_flag) == 0;
	}
}