const nearley = require("nearley");
const grammar = require("../bkp/grammar.js");

// Create a Parser object from our grammar.
const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar));

// Parse something!
parser.feed("sinosc(2.0)");

// parser.results is an array of possible parsings.
console.log(parser.results); // [[[[ "foo" ],"\n" ]]]
