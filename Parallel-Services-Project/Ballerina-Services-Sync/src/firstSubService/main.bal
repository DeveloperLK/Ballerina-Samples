import ballerina/http;
import ballerina/log;

public listener http:Listener endpoint = new(8080);

service SubService_One = @http:ServiceConfig {
    basePath: "/serviceOneBase"
}
service {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/sayHello"
    }
    resource function sayHelloSubService_One(http:Caller caller, http:Request req) {

        // resource function execution
        var result = caller->respond("Hello From firstSubService!");
        if (result is error) {
            log:printError("Error sending response", result);
        }

   }

};

// public listener http:Listener endpoint = new(8080);

// service SubService_One = service {
    
//     resource function sayHelloSubService_One(http:Caller caller, http:Request req) {
    
//         var result = caller->respond("Hello World firstSubService!");
//         if (result is error) {
//             log:printError("Error sending response", result);
//         }
//     }

// };

// public function getService() returns service{
//     return SubService_One;
// }


public function getService() returns service{
    return SubService_One;
}