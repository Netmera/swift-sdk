# Netmera iOS SDK Quick Start Guide

Welcome to the Netmera iOS SDK Quick Start Guide. This guide provides a step-by-step tutorial for integrating the Netmera iOS SDK into your iOS app.

## Requirements

-   Xcode 13 or later
-   iOS 11.0 or later

## Installation

1.  Add Netmera to your Podfile
````ruby
pod "NetmeraAnalytic" // to use Netmera analytic features
#pod "NetmeraAnalyticAutotracking" // to use auto tracking features
#pod "NetmeraNotification" // to use Netmera push notification features
#pod "NetmeraAdvertisingId" // to use Netmera advertising identifier features
#pod "NetmeraLocation" // to use Netmera location features
#pod "NetmeraGeofence" // to use Netmera geofence features
#pod "NetmeraNotificationInbox" // to use Netmera push inbox features
#pod "NetmeraLiveActivity" // to use Live Activity features
````

2.  Run `pod install` command in your terminal.

## Initialization

1.  Import the Netmera framework in your AppDelegate.swift file:

```swift
import NetmeraAnalytic
import NetmeraNotification
import NetmeraLocation
import NetmeraNotificationInbox
import NetmeraAdvertisingId
import NetmeraLiveActivity
```

2. Initialize Netmera in your App.

There are two ways to initialize Netmera.

#### First Option: (Recommended)
Configure with Plist. Add Netmera-Config.plist file to your project. Copy the following code into the Plist file and replacing the  `API_KEY` placeholders with your actual API Key value.

```xml

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>sdk_params</key>
	<dict>
		<key>app_group_name</key>
		<string>{AppGroupName}</string>
		<key>api_key</key>
		<string>{API_KEY}</string>
		<key>base_url</key>
		<string>{BaseURL}</string>
		<key>custom_events</key>
		<array>
			<string>{YourCustomEvent}</string>
		</array>
	</dict>
	<key>location_max_active_region</key>
	<string></string>
	<key>in_app_message_settings</key>
	<dict>
		<key>TextColor</key>
		<string>{hexcolor. For ex-&gt; 16777215}</string>
		<key>TitleColor</key>
		<string>{hexcolor. For ex-&gt; 16777215}</string>
		<key>BackgroundColor</key>
		<string>{hexcolor. For ex-&gt; 16777215}</string>
		<key>CancelButtonBackgroundColor</key>
		<string>{hexcolor. For ex-&gt; 16777215}</string>
		<key>TitleFont</key>
		<string>{font family name. ex -&gt; ariel}</string>
		<key>TextFont</key>
		<string>{font family name. ex -&gt; ariel}</string>
		<key>CancelButtonRadius</key>
		<string>{10 sd px}</string>
		<key>ShadowOpacity</key>
		<string>{0-1}</string>
		<key>BottomPaddingRatio</key>
		<string>{between 0.01 - 1}</string>
		<key>CancelButtonImage</key>
		<string>{imagename}</string>
	</dict>
	<key>blacklist_screen_names</key>
	<array/>
</dict>
</plist>

```

Call Netmera initialize method in your `application(_:didFinishLaunchingWithOptions:)` method.

```swift
Netmera.initialize()
```

#### Second Option:
Add the following code to your `application(_:didFinishLaunchingWithOptions:)` method, replacing the  `API_KEY` placeholders with your actual API Key value:

```swift
let netmeraParams = NetmeraParams(
  apiKey: "API_KEY",
  baseUrl: "", // Optional; For On-premise setup
  appGroupName: "", // Optional; to use carousel&slider push
  customEvents: [CustomLoginEvent.self] // Optional; give list of all custom event class type
)
Netmera.initialize(params: netmeraParams)
Netmera.setLogLevel(.debug) // Options can be .debug, .info, .error, .fault
```

SDK_API_KEY : You can get that api key from Developers -> API -> Sdk Api Key from your web panel.

## Push Notifications

In your pod file, you should add `NetmeraNotification` and install to your app target like this;

````ruby
pod "NetmeraNotification"
````

Request push notification authorization from user by calling the following method in an appropriate place:

