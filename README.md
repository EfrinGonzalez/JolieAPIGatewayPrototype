# JolieAPIGatewayPrototype
Master Thesis project on Microservices and Jolie Programming Language.

Before you start the services, you should have a MySql database as follows:
name: test
tables: customer, product, service_registry, users
There is a full set of queries in this folder structure, at: /db_service/ReadMe_DBNotes.txt


To start the software go to the command line and look for main root of the project, and write: jolie gateway.ol
Then, the services will run and the information can be retrieved, for instance, at:
Retrieve all customers: http://localhost:8001/retrieveAll
Retrieve all userss: http://localhost:8002/retrieveAll
Retrieve all products: http://localhost:8002/retrieveAll
For more information on the API, check the Master Thesis at: API Gateway section

