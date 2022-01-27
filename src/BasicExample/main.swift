import ArgParser

let parser = ArgParser()
    .helptext("Usage: example...")
    .version("1.0")
    .flag("foo f")
    .option("bar b")

parser.parse()
parser.dump()