```swift
Netmera.requestPushNotificationAuthorization(for: [.alert, .badge, .sound])
```

> Calling this method will immediately prompt push notification permission dialog to user, therefore it's important for you to call this method after you informed user about how your application will utilize push notifications.

‼️ If you receive a push permission request from a push provider such as Apple, it is important to call the appropriate method in order for the Netmera SDK to handle interactive push buttons correctly. Failure to do so may result in these buttons not being properly handled by the SDK.

### Enable Push Notifications
Enable Push Notifications from Signing & Capabilities -> Capability -> Push Notifications in Xcode.

```swift
//in didFinishLaunchingWithOptions
// ‼️ Implement UNUserNotificationCenterDelegate methods in AppDelegate
UNUserNotificationCenter.current().delegate = self
```

```swift
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
	//
}
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
	//
}
```

Advanced Push Notification Management

### Push Notification Delegate Methods

Unless you need special use cases, Netmera handles all  `UIApplicationDelegate`  methods related to remote notifications, so you do not need to implement them in your App Delegate class.

However, if your application has use cases that require a custom implementation on remote notification delegate methods, you can freely implement them and perform your specific logic inside these delegate methods.

You can find detailed information about the delegate methods related to push notifications in  [UIApplicationDelegate Protocol Reference](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/index.html#//apple_ref/doc/uid/TP40006786-CH3-SW17)

>**Accessing NetmeraPushObject Inside Delegate Methods**  
SDK provides `[Netmera recentPushObject]/Netmera.recentPushObject()` method which returns the object representation of the remote notification payload. You can use this method to access the NetmeraPushObject instance corresponding to the remote notification inside your UIApplicationDelegate methods.

### Disable/Enable Popups , In App Messages and Widgets

When a popup notification or an in app message is received by the SDK, it immediately presents the corresponding web view content if the application is in foreground state. If application is in background state when popup is received, SDK presents the web view content whenever application comes to foreground state.

You may want to disable this immediate presentation behavior for cases like when your users watch a video, when they are in the middle of their favorite game level, or when they are about to finish purchasing their order. You use the following two methods to manage this process:

```swift
Netmera.setEnabledPopupPresentation(true) // to enable showing popup and widget push 
Netmera.setEnabledPopupPresentation(false) // to disable showing popup and widget push

Netmera.setEnabledInAppMessagePresentation(true) // to enable showing banner push 
Netmera.setEnabledInAppMessagePresentation(false) // to disable showing banner push 
```

>⚠️ If you want to recieve popups or in app messages while application is in background, you should enable Remote Notifications at Background Modes from Capabilities.
>
>⚠️ Also device cannot receive popups or in app messages while application is closed and killed while low battery mode is on. Because that mode disable background application refresh mode.

## Notification Service Extension Integration

To enable media attachments (images, videos, etc.) in push notifications, integrate the Netmera Notification Service Extension.

### 1. Add the Pod

Add the following line to your Podfile for your extension target:

```ruby
pod "NetmeraNotificationServiceExtension"
```

### 2. Create the Extension

1. In Xcode, go to **File > New > Target**.
2. Select **Notification Service Extension** and click **Next**.
3. Name your extension (e.g., `NotificationServiceExtension`) and click **Finish**.

### 3. Configure the Extension

In your extension's `NotificationService.swift` file, replace the content with:

```swift
import UserNotifications
import NetmeraNotificationServiceExtension

class NotificationService: NetmeraNotificationServiceExtension {
    // No additional implementation needed
}
```

### 4. Network Configuration

Add the following to your extension's `Info.plist` to allow HTTPS connections:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 5. Custom Push Icon Support

To enable custom push icons:

1. **Add Communication Notifications capability** to your main app target in Xcode.
2. **Add the following to your main app's `Info.plist`**:

```xml
<key>NSUserActivityTypes</key>
<array>
    <string>INSendMessageIntent</string>
</array>
```

3. **Add your custom icon image** to your extension target's asset catalog.

The SDK will automatically display the custom icon when the push payload contains the relevant field.

**⚠️ Warning**: Make sure to add the `Netmera-Config.plist` file to both Service Extension and Content Extension targets for proper configuration.

## Notification Content Extension Integration

To enable custom notification UI with carousel and slider support, integrate the Netmera Notification Content Extension.

### 1. Add the Pod

Add the following line to your Podfile for your extension target:

```ruby
pod "NetmeraNotificationContentExtension"
```

### 2. Create the Extension

1. In Xcode, go to **File > New > Target**.
2. Select **Notification Content Extension** and click **Next**.
3. Name your extension (e.g., `NotificationContentExtension`) and click **Finish**.

### 3. Configure the Extension

In your extension's `NotificationViewController.swift` file, replace the content with:

```swift
import UserNotifications
import UserNotificationsUI
import NetmeraNotificationContentExtension

class NotificationViewController: NotificationContentExtension {
    // No additional implementation needed
}
```

### 4. Supported Features

The extension automatically supports:

- **Carousel View**: Horizontal scrolling through multiple content items
- **Slider View**: Swipeable content with navigation
- **Custom Actions**: Forward and dismiss actions
- **Analytics**: Automatic push view event tracking

**⚠️ Warning**: Make sure to add the `Netmera-Config.plist` file to both Service Extension and Content Extension targets for proper configuration.

## Analytics

### Internal Events

By default, Netmera SDK automatically tracks and reports the following behaviors about application usage:

-   Install (First open) app
-   App opens
-   Time passed inside the application for each foreground usage
-   Push receipts (if configured from Dashboard)
-   Push opens
-   Enter/exit actions for geofence regions if any has been set up
-   Actions taken inside web views presented by Netmera
-   Log event (triggered when an error occured)

Other than default event tracking, SDK provides a rich set of built-in event classes which you can use to report users' corresponding behaviors inside your application.

Rather than accepting unstructured information inside events, SDK requires a predefined set of constraint related to attributes of events and their data types by means of these  `NetmeraEvent`  subclasses. This approach enables Netmera to verify type of the given event attributes, and force some attributes for a particular event type. These restrictions are crucial for providing reliable data during event analytics operations on Netmera servers.

You send events easily with the following code pattern:

```swift
// Generate event instance
// This can be any NetmeraEvent subclass
let event = NetmeraLoginEvent(userId: "user_id")
Netmera.send(event)
```

Below is the list of all built-in event classes — categorized by use cases — and their sample usage:

-   Common Events
    -   Screen View Event (`NetmeraScreenViewEvent`)
    -   Login Event (`NetmeraLoginEvent`)
    -   Register Event (`NetmeraRegisterEvent`)
    -   Search Event (`NetmeraSearchEvent`)
    -   Share Event (`NetmeraShareEvent`)
    -   In App Purchase Event (`NetmeraInAppPurchaseEvent`)
    -   Banner Click Event (`NetmeraBannerClickEvent`)
    -   Category View Event (`NetmeraCategoryViewEvent`)
    -   Battery Level Event (`NetmeraBatteryLevelEvent`)
    -   Open App Event (`NetmeraOpenAppEvent`)
    -   Location Update Event (`NetmeraLocationUpdateEvent`)
    -   Time In App Event (`NetmeraTimeInAppEvent`)
    -   Link Click Event (`NetmeraLinkClickEvent`)
    -   Location Authorization Event (`NetmeraLocationAuthorizationEvent`)
    -   Geofence Event (`NetmeraGeofenceEvent`)
    -   Notification Settings Event (`NetmeraNotificationSettingsEvent`)
    -   Push Receive Event (`NetmeraPushReceiveEvent`)
    -   Push View Event (`NetmeraPushViewEvent`)
    -   Push Dismiss Event (`NetmeraPushDismissEvent`)
    -   Popup Show Event (`NetmeraPopupShowEvent`)
    -   Push Open Event (`NetmeraPushOpenEvent`)
-   Commerce Events
    -   Product View Event (`NetmeraProductViewEvent`)
    -   Product Rate Event (`NetmeraProductRateEvent`)
    -   Product Comment Event (`NetmeraProductCommentEvent`)
    -   Order Cancel Event (`NetmeraOrderCancelEvent`)
    -   Purchase Event (`NetmeraInAppPurchaseEvent`)
    -   Cart View Event (`NetmeraCartViewEvent`)
    -   Add To Cart Event (`NetmeraCartAddProductEvent`)
    -   Remove From Cart Event (`NetmeraCartRemoveProductEvent`)
    -   Add To Wishlist Event (`NetmeraWishListEvent`)
-   Media Events
    -   Content Comment Event (`NetmeraContentCommentEvent`)
    -   Content Rate Event (`NetmeraContentRateEvent`)
    -   Content View Event (`NetmeraContentViewEvent`)
    
 ### Custom Events
 
If events provided by the SDK do not completely satisfy your needs, you can also generate your own event classes using Netmera Dashboard. If the custom event is to be created on the Netmera, it must first be defined in the panel.  
You may extend your custom event subclass from one of the built-in event subclasses, or from the base  `NetmeraEvent`  class. You can select the data type of the parameters, make them array or set them as mandatory. If you do not send a mandatory parameter you will get error(bad request) and your request will be rejected.

You can follow Developers -> Events and click the Create New Event button to generate your custom event.
In the end, Netmera Dashboard will automatically generate source files for your custom event, so that you can just add them to your project and use without any hassle.

After you add the source files to your project, you can fire that custom event.

### Data Transfer Control

You can control whether Netmera SDK sends data to the server or not using the following methods:

```swift
// Enable data transfer (default state)
Netmera.setDataTransferEnabled(true)

// Disable data transfer to pause all data sending
Netmera.setDataTransferEnabled(false)

// Check current data transfer status
let isEnabled = Netmera.isDataTransferEnabled()
print("Data transfer enabled: \(isEnabled)")
```

### Additional Request Headers

You can add custom headers to all Netmera HTTP requests made by the SDK:

```swift
// Set additional headers for all requests
Netmera.setAdditionalRequestHeaders([
    "X-Custom-Header": "custom-value"
])
```

## Geofence & Location

In your pod file, you should add `NetmeraLocation` and `NetmeraGeofence`  then install to your app target like this;

````ruby
pod "NetmeraLocation"
pod "NetmeraGeofence"
````

By default, Netmera SDK does not gather any location information from device. If you want to use Netmera features requiring location information such as geofence messages and filtering target users by location, you must enable location tracking for your application.

For using location to targeting your users, you should enable Location History from the web panel. In order to do that, follow Developers -> App Info -> App Config -> Location History Enabled.

### Enable Location Tracking for Your Application

#### Add appropriate authorization strings to your application target's  `Info.plist`  file

-   If your application will use geofence messages and supports iOS 10 and earlier, you  _**must**_  set  `NSLocationAlwaysUsageDescription`  key and add a proper description explaining why your app will use region monitoring, for iOS 11 and above you must set  `NSLocationAlwaysAndWhenInUseUsageDescription`  and a proper description.
    -   In this case, SDK will monitor region enter/exit actions for geofence regions configured inside Netmera Dashboard.
-   If your application only needs occasional location history information, you can set  `NSLocationWhenInUseUsageDescription`  key and add a proper description.
    -   In this case, SDK will send the most recent location only once per session.

### Request Location Authorization

Request location authorization from user by calling the following method in an appropriate place:

```swift
Netmera.requestLocationAuthorization()
```
>⚠️ You can set max regions for Geofence with **setNetmeraMaxActiveRegions** method. If you set max active regions' number greater than 20 or smaller than 0, it will be set as the default which is 20.

## User Management

Netmera SDK provides comprehensive user management capabilities to identify, update, and manage user information in a structured way.

### User Identification

Use the `identifyUser(_:)` method to send or refresh the user's identity information. This is the recommended approach for user management:

```swift
// Create a user object that extends NetmeraUserIdentify class
var user = NetmeraUserIdentify()
user.userId = "user123"
user.email = "john.doe@example.com"
user.msisdn = "+905551234567"

// Identify the user
Netmera.identifyUser(user)
```

### User Updates (Deprecated)

⚠️ **Deprecated**: The `updateUser(_:)` method is deprecated. Use `identifyUser(_:)` instead.

```swift
// DEPRECATED - Use identifyUser(_:) instead
var user = NetmeraUser()
user.userId = userId
user.name = name
user.surname = surname
user.email = email
Netmera.updateUser(user: user) // This method is deprecated
```

### User Profile Updates

Use the `updateUserProfile(_:)` method to apply specific profile updates. `NetmeraUserProfile` uses `NetmeraProfileAttribute` objects that support different operations:

```swift
// Create a user profile object that extends NetmeraUserProfile class
var userProfile = NetmeraUserProfile()

// Set values using the set() method
userProfile.name.set("John")
userProfile.surname.set("Doe")
userProfile.dateOfBirth.set(Date())

// For array properties, you can add or remove values
userProfile.externalSegments.add(["segment1", "segment2"])
userProfile.externalSegments.remove(["segment1"])

// Unset a property to remove it
userProfile.gender.unset()

// Update the user profile
Netmera.updateUserProfile(userProfile: userProfile)
```

**Available Operations:**
- `set(_:)` - Sets a new value, replacing any existing value
- `unset()` - Removes the property value
- `add(_:)` - Adds values to array properties (only for array types)
- `remove(_:)` - Removes values from array properties (only for array types)

### Getting Current User Information

You can retrieve the current external identifier for the user:

```swift
let externalId = Netmera.getCurrentExternalId()
if let id = externalId {
    print("Current external ID: \(id)")
}
```

### Adding Custom Attributes to User

Similar to events, you can generate a custom `NetmeraUserProfile` subclass using Netmera Dashboard if the set of built-in attributes is not enough for your use case.

If the custom attribute is to be created on Netmera, it must first be defined in the panel (Developers → Profile Attributes).

Netmera will automatically generate the source files for your custom user class, so that you can easily use them to send information about your custom attributes.

⚠️ **Important**: The `userId` cannot be removed even if you set `nil` to it.

## Tracking Transparency

In your pod file, you should add `NetmeraAdId` and install to your app target like this;

````ruby
pod "NetmeraAdId"
````

Request user authorization to access app-related data for tracking the user or the device.

```swift
Netmera.requestAdvertisingAuthorization()
```
The authorization prompts will be showed to user for Netmera to access device advertisingIdentifier.

To enable or disable tracking transparency within the app, you can use the following code:
```swift
Netmera.setAuthorizedAdvertisingIdentifier(authorized: true) // to enable tracking transparency within app
Netmera.setAuthorizedAdvertisingIdentifier(authorized: false) // to disable tracking transparency within app
```
For more information visit the [developer.apple](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager)

## Deep Linking

When you send a push notification with custom actions buttons, you may redirect users to any custom page or view in your app by specifying deep links as custom actions button URLs. To do so, you will first need to create a URL scheme ( your_deeplink_scheme://) in your project.  
Using Xcode edit your Info.plist file:  
• Add a new key URL types. Xcode will automatically make this an array containing a dictionary called Item 0.  
• Within Item 0, add a key URL identifier. Set the value to your custom scheme.  
• Within Item 0, add a key URL Schemes. This will automatically be an array containing a string called Item 0.  
• Set URL Schemes » Item 0 to your custom scheme.  
When you are done, you may confirm that your new URL scheme has been added to your app's Info.plist file.

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
	print("openUrl: \(url)")
	return true
}
```
### Universal Link

To detect the universal link provided by Netmera push actions, which typically takes the form of `https://your_domain/scheme?query`, you need to implement a custom handler in your iOS app. Specifically, you should add the following code to your `didFinishLaunchingWithOptions` method and make sure that your `AppDelegate` conforms to the `NetmeraPushDelegate` protocol:
 
```swift
//in didFinishLaunchingWithOptions
// Implement NetmeraPushDelegate in your AppDelegate
Netmera.setPushDelegate(self)
```
Then, you can handle the universal link by implementing the following two delegate methods:

```swift
func shouldHandleOpenURL(_ url: URL, for pushObject: NetmeraBasePush) -> Bool {
	if url.host == "your_domain" {
		return true
	}
	return false
}

func handleOpenURL(_ url: URL, for pushObject: NetmeraBasePush) {
	print("openUrl \(url)")
}
```
You should check the given URL's whether you want to take an action in  the `shouldHandleOpenURL`  and returns `true` if you want to handle. Then the `handleOpenURL` method is called when URL is triggered with the Netmera push actions, and you can use it to perform the appropriate action based on the URL's contents.

## Inbox

In your pod file, you should add `NetmeraNotificationInbox` and install to your app target like this;
````ruby
pod "NetmeraNotificationInbox"
````

If your application needs information about the push notifications that are previously sent to device by Netmera, you can use  `NetmeraInbox`  class to fetch that information from Netmera.

The most common use case for this would be to show the list of notifications inside your application in an inbox-style interface.

`NetmeraInbox`  is the core class providing methods and properties needed for operations on push notifications like fetching push objects or updating push objects' status, but you can not directly initialize a  `NetmeraInbox`  instance. You get an instance from SDK, then operate on that instance for future inbox actions. Here is the common workflow to use inbox feature of Netmera.

### 1. Determine properties of push notifications to fetch

You must first define filtering properties by creating a  `NetmeraInboxFilter`  instance. You determine which push notifications will be included in the fetched list by setting related properties of this  `NetmeraInboxFilter`  instance.

`NetmeraInboxFilter` class provides filtering according to the following options:

-   Inbox Status : Read / Unread / Deleted
-   Categories : Categories to which push notifications are belong.
-   Including expired push notifications or not.
-   Page Size : This is not to filter, but to determine the size of chunks which will be gathered during one request.

```swift
// 1. Define inbox manager
var  inboxManager: NetmeraInboxManager?
// 2. Create filter for fetching inbox
let filter = NetmeraInboxFilter(status: status,
								pageSize: 10,
								shouldIncludeExpiredObjects: true,
								categories: ["category_names"] //Optional
								)
// 3. Crete inbox manager instance
self.inboxManager = Netmera.inboxManager(with: filter)
```
### 2. Fetch the first page and get the  `NetmeraInbox`  instance

Now, you can request from Netmera to return the list of push notification objects matching with the filter object using the following code:

```swift
inboxManager?.inbox(callback: { result in
	// List inbox
}
```

### 3. Update the status of push notifications

Push notifications may have 3 different states, which are the following:

-   Unread
-   Read
-   Deleted

These three states allows you to implement a simple notification inbox interface for your users where they can read messages, mark previously read message as unread, delete messages and restore them again if needed.

You can make transitions among states for push notifications inside inbox using  `-updateStatus:forPushObjects:completion:`  method. Calling this method will start an asynchronous request to update status for given push objects, and given completion block will be called upon the result of the request.

Here is a sample implementation which deleted the first 5 push objects from inbox:

```swift
// To update status of given push objects
inboxManager?.updateStatus(status, for: [object]) { result in
	// List inbox
}

// To update status of all push objects
inboxManager?.updateStatusForAllPushObjects(status) { result in
	// List inbox
}
```

### 4. Fetch more pages

If you set a custom  `pageSize`  value as a filtering option, result of the first fetch operation may not contain all push objects which matches with the given filtering criteria. In this case, you can fetch next chunk of objects using the following code:

```swift
inboxManager?.nextPage(callback: { result in
	// List inbox
}
```

`NetmeraInbox`  instance returned as the result of  `-fetchInboxUsingFilter:completion:`  method stores the fetched list of objects incrementally. Specifically,  `inbox.objects`  property will include all list of objects fetched until that time. For instance, if you set  `pageSize`  as  `10`, and fetch 3 pages in total (one with  `-fetchInboxUsingFilter:completion:`, two with  `-fetchNextPageWithCompletionBlock:`),  `inbox.objects`  array will contain all 30 objects in these 3 pages. Therefore, you can solely rely on this array while showing push notifications to your users inside a table view or collection view.

If operation fails for some reason, completion block will be called with a  `nonnull`  `error`  parameter describing the reasons of failure.

If you call this method when there is no more page left, method immediately calls completion block with an appropriate error.

ℹ️ You can check if you have fetched all pages via `hasNextPage` property of `NetmeraInbox` instance. It will have value `NO` when all pages have been fetched.

### Get count of push notifications according to status

You can show your users information about total count of push notifications according to inbox status using  `-countForStatus:`  method like this:

```swift
self.inboxManager?.count(for: NetmeraInboxStatus.read)
```

### 5. Light fetching

// TODO:

## Communication Preferences

Netmera SDK allows you to manage your users' communication preferences, including email and SMS permissions, as well as category-based notification preferences.

### 1. Email and SMS Permissions

You can set and query your users' consent for email and SMS communication:

```swift
import NetmeraCore

// Grant email permission
Netmera.setEmailPermission(isAllowed: true)

// Query email permission
Netmera.getEmailPermission { result in
    switch result {
    case .success(let isAllowed):
        print("Email permission: \(isAllowed)")
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Grant SMS permission
Netmera.setSmsPermission(isAllowed: true)

// Query SMS permission
Netmera.getSmsPermission { result in
    switch result {
    case .success(let isAllowed):
        print("SMS permission: \(isAllowed)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

## Category Preferences

You can manage user preferences for specific notification categories:

```swift
import NetmeraNotification

// Fetch user category preferences
Netmera.getUserCategoryPreferenceList { result in
    switch result {
    case .success(let preferences):
        for pref in preferences {
            print("Category: \(pref.categoryName ?? "") - Enabled: \(pref.categoryEnabled ?? false)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Update preference for a specific category
Netmera.setUserCategoryPreference(
    categoryId: 123,
    categoryEnabled: true
) { result in
    switch result {
    case .success(let success):
        print("Preference updated: \(success)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

#### Model

`NetmeraUserCategoryPreference` contains:
- `categoryId: Int?`
- `categoryEnabled: Bool?`
- `categoryName: String?`

## Live Activity Integration

Netmera SDK provides built-in support for iOS Live Activities, allowing you to track and manage Live Activity lifecycles and receive updates via push notifications.

### 1. Installation

Add the following to your Podfile to include Live Activity support:

```ruby
pod "NetmeraLiveActivity"
```

### 2. Import

In your relevant Swift files, import the module:

```swift
import NetmeraLiveActivity
```

### 3. Usage

#### Registering a Live Activity Type

To enable Netmera to observe and manage a specific Live Activity type, register it at app launch (iOS 17.2+):

```swift
import ActivityKit
import NetmeraLiveActivity

@available(iOS 17.2, *)
func setupLiveActivity() {
    Netmera.register(forType: MyActivityAttributes.self, name: "MyActivity")
}
```

#### Unregistering

To stop observing a Live Activity type:

```swift
@available(iOS 17.2, *)
Netmera.unregister(name: "MyActivity")
```

#### Observing a Specific Activity

To observe a specific Live Activity instance (iOS 16.1+):

```swift
if #available(iOS 16.1, *) {
    Netmera.observeActivity(activityInstance)
}
```

#### Resume Observing After Relaunch

To resume observing all active Live Activities of a given type (iOS 16.1+):

```swift
if #available(iOS 16.1, *) {
    Netmera.resumeObservingActivities(ofType: MyActivityAttributes.self)
}
```

### 4. Requirements

- Your `ActivityAttributes` type must conform to both `ActivityAttributes` and `NetmeraLiveActivityAttributes` protocols.
- Available on iOS 16.1 and above (some features require iOS 17.2+).

### 5. Example Attribute Protocol

```swift
import ActivityKit
import NetmeraLiveActivity

struct MyActivityAttributes: ActivityAttributes, NetmeraLiveActivityAttributes {
    var netmeraGroupId: String?
    // ... your custom properties
}
```

## Enabling Network SSL Pinning

To enable SSL Pinning with the Netmera SDK, simply add your server’s public SSL certificate file (`netmera.com.cer`, DER format) to your Xcode project and ensure it is included in your app bundle. The SDK will automatically detect and use this certificate for SSL pinning. If the certificate is not present, SSL pinning will not be enabled, and network requests will proceed as usual without pinning. No additional configuration or code changes are required.

**Note:** If your certificate changes, update the `.cer` file in your project and rebuild your app.

## License

This software is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).
