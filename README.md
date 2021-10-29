# Catalyst

Catalyst iOS SDK is a library that enables you to build iOS apps for your Catalyst project. The Catalyst iOS SDK package contains a host of tools and functionalities that help you in developing dynamic and robust iOS apps, with powerful backends.

The iOS SDK package enables you to handle several back end jobs such as user 

- **Authentication** : Catalyst Authentication feature enables you to add end-users to your Catalyst serverless applications, configure their user accounts and roles, and manage user sign-in and authentication of your application directly from the Catalyst console.

- **Data Store** : The Data Store in Catalyst is a cloud-based relational database management system which stores the persistent data of your application. This data repository includes the data from the application's backend and the data of the application's end users. The Catalyst Data Store enables you to perform data manipulations such as adding new tables, adding and modifying records, defining field characteristics, and deleting data.

- **File Store functionalities**: Catalyst File Store provides cloud storage solutions to store, manage, and organise your application files and user data files. The files can be images, videos, text files, document files, spreadsheets, or other formats. Catalyst provides storage for all file formats and helps you categorise them in folders.

- **Function executions** : Catalyst Functions are custom-built coding structures which contain the intense business logic of your application. Functions allow you to store the functionality of the application in a centralised and secure place, rather than storing it within the application's main code. The application uses APIs to invoke functions from the Catalyst servers when needed.

You can seamlessly integrate these Catalyst components in your iOS app by implementing the ready-made functionalities provided by the SDK package, and build on them easily. This saves you from investing time and effort into coding the backend from scratch, and helps you focus more on designing the user experience of the app.


 Home / Catalyst Readme
Catalyst Readme
 ZCATALYST iOS SDK
Catalyst iOS SDK is a library that enables you to build iOS apps for your Catalyst project. The Catalyst iOS SDK package contains a host of tools and functionalities that help you in developing dynamic and robust iOS apps, with powerful backends.

The iOS SDK package enables you to handle several back end jobs such as user 

- Authentication : Catalyst Authentication feature enables you to add end-users to your Catalyst serverless applications, configure their user accounts and roles, and manage user sign-in and authentication of your application directly from the Catalyst console.

- Data Store : The Data Store in Catalyst is a cloud-based relational database management system which stores the persistent data of your application. This data repository includes the data from the application's backend and the data of the application's end users. The Catalyst Data Store enables you to perform data manipulations such as adding new tables, adding and modifying records, defining field characteristics, and deleting data.

- File Store functionalities : Catalyst File Store provides cloud storage solutions to store, manage, and organise your application files and user data files. The files can be images, videos, text files, document files, spreadsheets, or other formats. Catalyst provides storage for all file formats and helps you categorise them in folders.

- Function executions : Catalyst Functions are custom-built coding structures which contain the intense business logic of your application. Functions allow you to store the functionality of the application in a centralised and secure place, rather than storing it within the application's main code. The application uses APIs to invoke functions from the Catalyst servers when needed.

You can seamlessly integrate these Catalyst components in your iOS app by implementing the ready-made functionalities provided by the SDK package, and build on them easily. This saves you from investing time and effort into coding the backend from scratch, and helps you focus more on designing the user experience of the app.

## 📜 Content 
- [Requirement](#-requirements)
- [Example Build](#-example-build)
- [Documentation](#-documentation)
- [SDK Responsibilities](#-sdk-responsibilities)
- [Installation](#-installation)
- [Author](#-author)
- [License](#-license)

## 📋 Requirements
- Xcode 9 and Above

- Swift 4.2

## 🏗 Example Build
To run the example project, clone the repo, and run pod install from the Example directory first.

## 📖 Documentation 
- The full documentation for Catalyst API can be found on our [website](https://catalyst.zoho.com/help/sdk/ios/overview.html).

- The Catalyst SDK documentation discusses components, APIs, and topics that are specific to Catalyst SDK. For further documentation on the Catalyst API refer to the [Catalyst API documentation](https://catalyst.zoho.com/help/api/introduction/overview.html).

## SDK Responsibilities
Scaffolding - Zoho CRM dependencies inclusion and base project creation.

Authentication - User login and logout.

API wrapping & version upgrades - API requests wrapped as method calls.

Data modeling - Catalyst entities modeled as language objects.

Metadata caching - Essential metadata are cached to avoid unnecessary API calls.

The mobile SDK takes care of the above, so that the developers can focus only on the UI components of the mobile app.

## ⬇️ Installation
Catalyst is available through CocoaPods. To install it, simply add the following line to your Podfile:

pod 'ZCatalyst', :git => 'https://github.com/zoho/Catalyst-iOS-SDK.git', :tag => '2.0.1'

## ✍️ Author
@Zohocorp

## 📄 License
Catalyst is available under the MIT license. See the LICENSE file for more info.
