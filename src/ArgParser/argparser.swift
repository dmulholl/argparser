import Foundation


/// Writes to stderr.
fileprivate func writeStderr(_ string: String) {
    if let data = string.data(using: .utf8) {
        FileHandle.standardError.write(data)
    }
}


/// Exits with an error message and a non-zero status code.
fileprivate func exitWithError(_ message: String) -> Never {
    writeStderr("Error: " + message + ".\n")
    exit(1)
}


/// Internal class for storing option values.
fileprivate class Option {
    var values = [String]()
}


/// Internal class for storing flag counts.
fileprivate class Flag {
    var count = 0
}


/// Internal class for making an array of arguments available as a stream.
fileprivate class ArgStream {
    let args: [String]
    var index = 0

    init(_ args: [String]) {
        self.args = args
    }

    func next() -> String {
        index += 1
        return args[index - 1]
    }

    func hasNext() -> Bool {
        return index < args.count
    }
}


/// An ArgParser instance is responsible for registering options and commands and parsing the
/// input array of raw arguments.
public class ArgParser {
    private var _helptext: String?
    private var _version: String?
    private var options = [String:Option]()
    private var flags = [String:Flag]()
    private var commands = [String:ArgParser]()
    private var commandCallback: ((String, ArgParser) -> Void)?
    private var _enableHelpCommand = false

    public init() {}

    /// If a command was found, stores the command name.
    public var commandName: String?

    /// If a comand was found, stores the command's parser instance.
    public var commandParser: ArgParser?

    /// Stores positional arguments.
    public var args = [String]()

    /// Registers a helptext string for the parser.
    /// Supplying a helptext string activates an automatic `--help/-h` flag.
    public func helptext(_ text: String) -> ArgParser {
        self._helptext = text
        return self
    }

    /// Registers a version string for the parser.
    /// Supplying a version string activates an automatic `--version/-v` flag.
    public func version(_ text: String) -> ArgParser {
        self._version = text
        return self
    }

    /// Registers a new flag. The `name` parameter accepts an unlimited number of space-separated
    /// aliases and single-character shortcuts.
    public func flag(_ name: String) -> ArgParser {
        let flag = Flag()
        for alias in name.split(separator: " ") {
            flags[String(alias)] = flag
        }
        return self
    }

    /// Registers a new option. The `name` parameter accepts an unlimited number of space-separated
    /// aliases and single-character shortcuts.
    public func option(_ name: String) -> ArgParser {
        let option = Option()
        for alias in name.split(separator: " ") {
            options[String(alias)] = option
        }
        return self
    }

    /// Registers a new command. The `name` parameter accepts an unlimited number of space-separated
    /// aliases and single-character shortcuts.
    public func command(_ name: String, _ commandParser: ArgParser) -> ArgParser {
        for alias in name.split(separator: " ") {
            commands[String(alias)] = commandParser
        }
        if commandParser._helptext != nil {
            _enableHelpCommand = true
        }
        return self
    }

    /// Registers a callback function on a command parser. If the command is found the function
    /// will be called and passed the command name and the command's ArgParser instance.
    public func callback(_ cb: @escaping (String, ArgParser) -> Void) -> ArgParser {
        commandCallback = cb
        return self
    }

    /// Boolean switch. Toggles support for an automatic `help` command that prints subcommand
    /// help text.
    public func enableHelpCommand(_ enable: Bool) -> ArgParser {
        _enableHelpCommand = enable
        return self
    }

    // ---------------------------------------------------------------------
    // Retrieve option values.
    // ---------------------------------------------------------------------

    /// Returns the number of times the specified flag or option was found.
    public func count(_ name: String) -> Int {
        if let flag = flags[name] {
            return flag.count
        } else if let option = options[name] {
            return option.values.count
        } else {
            exitWithError("'\(name)' is not a registered flag or option name")
        }
    }

    /// Returns true if the specified flag or option was found.
    public func found(_ name: String) -> Bool {
        return count(name) > 0
    }

    /// Returns the value of the specified option.
    public func value(_ name: String) -> String? {
        if let option = options[name] {
            return option.values.last
        }
        exitWithError("'\(name)' is not a registered option name")
    }

    /// Returns the specified option's list of values.
    public func values(_ name: String) -> [String] {
        if let option = options[name] {
            return option.values
        }
        exitWithError("'\(name)' is not a registered option name")
    }

    // ---------------------------------------------------------------------
    // Parsing machinery.
    // ---------------------------------------------------------------------

    /// Parse an array of strings. Defaults to parsing the command line arguments.
    public func parse(_ args: [String]? = nil) {
        let stream = ArgStream(args ?? Array(CommandLine.arguments[1...]))
        self.parseStream(stream)
    }

