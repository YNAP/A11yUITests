//
//  XCTestCase+A11y.swift
//  A11yUITestsUITests
//
//  Created by Rob Whitaker on 05/12/2019.
//  Copyright © 2019 RWAPP. All rights reserved.
//

import XCTest

extension XCTestCase {

    public enum A11yTests: CaseIterable {
        case minimumSize,
        minimumInteractiveSize,
        labelPresence,
        buttonLabel,
        imageLabel,
        labelLength,
        overlapping
    }

    // MARK: - Test Suites

    public var allA11yTestSuite: [A11yTests] {
        return A11yTests.allCases
    }

    public var imageA11yTestSuite: [A11yTests] {
        return [.minimumSize, .labelPresence, .imageLabel, .labelLength]
    }

    public var interactiveA11yTestSuite: [A11yTests] {
        // Valid tests for any interactive elements, eg. buttons, cells, switches, text fields etc.
        // Note: Many standard Apple controls fail these tests.
        return [.minimumInteractiveSize, .labelPresence, .buttonLabel, .labelLength]
    }

    public var labelA11yTestSuite: [A11yTests] {
        // valid for any text elements, eg. labels, text views
        return [.minimumSize, .labelPresence]
    }

    // MARK: - Test Groups

    public func runAllA11yTestsOnScreen(file: StaticString = #file,
                                        line: UInt = #line) {

        let elements = XCUIApplication().descendants(matching: .any).allElementsBoundByAccessibilityElement
        runAllA11yTestsOn(elements: elements, file: file, line: line)
    }

    public func runAllA11yTestsOn(elements: [XCUIElement],
                                  file: StaticString = #file,
                                  line: UInt = #line) {
        run(a11yTests: allA11yTestSuite, on: elements, file: file, line: line)
    }

    public func run(a11yTests: [A11yTests],
                    on elements: [XCUIElement],
                    file: StaticString = #file,
                    line: UInt = #line) {

        for element in elements {

            if a11yTests.contains(.minimumSize) {
                checkValidSizeFor(element: element, file: file, line: line)
            }

            if a11yTests.contains(.minimumInteractiveSize) {
                if element.isInteractive {
                    checkValidSizeFor(interactiveElement: element, file: file, line: line)
                }
            }

            if a11yTests.contains(.labelPresence) {
                checkValidLabelFor(element: element, file: file, line: line)
            }

            if a11yTests.contains(.buttonLabel) {
                checkValidLabelFor(button: element, file: file, line: line)
            }

            if a11yTests.contains(.imageLabel) {
                checkValidLabelFor(image: element, file: file, line: line)
            }

            if a11yTests.contains(.labelLength) {
                checkLabelLength(element: element, file: file, line: line)
            }

            if a11yTests.contains(.overlapping) {
                for element2 in elements {
                    check(element1: element, doesNotOverlap: element2, file: file, line: line)
                }
            }
        }
    }

    // MARK: - Individual Tests

    public func checkValidSizeFor(element: XCUIElement,
                                  file: StaticString = #file,
                                  line: UInt = #line) {

        XCTAssert(element.frame.size.height >= 18,
                  "Accessibility Failure: Element not tall enough: \(element.description)",
                 file: file,
                 line: line)

        XCTAssert(element.frame.size.width >= 18,
                  "Accessibility Failure: Element not wide enough: \(element.description)",
                 file: file,
                 line: line)
    }

    public func checkValidLabelFor(element: XCUIElement,
                                   file: StaticString = #file,
                                   line: UInt = #line) {

        guard element.isNotWindow,
            element.elementType != .other else { return }

        XCTAssert(element.label.count > 2,
                  "Accessibility Failure: Label not meaningful: \(element.description)",
                 file: file,
                 line: line)
    }

    public func checkValidLabelFor(button: XCUIElement,
                                   file: StaticString = #file,
                                   line: UInt = #line) {

        guard button.elementType == .button else { return }

        // TODO: Localise this check
        XCTAssertFalse(button.label.contains(substring: "button"),
                       "Accessibility Failure: Button should not contain the word button in the accessibility label, set this as an accessibility trait: \(button.description)",
                       file: file,
                       line: line)

        XCTAssert(button.label.first!.isUppercase, "Accessibility Failure: Buttons should begin with a capital letter: \(button.description)",
                  file: file,
                  line: line)

        XCTAssert((button.label.range(of: ".") == nil),
                  "Accessibility failure: Button accessibility labels shouldn't contain punctuation: \(button.description)",
                  file: file,
                  line: line)
    }

    public func checkValidLabelFor(image: XCUIElement,
                                   file: StaticString = #file,
                                   line: UInt = #line) {

        guard image.elementType == .image else { return }

        // TODO: Localise this test
        let avoidWords = ["image", "picture", "graphic", "icon"]

        for word in avoidWords {
            XCTAssertFalse(image.label.contains(substring: word),
                           "Accessibility Failure: Images should not contain the word \(word) in the accessibility label, set the image accessibility trait: \(image.description)",
                           file: file,
                           line: line)
        }

        let possibleFilenames = ["_", "-", ".png", ".jpg", ".jpeg", ".pdf", ".avci", ".heic", ".heif"]

        for word in possibleFilenames {
            XCTAssertFalse(image.label.contains(substring: word),
                           "Accessibility Failure: Image file name is used as the accessibility label: \(image.description)",
                           file: file,
                           line: line)
        }
    }

    public func checkLabelLength(element: XCUIElement,
                                 file: StaticString = #file,
                                 line: UInt = #line) {

        guard element.elementType != .staticText,
            element.elementType != .textView else { return }

        XCTAssertTrue(element.label.count <= 40,
                      "Accessibility Failure: Label is too long: \(element.description)",
                      file: file,
                      line: line)
    }

    public func checkValidSizeFor(interactiveElement: XCUIElement,
                                  file: StaticString = #file,
                                  line: UInt = #line) {

        XCTAssert(interactiveElement.frame.size.height >= 44,
                  "Accessibility Failure: Interactive element not tall enough: \(interactiveElement.description)",
                  file: file,
                  line: line)

        XCTAssert(interactiveElement.frame.size.width >= 44,
                  "Accessibility Failure: Interactive element not wide enough: \(interactiveElement.description)",
                  file: file,
                  line: line)
    }

    public func check(element1: XCUIElement, doesNotOverlap element2: XCUIElement,
                      file: StaticString = #file,
                      line: UInt = #line) {
        let label1 = element1.label
        let label2 = element2.label
        let type1 = element1.elementType
        let type2 = element2.elementType

        guard !label1.isEmpty,
            !label2.isEmpty,
            label1 != label2,
            !orLabels(type1: type1, type2: type2),
            element1 != element2 else { return }

        XCTAssertFalse(element1.frame.intersects(element2.frame),
                       "Accessibility Failure: Elements overlap: \(element1.description), \(element2.description)", file: file, line: line)
    }

    private func orLabels(type1: XCUIElement.ElementType, type2: XCUIElement.ElementType) -> Bool {
        return ((type1 == .staticText) || (type2 == .staticText))
    }
}

private extension String {
    func contains(substring: String) -> Bool {
        return self.lowercased().contains(substring.lowercased())
    }
}

private extension XCUIElement {
    var isNotWindow: Bool {
        return self.elementType != .window
    }

    var isInteractive: Bool {
        // strictly switches, steppers, sliders, segmented controls, & text fields should be included
        // but standard iOS implimentations aren't large enough.

        return self.elementType == .button ||
            self.elementType == .cell

    }
}
