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

main -> _ Statement _

Statement ->
  func %lparen Statement %rparen
  | Number

func ->
  %functionname
  | %functionkeyword



# Numbers — defining our rules can be more efficient that using builtins

Number -> _number {% function(d) {return {'literal': parseFloat(d[0])}} %}

_posint ->
  [0-9] {% id %}
  | _posint [0-9] {% function(d) {return d[0] + d[1]} %}

_int ->
	"-" _posint {% function(d) {return d[0] + d[1]; }%}
	| _posint {% id %}

_float ->
	_int {% id %}
  | _int "." _posint {% function(d) {return d[0] + d[1] + d[2]; }%}
  | "." _posint {% function(d) {return "0" + d[0] + d[1]; }%}

_number ->
  _float {% id %}
  | _float "e" _int {% function(d){return d[0] + d[1] + d[2]; } %}



# Whitespace

_  -> wschar:* {% function(d) {return null;} %}
__ -> wschar:+ {% function(d) {return null;} %}

wschar -> [ \t\n\v\f] {% id %}


# _ -> null | _ [\s] {% function() {} %}
# __ -> [\s] | __ [\s] {% function() {} %}
