# cf-jwt-simple

## Description

CFML Component for encoding and decoding [JSON Web Tokens (JWT)](http://self-issued.info/docs/draft-ietf-oauth-json-web-token.html).

This is a port of the node.js project [node-jwt-simple](https://github.com/hokaccha/node-jwt-simple) to cfml. It currently supports HS256, HS384, and HS512 signing algorithms.


## Usage
	<!--- Initialize the component with the secret signing key --->
    <cfset jwt = createObject("component","jwt").init(secretkey)>
	<cfset payload = {"ts" = now(), "userid" = "jdoe"}>
	<!--- Encode the data structure as a json web token --->
	<cfset token = jwt.encode(payload)>
	<!--- Decode the token and get the data structure back. This is will throw an error if the token is invalid --->
	<cfset result = jwt.decode(token)>

