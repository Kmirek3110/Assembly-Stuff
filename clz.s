/*
 * UWAGA! W poniższym kodzie należy zawrzeć krótki opis metody rozwiązania
 *        zadania. Będzie on czytany przez sprawdzającego. Przed przystąpieniem
 *        do rozwiązywania zapoznaj się dokładnie z jego treścią. Poniżej należy
 *        wypełnić oświadczenie o samodzielnym wykonaniu zadania.
 *
 * Oświadczam, że zapoznałem(-am) się z regulaminem prowadzenia zajęć
 * i jestem świadomy(-a) konsekwencji niestosowania się do podanych tam zasad.
 *
 * Imię i nazwisko, numer indeksu: Karol Mirek, 301650
 */

        .text
        .globl  clz
        .type   clz, @function

/*
 * W moim rozwiązaniu używam następującej techniki: 
        Find first set
        liczę ile jest wiodących zer w coraz to mniejszych przedziałach
        zaczynając od 8 bajtów, następnie na n_i-1 = n_i /2 
        Liczymy to za pomocą coraz to większych numerycznie(robimy shlq na masce) masek ponieważ
        cały czas jeśli musieliśmy przesuwaliśmy nasz input także w lewo zliczajac jedynki. 

        Dodatkowo na początku istnieje check na 0.

        Pierwszy krok sprawdzamy dla maski z 8bajtami jedynek 
        Jeśli input jest mniejszy od tego to wiemy ze napewno jego 32pierwsze bity są zerami 
 */

clz:
        xor     %eax,%eax       /* Tutaj robię coś bardzo ważnego! */
        xor     %r9,%r9

        cmpq    $0,%rdi       /* Przypadek specjalny sprawdzamy czy input nie jest zerem */
        je      zero          /* Jeśli jest idziemy do specjalnego zakończenia gdzie zwracamy 64 */
        
        movq     $0x00000000FFFFFFFF, %r9 /* Pierwsza maska w której wypełniamy 1/2 ostatnich bajtów */
        cmpq     %r9, %rdi              /* Jeśli nasz input jest od niej mniejszy to wiemy ze pierwsze */
        jnbe     one_fourth              /* 8 bajtów jest zerami. Jeśli input był mniejszy to  */     
        addq     $32, %rax               /* przesuwamy o 32 rdi  w lewo (8bajtów) ponieważ już je sprawdzilismy */   
        shlq     $32, %rdi              /* i nie musimy ich rozpatrzać */

one_fourth:
        shlq     $16, %r9               /* Maska w której 4 pierwsze bajty to 0 reszta 1 */
        cmpq     %r9, %rdi           /*  Jest ona numerycznie większa od poprzedniej maski */
        jnbe     one_eight            /* jeśli przesuneliśmy rdi u góry, to tutaj sprawdzamy kolejne 4 bajty(pierwsze 4 bajty od połowy w prawo)    */
        addq     $16, %rax             /* wpp. sprawdzamy input na większej masce i stosujemy logikę podobną co w poprzednich krokach */
        shlq     $16, %rdi             /*  (jeśli jesteśmy mniejsi od większej maski to wiemy ile bajtów napewno jest zerami)    */

one_eight:
        shlq     $8, %r9 /* Tak samo co w one_fourth tylko na większej numerycznie masce z mniejsza ilością zerowych bitów   */
        cmpq     %r9, %rdi
        jnbe     one_sixteenth
        addq     $8, %rax
        shlq     $8, %rdi

one_sixteenth:
        shlq     $4, %r9
        cmpq     %r9, %rdi
        jnbe     one_thirty_second
        addq     $4, %rax
        shlq     $4, %rdi

one_thirty_second:
        shlq     $2, %r9
        cmpq     %r9, %rdi
        jnbe     one_sixty_fourth
        addq     $2, %rax
        shlq     $2, %rdi

one_sixty_fourth:
        shlq     $1, %r9
        cmpq     %r9, %rdi
        jnbe     done
        addq     $1, %rax

done:   
        ret
zero:
        movq    $64,%rax
        ret

        .size   clz, .-clz