/**
* cf-jwt-simple TestBox Suite
*/
component extends="testbox.system.BaseSpec"{
	
/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
	}

	function run( testResults, testBox ){
		describe( "cf-jwt-simple TestBox Suite", function(){

			beforeEach(function( currentSpec ){
				myPrivateKey = "abcdefg";
				jwt = new root.jwt(myPrivateKey);

				/* Test tokens can be generated at https://jwt.io/ and Epoch time from http://www.epochconverter.com/*/
				testData = {
					payload = {
					  "sub": "1234567890",
					  "name": "John Doe",
					  "admin": true
					},
					// Uses payload 
					validToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.e0CFuBLfhSbH7bQIVrIODvMIcdiKBpmk0TVcWE288dQ",
					invalidFormatToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0cyI6IkZlYnJ1YXJ5LCAwNSAyMDE0IDEyOjA4OjA1IiwidXNlcmlkIjoiamRvZSJ9",
					// Payload signed with invalid signature
					invalidToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.ruc_ziwPAc2QnO2zrrrEL_Fn-SSjtczeW4SeQGcjUn0",
					/* 
					exp: 2037-12-31 17:00:00 GMT Last year that we can convert using dateAdd in ACF
					{
					  "iss": "http://myapi",
					  "aud": "clientid",
					  "exp" : 2145891600
					  "sub": "1234567890",
					  "name": "John Doe",
					  "admin": true
					} */
					tokenWithClaims = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwOi8vbXlhcGkiLCJhdWQiOiJjbGllbnRpZCIsImV4cCI6MjE0NTg5MTYwMCwic3ViIjoiMTIzNDU2Nzg5MCIsIm5hbWUiOiJKb2huIERvZSIsImFkbWluIjp0cnVlfQ.EGZZwFvl9q_44Pq5wH18FZ_R4r7FsXegkf_onRvQqU8",
					//exp: 1999-01-01 00:00:00
					expiredTokenWithClaims = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwOi8vbXlhcGkiLCJhdWQiOiJjbGllbnRpZCIsImV4cCI6OTE1MTQ4ODAwLCJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.HZXXIsXFO6yp8SDlL91PpuPVo_fbMXxKzOj4lCNkaV8",
					//nbf: 1999-01-01 00:00:00 GMT
					validNotBefore = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjkxNTE0ODgwMCwic3ViIjoieHl6In0.-KjrG0ktPVz-RrEhf79NCiWASljbA--wYjK2ykC_bbw",
					//nbf: 2999-01-01 00:00:00 GMT
					invalidNotBefore = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjMyNDcyMTQ0MDAwLCJzdWIiOiJ4eXoifQ.I13RhKA9iflSJ2xLHxgUARYe7IRuf7J_MlGFkNKj3cQ"
				};
		
			});

			describe( "encode()", function(){

				it( "should return a valid JWT formatted token", function(){
					var token = jwt.encode(testData.payload);

					expect(	listLen(token,".") ).toBe(3);
				});

			});

			describe( "decode()", function(){

				it( "should return data decoded from JWT in a struct", function(){

					var result = jwt.decode(testData.validToken);

					expect(	result ).toBeStruct();
					expect(	result.sub ).toBe(1234567890);
					expect(	result.name ).toBe("John Doe");
				});

				it( "should throw an error for token with an invalid format", function(){

					expect( function(){ 
						jwt.decode(testData.invalidFormatToken);
					} ).toThrow( type="Invalid Token", regex = "Token should contain 3 segments" );

				});

				it( "should throw an error for token signed with the wrong key", function(){

					expect( function(){ 
						jwt.decode(testData.invalidToken);
					} ).toThrow( type="Invalid Token", regex = "Signature verification failed: Invalid key" );

				});

				it( "should verify token nbf (Not Before) claim ", function(){
					var data = jwt.decode(testData.validNotBefore);
					expect(	data.sub ).toBe("xyz");
					expect( DateAdd("s",data.nbf,DateConvert("utc2Local","January 1 1970 00:00"))).toBeLT(now());
				});

				it( "should fail if nbf is prior to current date and time", function(){

					expect( function(){ 
						jwt.decode(testData.expiredTokenWithClaims);
					} ).toThrow( type="Invalid Token", regex = "Signature verification failed: Token expired" );

				});

				it( "should verify token is not expired", function(){
					var data = jwt.decode(testData.tokenWithClaims);
					expect(	data.name ).toBe("John Doe");
				});

				it( "should fail for an expired token", function(){

					expect( function(){ 
						jwt.decode(testData.expiredTokenWithClaims);
					} ).toThrow( type="Invalid Token", regex = "Signature verification failed: Token expired" );

				});

				it( "should not fail for an expired token when ignoreExpiration is true", function(){

					var jwt = new root.jwt(key="abcdefg",ignoreExpiration=true);
					 
					var data = local.jwt.decode(testData.expiredTokenWithClaims);
					expect(	data.name ).toBe("John Doe");

				});

				it( "should verify the issuer if provided", function(){
					var jwt = new root.jwt(key="abcdefg",issuer="http://myapi");
					var data = local.jwt.decode(testData.tokenWithClaims);
					expect(	data.iss ).toBe("http://myapi");
				});

				it( "should throw an error if issuer does not match", function(){
										
					var jwt = new root.jwt(key="abcdefg",issuer="http://test.issuer.com");
					expect( function(){ 
						jwt.decode(testData.tokenWithClaims);
					} ).toThrow( type="Invalid Token", regex = "Signature verification failed: Issuer does not match" );

				});

				it( "should verify the audience if provided", function(){
					var jwt = new root.jwt(key="abcdefg",audience="clientid");
					var data = local.jwt.decode(testData.tokenWithClaims);
					expect(	data.aud ).toBe("clientid");
				});

				it( "should throw an error if audience does not match", function(){
										
					var jwt = new root.jwt(key="abcdefg",audience="xyz");
					expect( function(){ 
						jwt.decode(testData.tokenWithClaims);
					} ).toThrow( type="Invalid Token", regex = "Signature verification failed: Audience does not match" );

				});



			});

			describe( "verify()", function(){
			
				it( "should return true for a valid token", function(){
					var result = jwt.verify(testData.validToken);

					expect(	result ).toBeTrue();
				});

				it( "should return false for an invalid token", function(){
					var result = jwt.verify(testData.invalidToken);

					expect(	result ).toBeFalse();
				});

			});

			
		});
	}
	
}