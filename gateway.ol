include "console.iol"
include "database.iol"
include "time.iol"
include "../db_service/customer_iface.iol"
include "/db_service/user_iface.iol"
include "/db_service/DBConnector_iface.iol"
include "runtime.iol"
include "protocols/http.iol"
include "MonitoringTool/LeonardoWebServer/config.iol"


execution{ concurrent }

outputPort DB_Connector {
	Location: "socket://localhost:1000/"
	Protocol: sodep
	Interfaces: ConnectionPool
}

outputPort Auth_Service{
	Location: "socket://localhost:9000"
	Protocol: sodep
	Interfaces: Users
}

//Note: The gateway runs the monitoring service
outputPort Monitor {
	Location: "socket://localhost:8005/"
	Interfaces: Customers
}

//Note: the gateway runs the leonardo server to show what it is 
//in the monitoring service.
outputPort HTTPInput {
	Location: Location_Leonardo //global variable
}


inputPort Gateway{
	Location: "socket://localhost:2000"
	Protocol: sodep
	Interfaces: Users, ConnectionPool
	//Redirection used with the static embedding of services.
	Redirects: MonitoringTool => Monitor,	
			   LeonardoWebServer => HTTPInput
}

embedded 
{       //Static embedding of services.
		Jolie:  "/MonitoringTool/Monitor.ol" in Monitor, //Embedding the monitor service, that will be user by the web application.
		        "/MonitoringTool/LeonardoWebServer/leonardo.ol" in HTTPInput, //Embedding the leonardo web server.
				"/db_service/DBConnector.ol" //Embedding the database connector.

}
	
init
{   //The init will execute this operations when the service starts.
	//Connecting the database. The configuration is hidden.
	connectionConfigInfo@DB_Connector()(connectionInfo);
	connect@Database(connectionInfo)();


        //Querying the service_registry table, in order to simulate the service discovery.
       q = "select * from service_registry";
            	query@Database(q)(result);



            	for ( i = 0, i < 3, i++ ) {
            	//Printing what is retrieved from the service_registry table.
                	println@Console(         "Service id: "+ result.row[i].service_id +
                    						 "\n"+
                    						 "Service context: "+ result.row[i].context +
                    						 "\n"+
                    						 "Service protocol: "+ result.row[i].protocol +
                    						 "\n"+
                    						 "Service Input port: "+ result.row[i].input_port +
                    						 "\n"+
                    						 "Service Filepath: "+ result.row[i].filepath +
                    						 "\n"+
                    						 "Service Location: "+ result.row[i].location)();
                       //Loading the collection of services retrieved from the service_registry table.
                    	embedInfo.type = "Jolie";

                       //The path within the project folder structure.
                        embedInfo.filepath = result.row[i].filepath;

                        //Loading the service i.
                        loadEmbeddedService@Runtime( embedInfo )( result.row[i].context.location )
                }



}			

main
{
	start()



}






