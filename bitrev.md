Odwracanie wektora bitów
===

W pliku `bitrev.s` zaprogramuj w asemblerze `x86-64` procedurę o sygnaturze
`uint64_t bitrev(uint64_t)`. Dla danego słowa maszynowego składającego się z
bitów <tt>b<sub>n-1</sub>...b<sub>0</sub></tt> procedura ma wyznaczyć jego
lustrzane odbicie tak, że dla każdego `i` zachodzi <tt>r<sub>i</sub> =
b<sub>(n-1)-i</sub></tt>, gdzie `r` jest wynikiem działania. Rozwiązanie ma
działać w `O(log n)`, gdzie `n` jest długością słowa maszynowego w bitach.
