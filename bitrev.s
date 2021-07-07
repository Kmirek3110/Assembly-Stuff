	.text
	.global	bitrev
	.type	bitrev, @function
	#Metoda ktora wykorzystalem jest podobna do tej ktore byla
	#pokazywana na cwiczeniach z odwracaniem Little Endiana na Big Endiana
	#Wykorzystujemy maski oraz przesuniecia >> ,  << 
	#Na poczatku zamieniamy miejscem bity obok siebie 
	#nastepnie pary bitow, czworki itp
    
bitrev:

    mov %rdi,%rax
    shr $1,%rdi     # x>>1        
    mov $0x5555555555555555,%rcx  #maska 0101.... 
    and %rcx,%rdi    # (x>>1)&maska 0101..
    and %rcx,%rax   # (x&maska 0101..)
    shl $1,%rax    #(x&maska 0101..)<<1
    or %rax,%rdi  #   (x>>1)&maska 0101..| (x&maska 0101..)<<1
    mov %rdi,%rax
    shr $2,%rdi # przesuwanie o 2
    mov $0x3333333333333333,%rcx # maska 00110011...
    and %rcx,%rdi
    and %rcx,%rax
    shl $2,%rax
    or %rax,%rdi
    mov %rdi,%rax
    shr $4,%rdi # przesuwanie o 4
    mov $0x0F0F0F0F0F0F0F0F,%rcx # maska 00001111......
    and %rcx,%rdi
    and %rcx,%rax
    shl $4,%rax
    or %rax,%rdi
    mov %rdi,%rax
    shr $8,%rdi #przesuwanie o 8
    mov $0x00FF00FF00FF00FF,%rcx # maska 0000 0000 1111 1111 ....
    and %rcx,%rdi
    and %rcx,%rax
    shl $8,%rax 
    or %rax,%rdi
    mov %rdi,%rax
    shr $16,%rdi # przesuwanie o 16
    mov $0x0000FFFF0000FFFF,%rcx 
    and %rcx,%rdi
    and %rcx,%rax
    shl $16,%rax
    or %rax,%rdi   
    mov %rdi,%rax
    shr $32,%rdi 
    shl $32,%rax
    or %rdi,%rax
    ret 

	.size	bitrev, .-bitrev
