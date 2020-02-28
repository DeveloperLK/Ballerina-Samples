import ballerina/io;
import ballerina/http;
import ballerina/log;
import firstSubService;
import secondSubService;

function __init() {
    
    io:println("Main Service!");

    var serviceOneAttachResult = firstSubService:endpoint.__attach(firstSubService:getService());
    if(serviceOneAttachResult is error){
        io:println("Error when attaching the service to the listener");
    }
    else{
        var serviceOneStartResult = firstSubService:endpoint.__start();
        if(serviceOneStartResult is error){
            io:println("Error when starting the service");
        }
    }

    var serviceTwoAttachResult = secondSubService:endpoint.__attach(secondSubService:getService());
    if(serviceTwoAttachResult is error){
        io:println("Error when attaching the service to the listener");
    }
    else{
        var serviceTwoStartResult = secondSubService:endpoint.__start();
        if(serviceTwoStartResult is error){
            io:println("Error when starting the service");
        }
    }
   

}


@http:ServiceConfig {
    basePath: "/mainBase"
}
service mainService on new http:Listener(3000) {
    
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/sayHello"
    }
    resource function sayHelloMainService(http:Caller caller, http:Request req) {
        var result = caller->respond("Hello From main Service!");
        if (result is error) {
            log:printError("Error sending response", result);
        }
    }
}
