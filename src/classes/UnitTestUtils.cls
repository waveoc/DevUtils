/**
* @description Develop tool for creating records for unit test.
*
* @author Fesenko Maksim
*/
public class UnitTestUtils {
	private static Map<String, Schema.SObjectType> globalSObjectsMap = Schema.getGlobalDescribe();
	
	private WaveObject obj;
	
	/**
	* @description Create and return Account record.
	*
	* @return UnitTestUtils is current class.
	*/
	public WaveAccount createAccount() {
		return new WaveAccount();
	}
	
	/**
	* @description Create and return Account record with input field values.
	*
	* @param p_fieldValue is a map with field values.
	* @return WaveAccount is a template class.
	*/
	public WaveAccount createAccount(Map<String, Object> p_fieldValue) {
		return new WaveAccount(p_fieldValue);
	}
	
	/**
	* @description Create and return Opportunity record.
	*
	* @return UnitTestUtils is current class.
	*/
	public WaveOpportunity createOpportunity() {
		return new WaveOpportunity();
	}
	
	/**
	* @description Create and return Opportunity record with input field values.
	*
	* @param p_fieldValue is a map with field values.
	* @return WaveOpportunity is a template class.
	*/
	public WaveOpportunity createOpportunity(Map<String, Object> p_fieldValue) {
		return new WaveOpportunity(p_fieldValue);
	}
	
	/**
	* @description Create and return Contact record.
	*
	* @return UnitTestUtils is current class.
	*/
	public WaveContact createContact() {
		return new WaveContact();
	}
	
	/**
	* @description Create and return Contact record with input field values.
	*
	* @param p_fieldValue is a map with field values.
	* @return WaveContact is a template class.
	*/
	public WaveContact createContact(Map<String, Object> p_fieldValue) {
		return new WaveContact(p_fieldValue);
	}
	
	/**
	* @description Create and return Lead record.
	*
	* @return UnitTestUtils is current class.
	*/
	public WaveLead createLead() {
		return new WaveLead();
	}
	
	/**
	* @description Create and return Lead record with input field values.
	*
	* @param p_fieldValue is a map with field values.
	* @return WaveLead is a template class.
	*/
	public WaveLead createLead(Map<String, Object> p_fieldValue) {
		return new WaveLead(p_fieldValue);
	}
	
	/**
	* @description Create and return Contract record.
	*
	* @return UnitTestUtils is current class.
	*/
	public WaveContract createContract() {
		return new WaveContract();
	}
	
	/**
	* @description Create and return Contract record with input field values.
	*
	* @param p_fieldValue is a map with field values.
	* @return WaveContract is a template class.
	*/
	public WaveContract createContract(Map<String, Object> p_fieldValue) {
		return new WaveContract(p_fieldValue);
	}
	
	/**
	* @description Create and return Case record.
	*
	* @return UnitTestUtils is current class.
	*/
	public WaveCase createCase() {
		return new WaveCase();
	}
	
	/**
	* @description Create and return Case record with input field values.
	*
	* @param p_fieldValue is a map with field values.
	* @return WaveCase is a template class.
	*/
	public WaveCase createCase(Map<String, Object> p_fieldValue) {
		return new WaveCase(p_fieldValue);
	}
	
	/**
	* @description Create and return Product2 record.
	*
	* @return UnitTestUtils is current class.
	*/
	public WaveProduct2 createProduct2() {
		return new WaveProduct2();
	}
	
	/**
	* @description Create and return Product2 record with input field values.
	*
	* @param p_fieldValue is a map with field values.
	* @return WaveProduct2 is a template class.
	*/
	public WaveProduct2 createProduct2(Map<String, Object> p_fieldValue) {
		return new WaveProduct2(p_fieldValue);
	}
	
