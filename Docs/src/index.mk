---
title: Home
meta title: Janus &mdash; an argument-parsing library for Swift
meta description: >
    Janus is an argument-parsing library designed for building elegant command-line interfaces.
---

Janus is an argument-parsing library designed for building elegant command-line interfaces.



### Features

* Long-form boolean flags with single-character shortcuts: `--flag`, `-f`.

* Long-form string, integer, and floating-point options with
  single-character shortcuts: `--option <arg>`, `-o <arg>`.

* Condensed short-form options: `-abc <arg> <arg>`.

* Automatic `--help` and `--version` flags.

* Support for multivalued options.

* Support for git-style command interfaces with arbitrarily-nested commands.



### Installation

You can add Janus to your application as a dependency using the Swift Package Manager. The repository url is:

    https://github.com/dmulholland/janus-swift.git

Alternatively, you can add the single public-domain `Janus.swift` file directly to your application's source.



### Links

* [Github Homepage][github]
* [Sample Application][sample]


[github]: https://github.com/dmulholland/janus-swift
[sample]: https://github.com/dmulholland/janus-swift/blob/master/Sources/JanusExample/main.swift



### License

This work has been placed in the public domain.
