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
        .globl  mod17
        .type   mod17, @function

/*
 * W moim rozwiązaniu używam następującej techniki:
        Na początku tworzę 3 następujące maski:
        - $0x0f0f0f0f0f0f0f0f (odpowiada za miejsca nieparzyste)
        - $0xf0f0f0f0f0f0f0f0 (odpowiada za miejsca parzyste)
        - $0x1010101010101010 (to są tak naprawdę patrząc na bajty 16(0001 0000), dodajemy je w celu
        ułatwienie arytmetyki na ciele mod 17, po czym dodamy jeszczę 1 więc 16+1=17(element neutralny))



        Następnie sprawdzam 2 przypadki brzegowe 0f0f0f00f0f0, f0f0f00f0f0 mój algorytm ich nie łapie.

        AND'uje maskę parzystę i nieparzystą z rdi(arugmentem)


        Maskę pomocy $0x1010101010101010 dodaje do maski miejsc nieparzystych(juz po andowaniu z rdi)
        Otrzymujemy coś w postaci 0x1F1F1F1F1F1F1F1F (F odpowiada za kolejne a andowane liczby nieparzyste)

        Nastepnie odejmuje przesuwam parzystą maskę parzystę o 4 miejsca w prawo(przygotowanie do odejmowania)
        Odejmuje maskę nieparzystych z parzysytmi.

        Uzasadnienie czemu dodałem do maski nieparzystych maskę(1010101001010)
        Odejmując liczbą nieparzystą z parzystą w ciele mod 17 mamy 2 przypadki
        nieparzysta:N >= parzysta:P
                Wtedy na bajcie masek nieparzystych mamy 1N
                na bajcie masek parzystych mamy          0P
                Jako ze wiemy ze N >= P więc nie korzystamy z dodatkowej 1 i otrzymujemy wynik 1(N-P)
                Przykład : nieparzysta wynosi 8, parzysta 6
                         mamy            
                                                18
                                               -06
                                               ----
                                                12
                0x12 == 16 + 2 = 18, ale zawsze jeszcze dodajemy 1 więc 18 + 1 = 19
                a 19 mod 17 = 2, czyli to samo co 8-2
        Parzysta:P > nieparzysta:N
                Wtedy przy odejmowaniu będziemy musieli korzystać z naszej 1(z maski dodatkowej).
                Przykład: parzysta wynosi 8, nieparzysta 6
                mamy            
                                                16
                                               -08
                                               ----
                                                0E
                0x0E == 14,
                W kolejnym kroku dla każdego bajta dodajemy $1, tak jak to robilismy tez na górze więc
                14 + 1 = 15,      6-8(mod17)= -2(mod17) == 15.

        To uzasadnia dlaczego nasze odejmowania działa.

        Aby przejść do kolejnego bajtu przesuwamy w prawo o 8.(robimy to bo chcemy sumowac te bajty)

        Sumując te odejmowania dostajemy wynik na bajcie, lecz on nie jest dalej mod 17
        więc ten tok rozumowania powtarzamy tylko ze na 8 bitach, w rezultacie dostając pożądany wynik.
        maski (0x0f, 0xf0,0x1f)



 */

mod17:
        xor      %eax,%eax       /* Tutaj robię coś bardzo ważnego! */
        
        movq     $0x0f0f0f0f0f0f0f0f,%r9
        movq     $0xf0f0f0f0f0f0f0f0,%r10
        movq     $0x1010101010101010,%r11

        test     %r9,%rdi
        je       finish_brzegowy2

        test     %r10,%rdi
        je       finish_brzegowy1

        
        andq     %rdi,%r9
        andq     %rdi,%r10
        shr      $4,%r10
        addq     %r11,%r9
        subq     %r10,%r9
        
        addb     $1,%r9b
        addb    %r9b,%al
        
        shr     $8,%r9
        addb     $1,%r9b
        addb    %r9b,%al
     

        shr     $8,%r9
        addb     $1,%r9b
        addb    %r9b,%al


        shr     $8,%r9
        addb     $1,%r9b
        addb    %r9b,%al


        shr     $8,%r9
        addb     $1,%r9b
        addb    %r9b,%al


        shr     $8,%r9
        addb     $1,%r9b
        addb    %r9b,%al


        shr     $8,%r9
        addb     $1,%r9b
        addb    %r9b,%al


        shr     $8,%r9
        addb     $1,%r9b
        addb    %r9b,%al
        
        movb     $0x0f,%r9b
        movb     $0xf0,%r10b
        movb     $0x10,%r11b

        andb    %al,%r9b
        andb    %al,%r10b
        
        shr     $4,%r10b
        addb    %r11b,%r9b

        subb    %r10b,%r9b
        movb    %r9b,%al
        addb     $1,%al
        
        cmp     $17,%al
        jl      finish
        subb    $17,%al

finish:
        ret 

finish_brzegowy1:
        movb   $1,%al
        ret

finish_brzegowy2:
        movb   $16,%al
        ret




 
        .size   mod17, .-mod17