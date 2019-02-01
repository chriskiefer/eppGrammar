@{%
const moo = require("moo"); // this 'require' creates a node dependency

const lexer = moo.compile({
  functionkeyword: ['sinosc','add'],
  functionname: /[a-zA-Z][a-zA-Z0-9]*/,
  number: /[-+]?[0-9]*\.[0-9]+/,
  ws:     /[ \t\v\f]/,
  lparen: /\(/,
  rparen: /\)/,
});
%}

# Pass your lexer object using the @lexer option:
@lexer lexer

main -> _ statement _
statement ->  func %lparen statement %rparen
  | %number

func -> %functionname
  | %functionkeyword


_  -> wschar:* {% function(d) {return null;} %}
__ -> wschar:+ {% function(d) {return null;} %}
wschar -> %ws {% id %}
