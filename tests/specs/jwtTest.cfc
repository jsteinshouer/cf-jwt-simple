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
					invalidToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.ruc_ziwPAc2QnO2zrrrEL_Fn-SSjtczeW4SeQGcjUn0"
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