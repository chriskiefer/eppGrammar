// Generated automatically by nearley, version 2.16.0
// http://github.com/Hardmath123/nearley
(function () {
function id(x) { return x[0]; }
var grammar = {
    Lexer: undefined,
    ParserRules: [
    {"name": "block", "symbols": ["_", "statement", "_"]},
    {"name": "statement", "symbols": ["Name", "_", "parenExpr"]},
    {"name": "parenExpr", "symbols": [{"literal":"&"}, "exprlist", {"literal":"%"}]},
    {"name": "exprlist", "symbols": ["expr"]},
    {"name": "exprlist", "symbols": ["exprlist", "_", {"literal":","}, "_", "expr"]},
    {"name": "expr", "symbols": ["Number"]},
    {"name": "expr", "symbols": ["parenExpr"]},
    {"name": "expr", "symbols": ["statement"]},
    {"name": "expr", "symbols": []},
    {"name": "Name", "symbols": ["_name"], "postprocess": function(d) {return {'name': d[0]}; }},
    {"name": "_name", "symbols": [/[a-zA-Z_]/], "postprocess": id},
    {"name": "_name", "symbols": ["_name", /[\w_]/], "postprocess": function(d) {return d[0] + d[1]; }},
    {"name": "Number", "symbols": ["_number"], "postprocess": function(d) {return {'literal': parseFloat(d[0])}}},
    {"name": "_posint", "symbols": [/[0-9]/], "postprocess": id},
    {"name": "_posint", "symbols": ["_posint", /[0-9]/], "postprocess": function(d) {return d[0] + d[1]}},
    {"name": "_int", "symbols": [{"literal":"-"}, "_posint"], "postprocess": function(d) {return d[0] + d[1]; }},
    {"name": "_int", "symbols": ["_posint"], "postprocess": id},
    {"name": "_float", "symbols": ["_int"], "postprocess": id},
    {"name": "_float", "symbols": ["_int", {"literal":"."}, "_posint"], "postprocess": function(d) {return d[0] + d[1] + d[2]; }},
    {"name": "_float", "symbols": [{"literal":"."}, "_posint"], "postprocess": function(d) {return "0" + d[0] + d[1]; }},
    {"name": "_number", "symbols": ["_float"], "postprocess": id},
    {"name": "_number", "symbols": ["_float", {"literal":"e"}, "_int"], "postprocess": function(d){return d[0] + d[1] + d[2]; }},
    {"name": "_", "symbols": []},
    {"name": "_", "symbols": ["_", /[\s]/], "postprocess": function() {}},
    {"name": "__", "symbols": [/[\s]/]},
    {"name": "__", "symbols": ["__", /[\s]/], "postprocess": function() {}}
]
  , ParserStart: "block"
}
if (typeof module !== 'undefined'&& typeof module.exports !== 'undefined') {
   module.exports = grammar;
} else {
   window.grammar = grammar;
}
})();
