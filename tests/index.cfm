<cfsetting showDebugOutput="false">
<!--- Executes all tests in the 'specs' folder with simple reporter by default --->
<cfparam name="url.reporter" 		default="simple">
<cfparam name="url.directory" 		default="tests.specs">
<cfparam name="url.recurse" 		default="true" type="boolean">
<cfparam name="url.bundles" 		default="">
<cfparam name="url.labels" 			default="">
<cfparam name="url.reportpath" 		default="#expandPath( "/tests/results" )#">
<cfparam name="url.propertiesFilename" 	default="TEST.properties">
<cfparam name="url.propertiesSummary" 	default="false" type="boolean">
<cfif structKeyExists(server, "lucee")>
	<cfoutput>Lucee Version #server.lucee.version#</cfoutput>
<cfelse>
	<cfoutput>Adobe CF Version #server.coldfusion.productVersion#</cfoutput>
</cfif>
<!--- Include the TestBox HTML Runner --->
<cfinclude template="/testbox/system/runners/HTMLRunner.cfm" >
