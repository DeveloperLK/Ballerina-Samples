// import ballerina/jwt;
import ballerina/io;
import ballerina/http;
import ballerina/runtime;

import ballerina/encoding;
import ballerina/internal;


import ballerina/mime;

string JWT_HEADER = "Authorization";
// Define the endpoint in an HTTP client.
http:Client backendClient = new("http://10.100.0.51:8280/services/test");


listener http:Listener ep = new(9090, config = {

});


@http:ServiceConfig {
    basePath: "/hello"
}
service sampleService on ep {
    


    @http:ResourceConfig {
        methods: ["GET"],
        path: "/sayHello"
    }
    resource function requestRouter(http:Caller caller, http:Request req) {
            // Define http response for forwarded request.
            http:Response|error res;

            // Get the Authorization header from the request and remove the Bearer string.
            string header_ = req.getHeader(JWT_HEADER);
            string header = header_.replace("Bearer ", "");
            io:println(header); 

            // Decode the jwt body and get the json object.
            json|error decodedToken = getJWTComponents(header);   
            
            io:println("decodedToken");
            io:println(decodedToken);


            // Check whether the decoded token is not error.
            if (decodedToken is json) {
                

                io:println("Inside decodeToken");

                // Extract the required parameter from the token. 
                // The param is returned as a json, and need to convert to string.
                string subProperty = decodedToken.sub.toString();

                io:println("subProperty");
                io:println(subProperty);

                json j = {
                    "sub": subProperty
                };

                http:Request requ = new;

                ()|error reqStatus = requ.setContentType(mime:APPLICATION_JSON);
                if(reqStatus is ()){
                    requ.setJsonPayload(j);
                }
                else{
                    io:println("Error setting the content-type");
                }

                res = backendClient->post("/",requ);

                io:println("res");
                io:println(res);

                if (res is http:Response) {
                    // If respons is success, send the response back to the client.
                    var result = caller->respond(res);
                    io:println(result); // For testing: print the response.

                    // Set the runtime variable to break the request flow.
                    var runTime = runtime:getInvocationContext();
                    runTime.attributes["breakRequestFlow"] = true;
                }    
      
            }

       
    }
}



// Split the jwt token, decode the body and retuen the json object.
function getJWTComponents(string jwtToken) returns json|error {
    string[] jwtComponents = jwtToken.split("\\.");
    string jwtPayload = encoding:byteArrayToString(check
        encoding:decodeBase64(urlDecode(jwtComponents[1])));

    json jwtPayloadJson = {};

    var jsonPayloaad = internal:parseJson(jwtPayload);
    if (jsonPayloaad is json) {
        jwtPayloadJson = jsonPayloaad;
    } else if (jsonPayloaad is error) {
        return jsonPayloaad;
    }
    return jwtPayloadJson;
}

// URL decode the encoded jwt string.
function urlDecode(string encodedString) returns (string) {
    string decodedString = encodedString.replaceAll("-", "+");
    decodedString = decodedString.replaceAll("_", "/");
    return decodedString;
}