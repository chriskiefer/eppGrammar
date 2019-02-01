// Generated automatically by nearley, version 2.16.0
// http://github.com/Hardmath123/nearley
(function () {
function id(x) { return x[0]; }

const moo = require("moo"); // this 'require' creates a node dependency

const lexer = moo.compile({
  functionkeyword: ['sinosc','add'],
  functionname: /[a-zA-Z][a-zA-Z0-9]*/,
  number: /[-+]?[0-9]*\.[0-9]+/,
  ws:     /[ \t\v\f]/,
  lparen: /\(/,
  rparen: /\)/,
});
var grammar = {
    Lexer: lexer,
    ParserRules: [
    {"name": "main", "symbols": ["_", "statement", "_"]},
    {"name": "statement", "symbols": ["func", (lexer.has("lparen") ? {type: "lparen"} : lparen), "statement", (lexer.has("rparen") ? {type: "rparen"} : rparen)]},
    {"name": "statement", "symbols": [(lexer.has("number") ? {type: "number"} : number)]},
    {"name": "func", "symbols": [(lexer.has("functionname") ? {type: "functionname"} : functionname)]},
    {"name": "func", "symbols": [(lexer.has("functionkeyword") ? {type: "functionkeyword"} : functionkeyword)]},
    {"name": "_$ebnf$1", "symbols": []},
    {"name": "_$ebnf$1", "symbols": ["_$ebnf$1", "wschar"], "postprocess": function arrpush(d) {return d[0].concat([d[1]]);}},
    {"name": "_", "symbols": ["_$ebnf$1"], "postprocess": function(d) {return null;}},
    {"name": "__$ebnf$1", "symbols": ["wschar"]},
    {"name": "__$ebnf$1", "symbols": ["__$ebnf$1", "wschar"], "postprocess": function arrpush(d) {return d[0].concat([d[1]]);}},
    {"name": "__", "symbols": ["__$ebnf$1"], "postprocess": function(d) {return null;}},
    {"name": "wschar", "symbols": [(lexer.has("ws") ? {type: "ws"} : ws)], "postprocess": id}
]
  , ParserStart: "main"
}
if (typeof module !== 'undefined'&& typeof module.exports !== 'undefined') {
   module.exports = grammar;
} else {
   window.grammar = grammar;
}
})();
