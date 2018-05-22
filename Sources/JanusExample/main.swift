// -----------------------------------------------------------------------------
// A sample application demonstrating Janus in action.
// -----------------------------------------------------------------------------

import Janus

// Callback function for the 'foo' command. This function will be called if
// the command is found. The function recieves an ArgParser instance containing
// the command's parsed arguments. Here we simply dump it to stdout.
func callback(parser: ArgParser) {
    print("---------- callback ----------")
    parser.dump()
    print("------------------------------\n")
}

// We instantiate an argument parser, optionally supplying help text and a
// version string. Supplying help text activates an automatic --help flag,
// supplying a version string activates an automatic --version flag.
let parser = ArgParser(helptext: "Help!", version: "Version 1.2.3")

// Register a flag, --bool, with a single-character alias, -b. A flag is a
// boolean option - it is either present (true) or absent (false).
parser.newFlag("bool b")

// Register a string option, --string <arg>, with a single-character alias,
// -s <arg>. The default fallback value for string options is the empty string.
// Here we specify a custom fallback value.
parser.newString("string s", fallback: "foobar")

// Register an integer option, --int <arg>, with a single-character alias,
// -i <arg>. The default fallback value for integer options is 0.
parser.newInt("int i")

// Register a floating-point option, --double <arg>, with a single-character
// alias, -d <arg>. The default fallback value for floating-point options is 0.
parser.newDouble("double d")

// Register a command 'foo'. We need to supply the command's help text and a
// callback function.
let cmdParser = parser.newCmd("foo", helptext: "Command!", callback: callback)

// Registering a command returns a new ArgParser instance dedicated to parsing
// the command's arguments. We can register as many flags and options as we
// like on this subparser. Note that the subparser can reuse the parent's
// option names without interference.
cmdParser.newFlag("bool")
cmdParser.newInt("int i", fallback: 999)

// Once all our options and commands have been registered we call the parser's
// parse() method with an array of string arguments. Only the root parser's
// parse() method should be called - command arguments will be parsed
// automatically. The parse() method defaults to parsing the application's
// command line arguments if no array is supplied.
parser.parse()

// In a real application we could now retrieve our option and argument values
// from the parser instance. Here we simply dump the parser to stdout.
parser.dump()
