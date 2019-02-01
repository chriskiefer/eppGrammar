#bits of this taken from https://github.com/kach/nearley/blob/master/examples/lua.ne




block -> _ statement _

statement -> Name _ parenExpr

parenExpr -> "&" exprlist "%"

exprlist -> expr | exprlist _ "," _ expr
expr -> Number
    | parenExpr
    | statement
    | null


Name -> _name {% function(d) {return {'name': d[0]}; } %}

_name -> [a-zA-Z_] {% id %}
| _name [\w_] {% function(d) {return d[0] + d[1]; } %}

# Primitives
# ==========

# Numbers

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
_ -> null | _ [\s] {% function() {} %}
__ -> [\s] | __ [\s] {% function() {} %}
