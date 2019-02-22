# Builtins make your parser slower. For efficiency, use lexer like Moo
# functionkeyword: [, 'tri', 'square', 'pulse', 'noise', 'cososc', 'phasor', 'adsr', 'filter', 'samp'],
@{%
const moo = require("moo"); // this 'require' creates a node dependency

const lexer = moo.compile({
  osc: ['osc'],
  sinosc: ['sin'],
  cososc: ['cos'],
  sawosc: ['saw'],
  triosc: ['tri'],
  squareosc: ['square'],
  pulseosc: ['pulse'],
  wnoise: ['wnoise'],
  pnoise: ['pnoise'],
  bnoise: ['bnoise'],
  phasosc: ['phasor'],
  tpb: ['tpb'],
  functionkeyword: ['gain', 'adsr', 'dyn', 'dist', 'filter', 'delay', 'flang', 'chorus', 'samp'],
  o: /o/,
  x: /x/,
  at: /@/,
  lparen: /\(/,
  rparen: /\)/,
  lbrack: /\[/,
  rbrack: /\]/,
  pipe: /\|/,
  mult: /\*/,
  add: /\+/,
  dot: /\./,
  assign: /\->/,
  bindr: /\>>/,
  bindl: /\<</,
  ampmore: /\(\(/,
  ampless: /\)\)/,
  silence: /\!/,
  transpmore: /\+/,
  underscore: /\_/,
  hash: /\#/,
  hyphen: /\-/,
  ndash: /\–/,
  mdash: /\—/,
  comma: /\,/,
  colon: /\:/,
  semicolon: /\;/,
  split: /\<:/,
  merge: /\:>/,
  tilde: /\~/,
  functionname: /[a-zA-Z][a-zA-Z0-9]*/,
  number: /[-+]?[0-9]*\.?[0-9]+/,
  ws: {match: /\s+/, lineBreaks: true}
});
%}

# Pass your lexer object using the @lexer option
@lexer lexer

main -> _ Statement _ {% d => ({ "@lang" : d[1] })  %}

Statement ->
      Expression _ %semicolon _ Statement {% d => [{ "@spawn": d[0] }].concat(d[4]) %}
      | Expression ( _ %semicolon ):? {% d => [{ "@spawn": d[0] }] %}
      | %hash . "\n" {% d => ({ "comment": d[3] }) %}

Expression ->
      Loop     {% d => ({ "@loop": d[0] }) %}
      | Beats  {% d => ({ "@beats": d[0] }) %}
      | Synth  {% d => ({ "@synth": d[0] }) %}
      | Tempo  {% id %}

Tempo -> %tpb _ %number {% d => ({ "@tpb": parseInt(d[2]) }) %}

Loop -> "[" Beats "]" {% d => ( d[1] ) %}

Beats -> Beat:+ {% d => [ d[0].join() ] %}

Beat ->
    Rest          {% id %}
    | Hat         {% id %}
    | Snare       {% id %}
    | Kick        {% id %}

Rest -> %dot      {% id %}
Hat -> %hyphen    {% id %}
Snare -> %o       {% id %}
Kick -> %x        {% id %}

Synth ->
      Effects _ %colon _ Function                             {% d => ({ "@fx": d[0], "@func": d[4] }) %}
      | Function                                              {% d => ({ "@func": d[0] }) %}

Effects ->
        %functionkeyword _ Params _ %colon _ Effects          {% d => [ Object.assign({}, {type:d[0].value} , { param: d[2]}) ].concat(d[6]) %}
          # ( console.log(d[0].value) ) %}
        | %functionkeyword _ Params                           {% d => ( Object.assign({}, {type:d[0].value}, { param: d[2]} )) %}
        # | %functionkeyword _ Params                           {% d => ( d[0].value: [{param: d[2]}) %}


Function ->
      Oscillator _ %lparen _ Function _ %rparen               {% d => ({ "@rec": [d[0]].concat(d[4])}) %}
      | Oscillator _ Params _ %add _ Function                 {% d => [{ "@add": [ Object.assign({}, d[0], { param: d[2]}) ].concat(d[6])}] %}
      | Oscillator _ Params _ %mult _ Function                {% d => [{ "@mul": [ Object.assign({}, d[0], { param: d[2]}) ].concat(d[6])}] %}
      | Oscillator _ Params _ %hyphen _ Function              {% d => [{ "@sub": [ Object.assign({}, d[0], { param: d[2]}) ].concat(d[6])}] %}
      | Oscillator _ Params                                   {% d => Object.assign({}, d[0], { param: d[2]}) %}

Oscillator ->
    # %osc _ Sinewave {% id %}
    %osc _ Sinewave                                           {% d => ({ "@osc": "sin" }) %}
    | %osc _ Coswave                                          {% d => ({ "@osc": "@cos" }) %}
    | %osc _ Phasor                                           {% d => ({ "@osc": "@pha" }) %}
    | %osc _ Saw                                              {% d => ({ "@osc": "@saw" }) %}
    | %osc _ Triangle                                         {% d => ({ "@osc": "@tri" }) %}
    | %osc _ Square                                           {% d => ({ "@osc": "@square" }) %}
    | %osc _ Pulse                                            {% d => ({ "@osc": "@pulse" }) %}
    | %osc _ Noise                                            {% id %}

        # | %number _ %pipe _ Params  {% d =>  [ parseFloat(d[0]), d[4] ] %}
        # | %lbrack Params %rbrack {% d =>  %}
        # | %number {% d => parseFloat(d[0]) %}


Sinewave -> %sinosc     {% id %}
Coswave -> %cososc      {% id %}
Phasor -> %phasosc      {% id %}
Saw -> %sawosc          {% id %}
Triangle -> %triosc     {% id %}
Square -> %squareosc    {% id %}
Pulse -> %pulseosc      {% id %}

Noise -> %wnoise {% d => [{ "@wnoise" : d[0] }] %}
      |  %pnoise {% d => [{ "@pnoise" : d[0] }] %}
      |  %bnoise {% d => [{ "@bnoise" : d[0] }] %}

Params -> %lbrack _ %number:+ _ %rbrack        {% d => console.log(d[2])  %}
      | %number                                   {% d => parseInt(d[0]) %}




# Synths -> %lbrack Synth %rbrack

# Synth -> Params _ %bindr _ Functions  {% d => ({
#                                                 "@synth": {
#                                                   "@params": d[0],
#                                                   "@functions": d[4]
#                                                 }
#                                               }) %}


# Functions ->
#             %functionkeyword _ %bindr _ Functions {% d => [ d[0] ].concat(d[4]) %}
#             | %functionkeyword {% d => d[0] %}



# Whitespace

_  -> wschar:* {% function(d) {return null;} %}
__ -> wschar:+ {% function(d) {return null;} %}

wschar -> %ws {% id %}

@{%

function extend(obj, src) {
  for (var key in src) {
    if (src.hasOwnProperty(key)) obj[key] = src[key];
  }
  return obj;
}

%}
