# suma64uns.s:       Sumar los elementos de una lista llamando a función, pasando argumentos mediante registros, sin signo
#
# retorna:           llamando a función, pasando argumentos mediante registros


# SECCIÓN DE DATOS (.data, variables globales inicializadas)
.section .data
	.macro linea
	#	.int 1,1,1,1
	#	.int 2,2,2,2
	#	.int 1,2,3,4
	#	.int -1,-1,-1,-1
	#	.int 0xffffffff,0xffffffff,0xffffffff,0xffffffff
	#	.int 0x08000000,0x08000000,0x08000000,0x08000000
		.int 0x10000000,0x20000000,0x40000000,0x80000000
	.endm

lista:	.irpc i,12345678
	linea
	.endr
longlista:
	.int(.-lista)/4    # . = contador posiciones. Aritm.etiquetas
resultado:
	.quad 0x123456789ABCDEF						#resultado->123..8       resultado+4->9...F
formato:
	.ascii "suma = %llu = %llx hex\n\0"


# SECCIÓN DE CÓDIGO (.text, instrucciones máquina)

.section .text                # PROGRAMA PRINCIPAL
#_start: .global _start        # se puede abreviar de esta forma
main: .global main          # Programa principal si se usa gcc

	mov    $lista, %ebx   #dirección del array lista
	mov longlista, %ecx   #número de elementos a sumar      
	call suma             #llamar suma(&lista, longlista);
	mov %eax, resultado   #salvar resultado
	mov %edx, resultado+4

	push resultado+4						#little endian    EDX:EAX
	push resultado
	push resultado+4        
	push resultado        
	push $formato         #traduce resultado a ASCII decimal/hex
	call printf           # == printf(formato,resultado,resultado)
	add $20, %esp
					#void _exit(int status);
	mov $1, %eax			#exit: servicio 1 kernel Linux
	mov $0, %ebx			# status: código a retornar (0=OK)
	int $0x80			# llamar _exit(0);

suma:
	mov $0, %eax	# poner a 0 acumulador
	mov $0, %edx 	# poner a 0 índice
	mov $0, %esi

bucle:
	add (%ebx,%esi,4), %eax		#acumular i-ésimo elemento
	jne nocarry			#si no iguales, seguir acumulando
	inc %edx			#incrementar índice

nocarry:
	inc %esi
	cmp %esi, %ecx
	jne bucle


	ret
