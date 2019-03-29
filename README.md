# Wrap Unity generated Xcode project in Framework

We often need to integrate Unity into the native iOS app or iMessage extension. Here's a nice way to do it - wrap Unity stuff into the dynamic framework. Frameworks are great - they can encapsulate both code and data. And the same framework can be used in iMessage and the host app without having the code and data twice.

In this demo project, I used [SpaceShooter](https://assetstore.unity.com/packages/essentials/tutorial-projects/space-shooter-tutorial-13866) example and wrapped it into the framework and used the framework in the host app and iMessage extension. For more details, check my [blog post](https://www.kodbiro.com/blog/a-great-way-to-integrate-unity-into-the-native-ios-app/)

Also, feel free to create an issue or a pull request if you think something needs to be fixed.

This project has been tested with Unity 2018.2.1f1
