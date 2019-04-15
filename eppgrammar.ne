# Builtins make your parser slower. For efficiency, use lexer like Moo
# functionkeyword: [, 'tri', 'square', 'pulse', 'noise', 'cososc', 'phasor', 'adsr', 'filter', 'samp'],
@{%
const moo = require("moo"); // this 'require' creates a node dependency

const lexer = moo.compile({
  osc:          ['osc',    '∞'],  // ∞ – Option–5
  sinosc:       ['sin',    '~'],  // ~ – Shift-`
  cososc:       ['cos',    '≈'],  // ≈ – Option–x
  triosc:       ['tri',    '∆'],  // ∆ – Option–j
  sawosc:       ['saw',    '◊'],  // ◊ – Shift-Option–v
  phasosc:      ['phasor', 'ø'],  // Ø – Option–o
  squareosc:    ['square', '∏'],  // ∏ – Shift-Option–p
  pulseosc:     ['pulse',  '^'],  // ^ – Shift–6
  gateosc:      ['gate',   '≠'],  // ≠ – Option–=
  patternosc:   ['patt',   '¶'],  // ¶ – Option–7
  bus:          ['bus',    '‡' ], // ‡ – Shift-Option–7
  wnoise:       ['wnoise', 'Ω'],  // Ω – Option–z
  pnoise:       ['pnoise'],
  bnoise:       ['bnoise'],
  tpb:          ['tpb'],
  import:       ['import'],
  declaration:  ['let'],
  functionkeyword: ['gain', 'adsr', 'dyn', 'dist', 'filter', 'delay', 'flang', 'chorus', 'samp', 'rev', 'conv', 'map'],
  map:          ['linlin', 'linexp', 'explin', 'expexp', 'linreg', 'class'],
  o:            /o/,
  x:            /x/,
  at:           /@/,
  lparen:       /\(/,
  rparen:       /\)/,
  lbrack:       /\[/,
  rbrack:       /\]/,
  pipe:         /\|/,
  add:          /\+/,
  mult:         /\*/,
  div:          /\//,
  dot:          /\./,
  assign:       /\->/,
  bindr:        /\>>/,
  bindl:        /\<</,
  ampmore:      /\(\(/,
  ampless:      /\)\)/,
  silence:      /\!/,
  transpmore:   /\+/,
  underscore:   /\_/,
  hash:         /\#/,
  hyphen:       /\-/,
  ndash:        /\–/,
  mdash:        /\—/,
  comma:        /\,/,
  colon:        /\:/,
  semicolon:    /\;/,
  split:        /\<:/,
  merge:        /\:>/,
  tilde:        /\~/,
  dquote:       /\"/,
  squote:       /\'/,
  functionname: /[a-zA-Z][a-zA-Z0-9]*/,
  number:       /[-+]?[0-9]*\.?[0-9]+/,
  ws:   {match: /\s+/, lineBreaks: true}
});
%}

# Pass your lexer object using the @lexer option
@lexer lexer

main -> ( _ Statement _ ):+                                   {% d => ({ "☺++" : d[1] })  %}

Statement -> Expressions
      | Declaration
      | Import
      | Comment

Declaration -> %let %functionname %dquote .:* %dquote         {% id %}
Import -> %import %lparen %functionname %rparen               {% id %}
Comment -> %hash .:* "\n"                                     {% d => ({ "☺comment": d[3] }) %}

Expressions -> Expression _ %semicolon _ Statement            {% d => [{ "☺spawn": d[0] }].concat(d[4]) %}
      | Expression ( _ %semicolon ):?                         {% d => [{ "☺spawn": d[0] }] %}
      | %hash . "\n"                                          {% d => ({ "☺comment": d[3] }) %}

Expression ->
      Loop                                                    {% d => ({ "☺loop": d[0] }) %}
      | Beats                                                 {% d => ({ "☺beats": d[0] }) %}
      | Synth                                                 {% d => ({ "☺synth": d[0] }) %}
      | Tempo                                                 {% id %}

Tempo -> %tpb _ %number                                       {% d => ({ "☺tpb": parseInt(d[2]) }) %}

