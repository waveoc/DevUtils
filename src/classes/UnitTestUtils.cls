/**
*	@description Develop tool for creating records for unit test.
*
*	@author Fesenko Maksim
*/
public class UnitTestUtils {
	private static Map<String, Schema.SObjectType> globalSObjectsMap = Schema.getGlobalDescribe();
	
	private WaveObject obj;
	
	/**
	*	@description Create and return Account record.
	*
	*	@return UnitTestUtils is current class.
	*/
	public UnitTestUtils getAccount() {
		obj = new WaveAccount().getRecord();
		
		return this;
	}
	
	/**
	* @description Add field to object via field name and value.
	*
	*	@param p_name is field name.
	*	@param p_value is field value.
	*	@return UnitTestUtils is current class.
	*/
	public UnitTestUtils addField(String p_name, Object p_value) {
		obj.addField(p_name, p_value);
		
		return this;
	}
	
	/**
	* @description Add field to object via field name and value.
	*
	*	@param p_fieldMap is a map with field values.
	*	@return UnitTestUtils is current class.
	*/
	public UnitTestUtils addField(Map<String, Object> p_fieldMap) {
		obj.addFields(p_fieldMap);
		
		return this;
	}
	
	/**
	*	@description 
	*
	*	@param p_relationship is name of relationship of parent object.
	*	@return sObject is parent object from current object;
	*/
	public sObject getParent(String p_relationship) {
		String v_objectName = obj.record.getSObjectType().getDescribe().getName();
		
		//
		return getsObject(v_objectName, p_relationship);
	}
	
	/**
	*	@description 
	*
	*	@param p_objectId is parent object id;
	*	@param p_relationship is name of relationship of parent object.
	*	@return sObject is parent object from current object;
	*/
	public sObject getParent(Id p_objectId, String p_relationship) {
		//
		if (obj.sObjectMap.containsKey(p_objectId)) {
			sObject v_sObject = obj.sObjectMap.get(p_objectId);
			String v_objectName = v_sObject.getSObjectType().getDescribe().getName();
			
			//
			return getsObject(v_objectName, p_relationship);
		}
		
		return null;
	}
	
	/**
	*	@description Get sObject parent record by relationship value.
	*
	*	@param p_objectName is name of object that parent record we will return.
	*	@param p_relationship is name of relationship for getting parent record.
	*	@return sObject is parent record.
	*/
	private sObject getsObject(String p_objectName, String p_relationship) {
		if (globalSObjectsMap.containsKey(p_objectName)) {
			Map <String, Schema.SObjectField> v_fieldMap = globalSObjectsMap.get(p_objectName).
					getDescribe().fields.getMap();
			
			//
			Schema.SObjectField v_field = v_fieldMap.get(p_relationship);
			if (v_field != null && v_field.getDescribe().isIdLookup()) {
				return obj.sObjectMap.get(v_field.getDescribe().getName());
			}
		}
		
		return null;
	}
	
	/**
	*	@description Insert and return record.
	*
	*	@return UnitTestUtils is current class.
	*/
	public UnitTestUtils insertRecord() {
		obj.insertRecord();
		
		return this;
	}
	
	/**
	*	@description Custom method for getting any type of objects.
	*
	*	@param p_objectName is name of object.
	*	@return UnitTestUtils is current class.
	*/
	public sObject getRecord(String p_objectName) {
		if (p_objectName == 'Account') {
			obj = new WaveAccount().getRecord();
		} else if (p_objectName == 'Opportunity') {
			obj = new WaveOpportunity().getRecord();
		} else {
			obj = new WaveObject(p_objectName).getRecord();
		}
		
		return obj.record;
	}
	
	/**
	*	@description Extend class from WaveObject for Account object
	*/
	public class WaveAccount extends WaveObject {
		public WaveAccount() {
			super('Account');
		}
	}
	
	/**
	*	@description Extend class from WaveObject for Opportunity object
	*/
	public class WaveOpportunity extends WaveObject {
		public WaveOpportunity() {
			super('Opportunity');
		}
	}
}