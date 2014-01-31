public class InetAddressValidator {
	private static final String IPV4_REGEX = '^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$';

	/**
	*	@description Singleton instance of this class.
	*/
	private static final InetAddressValidator VALIDATOR = new InetAddressValidator();

	/** IPv4 RegexValidator*/
	private final RegexValidator ipv4Validator = new RegexValidator(IPV4_REGEX);

	/**
	*	@description Returns the singleton instance of this validator.
	*
	*	@return the singleton instance of this validator
	*/
	public static InetAddressValidator getInstance() {
		return VALIDATOR;
	}

	/**
	*	@description Checks if the specified string is a valid IP address.
	*
	*	@param inetAddress the string to validate
	*	@return true if the string validates as an IP address
	*/
	public boolean isValid(String p_inetAddress) {
		return isValidInet4Address(p_inetAddress);
	}
	
	/**
	*	@description Validates an IPv4 address. Returns true if valid.
	*
	*	@param inet4Address the IPv4 address to validate
	*	@return true if the argument contains a valid IPv4 address
	*/
	public boolean isValidInet4Address(String p_inet4Address) {
		// verify that address conforms to generic IPv4 format
		List<String> v_groups = ipv4Validator.match(p_inet4Address);
		
		if (v_groups == null) {
			return false;
		}
		
		// verify that address subgroups are legal
		for (Integer i = 0; i <= 3; i++) {
			String v_ipSegment = v_groups.get(i);
			if (v_ipSegment == null || v_ipSegment.length() <= 0) {
				return false;
			}

			Integer v_iIpSegment = 0;
			
			try {
				v_iIpSegment = Integer.valueOf(v_ipSegment);
			} catch(Exception e) {
				return false;
			}
			
			if (v_iIpSegment > 255) {
				return false;
			}
		}
		
		return true;
	}
}