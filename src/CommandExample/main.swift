import ArgParser

func boo(cmdName: String, cmdParser: ArgParser) {
    print("boo!")
}

let parser = ArgParser()
    .helptext("Usage: foobar...")
    .version("1.0")
    .command("boo", ArgParser()
        .helptext("Usage: foobar boo...")
        .callback(boo)
    )

parser.parse()
