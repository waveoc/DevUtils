/**
* @description Main object that can be used as any custom object and also can be overrided.
*
* @author Maksim Fesenko
*/
public virtual class UnitObject {
	private static Map<String, Schema.SObjectType> globalSObjectsMap = Schema.getGlobalDescribe();
	
	private final Map<String, Object> defaultFieldValueMap = new Map<String, Object> {
		'STRING' => 'Test' + Math.round(Math.random() * 100), 
		'INTEGER' => 0, 
		'DOUBLE' => 0.0, 
		'BOOLEAN' => true, 
		'CHECKBOX' => true, 
		'DATE' => Date.today(), 
		'DATETIME' => DateTime.now()
	};
	
	public Map<String, sObject> sObjectMap;
	public String objectName;
	public sObject record;
	
	/**
	* @description Empty constructor.
	*/
	public UnitObject() {
	}
	
	/**
	* @description Constructor with name of object. 
	* Create a record of this object with all required fields.
	*
	* @param p_objectName is name of object.
	*/
	public UnitObject(String p_objectName) {
		this(p_objectName, new Map<String, Object>(), false);
	}
	
	/**
	* @description Constructor with name of object. 
	* Create a record of this object with all required or all fields (depending on p_isRequiredOnly flag).
	*
	* @param p_objectName is name of object.
	* @param p_isRequiredOnly is flag that allows fill all(none required and none lookup) fields
	*/
	public UnitObject(String p_objectName, Boolean p_isRequiredOnly) {
		this(p_objectName, new Map<String, Object>(), p_isRequiredOnly);
	}
	
	/**
	* @description Constructor with name of object. 
	*  Create a record of this object with all require fields.
	*
	* @param p_sObjectType is name of object in SObjectType format.
	*/
	public UnitObject(Schema.SObjectType p_sObjectType, Boolean p_isRequiredOnly) {
		this(p_sObjectType.getDescribe().getName(), new Map<String, Object>(), p_isRequiredOnly);
	}
	
	/**
	* @description Constructor with name of object. 
	Create a record of this object with all require fields.
	* @param p_sObjectType is name of object in SObjectType format.
	* @param p_fieldValues is map with field values.
	*/
	public UnitObject(String p_objectName, Map<String, Object> p_fieldValues, Boolean p_isRequiredOnly) {
		sObjectMap = new Map<String, sObject>();
		objectName = p_objectName;
		record = newSObject(p_objectName);
		
		List<Schema.SObjectField> v_fields = new List<Schema.SObjectField>();
		try {
			v_fields = globalSObjectsMap.get(p_objectName).getDescribe().fields.getMap().values();
		} catch(Exception ex) {
			throw new UtilsException('This sObject \'' + p_objectName + '\' doesn\'t contains in database.');
		}
		
		for (Schema.SObjectField v_field : v_fields) {
			//Craete an all require fields
			Schema.DescribeFieldResult v_resultDescribe = v_field.getDescribe();
			
			
			if (p_isRequiredOnly) {
				//Set default field value
				if ( ! v_resultDescribe.isNillable() && v_resultDescribe.isCreateable()) {
					record = setDefaultFieldValue(v_resultDescribe, record);
				}
				
				//Create an all master-details fields
				if ( ! v_resultDescribe.getReferenceTo().isEmpty() && v_resultDescribe.isCreateable() && 
					! v_resultDescribe.isNillable()) {
				
					for (Schema.SObjectType v_fieldType : v_resultDescribe.getReferenceTo()) {
						String v_objectReferenceName = v_fieldType.getDescribe().getName();
						
						if (v_objectReferenceName == 'User') {
							record.put(v_resultDescribe.getName(), UserInfo.getUserId());
							
							User v_currentUser = [
									SELECT Name 
									FROM User 
									WHERE Id = :UserInfo.getUserId() 
									LIMIT 1];
							
							this.sObjectMap.put(UserInfo.getUserId(), v_currentUser);
						} else if (v_objectReferenceName == 'Profile') {
							record.put(v_resultDescribe.getName(), UserInfo.getProfileId());
							
							Profile v_currentProfile = [
									SELECT Name 
									FROM Profile 
									WHERE Id = :UserInfo.getProfileId() 
									LIMIT 1];
							
							this.sObjectMap.put(UserInfo.getProfileId(), v_currentProfile);
						} else if (v_objectReferenceName == 'Group') {
							try {
								List<Group> v_groups = [SELECT Id FROM Group LIMIT 1];
								
								record.put(v_resultDescribe.getName(), v_groups.get(0).Id);
								this.sObjectMap.put(v_groups.get(0).Id, v_groups.get(0));
							} catch(Exception ex) {
								throw new UtilsException('Group records do not exist in database.');
							}
						} else {
							//Master-detail or require lookup
							if (v_fieldType.getDescribe().getName() != objectName && 
									globalSObjectsMap.get(v_fieldType.getDescribe().getName()).getDescribe().isCreateable()) {
								
								sObject v_newObject = new UnitObject(v_fieldType.getDescribe().getName()).insertSObjectRecord();
								
								this.sObjectMap.put(v_newObject.Id, v_newObject);
								
								record.put(v_resultDescribe.getName(), v_newObject.Id);
							}
						}
					}
				}
			} else if (v_resultDescribe.getReferenceTo().isEmpty() && v_resultDescribe.isCreateable()) {
					
				//Set default field value
				record = setDefaultFieldValue(v_resultDescribe, record);
			}
		}
		
		//reEnter fields from input map
		for (String v_fieldName : p_fieldValues.keySet()) {
			record.put(v_fieldName, p_fieldValues.get(v_fieldName));
		}
	}
	
	/**
	* @description TypeName must be a valid API name (i.e. custom objects should be suffixed with "__c")
	*
	* @param p_typeName is sObject name.
	* @return sObject is created sObject.
	*/
	public SObject newSObject(String p_typeName) {
		Schema.SObjectType v_targetType = globalSObjectsMap.get(p_typeName);
		
		if (v_targetType == null) {
		// calling code should usually handle this exception:
		throw new UtilsException('The requested SObject type [' + v_targetType + '] cannot be constructed;' + 
				' it is not configured on this org.');
		}
		
		return v_targetType.newSObject();
	}
	
	/**
	* @description Add field value to sObject.
	*
	* @param p_name is a field name.
	* @param p_value is a field value.
	* @return UnitObject is a current class.
	*/
	public UnitObject addField(String p_name, Object p_value) {
		//Enter object field from input parameters
		record.put(p_name, p_value);
		
		return this;
	}
	
	/**
	* @description Add field values to sObject.
	*
	* @param p_fieldValues is a map that consists of field values.
	* @return UnitObject is a current class.
	*/
	public UnitObject addFields(Map<String, Object> p_fieldValues) {
		for (String v_fieldName : p_fieldValues.keySet()) {
			record.put(v_fieldName, p_fieldValues.get(v_fieldName));
		}
		
		return this;
	}
	
	/**
	* @description Return record after some actions.
	*
	* @return UnitObject is a current class.
	*/
	public sObject getSObjectRecord() {
		return this.record;
	}
	
	/**
	* @description Insert and return record.
	*
	* @return UnitObject is a current class.
	*/
	public sObject insertSObjectRecord() {
		//Try to insert record and return
		try {
			insert record;
		} catch(System.Exception ex) {
			throw new UtilsException('Can not create ' + record.getSObjectType().getDescribe().getName() + 
					'. The error message : ' + ex.getMessage());
		}
		
		return this.record;
	}
	
	/**
	* @description Get a parent record of creating sObject.
	*
	* @param p_relationship is name of relationship of parent object.
	* @return sObject is parent object from current object;
	*/
	public sObject getParentSObject(String p_relationship) {
		String v_objectName = record.getSObjectType().getDescribe().getName();
		
		//
		return getsObject(v_objectName, p_relationship);
	}
	
	/**
	* @description Get a parent record of object by input id value.
	* @param p_objectId is parent object id;
	* @param p_relationship is name of relationship of parent object.
	* @return sObject is parent object from current object;
	*/
	public sObject getParentSObject(Id p_objectId, String p_relationship) {
		//
		if (sObjectMap.containsKey(p_objectId)) {
			sObject v_sObject = sObjectMap.get(p_objectId);
			String v_objectName = v_sObject.getSObjectType().getDescribe().getName();
			
			//
			return getsObject(v_objectName, p_relationship);
		}
		
		return null;
	}
	
	/**
	* @description Get sObject parent record by relationship value.
	* @param p_objectName is name of object that parent record we will return.
	* @param p_relationship is name of relationship for getting parent record.
	* @return sObject is parent record.
	*/
	private sObject getsObject(String p_objectName, String p_relationship) {
		if (globalSObjectsMap.containsKey(p_objectName)) {
			Map <String, Schema.SObjectField> v_fieldMap = globalSObjectsMap.get(p_objectName).getDescribe().fields.getMap();
			Schema.SObjectField v_field = v_fieldMap.get(p_relationship);
			
			if (v_field != null && ! v_field.getDescribe().getReferenceTo().isEmpty()) {
				String v_parentId = String.valueOf(record.get(v_field.getDescribe().getName()));
				
				return sObjectMap.get(v_parentId);
			} else if (v_field == null) {
				throw new UtilsException(p_relationship + ' field is not exists for ' + p_objectName + ' object.');
			} else if (v_field.getDescribe().getReferenceTo().isEmpty()) {
				throw new UtilsException(p_relationship + ' field is not lookup field type.');
			}
		}
		
		return null;
	}
	
	/**
	* @description Set default field value by default map or active picklist values.
	*
	* @param p_resultDescribe Schema.DescribeFieldResult variable
	* @param p_record sObject that we should fill.
	*
	* @return sObject that with populated input field.
	*/
	private sObject setDefaultFieldValue(Schema.DescribeFieldResult p_resultDescribe, sObject p_record) {
		if (p_resultDescribe.getName() == 'Status' && objectName == 'Contract') {
			p_record.put(p_resultDescribe.getName(), 'Draft');
		} else if (p_resultDescribe.getName() == 'isConverted' && objectName == 'Lead') {
			p_record.put(p_resultDescribe.getName(), false);
		} else if (String.valueOf(p_resultDescribe.getType()) == 'PICKLIST') {
			for (Schema.PicklistEntry pEntry : p_resultDescribe.getPicklistValues()) {
				if (pEntry.isActive()) {
					p_record.put(p_resultDescribe.getName(), pEntry.getValue());
					
					break;
				}
			}
		} else {
			Object v_defaultFieldValue = defaultFieldValueMap.get(String.valueOf(p_resultDescribe.getType()));
			p_record.put(p_resultDescribe.getName(), v_defaultFieldValue);
		}
		
		return p_record;
	}
	
	/**
	* @description Custom Exception class
	*/
	public class UtilsException extends Exception {
	}
}