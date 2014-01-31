/**
*	@description 
*
*	@author Maksim Fesenko
*/
@isTest
private class InetAddressValidatorTest {
	@isTest
	private static void testInetAddressesFromTheWild() {
		Test.startTest();
		
		InetAddressValidator v_inetAddress = InetAddressValidator.getInstance();
		
		System.assert(v_inetAddress.isValid('140.211.11.130'), 'www.apache.org IP should be valid');
		System.assert(v_inetAddress.isValid('72.14.253.103'), 'www.l.google.com IP should be valid');
		System.assert(v_inetAddress.isValid('199.232.41.5'), 'fsf.org IP should be valid');
		System.assert(v_inetAddress.isValid('216.35.123.87'), 'appscs.ign.com IP should be valid');
		
		Test.stopTest();
	}
	
	@isTest
	private static void testInetAddressesByClass() {
		Test.startTest();
		
		InetAddressValidator v_inetAddress = InetAddressValidator.getInstance();
		
		System.assert(v_inetAddress.isValid('24.25.231.12'), 'class A IP should be valid');
		System.assert( ! v_inetAddress.isValid('2.41.32.324'), 'illegal class A IP should be invalid');
		
		System.assert(v_inetAddress.isValid('135.14.44.12'), 'class B IP should be valid');
		System.assert( ! v_inetAddress.isValid('154.123.441.123'), 'illegal class B IP should be invalid');
		
		System.assert(v_inetAddress.isValid('213.25.224.32'), 'class C IP should be valid');
		System.assert( ! v_inetAddress.isValid('201.543.23.11'), 'illegal class C IP should be invalid');
		
		System.assert(v_inetAddress.isValid('229.35.159.6'), 'class D IP should be valid');
		System.assert( ! v_inetAddress.isValid('231.54.11.987'), 'illegal class D IP should be invalid');
		
		System.assert(v_inetAddress.isValid('248.85.24.92'), 'class E IP should be valid');
		System.assert( ! v_inetAddress.isValid('250.21.323.48'), 'illegal class E IP should be invalid');
		
		Test.stopTest();
	}
	
	@isTest
	private static void testReservedInetAddresses() {
		Test.startTest();
		
		InetAddressValidator v_inetAddress = InetAddressValidator.getInstance();
		
		System.assert(v_inetAddress.isValid('127.0.0.1'), 'localhost IP should be valid');
		System.assert(v_inetAddress.isValid('255.255.255.255'), 'broadcast IP should be valid');

		Test.stopTest();
	}
	
	@isTest
	private static void testBrokenInetAddresses() {
		Test.startTest();
		
		InetAddressValidator v_inetAddress = InetAddressValidator.getInstance();
		
		System.assert( ! v_inetAddress.isValid('124.14.32.abc'), 'IP with characters should be invalid');
		System.assert( ! v_inetAddress.isValid('23.64.12'), 'IP with three groups should be invalid');
		System.assert( ! v_inetAddress.isValid('26.34.23.77.234'), 'IP with five groups should be invalid');
		
		Test.stopTest();
	}
}