    /// Parse a stream of strings.
    private func parseStream(_ stream: ArgStream) {
        var isFirstArg = true

        while stream.hasNext() {
            let arg = stream.next()

            // If we encounter a -- argument, turn off option parsing.
            if arg == "--" {
                while stream.hasNext() {
                    args.append(stream.next())
                }
            }

            // Is the argument a long-form option?
            else if arg.starts(with: "--") {
                parseLongOption(String(arg.dropFirst(2)), stream)
            }

            // Is the argument a short-form option?
            else if arg.starts(with: "-") {
                if arg == "-" {
                    args.append(arg)
                } else if Array(arg)[1] >= "0" && Array(arg)[1] <= "9" {
                    args.append(arg)
                } else {
                    parseShortOption(String(arg.dropFirst(1)), stream)
                }
            }

            // Is the argument a registered command?
            else if isFirstArg, let parser = commands[arg] {
                commandName = arg
                commandParser = parser
                parser.parseStream(stream)
                parser.commandCallback?(arg, parser)
            }

            // Is the argument an automatic 'help' command?
            else if isFirstArg && _enableHelpCommand && arg == "help" {
                if stream.hasNext() {
                    let name = stream.next()
                    if let parser = commands[name] {
                        parser.exitWithHelptext()
                    } else {
                        exitWithError("'\(name)' is not a recognised command name")
                    }
                } else {
                    exitWithError("the help command requires an argument")
                }
            }

            // Add the argument to our list of positionals.
            else {
                args.append(arg)
            }

            isFirstArg = false
        }
    }

    /// Parse an option beginning with a double dash.
    private func parseLongOption(_ arg: String, _ stream: ArgStream) {
        if arg.contains("=") {
            parseEqualsOption(prefix: "--", arg: arg)
        } else if let flag = flags[arg] {
            flag.count += 1
        } else if let option = options[arg] {
            if stream.hasNext() {
                option.values.append(stream.next())
            } else {
                exitWithError("missing value for '--\(arg)' option")
            }
        } else if arg == "help" && _helptext != nil {
            exitWithHelptext()
        } else if arg == "version" && _version != nil {
            exitWithVersion()
        } else {
            exitWithError("--\(arg) is not a recognised flag or option name")
        }
    }

    /// Parse an option beginning with a single dash.
    private func parseShortOption(_ arg: String, _ stream: ArgStream) {
        if arg.contains("=") {
            parseEqualsOption(prefix: "-", arg: arg)
            return
        }

        for char in arg {
            if let flag = flags[String(char)] {
                flag.count += 1
            } else if let option = options[String(char)] {
                if stream.hasNext() {
                    option.values.append(stream.next())
                } else if arg.count > 1 {
                    exitWithError("missing value for '\(char)' option in -\(arg)")
                } else {
                    exitWithError("missing value for '-\(arg)' option")
                }
            } else if char == "h" && _helptext != nil {
                exitWithHelptext()
            } else if char == "v" && _version != nil {
                exitWithVersion()
            } else if arg.count > 1 {
                exitWithError("'\(char)' in -\(arg) is not a recognised flag or option name")
            } else {
                exitWithError("-\(arg) is not a recognised flag or option name")
            }
        }
    }

    /// Parse an option of the form --name=value or -n=value.
    private func parseEqualsOption(prefix: String, arg: String) {
        let split = arg.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
        let name = String(split[0])
        let value = String(split[1])

        guard let option = options[name] else {
            exitWithError("\(prefix)\(name) is not a recognised option name")
        }

        guard value != "" else {
            exitWithError("missing value for '\(prefix)\(name)' option")
        }

        option.values.append(value)
    }

    // ---------------------------------------------------------------------
    // Utility functions.
    // ---------------------------------------------------------------------

    /// Prints the parser's help text and exits.
    public func exitWithHelptext() -> Never {
        print(_helptext ?? "")
        exit(0)
    }

    /// Prints the parser's version string and exits.
    public func exitWithVersion() -> Never {
        print(_version ?? "")
        exit(0)
    }

    /// Dumps the parser's state to stdout.
    public func dump() {
        print("Flags:")
        if flags.count > 0 {
            for name in flags.keys.sorted() {
                print("  \(name): \(flags[name]!.count)")
            }
        } else {
            print("  [none]")
        }

        print("\nOptions:")
        if options.count > 0 {
            for name in options.keys.sorted() {
                print("  \(name): \(options[name]!.values)")
            }
        } else {
            print("  [none]")
        }

        print("\nArguments:")
        if args.count > 0 {
            for arg in args {
                print("  \(arg)")
            }
        } else {
            print("  [none]")
        }

        print("\nCommand:")
        print("  \(commandName ?? "[none]")")
    }
}
