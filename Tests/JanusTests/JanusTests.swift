// -----------------------------------------------------------------------------
// Unit tests for the Janus library.
// -----------------------------------------------------------------------------

import Foundation
import XCTest
import Janus

class JanusTests: XCTestCase {

    // ---------------------------------------------------------------------
    // Boolean options.
    // ---------------------------------------------------------------------

    func testBoolEmpty() {
        let parser = ArgParser()
        parser.newFlag("bool b")
        parser.parse([])
        XCTAssert(parser.getFlag("bool") == false)
    }

    func testBoolMissing() {
        let parser = ArgParser()
        parser.newFlag("bool b")
        parser.parse(["foo", "bar"])
        XCTAssert(parser.getFlag("bool") == false)
    }

    func testBoolLongSingle() {
        let parser = ArgParser()
        parser.newFlag("bool b")
        parser.parse(["--bool"])
        XCTAssert(parser.getFlag("bool") == true)
    }

    func testBoolShortSingle() {
        let parser = ArgParser()
        parser.newFlag("bool b")
        parser.parse(["-b"])
        XCTAssert(parser.getFlag("bool") == true)
    }

    func testBoolLongMultiple() {
        let parser = ArgParser()
        parser.newFlag("bool b")
        parser.parse(["--bool", "--bool", "--bool"])
        XCTAssert(parser.lenList("bool") == 3)
    }

    func testBoolShortMultiple() {
        let parser = ArgParser()
        parser.newFlag("bool b")
        parser.parse(["-bb", "-b"])
        XCTAssert(parser.lenList("bool") == 3)
    }

    // ---------------------------------------------------------------------
    // String options.
    // ---------------------------------------------------------------------

    func testStringEmpty() {
        let parser = ArgParser()
        parser.newString("string s")
        parser.parse([])
        XCTAssert(parser.getString("string") == "")
    }

    func testStringMissing() {
        let parser = ArgParser()
        parser.newString("string s")
        parser.parse(["foo", "bar"])
        XCTAssert(parser.getString("string") == "")
    }

    func testStringFallback() {
        let parser = ArgParser()
        parser.newString("string s", fallback: "fallback")
        parser.parse(["foo", "bar"])
        XCTAssert(parser.getString("string") == "fallback")
    }

    func testStringLongSingle() {
        let parser = ArgParser()
        parser.newString("string s")
        parser.parse(["--string", "value"])
        XCTAssert(parser.getString("string") == "value")
    }

    func testStringShortSingle() {
        let parser = ArgParser()
        parser.newString("string s")
        parser.parse(["-s", "value"])
        XCTAssert(parser.getString("string") == "value")
    }

    func testStringLongSingleEquals() {
        let parser = ArgParser()
        parser.newString("string s")
        parser.parse(["--string=value"])
        XCTAssert(parser.getString("string") == "value")
    }

    func testStringShortSingleEquals() {
        let parser = ArgParser()
        parser.newString("string s")
        parser.parse(["-s=value"])
        XCTAssert(parser.getString("string") == "value")
    }

    func testStringLongMultiple() {
        let parser = ArgParser()
        parser.newString("string s")
        parser.parse(["--string", "a", "--string", "b", "--string", "c"])
        XCTAssert(parser.lenList("string") == 3)
        XCTAssert(parser.getStringList("string")[0] == "a")
        XCTAssert(parser.getStringList("string")[1] == "b")
        XCTAssert(parser.getStringList("string")[2] == "c")
    }

    func testStringShortMultiple() {
        let parser = ArgParser()
        parser.newString("string s")
        parser.parse(["-s", "a", "-s", "b", "-s", "c"])
        XCTAssert(parser.lenList("string") == 3)
        XCTAssert(parser.getStringList("string")[0] == "a")
        XCTAssert(parser.getStringList("string")[1] == "b")
        XCTAssert(parser.getStringList("string")[2] == "c")
    }

    // ---------------------------------------------------------------------
    // Integer options.
    // ---------------------------------------------------------------------

