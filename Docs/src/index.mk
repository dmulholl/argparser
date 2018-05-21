---
title: Home
meta title: ArgParse &mdash; an argument-parsing library for Swift
meta description: >
    ArgParse is an argument-parsing library designed for building elegant command-line interfaces.
---

ArgParse is an argument-parsing library designed for building elegant command-line interfaces.



### Features

* Long-form boolean flags with single-character shortcuts: `--flag`, `-f`.

* Long-form string, integer, and floating-point options with
  single-character shortcuts: `--option <arg>`, `-o <arg>`.

* Condensed short-form options: `-abc <arg> <arg>`.

* Automatic `--help` and `--version` flags.

* Support for multivalued options.

* Support for git-style command interfaces with arbitrarily-nested commands.



### Installation

You can add ArgParse to your application as a dependency using the Swift Package Manager. The repository url is:

    https://github.com/dmulholland/ArgParse.git

Alternatively, you can add the single public-domain `ArgParse.swift` file directly to your application's source.



### Status

ArgParse is a beta-stage project and breaking changes to its API are possible. Feedback is welcome.



### Links

* [Github Homepage][github]
* [Sample Application][sample]
* [Online Documentation][docs]


[github]: https://github.com/dmulholland/ArgParse
[docs]: https://darrenmulholland.com/docs/argparse/
[sample]:
    https://github.com/dmulholland/ArgParse/blob/master/Sources/ArgParseExample/main.swift



### License

This work has been placed in the public domain.
