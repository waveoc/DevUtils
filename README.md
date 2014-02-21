1.	Validator utils

Description:
Integrity of the data is one of the key problems when it is being received electronically or from user input.
The appropriate checks for integrity are always repetitive and rather complicated. And current package is created to solve related with validation rules issues and to increase the speed of development process as well.

Features:
Our Team has created “Validator” library that provides reusable "primitive" validation methods.
These methods have a set of common validation methods (email addresses, URLs, etc.) that could help in creating pluggable actions.
Our library is adapted for Salesforce version of Apache commons validator (Java language) library.

How to use (samples)

		DomainValidator:
			DomainValidator.getInstance().isValid('apache.org'); // return true,  domain 'apache.org' is valid.
			DomainValidator.getInstance().isValid('apa che.org'); // return false, domain 'apa che.org is not valid.
			DomainValidator.getInstance().isValidInfrastructureTld('arpa'); // return true .arpa is validate as iTLD;
			DomainValidator.getInstance().isValidTld('COM'); // return true, .COM is validate as TLD;
		EmailValidator:
			EmailValidator.getInstance().isValid('joe+@apache.org'); // return true, + is valid unquoted.
			EmailValidator.getInstance().isValid('someone@[216.109.118.76]'); // return true.
			EmailValidator.getInstance().isValid('joe!/blow@apache.org'); // return true, / and ! valid in username.
			EmailValidator.getInstance().isValid('joe@ap/ache.org'); // return false, / not valid in domain.
			EmailValidator.getInstance().isValid('andy.noble@data-workshop.com'); // return true;
		InetAddressValidator:
			InetAddressValidator.getInstance()
			InetAddressValidator.getInstance().isValid('199.232.41.5'); // return true, fsf.org IP is valid
			InetAddressValidator.getInstance().isValid('2.41.32.324'); // return false, illegal class A IP is invalid.
			InetAddressValidator.getInstance().isValid('127.0.0.1'); // return true,  localhost IP is valid.
			InetAddressValidator.getInstance().isValid('26.34.23.77.234'); // return false, IP with five groups is invalid.
		NumericValidator:
			Example (Apex):
				NumericValidator numeric = NumericValidator.getInstance();
				Decimal d = 11.123456;
				d.setScale(2);
				System.assertEquals(d, numeric.validate('dssd11.123456', '##.##').toDecimal()); // return true
		RegexValidator:
			Example (Apex):
				RegexValidator sensitive = new RegexValidator('^([abc]*)(?:\\-)([DEF]*)(?:\\-)([123]*)$');
				// method isValid
				System.assert(sensitive.isValid('ac-DE-1'), 'Sensitive isValid() valid');
				System.assert( ! sensitive.isValid('AB-de-1'), 'Sensitive isValid() invalid');
				
				// method validate
				System.assertEquals('acDE1', sensitive.validate('ac-DE-1'), 'Sensitive validate() valid');
				System.assertEquals(null, sensitive.validate('AB-de-1'), 'Sensitive validate() invalid');
		URLValidator:
			Construct a UrlValidator with valid schemes of "http", and "https":
				String[] schemes = {"http","https"}.
				UrlValidator urlValidator = new UrlValidator(schemes);
				urlValidator.isValid("ftp://foo.bar.com/"); // return false, url is invalid
			UrlValidator with default constructor:
				UrlValidator urlValidator = new UrlValidator();
				urlValidator.isValid("ftp://foo.bar.com/"); // return true, url is valid

2. UnitTest utils

Description:
Most of Salesforce developer effort is usually connected with creating Unit tests. Acceptable test coverage index starts from 75% (to be able to deploy to Production environment) – this value is not high enough, but nevertheless it guarantees that code is stable.

Features:
Our Team gathered utility methods that reduce time that is usually spent by developers on unit tests creation. These methods create objects (standard and custom) with pre-populated data.
All the required and master details fields are being populated by default. In addition, developer can fill in other specific fields with necessary data.
	
How to use (sample).

	Additional information: We have 1 custom object (Order) with 2 master details: Opportunity and Case.

	Apex class - is created to implement a part of business logic. Developer should create unit tests to cover this class (no less than 75% coverage).

public with sharing class TestController {
		
			private Order__c orderObject;
			private String oId;
			
			public TestController() {
				this.oId = ApexPages.currentPage().getParameters().get('oId');
			}
			
			public void init() {
				this.orderObject = [SELECT
										Id,
										Opportunity__r.Probability,
										Case__r.Priority,
										Case__r.Origin
									FROM Order__c
									WHERE ID = :oId
									LIMIT 1];
			}
			
			public Boolean needCall () {
				Decimal oppProbality = orderObject.Opportunity__r.Probability;
				String casePriority = orderObject.Case__r.Priority;
				String caseOrigin = orderObject.Case__r.Origin;
				if (oppProbality < 100 && casePriority == 'High'  && caseOrigin == 'Call') {
					return true;
				} else {
					return false;
				}
			}
		}

	Test class #1 - tests for Apex class (92% coverage). These tests were created without using our library.

		@isTest
		public with sharing class TestControllerTest {
			
			@IsTest(SeeAllData=true) 
			static void testCallNeedFalse() {
				
				Opportunity testOpp = new Opportunity(
					Name='Test1',
					CloseDate=Date.valueof('2015-12-30'),
					StageName = 'Prospecting',
					Probability = 10);
				insert testOpp;
				
				Case testCase = new Case(
					Status='New',
					Origin='Call');
					
				insert testCase;
				
				Order__c testOrder = new Order__c(
					Opportunity__c = testOpp.Id,
					Case__c = testCase.Id);
					
				insert testOrder;

				PageReference pageRef = Page.Start_Here;
				Test.setCurrentPage(pageRef);
				ApexPages.currentPage().getParameters().put('oId', testOrder.Id);
				
				TestController controller = new TestController();
				controller.init();
				System.assertEquals(false, controller.needCall());
			}

		}

	Test class #2 - tests for Apex class (92% coverage). These tests were created with using our library.

		@isTest
		public with sharing class TestControllerTest {			
			@IsTest(SeeAllData=true) 
			static void testCallNeedFalse() {
				
				SObject testOrder = new UnitTestUtils().createRecord('Order__c').insertSObjectRecord();
				
				PageReference pageRef = Page.Start_Here;
				Test.setCurrentPage(pageRef);
				ApexPages.currentPage().getParameters().put('oId', testOrder.Id);
				
				TestController controller = new TestController();
				controller.init();
				System.assertEquals(false, controller.needCall());
			}
		}
		
As a result:
	- Code amount reduction
	- Time spent on development reduction
