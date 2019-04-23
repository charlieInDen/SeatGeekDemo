# SeatGeekDemo
This is a simple project showing how to implement pagnation functionality in UITableView. Compatible with Xcode 10 and Swift 5.
My aim of this project is to how we can write the optimal code with following iOS and Swift design patterns.
Implemented a type ahead against the Seat Geek API. The type ahead should update a list of results as the search query changes. Results can be tapped to view them on a details screen. On the details screen the result can be favorited. On the type ahead screen, results matching the favorites list should show a visual indication that they are favorited.

# Pre-requisite:
1. Install Carthage - https://github.com/Carthage/Carthage
Get Carthage by running brew install carthage.
2. Install swiftlint - https://github.com/realm/SwiftLint
brew install swiftlint
3. Xcode 10.2 & Swift 5

# Features included: 
1. MVP architecture
2. Pagination 
3. Search functionality 
4. Detail view of all data

Summary

# API Information
The endpoint to use on Seat Geek is free and publicly accessible, but you will need to register for a Seat Geek account and obtain an API key to use it. Details can be found at http://platform.seatgeek.com/

You will pass in the url param of q which will correspond to the search query. For example, the below query will give a result set for the term Texas Ranger.

https://api.seatgeek.com/2/events?client_id=<your client id>&q=Texas+Ranger
Full API documentation is available at http://platform.seatgeek.com/#events

#### Suggestions and contributions are welcome! 
