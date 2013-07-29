##Overview
`CNUserNotification` is a kind of proxy to give OS X Lion 10.7 „the same‟ support for user notifications like OS X Mountain Lion 10.8 does. Benefits are also a bit more flexibility since you are able to define a custom banner image or variable dismiss delay times. `CNUserNotification` uses a fake notification center that runs just per application. The class design and all method signatures are similar to their counterparts of `NSUserNotification`.

It's not necessary to install *Growl* or other third party libraries. It's all build in to get the user notified - Mountain Lion style.

As of `CNUserNotification` runs on a per application basis all methods related to scheduled or remote deliverey are **not** implemented. Please take a look at the [documentation](http://cnusernotification.cocoanaut.com/documentation/) to get a detailed look.


Here is a screenshot of the included example application:

![CNUserNotification Example](https://dl.dropboxusercontent.com/u/34133216/WebImages/Github/CNUserNotification-Example.jpg)



##Installation
####Via CocoaPods
Just add `pod 'CNUserNotification'` to your podfile.


####Via Git SubModule
`cd` into your project directory and execute `git submodule add https://github.com/phranck/CNUserNotification.git $DIR_WHERE_YOUR_SUBMODULES_ARE_PLACED`

You have to replace the `$DIR_WHERE_YOUR_SUBMODULES_ARE_PLACED` with the real path where your submodules are placed.


##Usage
As described above all method signatures are identical to that ones of `CNUserNotification*` classes. Strictly speaking you have to use three classes and one delegate:

	CNUserNotification
	CNUserNotificationCenter
	CNUserNotificationFeature
	CNUserNotificationDelegate

That's all. `CNUserNotificationFeature` is the extension that doesn't exist in the original `NSUserNotification`, but there is a category to implement just two accessor methods.

The only thing you have to do is to replace the prefix `NS` by `CN`. It's not required to change any code if you use `CNUserNotification`. It decides by itself whether to use `NSNotfication` or this custom implementation. 


##Requirements
`CNUserNotification` was written using ARC and runs on 10.7 and above. It requires the QuartzCore Framework.


##Contribution
The code is provided as-is, and it is far off being complete or free of bugs. If you like this component feel free to support it. Make changes related to your needs, extend it or just use it in your own project. Feedbacks are very welcome. Just contact me at [opensource@cocoanaut.com](mailto:opensource@cocoanaut.com?Subject=[CNUserNotification] Your component on Github), send me a ping on **Twitter** [@TheCocoaNaut](http://twitter.com/TheCocoaNaut) or **App.net** [@phranck](https://alpha.app.net/phranck). 


##Documentation
The documentation of this project is auto generated using [Appledoc](http://gentlebytes.com/appledoc/) by [@gentlebytes](https://twitter.com/gentlebytes).<br />
You can find the complete reference [here](http://CNUserNotification.cocoanaut.com/documentation/).


##License
This software is published under the [MIT License](http://cocoanaut.mit-license.org).