    func testIntEmpty() {
        let parser = ArgParser()
        parser.newInt("int i")
        parser.parse([])
        XCTAssert(parser.getInt("int") == 0)
    }

    func testIntMissing() {
        let parser = ArgParser()
        parser.newInt("int i")
        parser.parse(["foo", "bar"])
        XCTAssert(parser.getInt("int") == 0)
    }

    func testIntFallback() {
        let parser = ArgParser()
        parser.newInt("int i", fallback: 123)
        parser.parse(["foo", "bar"])
        XCTAssert(parser.getInt("int") == 123)
    }

    func testIntLongSingle() {
        let parser = ArgParser()
        parser.newInt("int i")
        parser.parse(["--int", "123"])
        XCTAssert(parser.getInt("int") == 123)
    }

    func testIntShortSingle() {
        let parser = ArgParser()
        parser.newInt("int i")
        parser.parse(["-i", "123"])
        XCTAssert(parser.getInt("int") == 123)
    }

    func testIntLongSingleEquals() {
        let parser = ArgParser()
        parser.newInt("int i")
        parser.parse(["--int=123"])
        XCTAssert(parser.getInt("int") == 123)
    }

    func testIntShortSingleEquals() {
        let parser = ArgParser()
        parser.newInt("int i")
        parser.parse(["-i=123"])
        XCTAssert(parser.getInt("int") == 123)
    }

    func testIntLongMultiple() {
        let parser = ArgParser()
        parser.newInt("int i")
        parser.parse(["--int", "1", "--int", "2", "--int", "3"])
        XCTAssert(parser.lenList("int") == 3)
        XCTAssert(parser.getIntList("int")[0] == 1)
        XCTAssert(parser.getIntList("int")[1] == 2)
        XCTAssert(parser.getIntList("int")[2] == 3)
    }

    func testIntShortMultiple() {
        let parser = ArgParser()
        parser.newInt("int i")
        parser.parse(["-i", "1", "-i", "2", "-i", "3"])
        XCTAssert(parser.lenList("int") == 3)
        XCTAssert(parser.getIntList("int")[0] == 1)
        XCTAssert(parser.getIntList("int")[1] == 2)
        XCTAssert(parser.getIntList("int")[2] == 3)
    }

    // ---------------------------------------------------------------------
    // Double options.
    // ---------------------------------------------------------------------

    func testDoubleEmpty() {
        let parser = ArgParser()
        parser.newDouble("double d")
        parser.parse([])
        XCTAssert(parser.getDouble("double") == 0.0)
    }

    func testDoubleMissing() {
        let parser = ArgParser()
        parser.newDouble("double d")
        parser.parse(["foo", "bar"])
        XCTAssert(parser.getDouble("double") == 0.0)
    }

    func testDoubleFallback() {
        let parser = ArgParser()
        parser.newDouble("double d", fallback: 123)
        parser.parse(["foo", "bar"])
        XCTAssert(parser.getDouble("double") == 123.0)
    }

    func testDoubleLongSingle() {
        let parser = ArgParser()
        parser.newDouble("double d")
        parser.parse(["--double", "123"])
        XCTAssert(parser.getDouble("double") == 123.0)
    }

    func testDoubleShortSingle() {
        let parser = ArgParser()
        parser.newDouble("double d")
        parser.parse(["-d", "123"])
        XCTAssert(parser.getDouble("double") == 123.0)
    }

    func testDoubleLongSingleEquals() {
        let parser = ArgParser()
        parser.newDouble("double d")
        parser.parse(["--double=123"])
        XCTAssert(parser.getDouble("double") == 123.0)
    }

    func testDoubleShortSingleEquals() {
        let parser = ArgParser()
        parser.newDouble("double d")
        parser.parse(["-d=123"])
        XCTAssert(parser.getDouble("double") == 123.0)
    }

    func testDoubleLongMultiple() {
        let parser = ArgParser()
        parser.newDouble("double d")
        parser.parse(["--double", "1", "--double", "2", "--double", "3"])
        XCTAssert(parser.lenList("double") == 3)
        XCTAssert(parser.getDoubleList("double")[0] == 1.0)
        XCTAssert(parser.getDoubleList("double")[1] == 2.0)
        XCTAssert(parser.getDoubleList("double")[2] == 3.0)
    }

