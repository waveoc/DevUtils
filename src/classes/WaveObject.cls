/**
*	@description Custom class for describe object and create a record for unit test.
*/
public virtual class WaveObject {
	private static Map<String, Schema.SObjectType> globalSObjectsMap = Schema.getGlobalDescribe();
	public Map<String, sObject> sObjectMap;
	public String objectName;
	public sObject record;
	
	/**
	*	@description Constructor with name of object. 
	*			Create a record of this object with all require fields.
	*
	*	@param p_objectName is name of object.
	*/
	public WaveObject(String p_objectName) {
		sObjectMap = new Map<String, sObject>();
		objectName = p_objectName;
		record = newsObject(p_objectName);
		
		
		for (Schema.SObjectField v_field : globalSObjectsMap.get(p_objectName)
				.getDescribe().fields.getMap().values()) {
			
			//Craete an all require fields
			Schema.DescribeFieldResult v_resultDescribe = v_field.getDescribe();
			if ( ! v_resultDescribe.isNillable() && v_resultDescribe.isCreateable()) {
				//Set default value
				record.put(v_resultDescribe.getName(), v_resultDescribe.getDefaultValue());
			}
			
			//Create an all master-details fields
			if ( ! v_resultDescribe.getReferenceTo().isEmpty() && v_resultDescribe.isCreateable() && 
					! v_resultDescribe.isNillable()) {
				
				for (Schema.SObjectType v_fieldType : v_resultDescribe.getReferenceTo()) {
					if (v_fieldType.getDescribe().getName() != objectName && 
						globalSObjectsMap.get(v_fieldType.getDescribe().getName()).getDescribe()
								.isCreateable()) {
						
						System.debug('-----' + v_fieldType.getDescribe().getName());
						
						WaveObject v_newObject = new WaveObject(v_fieldType.getDescribe().getName())
								.insertRecord();
						
					}
				}
			}
		}
	}
	
	public WaveObject(Schema.SObjectType p_sObjectType) {
		sObjectMap = new Map<String, sObject>();
		objectName = p_sObjectType.getDescribe().getName();
		record = newsObject(objectName);
		
		
		for (Schema.SObjectField v_field : globalSObjectsMap.get(objectName)
				.getDescribe().fields.getMap().values()) {
			
			//Craete an all require fields
			Schema.DescribeFieldResult v_resultDescribe = v_field.getDescribe();
			if ( ! v_resultDescribe.isNillable()) {
				//Set default value
				record.put(v_resultDescribe.getName(), v_resultDescribe.getDefaultValue());
			}
			
			//Create an all master-details fields
			if ( ! v_resultDescribe.getReferenceTo().isEmpty() && v_resultDescribe.isCreateable() && 
					! v_resultDescribe.isNillable()) {
				
				for (Schema.SObjectType v_fieldType : v_resultDescribe.getReferenceTo()) {
					if (v_fieldType.getDescribe().getName() != objectName) {
						WaveObject v_newObject = new WaveObject(v_fieldType.getDescribe().getName())
								.getRecord();
					}
				}
			}
		}
	}
	
	public WaveObject(String p_objectName, Map<String, Object> p_fieldValues) {
		sObjectMap = new Map<String, sObject>();
		objectName = p_objectName;
		record = newsObject(p_objectName);
		
		
		for (Schema.SObjectField v_field : globalSObjectsMap.get(p_objectName)
				.getDescribe().fields.getMap().values()) {
			
			//Craete an all require fields
			Schema.DescribeFieldResult v_resultDescribe = v_field.getDescribe();
			if ( ! v_resultDescribe.isNillable()) {
				//Set default value
				record.put(v_resultDescribe.getName(), v_resultDescribe.getDefaultValue());
			}
			
			//Create an all master-details fields
			if ( ! v_resultDescribe.getReferenceTo().isEmpty() && v_resultDescribe.isCreateable() && 
					! v_resultDescribe.isNillable()) {
				
				for (Schema.SObjectType v_fieldType : v_resultDescribe.getReferenceTo()) {
					if (v_fieldType.getDescribe().getName() != objectName) {
						WaveObject v_newObject = new WaveObject(v_fieldType.getDescribe().getName())
								.getRecord();
					}
				}
			}
			
			//reEnter fields from input map
			for (String v_fieldName : p_fieldValues.keySet()) {
				record.put(v_fieldName, p_fieldValues.get(v_fieldName));
			}
		}
	}
	
	/**
	*	@description TypeName must be a valid API name (i.e. custom objects should be suffixed with "__c"):
	*
	*	@param p_typeName is sObject name.
	*	@return sObject is created sObject.
	*/
	public SObject newSObject(String p_typeName) {
		Schema.SObjectType v_targetType = globalSObjectsMap.get(p_typeName);
		if (v_targetType == null) {
			// calling code should usually handle this exception:
			throw new UtilsException('The requested SObject type [' + v_targetType + 
					'] cannot be constructed; it is not configured on this org.');
		}
		
		// SObjects offer the only way in Apex to instantiate an object with a type determined at 
		// runtime -- you can optionally pass an Id argument to instantiate an SObject for an 
		// existing record:
		return v_targetType.newSObject();
	}
	
	/**
	*	@description Add field value to sObject.
	*
	*	@param p_name is a field name.
	*	@param p_value is a field value.
	*	@return WaveObject is a current class.
	*/
	public virtual WaveObject addField(String p_name, Object p_value) {
		//Enter object field from input parameters
		record.put(p_name, p_value);
		
		return this;
	}
	
	/**
	*	@description Add field values to sObject.
	*
	*	@param p_fieldValues is a map that consists of field values.
	*	@return WaveObject is a current class.
	*/
	public virtual WaveObject addFields(Map<String, Object> p_fieldValues) {
		for (String v_fieldName : p_fieldValues.keySet()) {
			record.put(v_fieldName, p_fieldValues.get(v_fieldName));
		}
		
		return this;
	}
	
	/**
	*	@description Return record after some actions.
	*
	*	@return WaveObject is a current class.
	*/
	public WaveObject getRecord() {
		return this;
	}
	
	/**
	*	@description Insert and return record.
	*
	*	@return WaveObject is a current class.
	*/
	public virtual WaveObject insertRecord() {
		//Try to insert record and return
		try {
			insert record;
		} catch(System.DMLException ex) {
			return new WaveObject(objectName);
		}
		
		return this;
	}
	
	public class UtilsException extends Exception {
	}
}