import Foundation
import XCTest
import ArgParser

class Tests: XCTestCase {

    // ---------------------------------------------------------------------
    // Flags.
    // ---------------------------------------------------------------------

    func testFlagEmpty() {
        let parser = ArgParser()
            .flag("foo f")
        parser.parse([])
        XCTAssert(parser.found("foo") == false)
        XCTAssert(parser.count("foo") == 0)
    }

    func testFlagMissing() {
        let parser = ArgParser()
            .flag("foo f")
        parser.parse(["abc", "def"])
        XCTAssert(parser.found("foo") == false)
        XCTAssert(parser.count("foo") == 0)
    }

    func testFlagLong() {
        let parser = ArgParser()
            .flag("foo f")
        parser.parse(["abc", "def", "--foo"])
        XCTAssert(parser.found("foo") == true)
        XCTAssert(parser.count("foo") == 1)
    }

    func testFlagLongMultiple() {
        let parser = ArgParser()
            .flag("foo f")
        parser.parse(["abc", "def", "--foo", "--foo"])
        XCTAssert(parser.found("foo") == true)
        XCTAssert(parser.count("foo") == 2)
    }

    func testFlagShort() {
        let parser = ArgParser()
            .flag("foo f")
        parser.parse(["abc", "def", "-f"])
        XCTAssert(parser.found("foo") == true)
        XCTAssert(parser.count("foo") == 1)
    }

    func testFlagShortMultiple() {
        let parser = ArgParser()
            .flag("foo f")
        parser.parse(["abc", "def", "-ff", "-f"])
        XCTAssert(parser.found("foo") == true)
        XCTAssert(parser.count("foo") == 3)
    }

    // ---------------------------------------------------------------------
    // Options.
    // ---------------------------------------------------------------------

    func testOptionEmpty() {
        let parser = ArgParser()
            .option("foo f")
        parser.parse([])
        XCTAssert(parser.found("foo") == false)
        XCTAssert(parser.count("foo") == 0)
    }

    func testOptionMissing() {
        let parser = ArgParser()
            .option("foo f")
        parser.parse(["abc", "def"])
        XCTAssert(parser.found("foo") == false)
        XCTAssert(parser.count("foo") == 0)
    }

    func testOptionLong() {
        let parser = ArgParser()
            .option("foo f")
        parser.parse(["abc", "def", "--foo", "bar"])
        XCTAssert(parser.found("foo") == true)
        XCTAssert(parser.count("foo") == 1)
        XCTAssert(parser.value("foo") == "bar")
    }

    func testOptionLongMultiple() {
        let parser = ArgParser()
            .option("foo f")
        parser.parse(["abc", "def", "--foo", "bar", "--foo", "baz"])
        XCTAssert(parser.found("foo") == true)
        XCTAssert(parser.count("foo") == 2)
        XCTAssert(parser.value("foo") == "baz")
        XCTAssert(parser.values("foo") == ["bar", "baz"])
    }

    func testOptionLongEquals() {
        let parser = ArgParser()
            .option("foo f")
        parser.parse(["abc", "def", "--foo=bar"])
        XCTAssert(parser.found("foo") == true)
        XCTAssert(parser.count("foo") == 1)
        XCTAssert(parser.value("foo") == "bar")
    }

    func testOptionShort() {
        let parser = ArgParser()
            .option("foo f")
        parser.parse(["abc", "def", "-f", "bar"])
        XCTAssert(parser.found("foo") == true)
        XCTAssert(parser.count("foo") == 1)
        XCTAssert(parser.value("foo") == "bar")
    }

    func testOptionShortMultiple() {
        let parser = ArgParser()
            .option("foo f")
        parser.parse(["abc", "def", "-ff", "bar", "baz", "-f", "bam"])
        XCTAssert(parser.found("foo") == true)
        XCTAssert(parser.count("foo") == 3)
        XCTAssert(parser.value("foo") == "bam")
        XCTAssert(parser.values("foo") == ["bar", "baz", "bam"])
    }

    func testOptionShortEquals() {
        let parser = ArgParser()
            .option("foo f")
        parser.parse(["abc", "def", "-f=bar"])
        XCTAssert(parser.found("foo") == true)
        XCTAssert(parser.count("foo") == 1)
        XCTAssert(parser.value("foo") == "bar")
    }

    // ---------------------------------------------------------------------
    // Positional arguments.
    // ---------------------------------------------------------------------

    func testPositionalArgs() {
        let parser = ArgParser()
        parser.parse(["abc", "def"])
        XCTAssert(parser.args.count == 2)
        XCTAssert(parser.args[0] == "abc")
        XCTAssert(parser.args[1] == "def")
    }

    // ---------------------------------------------------------------------
    // Option-parsing switch.
    // ---------------------------------------------------------------------

    func testOptionParsingSwitch() {
        let parser = ArgParser()
        parser.parse(["foo", "--", "--bar", "--baz"])
        XCTAssert(parser.args.count == 3)
    }

    // ---------------------------------------------------------------------
    // Commands.
    // ---------------------------------------------------------------------

    func testCommand() {
        let parser = ArgParser()
            .command("boo", ArgParser()
                .flag("foo f")
                .option("bar b")
            )
        parser.parse(["boo", "--foo", "--bar", "baz"])
        XCTAssert(parser.commandName == "boo")
        XCTAssert(parser.commandParser!.found("foo"))
        XCTAssert(parser.commandParser!.value("bar") == "baz")
    }
}