    func testDoubleShortMultiple() {
        let parser = ArgParser()
        parser.newDouble("double d")
        parser.parse(["-d", "1", "-d", "2", "-d", "3"])
        XCTAssert(parser.lenList("double") == 3)
        XCTAssert(parser.getDoubleList("double")[0] == 1.0)
        XCTAssert(parser.getDoubleList("double")[1] == 2.0)
        XCTAssert(parser.getDoubleList("double")[2] == 3.0)
    }

    // ---------------------------------------------------------------------
    // Multiple options.
    // ---------------------------------------------------------------------

    func testMultipleEmpty() {
        let parser = ArgParser()
        parser.newFlag("bool1")
        parser.newFlag("bool2 b")
        parser.newString("string1", fallback: "default1")
        parser.newString("string2 s", fallback: "default2")
        parser.newInt("int1", fallback: 101)
        parser.newInt("int2 i", fallback: 202)
        parser.newDouble("float1", fallback: 1.1)
        parser.newDouble("float2 f", fallback: 2.2)
        parser.parse([])
        XCTAssert(parser.getFlag("bool1") == false)
        XCTAssert(parser.getFlag("bool2") == false)
        XCTAssert(parser.getString("string1") == "default1")
        XCTAssert(parser.getString("string2") == "default2")
        XCTAssert(parser.getInt("int1")  == 101)
        XCTAssert(parser.getInt("int2") == 202)
        XCTAssert(parser.getDouble("float1") == 1.1)
        XCTAssert(parser.getDouble("float2") == 2.2)
    }

    func testMultipleLong() {
        let parser = ArgParser()
        parser.newFlag("bool1")
        parser.newFlag("bool2 b")
        parser.newString("string1", fallback: "default1")
        parser.newString("string2 s", fallback: "default2")
        parser.newInt("int1", fallback: 101)
        parser.newInt("int2 i", fallback: 202)
        parser.newDouble("float1", fallback: 1.1)
        parser.newDouble("float2 f", fallback: 2.2)
        parser.parse([
            "--bool1",
            "--bool2",
            "--string1", "value1",
            "--string2", "value2",
            "--int1", "303",
            "--int2", "404",
            "--float1", "3.3",
            "--float2", "4.4",
        ])
        XCTAssert(parser.getFlag("bool1") == true)
        XCTAssert(parser.getFlag("bool2") == true)
        XCTAssert(parser.getString("string1") == "value1")
        XCTAssert(parser.getString("string2") == "value2")
        XCTAssert(parser.getInt("int1")  == 303)
        XCTAssert(parser.getInt("int2") == 404)
        XCTAssert(parser.getDouble("float1") == 3.3)
        XCTAssert(parser.getDouble("float2") == 4.4)
    }

    func testMultipleShort() {
        let parser = ArgParser()
        parser.newFlag("bool1")
        parser.newFlag("bool2 b")
        parser.newString("string1", fallback: "default1")
        parser.newString("string2 s", fallback: "default2")
        parser.newInt("int1", fallback: 101)
        parser.newInt("int2 i", fallback: 202)
        parser.newDouble("float1", fallback: 1.1)
        parser.newDouble("float2 f", fallback: 2.2)
        parser.parse([
            "--bool1",
            "-b",
            "--string1", "value1",
            "-s", "value2",
            "--int1", "303",
            "-i", "404",
            "--float1", "3.3",
            "-f", "4.4",
        ])
        XCTAssert(parser.getFlag("bool1") == true)
        XCTAssert(parser.getFlag("bool2") == true)
        XCTAssert(parser.getString("string1") == "value1")
        XCTAssert(parser.getString("string2") == "value2")
        XCTAssert(parser.getInt("int1")  == 303)
        XCTAssert(parser.getInt("int2") == 404)
        XCTAssert(parser.getDouble("float1") == 3.3)
        XCTAssert(parser.getDouble("float2") == 4.4)
    }

