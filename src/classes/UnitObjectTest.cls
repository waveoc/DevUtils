/**
* @description Test on creating a UnitObject.
*
* @author Maksim Fesenko
*/
@isTest
private class UnitObjectTest {
	@isTest
	private static void testCreateByString() {
		Test.startTest();
		
		sObject v_object;
		try {
			v_object = new UnitObject('Account').addField('Name', 'Test Account').insertSObjectRecord();
		} catch(Exception ex) {
			System.assert(false, ex.getMessage());
		}
		
		System.assertNotEquals(null, v_object.Id, 'The object should be inserted.');
		
		Test.stopTest();
	}
	
	@isTest
	private static void testCreateBySObjectType() {
		Test.startTest();
		
		sObject v_object;
		try {
			v_object = new UnitObject(Account.getSObjectType(), true).insertSObjectRecord();
		} catch(Exception ex) {
			System.assert(false, ex.getMessage());
		}
		
		System.assertNotEquals(null, v_object.Id, 'The object should be inserted.');
		
		Test.stopTest();
	}
	
	@isTest
	private static void testCreateByMapValues() {
		Test.startTest();
		
		sObject v_object;
		Map<String, Object> v_fieldValueMap = new Map<String, Object> {
			'Name' => 'TestAccount', 
			'AccountNumber' => '12345'
		};
		try {
			v_object = new UnitObject('Account', v_fieldValueMap, false).insertSObjectRecord();
		} catch(Exception ex) {
			System.assert(false, ex.getMessage());
		}
		
		System.assertNotEquals(null, v_object.Id, 'The object should be inserted.');
		System.assertEquals(v_fieldValueMap.get('Name'), v_object.get('Name'), 'Object name is not equals.');
		
		Test.stopTest();
	}
	
	@isTest
	private static void testAddField() {
		Test.startTest();
		
		sObject v_object;
		try {
			v_object = new UnitObject('Account').addField('Name', 'TestAccount').insertSObjectRecord();
		} catch(Exception ex) {
			System.assert(false, ex.getMessage());
		}
		
		System.assertNotEquals(null, v_object.Id, 'The object should be inserted.');
		System.assertEquals('TestAccount', v_object.get('Name'), 'Object name is not equals.');
		
		Test.stopTest();
	}
	
	@isTest
	private static void testAddFields() {
		Test.startTest();
		
		sObject v_object;
		try {
			v_object = new UnitObject('Account').addFields(new Map<String, Object> { 'Name' => 'TestAccount'})
					.insertSObjectRecord();
		} catch(Exception ex) {
			System.assert(false, ex.getMessage());
		}
		
		System.assertNotEquals(null, v_object.Id, 'The object should be inserted.');
		System.assertEquals('TestAccount', v_object.get('Name'), 'Object name is not equals.');
		
		Test.stopTest();
	}
	
	@isTest
	private static void testGetParent() {
		Test.startTest();
		
		sObject v_object;
		try {
			v_object = new UnitObject('Contact', true).getParentSObject('OwnerId');
		} catch(Exception ex) {
			System.assert(false, ex.getMessage());
		}
		
		System.assertNotEquals(null, v_object.Id, 'The object should be inserted.');
		System.assertEquals(UserInfo.getName(), v_object.get('Name'), 
				'The parent sObject should be have an user.');
		
		Test.stopTest();
	}
	
	@isTest
	private static void testGetInvalidParent() {
		Test.startTest();
		
		sObject v_object;
		Boolean v_throwException = true;
		try {
			v_object = new UnitObject('Contact').getParentSObject('testfield');
		} catch(Exception ex) {
			v_throwException = true;
		}
		
		System.assert(v_throwException, 'This field is not exists.');
		
		//check on lookup invalid
		v_throwException = true;
		try {
			v_object = new UnitObject('Contact').getParentSObject('LastName');
		} catch(Exception ex) {
			v_throwException = true;
		}
		
		System.assert(v_throwException, 'This field is not lookup.');
		
		Test.stopTest();
	}
	
	//Creating object name is not consists in database or empty
	@isTest
	private static void testInvalidObject() {
		Test.startTest();
		
		UnitObject v_waveObject = new UnitObject();
		
		sObject v_object;
		Boolean v_throwException = false;
		try {
			v_object = new UnitObject('').getSObjectRecord();
		} catch(Exception ex) {
			v_throwException = true;
		}
		
		System.assert(v_throwException, 'This object have is not empty name.');
		
		v_throwException = false;
		try {
			v_object = new UnitObject('TestObject111').getSObjectRecord();
		} catch(Exception ex) {
			v_throwException = true;
		}
		
		System.assert(v_throwException, 'This object is consists in database.');
		
		Test.stopTest();
	}
	
	//create an Opportujnity for creating require picklist
	@isTest
	private static void testCreateRequirePicklist() {
		Test.startTest();
		
		sObject v_object;
		try {
			v_object = new UnitObject('Opportunity', true).getSObjectRecord();
			
			insert v_object;
		} catch(Exception ex) {
			System.assert(false, ex.getMessage());
		}
		
		System.assertNotEquals(null, v_object.Id, 'The object should be inserted.');
		
		Test.stopTest();
	}
	
	
	//cretae a Lead
	@isTest
	private static void testCreateLead() {
		Test.startTest();
		
		sObject v_object;
		try {
			v_object = new UnitObject('Lead', true).insertSObjectRecord();
		} catch(Exception ex) {
			System.assert(false, ex.getMessage());
		}
		
		System.assertNotEquals(null, v_object.Id, 'The object should be inserted.');
		
		Test.stopTest();
	}
	
	//create and not insert User record for creating profile relationship
	@isTest
	private static void testCreateProfileRelationship() {
		Test.startTest();
		
		sObject v_object;
		try {
			v_object = new UnitObject('User', true).getSObjectRecord();
		} catch(Exception ex) {
			System.assert(false, ex.getMessage());
		}
		
		System.assertEquals(v_object.get('ProfileId'), UserInfo.getProfileId(), 'Profile was attached to this User.');
		
		Test.stopTest();
	}
	
	//can not create a record e.g. profile
	@isTest
	private static void testCantCreateProfile() {
		Test.startTest();
		
		sObject v_object;
		Boolean v_throwException = false;
		try {
			v_object = new UnitObject('Profile', true).insertSObjectRecord();
		} catch(Exception ex) {
			v_throwException = true;
		}
		
		System.assert(v_throwException, 'Profile record should not be created.');
		
		Test.stopTest();
	}
}