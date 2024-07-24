# TowEase_Service_Flutter_Mobile_Application
The "TowEase" mobile application aims to provide comprehensive roadside assistance services, including towing, fuel delivery, and mechanical help, tailored to users' vehicle types and locations. Built using Flutter and Firebase, the app offers real-time tracking, service booking, and automatic route optimization based on vehicle size.

TowEase

Tools and Technologies:
Flutter: For developing the cross-platform mobile application.
Firebase:
Firebase Authentication: For user authentication and secure login.
Firebase Firestore: For real-time database management.
Firebase Cloud Messaging: For sending notifications to users.
Firebase Analytics: For tracking user interactions and app performance.
Google Maps API: For location services, including tracking and navigation.
Mapbox: Alternative to Google Maps for advanced mapping and custom map styles.
Dart: The programming language used for Flutter development.
RESTful APIs: For backend services and communication between the app and server.
Geolocation and Geocoding APIs: For determining the user's location and converting it to a readable address.
Google Places API: For locating nearby service centers and petrol stations.
Stripe or PayPal SDKs: For integrating payment systems for services.
Firebase Cloud Functions: For backend logic, such as calculating routes or processing bookings.
Additional Features:
Push Notifications: To alert users of updates, service status, or emergency situations.
Real-time Tracking: For monitoring the location of the towing vehicle and user.
In-app Chat or Call Feature: For communication between users and service providers.
Multilingual Support: To cater to a diverse user base.
Offline Support: Basic functionality when the user is offline.

Software Engineering Project
Towing machine and fuel service management Application:
(Katta Sathwik 20mcme16 and Rohit 19mcme11)

Problem Statement :

1) This application will be used for providing towing machine service when the user vehicle get damaged due to some technical issues.

2) This application will be used for providing fuel service, by which the towing machine will take user vehicle to the nearest petrol bunk in case user fuel got completed suddenly.

3) This application will be used for providing the road side mechanic service in case if the vehicle was large in which that was not movable due to some reason.

4) In this application the user can book the towing machine of different type based on their persenal vehicle type.

5) In this application the user can track the exact location of the booked towing machine and also track the user location.

6) In this appication the user can select the specific service center if user vehicle got damaged, and by default the towing machine will take the vehicle to the nearest service center.

7) This application will be used for tracking the ambulace in case if the registered mobile is linked with the ambulance emergency number.

8) In general case the maps will show the shorest distance between the user and the destination but in case the roads were shortest width in the ongoing way then the towing machine can not go through that road so inorder to avoid this difficulties, this application will provide an inbuild map in which this map will show the shorted distance as well as vehicle size sufficient roads.

9) This application will show the red line mark near the ongoing way in case the road width was short, and green line mark if the road width was enough in order to go the towing vehicle.

10) This appilcation will automatically select towing machine based on the user vehicle model and size of that vehicle.


Feasibility Analysis:

	Technical Feasibility :
	1) Accessing location through Google maps API services.
	2) Accessing advanced FusedlocationClient API in order to track the road width.
	3) The languages used inorder to develop this application we need xml, java, html5, css, 	javascript, nodejs,  mongodb, jdbc, kotlin.

	Operational Feasibility :
	1) customers need to have a smart phone along with GPS tracking.
	2) They need to enable permission for accessing location in order to track the user and 	booked vehicle location.
	4) customers need to Register in order to book an towing vehicle.

	Economical Feasibility :
	1) In the process of development of this application we will use an using open source 	softwares / APIs.
	2) Initially there is no cost associated in developing this application as we were using open 	source softwares / APIs.

	This application helps in  providing the service to the vehicles.

Requirements Engineering :

	User Requirements :
	1) We have made agile user stories in the excel file that was provided in the mail.

	Major System Requirements and Specifications:
	1) We need to access the location using an API from google
	2) We need to set Latitude and Longitude ranges to specify a particular location.
	3) Able to track the width of the roads based on the towing vehicle.

Product Backlog :
	● We need to create an Android Project or Web project based on the condition.
	● We need to create a Basic UI
	● We need to create Register and Login Forms for the user.
	● We need to create a Database
	● There should be connection between database and Application.
	● We need to develop a way of accessing the location of the user through java and API
	● We need display then location on the application in the range india
	● We need to set different ranges across the india.
	● We need to create user and vechile and specific locations database
	● We need to provide the choice for selecting their own service center.
	● /*Create a portal for the teacher to access and view the students who are
	currently in the class and submit the attendance.*/
	● The application will able to send autogenerated SMS/email/Notifications to the driver or 	 worker if user books the towing machine.
	● An User Interface for driver and user in order to check the location.
	● An alert for the driver will be be generated by the application if driver goes near to the  	road that is smaller than the towing machine.

Use Case Modeling : ( made diagrams in draw.io )

1. Identifying Actor :
	Customer
	Driver
	Worker

2. Identifying behavior
	Customer – can book towing machine, can track the towing machine location, can get the 	message if towing machine reached the destination, can track the ambulance if that called 	number get registered.
	Driver – has to take the vehicle to the destination.
	Worker – if there is need (incase that vehicle wasnt moveable) for the customer this actor 	will go near the customer destination.

3. Preliminary use case diagram drawn in star uml.
4. Use case diagrams are refined.
5. Identifying Analysis Classes.

USE CASE SPECIFICATION - Towing Booking

Precondition: Registered user
Postcondition: Towing machine will be booked and user can reach to the destination.
Assumptions: GPS location should be enabled.

Normal Flow:
1. Turning on Location by customer.
2. customer should open the ziptowing appilcation.
3. customer should upload his vehicle type in the application.
4. Based on the uploaded vehicle the customer can select the nearest towing machine type that is suitable to customer vehicle.
5. Book towing machine and driver can reach to the destination.

Alternate Flow :
A.1. Terminate Use case
A.3. If the vehicle wasnt uploaded by the customer the application will it automatically recommend
a towing machine.

Analysis Classes Obtained from the Use Case Specification :
customer,
Driver,
Worker
Location

USE CASE SPECIFICATION - CHECK Availability Of Towing machine.
Preconditions : Customer should be registered.
Postcondition: Towing machine will be booked and user can reach to the destination.
Assumptions: GPS location should be enabled.

Normal Flow :
1. open the application.
2. current location will be detected.
3. neartest towing machines will be displayed.

Alternate Flow :
A.1. Terminate use case
A.3. wait for the availability of towing machine.

USE CASE SPECIFICATION - Acceptance of Towing machine.
Preconditions : Customer should book the towing machine.
Postcondition: accepted Towing machine driver will reach to the location.
Assumptions: GPS location should be enabled.

Normal Flow :
1. open the application.
2. current location will be detected.
3. book the towing machine.
3. driver will accept the request.

Alternate Flow :
A.1. Terminate use case
A.3. wait untill the driver accept the request.

USE CASE SPECIFICATION – Update location of destination.
Preconditions : Customer should book the towing machine.
Postcondition: Towing machine driver will drop at updated location.
Assumptions: GPS location should be enabled.

Normal Flow :
1. open the application.
2. current location will be detected.
3. update loctaion of destination.
3. driver will drop at the location.

Alternate Flow :
A.1. Terminate use case

USE CASE SPECIFICATION – Update location of destination.
Preconditions : Customer should book the towing machine.
Postcondition: Towing machine driver will drop at updated location.
Assumptions: GPS location should be enabled.

Normal Flow :
1. open the application.
2. current location will be detected.
3. update loctaion of destination.
3. driver will drop at the location.

Alternate Flow :
A.1. Terminate use case

