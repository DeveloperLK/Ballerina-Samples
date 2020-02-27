import ballerina/http;
import ballerina/log;

public listener http:Listener endpoint = new(9090);

service SubService_Two = service {
    
    resource function sayHelloSubService_Two(http:Caller caller, http:Request req) {
        
        var result = caller->respond("Hello World secondSubService!");
        if (result is error) {
            log:printError("Error sending response", result);
        }
    }

};

public function getService() returns service{
    return SubService_Two;
}