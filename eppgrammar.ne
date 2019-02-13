# Builtins make your parser slower. For efficiency, use lexer like Moo
@{%
const moo = require("moo"); // this 'require' creates a node dependency

const lexer = moo.compile({
  functionkeyword: ['sinosc', 'phasor', 'adsr', 'filter', 'samp'],
  o: /o/,
  x: /x/,
  functionname: /[a-zA-Z][a-zA-Z0-9]*/,
  number: /[-+]?[0-9]*\.?[0-9]+/,
  ws: {match: /\s+/, lineBreaks: true},
  lparen: /\(/,
  rparen: /\)/,
  lbrack: /\[/,
  rbrack: /\]/,
  pipe: /\|/,
  mult: /\*/,
  add: /\+/,
  dot: /\./,
  assign: /->/,
  bindr: />>/,
  bindl: /<</,
  ampmore: /\(\(/,
  ampless: /\)\)/,
  silence: /!/,
  transpmore: /\+/,
  underscore: /\_/,
  hyphen: /\-/,
  ndash: /\–/,
  mdash: /\—/,
  colon: /\:/,
  semicolon: /\;/
});
%}

# Pass your lexer object using the @lexer option
@lexer lexer

main -> Lines {% d =>  ({ "@lang" : d[0] })  %}


Lines ->
      Line _ %semicolon _ Lines {% d => [{ "@spawn" : d[0] }].concat(d[4]) %}
      | Line  {% d => [{ "@spawn" : d[0] }] %}

# Line ->
#     %functionname {% id %}
#     | %functionkeyword {% id %}


Line ->
       Synth {% id %}
      | Loop  {% id %}
      | Beats {% id %}



Synth -> Params _ %bindr _ Functions  {% d => ({
                                                "@synth": {
                                                  "@params": d[0],
                                                  "@functions": d[4]
                                                }
                                              })
                                      %}

Params ->
        %number _ %pipe _ Params  {% d =>  [ parseFloat(d[0]), d[4] ] %}
        | %number {% d => parseFloat(d[0]) %}

Functions ->
            %functionkeyword _ %bindr _ Functions {% d => [d[0]].concat(d[4]) %}
            | %functionkeyword                 {% id %}

Loop -> "[" Beats "]" {% d => ({ "@loop": d[1] }); %}

Beats -> Beat:+ {% d => ({ "@beats": d[0].join() }); %}

Beat ->
    Rest          {% id %}
    | Hat         {% id %}
    | Snare       {% id %}
    | Kick        {% id %}

Rest -> %dot      {% id %}

Hat -> %hyphen    {% id %}

Snare -> %o       {% id %}

Kick -> %x        {% id %}




# Whitespace

_  -> wschar:* {% function(d) {return null;} %}
__ -> wschar:+ {% function(d) {return null;} %}

wschar -> %ws {% id %}
