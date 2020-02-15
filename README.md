# A11yUITests

[![Version](https://img.shields.io/cocoapods/v/A11yUITests.svg?style=flat)](https://cocoapods.org/pods/A11yUITests)
[![License](https://img.shields.io/cocoapods/l/A11yUITests.svg?style=flat)](https://cocoapods.org/pods/A11yUITests)
[![Platform](https://img.shields.io/cocoapods/p/A11yUITests.svg?style=flat)](https://cocoapods.org/pods/A11yUITests)

A11yUITests is an extension to `XCTestCase` that adds tests for common accessibility issues that can be run as part of an XCUI Test suite.

Tests can either be run separately or integrated into existing XCUI Tests.

## Using These Tests

Good accessibility is not about ticking boxes and conforming to regulations and guidelines, but about how your app is experienced. You will only ever know if your app is actually accessible by letting real people use it. Consider these tests as hints for where you might be able to do better and use them to detect regressions.

Failures for these tests should be seen as warnings for further investigation, not strict failures. As such, I'd recommend always having `continueAfterFailure = true` set.


## Running tests

Tests can be run individually or in suites.

### Running All Tests on All Elements

```swift
func test_allTests() {
    XCUIApplication().launch()
    a11yCheckAllOnScreen()
}
```

### Specifying Tests/Elements

To specify elements and tests use `a11y(tests: [A11yTests], on elements: [XCUIElement])` passing an array of tests to run and an array of elements to run them on. To run all interactive element tests on all buttons:

```swift
func test_buttons() {
    let buttons = XCUIApplication().buttons.allElementsBoundByIndex
    a11y(tests: a11yTestSuiteInteractive, on: buttons)
}
```

To run a single test on a single element call that test directly. To check if a button has a valid accessibility label:

```swift
func test_individualTest_individualButton() {
    let button = XCUIApplication().buttons["My Button"]
    a11yCheckValidLabelFor(button: button)
}
```

## Test Suites

A11yUITests contains 4 pre-built test suites with tests suitible for different elements.

`allA11yTestSuite` Runs all tests.

`a11yTestSuiteImages` Runs tests suitible for images.

`a11yTestSuiteInteractive` runs tests suitible for interactive elements.

`a11yTestSuiteLabels` runs tests suitible for static text elements.


Alternatively, you can create an array of `A11yTests` enum values for the tests you want to run.

## Tests

### Minimum Size

`minimumSize` or `a11yCheckValidSizeFor(element: XCUIElement)` checks an element is at least 18px x 18px.

Note: 18px is arbitrary.

### Minimum Interactive Size

`minimumInteractiveSize` or `a11yCheckValidSizeFor(interactiveElement: XCUIElement)` checks tappable elements are a minimum of 44px x 44px.
This satisfies [WCAG 2.1 Sucess Criteria 2.5.5 Target Size Level AAA](https://www.w3.org/TR/WCAG21/#target-size)

Note: Many of Apple's controls fail this requirement. For this reason, when running a suite of tests with `minimumInteractiveSize` only buttons and cells are checked. This may still result in some failures for `UITabBarButton`s, for example.
For full compliance, you should run `a11yCheckValidSizeFor(interactiveElement: XCUIElement)` on any element that your user might interact with, eg. sliders, steppers, switches, segmented controls. But you will need to make your own subclass as Apple's are not strictly adherent to WCAG.

### Label Presence

`labelPresence` or `a11yCheckValidLabelFor(element: XCUIElement)` checks the element has an accessibility label that is a minimum of 2 characters long.
This counts towards [WCAG 2.1 Guideline 1.1 Text Alternatives](https://www.w3.org/TR/WCAG21/#text-alternatives) but does not guarantee compliance.

### Button Label

`buttonLabel` or `a11yCheckValidLabelFor(interactiveElement: XCUIElement)` checks labels for interactive elements begin with a capital letter and don't contain a full stop or the word button.
This follows [Apple's guidance for writing accessibility labels](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/iPhoneAccessibility/Making_Application_Accessible/Making_Application_Accessible.html#//apple_ref/doc/uid/TP40008785-CH102-SW6). Buttons should all have the button trait applied, but this is currently untestable.

Note: This test is not localised.

### Image Label

`imageLabel` or `a11yCheckValidLabelFor(image: XCUIElement)` checks accessible images don't contain the words image, picture, graphic, or icon, and checks that the label isn't reusing the image filename.
This follows [Apple's guidelines for writing accessibility labels](https://developer.apple.com/videos/play/wwdc2019/254/). Images should all have the image trait applied, but this is currently untestable. Care should be given when deciding whether to make images accessible to avoid creating unnecessary noise.

Note: This test is not localised.

### Label Length

`labelLength` or `a11yCheckLabelLength(element: XCUIElement)` checks accessibility labels are <= 40 characters.
This follows [Apple's guidelines for writing accessibility labels](https://developer.apple.com/videos/play/wwdc2019/254/).
Ideally, labels should be as short as possible while retaining meaning. If you feel your element needs more context, consider adding an accessibility hint.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

A11yUITests_ExampleUITests.swift contains example tests that show a fail for each test above.

## Requirements

iOS 11

Swift 5

## Installation

A11yUITests is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'A11yUITests'
```

## Contributing

I welcome and encourage contributions to improve or expand this test suite.
If you would like to suggest a change, consider opening an issue against the repo first, to allow for discussion and planning.
To make code changes, please fork this repo and make changes there. Then open a pull request to contribute your changes back to this repo.

## Known Issues

If two elements of the same type have the same identifier, this will cause the tests to crash on iOS 13+. E.g., two buttons, both labelled 'Next'.

## Author

Rob Whitaker, rw@rwapp.co.uk
https://mobilea11y.com

## License

A11yUITests is available under the MIT license. See the LICENSE file for more info.
