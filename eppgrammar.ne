# Builtins make your parser slower. For efficiency, use lexer like Moo
@{%
const moo = require("moo"); // this 'require' creates a node dependency

const lexer = moo.compile({
  functionkeyword: ['sinosc', 'phasor', 'adsr', 'filter', 'samp'],
  functionname: /[a-zA-Z][a-zA-Z0-9]*?/,
  number: /[-+]?[0-9]*?\.[0-9]+?/,
  ws: {match: /\s+/, lineBreaks: true},
  lparen: /\(/,
  rparen: /\)/,
  mult: /\*/,
  add: /\+/,
  dot: /\./
});
%}

# Pass your lexer object using the @lexer option
@lexer lexer

main -> _ Statement _

Statement ->
  func %lparen Statement %rparen
  | Statement %dot Statement
  | Statement %add Statement
  | Statement %mult Statement
  | %number

func ->
  %functionname
  | %functionkeyword

  # Whitespace

  _  -> wschar:* {% function(d) {return null;} %}
  __ -> wschar:+ {% function(d) {return null;} %}

  wschar -> %ws {% id %}



# Number -> _number {% function(d) {return {'literal': parseFloat(d[0])}} %}
#
# _posint ->
#   [0-9] {% id %}
#   | _posint [0-9] {% function(d) {return d[0] + d[1]} %}
#
# _int ->
# 	"-" _posint {% function(d) {return d[0] + d[1]; }%}
# 	| _posint {% id %}
#
# _float ->
# 	_int {% id %}
#   | _int "." _posint {% function(d) {return d[0] + d[1] + d[2]; }%}
#   | "." _posint {% function(d) {return "0" + d[0] + d[1]; }%}
#
# _number ->
#   _float {% id %}
#   | _float "e" _int {% function(d){return d[0] + d[1] + d[2]; } %}






# _ -> null | _ [\s] {% function() {} %}
# __ -> [\s] | __ [\s] {% function() {} %}
