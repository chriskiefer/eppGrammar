# eppgrammar


Compile eppgrammar files to a JavaScript module
```
$ nearleyc eppgrammar.ne -o eppprocessor.js
```

Test eppprocessor against input
```
$ nearley-test ./eppprocessor.js --input '[xo.-.xo];'                           # One line with a Loop

$ nearley-test ./eppprocessor.js --input 'xo.-.xo;'                             # One line with Beats

$ nearley-test ./eppprocessor.js --input '3 | 2  >> sinosc;'                    # One line with a Synth

$ nearley-test ./eppprocessor.js --input '[xo.-.xo]  ; x.ox.-x.-; 10 | 3 | 2  >> sinosc >> sinosc; [x.-o.-.o-x]'     # Multiline with Loops, Beats and Synth

$ nearley-test ./eppprocessor.js --input 'tpb 12'                               # One line with a Loop

$ nearley-test ./eppprocessor.js --input '[xo.-.xo]; x.-ox.o- ; [xo-o.x.o-]; tpb 12 ;'

$ nearley-test ./eppprocessor.js --input 'tpb 12; x.oo-x.o-xo; [x.-o.xo-o.x]; ∞ ∆ 12'

$ nearley-test ./eppprocessor.js --input 'tpb 12; x.oo-x.o-xo; [x.-o.xo-o.x]; ∞ ∆ (∞ ~ 12 + ∞ ◊ 1 )'
```

Generate a railroad diagram for eppgrammar
```
$ nearley-railroad eppgrammar.ne -o eppgrammar.html
```


## License
MIT
