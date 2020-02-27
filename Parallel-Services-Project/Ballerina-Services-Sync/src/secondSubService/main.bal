import ballerina/http;
import ballerina/log;

public listener http:Listener endpoint = new(9090);

service SubService_Two = @http:ServiceConfig {
    basePath: "/serviceTwoBase"
}
service {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/sayHello"
    }
    resource function sayHelloSubService_Two(http:Caller caller, http:Request req) {

        // resource function execution
        var result = caller->respond("Hello World secondSubService!");
        if (result is error) {
            log:printError("Error sending response", result);
        }

   }

};


public function getService() returns service{
    return SubService_Two;
}