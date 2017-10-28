# Purpose
Do CallKit tutorial.

# References
## CallKit Tutorial for iOS  
https://www.raywenderlich.com/150015/callkit-tutorial-ios

## Enhancing VoIP Apps with CallKit
Apple WWDC 2016 Session 230
https://developer.apple.com/videos/play/wwdc2016/230/

# Results

## tutorial comments
This tutorial only covers CallKit, not making VoIP calls.
There is no VoIP backend in place, so all the calls are dummy operations.
You won't be able to use the sample app to communicate between two phones.

## Info.plist
Sample project starter code has array Required background modes

    Item 0 App plays audio or streams audio/video using AirPlay
    Item 1 App provides Voice over IP services

## CallKit
By adopting CallKit, your app will be able to:

Use the native incoming call screen in both the locked and unlocked states.
Start calls from the native Phone app’s Contacts, Favorites and Recents screens.
Interplay with other calls in the system.

## CXProvider
App sends CXCallUpdate to notify system about changes to a call.

## CXCallController
Makes requests to the system on behalf of the user.
Call controller uses CXTransaction containing one or more CXAction.

## CXAction
System sends a concrete instance of CXAction abstract class (e.g. CXStartCallAction) to CXProvider to notifiy app of events.

## CXCallDirectoryProvider
https://developer.apple.com/documentation/callkit/cxcalldirectoryprovider
