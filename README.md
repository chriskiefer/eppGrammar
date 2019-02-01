# eppgrammar


Compile eppgrammar files to a JavaScript module
```
$ nearleyc eppgrammar.ne -o eppprocessor.js
```

Test eppprocessor against input
```
$ nearley-test ./eppprocessor.js --input 'sinosc(2.0)'
```

Generate a railroad diagram for eppgrammar
```
$ nearley-railroad eppgrammar.ne -o eppgrammar.html
```


## License
MIT