	/**
	* @description Custom method for creating sObject record.
	*
	* @param p_objectName is name of object.
	* @return UnitTestUtils is current class.
	*/
	public WaveObject createRecord(String p_objectName) {
		if (p_objectName == 'Account') {
			return new WaveAccount();
		} else if (p_objectName == 'Opportunity') {
			return new WaveOpportunity();
		} else if (p_objectName == 'Contact') {
			return new WaveContact();
		} else if (p_objectName == 'Lead') {
			return new WaveLead();
		} else if (p_objectName == 'Contract') {
			return new WaveContract();
		} else if (p_objectName == 'Case') {
			return new WaveCase();
		} else if (p_objectName == 'Product2') {
			return new WaveProduct2();
		} else {
			return new WaveObject(p_objectName);
		}
	}
	
	/**
	* @description Extend class from WaveObject for Account object
	*/
	public class WaveAccount extends WaveObject {
		public WaveAccount() {
			super('Account');
		}
		
		public WaveAccount(Map<String, Object> p_fieldValueMap) {
			super('Account', p_fieldValueMap);
		}
		
		public Account getRecord() {
			return (Account)super.getSObjectRecord();
		}
		
		public Account insertRecord() {
			return (Account)super.insertSObjectRecord();
		}
	}
	
	/**
	* @description Extend class from WaveObject for Opportunity object
	*/
	public class WaveOpportunity extends WaveObject {
		public WaveOpportunity() {
			super('Opportunity');
		}
		
		public WaveOpportunity(Map<String, Object> p_fieldValueMap) {
			super('Opportunity', p_fieldValueMap);
		}
		
		public Opportunity getRecord() {
			return (Opportunity)super.getSObjectRecord();
		}
		
		public Opportunity insertRecord() {
			return (Opportunity)super.insertSObjectRecord();
		}
	}
	
	/**
	* @description Extend class from WaveObject for Contact object
	*/
	public class WaveContact extends WaveObject {
		public WaveContact() {
			super('Contact');
		}
		
		public WaveContact(Map<String, Object> p_fieldValueMap) {
			super('Contact', p_fieldValueMap);
		}
		
		public Contact getRecord() {
			return (Contact)super.getSObjectRecord();
		}
		
		public Contact insertRecord() {
			return (Contact)super.insertSObjectRecord();
		}
	}
	
	/**
	* @description Extend class from WaveObject for Lead object
	*/
	public class WaveLead extends WaveObject {
		public WaveLead() {
			super('Lead');
		}
		
		public WaveLead(Map<String, Object> p_fieldValueMap) {
			super('Lead', p_fieldValueMap);
		}
		
		public Lead getRecord() {
			return (Lead)super.getSObjectRecord();
		}
		
		public Lead insertRecord() {
			return (Lead)super.insertSObjectRecord();
		}
	}
	
	/**
	* @description Extend class from WaveObject for Case object
	*/
	public class WaveCase extends WaveObject {
		public WaveCase() {
			super('Case');
		}
		
		public WaveCase(Map<String, Object> p_fieldValueMap) {
			super('Case', p_fieldValueMap);
		}
		
		public Case getRecord() {
			return (Case)super.getSObjectRecord();
		}
		
		public Case insertRecord() {
			return (Case)super.insertSObjectRecord();
		}
	}
	
	/**
	* @description Extend class from WaveObject for Contract object
	*/
	public class WaveContract extends WaveObject {
		public WaveContract() {
			super('Contract');
		}
		
		public WaveContract(Map<String, Object> p_fieldValueMap) {
			super('Contract', p_fieldValueMap);
		}
		
		public Contract getRecord() {
			return (Contract)super.getSObjectRecord();
		}
		
		public Contract insertRecord() {
			return (Contract)super.insertSObjectRecord();
		}
	}
	
	/**
	* @description Extend class from WaveObject for Product2 object
	*/
	public class WaveProduct2 extends WaveObject {
		public WaveProduct2() {
			super('Product2');
		}
		
		public WaveProduct2(Map<String, Object> p_fieldValueMap) {
			super('Product2', p_fieldValueMap);
		}
		
		public Product2 getRecord() {
			return (Product2)super.getSObjectRecord();
		}
		
		public Product2 insertRecord() {
			return (Product2)super.insertSObjectRecord();
		}
	}
}