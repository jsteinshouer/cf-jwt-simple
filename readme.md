# CF-JWT-Simple

## Description

CFML Component for encoding and decoding [JSON Web Tokens (JWT)](http://self-issued.info/docs/draft-ietf-oauth-json-web-token.html).

This is a port of the node.js project [node-jwt-simple](https://github.com/hokaccha/node-jwt-simple) to cfml. It currently supports HS256, HS384, and HS512 signing algorithms.


## Usage
	<!--- Initialize the component with the secret signing key --->
    <cfset jwt = new jwt(secretkey)>
	<cfset payload = {"ts" = now(), "userid" = "jdoe"}>
	<!--- Encode the data structure as a json web token --->
	<cfset token = jwt.encode(payload)>
	<!--- Decode the token and get the data structure back. This is will throw an error if the token is invalid --->
	<cfset result = jwt.decode(token)>

## Support for registered claims

This CFC supports the `nbf` and `exp` registered claims that can be part of the payload. Verification of the token will fail if the token is not yet active or if the token is expired according to the `nbf` and `exp` claims. They should be numeric dates in Unix epoch time according to the JWT spec.

To ignore the `exp` claim during verification, pass `ignoreExpiration=true` when instantiating the CFC. For example:

	<cfset jwt = new jwt(key=secretkey, ignoreExpiration=true)>

This CFC also supports the `aud` and `iss` registered claims during verification. If you don't pass `audience` or `issuer` during instantiation, the claims will be ignored during verification. If you do pass them, they'll be included during the verification process. Here's an example:

	<cfset jwt = new jwt(key=secretkey, audience="myaudiencevalue", issuer="myissuervalue")>
