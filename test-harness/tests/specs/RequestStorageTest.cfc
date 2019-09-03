<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Author     :    Eric Peterson, Mike Burt, and Dan Murphy
Date        :   10/24/2007
Description :
Request Storage Test
----------------------------------------------------------------------->
<cfcomponent extends="coldbox.system.testing.BaseTestCase" appMapping="/root">
	<cffunction name="testRetrieval" access="public" returntype="void" output="false">
		<!--- Now test some events --->
		<cfscript>
		var storage = getModel( "requestStorage@cbstorages" );
		assertTrue( isObject( storage ) );
		</cfscript>
	</cffunction>

	<cffunction name="testMethods" access="public" returntype="void" output="false">
		<!--- Now test some events --->
		<cfscript>
		var storage = getModel( "requestStorage@cbstorages" );

		storage.set( "tester", 1 );

		AssertTrue( storage.exists( "tester" ), "Test set & Exists" );
		AssertEquals( 1, storage.get( "tester" ), "Get & Set Test" );

		AssertFalse( storage.exists( "nothing" ), "False Assertion on exists" );

		storage.delete( "tester" );
		AssertFalse( storage.exists( "tester" ), "Remove & Exists" );

		storage.set( "tester", 1 );
		storage.set( "tester2", now() );

		storage.clearAll();
		AssertTrue( structIsEmpty( request.cbStorage ), "Clear & Test" );

		// Remove it
		structDelete( request, "cbStorage" );
		// Try to add to it
		storage.set( "tester", 123 );
		AssertTrue( storage.exists( "tester" ), "Removal Reconstruction test." );

		storage.clearAll();

		// set/get multi with Keys
		storage.setMulti( { test : now(), test2 : "luis" } );
		expect( storage.getMulti( "test,test2" ) ).toHaveLength( 2 );
		// Get Keys
		expect( storage.getKeys() )
			.toBeArray()
			.toHaveLength( 2 )
			.toInclude( "test" )
			.toInclude( "test2" );

		// deleteMulti
		var r = storage.deleteMulti( "test,test2,test3" );
		expect( r.test ).toBeTrue();
		expect( r.test2 ).toBeTrue();
		expect( r.test3 ).toBeFalse();

		expect( storage.getSize() ).toBe( 0 );
		expect( storage.isEmpty() ).toBeTrue();
		</cfscript>
	</cffunction>

	<!--- tearDown --->
	<cffunction name="tearDown" output="false" access="public" returntype="void" hint="">
		<cfscript>
		structDelete( request, "cbStorage" );
		</cfscript>
	</cffunction>
</cfcomponent>
