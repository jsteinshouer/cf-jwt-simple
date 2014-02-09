<!---
	COMPONENT: jwtTest.cfc 
	PURPOSE: MXUnit tests for jwt.cfc
	--->
	
<cfcomponent output="false" extends="mxunit.framework.TestCase" mxunit:decorators="mxunit.framework.decorators.OrderedTestDecorator">

	<!--- 	setUp() as 
			Description:  
	---> 
	<cffunction name="setUp" output="false">
		<cfset var key = "abcdefg">
		<cfset jwt = createObject("component","../src/jwt").init(key)>
		<cfset json = '{"ts":"February, 05 2014 12:08:05","userid":"jdoe"}'>
		<cfset payload = deserializeJSON(json)>

		<cfset testTokenInvalid = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0cyI6IkZlYnJ1YXJ5LCAwNSAyMDE0IDEyOjA4OjA1IiwidXNlcmlkIjoiamRvZSJ9.mL2-sQ2xeC4PidmV-uEvlINiI0mlpq5KRKsmO9EDTYx">
	
	</cffunction>

	<!--- 	encodeTest() as Void
			Description: Make sure no excpetion is thrown and token has three parts
	---> 
	<cffunction name="encodeTest" output="false" order="1">
		<cfset var local = structNew()>

		<cfset token = jwt.encode(payload)>
		
		<cfset assert(listLen(token,".") eq 3)>
	
	</cffunction>

	<!--- 	decodeTest() as Void
			Description: Decode token created in previous test
	---> 
	<cffunction name="decodeTest" output="false" order="2">
		<cfset var local = structNew()>
		
		<cfset var result = jwt.decode(token)>
		
		<cfset assert(result.userid eq "jdoe")>
	
	</cffunction>

	<!--- 	decodeInvalidSignitureTest() as Void
			Description: Test decoding an invalid token
	---> 
	<cffunction name="decodeInvalidSignitureTest" output="false" mxunit:expectedException="Invalid Token">
		<cfset var local = structNew()>
		
		<cfset var result = jwt.decode(testTokenInvalid)>
	
	</cffunction>

	<!--- 	verifyTest() as Void
			Description: Test verifying the signiture of the token create in the first test
	---> 
	<cffunction name="verifyTest" output="false" order="4">
		<cfset var local = structNew()>
		
		<cfset var result = jwt.verify(token)>
		
		<cfset assert(result eq true)>
	
	</cffunction>

	<!--- 	verifyInvalidTokenTest() as Void
			Description: Test verifying and invalid token signiture
	---> 
	<cffunction name="verifyInvalidTokenTest" output="false" order="5">
		<cfset var local = structNew()>
		
		<cfset var result = jwt.verify(testTokenInvalid)>

		<cfset assert(result eq false)>
	
	</cffunction>

	
</cfcomponent>