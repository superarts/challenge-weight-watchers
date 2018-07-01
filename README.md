# iOS Exercises
Code exercises for iOS candidates

## Exercise 1

To complete this exercise successfully, you need to do the following:

1. Clone the [ios-exercises](https://github.com/WW-Digital/ios-exercises) repo to your computer.
1. Fix any runtime errors and console warnings.
1. Consume the following endpoint and deserialize the JSON response: https://www.weightwatchers.com/assets/cmx/us/messages/collections.json
1. With the data from this endpoint, display the title and image of each object in the response. You can use any UIView or UIControl to do this.
1. Run the application in the Simulator or on an iOS device.
1. Ensure the app displays correctly when the orientation changes.
1. Submit your completed updates to the ios-exercises repo using a pull request.

**Bonus Points**

 * Replace PureLayout with a solution that supports Safe Area Layout Guide for iPhone X
 * Display a placeholder image if the URL is invalid
 * Display an alert when the image is tapped

## Exercise 2

To complete this exercise, you need to do the following:

* Clone the [ios-exercises](https://github.com/WW-Digital/ios-exercises) repo, if you haven't already.
* Open Exercise2.playground in Xcode.
* Fix compilation errors.
* Assign the teacher the name "Alice" and an age of 31.
* Implement `addStudents()` to add Cecilia, Ellen, and Bob to Alice's list of students.
* In `printStudents()`, print the student's age if it's available. Otherwise, just print the name.
* Submit your completed updates to the ios-exercises repo using a pull request.

## Exercise 3

TBD

# Architecture of Exercise 1

## About Protocols

To eliminate Singleton Pattern, protocols are used to "hide" singleton instances and indicate dependencies. For example, even though cuisine data are stored in a shared instance of `CuisineManager`, view model that requires these data need to confirm to protocol `RequiresCuisineData` to access the shared `cuisineManager` instance. This is to prevent global level dependency: nothing should be required by everything.

Also, protocols are widely used as interfaces. In theory all non UI modules should provides protocols to make unit tests easier, and even UI related modules can work in this way to support multiple implementation. Currently only one dummy implementation `DummyViewModel` is provided.

## About Dependency Injection

`DependencyManager`, which is based on `Dip`, handles runtime dependency injection. Even `DependencyManager` can be replaced by other implementations like `Swinject` easily, as long as it's renamed to `DipDependencyManager` and a `protocol DependencyManager` is created. As mentioned in `About Protocols`, even though the manager itself is a shared singleton instance, it should only be accessed by classes that confirm to protocol `RequiresDependency`.

## About MVVM

Architecture design of this app is inspired by `Android Architecture Components`. The general idea is that UI elements in `ViewControllers` are bind with `MutableProperties` in `ViewModels` (like `LiveData` in Google's library). In another word, `ViewControllers` passively observe changes of `ViewModels` in a reactive way, and the actual business logic is handled in `ViewModels`. `ViewModels` do not depend on `UIKit` at all, which makes them easier to test.

To get data, `ViewModels` talk with `Managers`, which may be called `repositories`, `data source`, or `data store` as well. Please note that there are also `UI Managers` like `CuisineTableManager`, which are different since `UI Managers` are related with `UIKit` components, e.g. `UITableViewDataSource`. `UI Managers` only handles UI logic in a passive way, and they generate different `Views` like `CuisineTableCell`, which talks with `CuisineCellViewModel` and again, `CuisineCellViewModel` handles business logic.

## About Navigation

`NavigationManager` is part of `UI`. It handles lifecycle of the whole app, and is called by `UI` sub-modules. In this example, there is no navigation at all so it only provides minimium functionality.

## About Models and Networking

`Models` (or `Entities`) are implemented based on `EVReflection`, `ReflectionNetworkManager` utilizes it and results less code, but can be slow deserializing complex data structure. `MoyaNetworkManager` runs much faster, and you can always swap dependencies in `DependencyManager` to see the difference.

## About Tests

- `WWDependencyTests`: ensure dependency manager is setup correctly.
- `WWNetworkTests`: async test.
- `WWNetworkReflectionTests`: how to switch dependency at run time.

More unit tests / UI tests should be added, but I'm too sick to do so - 06/30/2018