    // ---------------------------------------------------------------------
    // Condensed short-form options.
    // ---------------------------------------------------------------------

    func testCondensedOptions() {
        let parser = ArgParser()
        parser.newFlag("bool b")
        parser.newString("string s")
        parser.newInt("int i")
        parser.newDouble("double d")
        parser.parse(["-bsid", "value", "1", "2.2"])
        XCTAssert(parser.getFlag("bool") == true)
        XCTAssert(parser.getString("string") == "value")
        XCTAssert(parser.getInt("int")  == 1)
        XCTAssert(parser.getDouble("double") == 2.2)
    }

    // ---------------------------------------------------------------------
    // Positional arguments.
    // ---------------------------------------------------------------------

    func testPositionalArgsEmpty() {
        let parser = ArgParser()
        parser.parse([])
        XCTAssert(parser.hasArgs() == false)
    }

    func testPositionalArgs() {
        let parser = ArgParser()
        parser.parse(["foo", "bar"])
        XCTAssert(parser.hasArgs() == true)
        XCTAssert(parser.numArgs() == 2)
        XCTAssert(parser.getArgs()[0] == "foo")
        XCTAssert(parser.getArgs()[1] == "bar")
    }

    func testPositionalArgsAsInts() {
        let parser = ArgParser()
        parser.parse(["1", "2"])
        XCTAssert(parser.hasArgs() == true)
        XCTAssert(parser.numArgs() == 2)
        XCTAssert(parser.getArgsAsInts()[0] == 1)
        XCTAssert(parser.getArgsAsInts()[1] == 2)
    }

    func testPositionalArgsAsDoubles() {
        let parser = ArgParser()
        parser.parse(["1", "2"])
        XCTAssert(parser.hasArgs() == true)
        XCTAssert(parser.numArgs() == 2)
        XCTAssert(parser.getArgsAsDoubles()[0] == 1.0)
        XCTAssert(parser.getArgsAsDoubles()[1] == 2.0)
    }

    // ---------------------------------------------------------------------
    // Option-parsing switch.
    // ---------------------------------------------------------------------

    func testOptionParsingSwitch() {
        let parser = ArgParser()
        parser.parse(["foo", "--", "--bar", "--baz"])
        XCTAssert(parser.numArgs() == 3)
    }

    // ---------------------------------------------------------------------
    // Commands.
    // ---------------------------------------------------------------------

    func callback(parser: ArgParser) {}

    func testCommandMissing() {
        let parser = ArgParser()
        _ = parser.newCmd("cmd", helptext: "help!", callback: callback)
        parser.parse([])
        XCTAssert(parser.hasCmd() == false)
    }

    func testCommandPresent() {
        let parser = ArgParser()
        let cmd = parser.newCmd("cmd", helptext: "help!", callback: callback)
        parser.parse(["cmd"])
        XCTAssert(parser.hasCmd() == true)
        XCTAssert(parser.getCmd() == "cmd")
        XCTAssert(parser.getCmdParser()! === cmd)
    }

    func testCommandWithOptions() {
        let parser = ArgParser()
        let cmd = parser.newCmd("cmd", helptext: "help!", callback: callback)
        cmd.newFlag("bool")
        cmd.newString("string")
        cmd.newInt("int")
        cmd.newDouble("double")
        parser.parse([
            "cmd",
            "foo", "bar",
            "--string", "value",
            "--int", "1",
            "--double", "2.2",
        ])
        XCTAssert(parser.hasCmd() == true)
        XCTAssert(parser.getCmd() == "cmd")
        XCTAssert(parser.getCmdParser()! === cmd)
        XCTAssert(cmd.hasArgs() == true)
        XCTAssert(cmd.numArgs() == 2)
        XCTAssert(cmd.getFlag("bool") == false)
        XCTAssert(cmd.getString("string") == "value")
        XCTAssert(cmd.getInt("int") == 1)
        XCTAssert(cmd.getDouble("double") == 2.2)
    }
}
