# eppgrammar


Compile eppgrammar files to a JavaScript module
```
$ nearleyc eppgrammar.ne -o eppgrammar.js
```

Test a eppgrammar against input
```
$ nearley-test ./eppgrammar.js --input 'sinosc(2.0)'
```

Generate a railroad diagram for eppgrammar
```
$ nearley-railroad eppgrammar.ne -o eppgrammar.html
```
