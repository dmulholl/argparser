import ArgParser

func boo(cmdName: String, cmdParser: ArgParser) {
    print("---------------- boo! ----------------")
    cmdParser.dump()
    print("--------------------------------------")
}

let parser = ArgParser()
    .helptext("Usage: example...")
    .version("1.0")
    .command("boo", ArgParser()
        .helptext("Usage: example boo...")
        .callback(boo)
        .flag("foo f")
        .option("bar b")
    )

parser.parse()
parser.dump()