Beats -> Beat:+                                               {% d => [ d[0].join() ] %}

Beat ->
    Rest                                                      {% id %}
    | Hat                                                     {% id %}
    | Snare                                                   {% id %}
    | Kick                                                    {% id %}

Rest -> %dot                                                  {% id %}
Hat -> %hyphen                                                {% id %}
Snare -> %o                                                   {% id %}
Kick -> %x                                                    {% id %}

Loop -> "[" Beats "]"                                         {% d => ( d[1] ) %}

Synth -> Effects _ %colon _ Function                          {% d => ({ "@fx": d[0], "@func": d[4] }) %}
      | Function                                              {% d => ({ "@func": d[0] }) %}

Effects -> %functionkeyword _ Params _ %colon _ Effects       {% d => [ Object.assign({}, {type:d[0].value} , { param: d[2]}) ].concat(d[6]) %}
        | %functionkeyword _ Params                           {% d => ( Object.assign({}, {type:d[0].value}, { param: d[2]} )) %}

Function ->
      Oscillator _ %lparen _ Function _ %rparen               {% d => ({ "@comp": [d[0]].concat(d[4])}) %}
      | Oscillator _ Params _ %add _ Function                 {% d => [{ "@add": [ Object.assign({}, d[0], { param: d[2]}) ].concat(d[6])}] %}
      | Oscillator _ Params _ %mult _ Function                {% d => [{ "@mul": [ Object.assign({}, d[0], { param: d[2]}) ].concat(d[6])}] %}
      | Oscillator _ Params _ %hyphen _ Function              {% d => [{ "@sub": [ Object.assign({}, d[0], { param: d[2]}) ].concat(d[6])}] %}
      | Oscillator _ Params _ %div _ Function                 {% d => [{ "@div": [ Object.assign({}, d[0], { param: d[2]}) ].concat(d[6])}] %}
      | Oscillator _ Params                                   {% d => Object.assign({}, d[0], { param: d[2]}) %}

# Composition Operators
Combinators -> Sequential
            | Parallel
            | Recursive
            | Split
            | Merge

Oscillator ->  %osc _ OscillatorType %lbrack _ Params _ %rbrack
            |  %osc %lbrack _ OscillatorType %comma Params _ %rbrack

# OscillatorType is based on Maximilian's maxiOsc
OscillatorType -> Sinewave                                    {% d => ({ "@type": "@sin" }) %}
                | Coswave                                     {% d => ({ "@type": "@cos" }) %}
                | Phasor                                      {% d => ({ "@type": "@pha" }) %}
                | Saw                                         {% d => ({ "@type": "@saw" }) %}
                | Triangle                                    {% d => ({ "@type": "@tri" }) %}
                | Square                                      {% d => ({ "@type": "@square" }) %}
                | Pulse                                       {% d => ({ "@type": "@pulse" }) %}
                | Noise                                       {% id %}

Sinewave -> %sinosc                                           {% id %}
          | %sinosc                                           {% id %}

Coswave -> %cososc                                            {% id %}
Coswave -> %cososc                                            {% id %}
Phasor -> %phasosc                                            {% id %}
Phasor -> %phasosc                                            {% id %}
Saw -> %sawosc                                                {% id %}
Saw -> %sawosc                                                {% id %}
Triangle -> %triosc                                           {% id %}
Triangle -> %triosc                                           {% id %}
Square -> %squareosc                                          {% id %}
Square -> %squareosc                                          {% id %}
Pulse -> %pulseosc                                            {% id %}
Pulse -> %pulseosc                                            {% id %}

Noise -> %wnoise                                              {% d => [{ "@wnoise" : d[0] }] %}
      |  %pnoise                                              {% d => [{ "@pnoise" : d[0] }] %}
      |  %bnoise                                              {% d => [{ "@bnoise" : d[0] }] %}

Params -> %number _ Params                                    {% d => return [ { parseFloat(d[0]) + d[2]  %}
      | null                                                  {% d => parseFloat(d[0]) %}

# Whitespace

_  -> wschar:*                                                {% function(d) {return null;} %}
__ -> wschar:+                                                {% function(d) {return null;} %}

wschar -> %ws                                                 {% id %}
