/**
* @description Develop tool for creating records for unit test.
*
* @author Fesenko Maksim
*/
public class UnitTestUtils {
	private static Map<String, Schema.SObjectType> globalSObjectsMap = Schema.getGlobalDescribe();
	
	private UnitObject obj;
	
	/**
	* @description Custom method for creating sObject record.
	* Create a record of this object with all required fields
	*
	* @param p_objectName is name of object.
	* @return UnitTestUtils is current class.
	*/
	public UnitObject createRecord(String p_objectName) {
		return this.createRecord(p_objectName, false);
	}
	
	/**
	* @description Custom method for creating sObject record.
	* Create a record of this object with all required or all fields (depending on p_isRequiredOnly flag)
	*
	* @param p_objectName is name of object.
	* @return UnitTestUtils is current class.
	* @param p_isRequiredOnly is flag that allows fill all(none required and none lookup) fields
	*/
	public UnitObject createRecord(String p_objectName, Boolean p_isRequiredOnly) {
		return new UnitObject(p_objectName, p_isRequiredOnly);
	}
	
	/**
	* @description Return a list of sObject records.
	*
	* @param p_objectName API name of sObject.
	* @param p_count how many records should be returned.
	* @return List<sObject> created records.
	*/
	public List<sObject> createRecords(String p_objectName, Integer p_count) {
		return this.createRecords(p_objectName, false, p_count);
	}
	
	/**
	* @description Return a list of sObject records.
	* Each record will be filled with all required or all fields (depending on p_isRequiredOnly flag)
	*
	* @param p_objectName API name of sObject.
	* @param p_count how many records should be returned.
	* @param p_isRequiredOnly is flag that allows fill all (none required and none lookup) fields
	* @return List<sObject> created records.
	*/
	public List<sObject> createRecords(String p_objectName, Boolean p_isRequiredOnly, Integer p_count) {
		List<sObject> v_resultObjects = new List<sObject>();
		
		for (Integer i = 0; i < p_count; i++) {
			v_resultObjects.add(new UnitObject(p_objectName).getSObjectRecord());
		}
		
		return v_resultObjects;
	}
}