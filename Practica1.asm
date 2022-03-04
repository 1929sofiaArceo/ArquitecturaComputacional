# Sofía Arceo Covarrubias || Oskar Franz Chávez

.data 
.eqv discos 4
.text

MAIN:
addi s0, zero, discos #Guardamos el numero inicial de discos (constante)
add s11, zero, s0
addi a6, zero, 0
addi a7, zero, 0
lui s1, 0x10010 #Direccion del primer arreglo (posicionando en data)
fill_t1:
addi a7, a7, 1
sw a7, 0(s1)
addi s1, s1, 4
bne a7, s0, fill_t1 #inicializamos las torre origen con el numero de discos
addi a7, zero, 0
fill_t2:
addi a7, a7, 1
sw zero, 0(s1)
addi s1, s1, 4
bne a7, s0, fill_t2 #inicializamos las torres aux
addi a7, zero, 0
fill_t3:
addi a7, a7, 1
sw zero, 0(s1)
addi s1, s1, 4
bne a7, s0, fill_t3 #inicializamos las torre destino
lui s1, 0x10010 #Restablecemos la direccion primer arreglo (posicionado al inicio en data)
add a3, zero, s1 #(Arreglo origen)
addi t1, zero, 4
MUL: #para multiplicar y sacar el offset del segundo arreglo
addi a6, a6, 1
add s2, s2, t1 #Offset del segundo arreglo
bne a6, s0, MUL
add a5, a3, s2 #(Arreglo auxiliar)
addi t1, t1, 4
mul s3, s11, t1 #Offset del tercer arreglo
add a4, a3, s3 #(Arreglo destino)
add a2, zero, s0 # Discos actuales
addi t0, zero, 1 # uno (constante)
addi s5, zero, 0
jal ra, HANOI
jal zero, EXIT

HANOI:
addi sp, sp,-4
sw ra, 4(sp)   #guardamos en el stack ra
jal ra, HANOI_RECURSIVO
addi sp, sp, 4
lw ra, 0(sp)
jalr zero, ra, 0

HANOI_RECURSIVO: 
sw ra, 0(sp)   #guardamos en el stack ra
addi sp, sp, -4 #aumentamos sp
sw a2, 0(sp) #guardamos a n en el stack
addi, sp, sp, -4
sw a3, 0(sp) #aguardamos direccion de arreglo origen 
addi, sp, sp, -4
sw a4, 0(sp) #guardamos a direccion de arreglo destino
addi, sp, sp, -4
sw a5, 0(sp) #guardamos a direccion de arreglo aux
addi, sp, sp, -4
beq a2, t0, N_1 #caso base
addi a2, a2, -1 # Reduccion de n, n=n-1
add t5, zero, a4 #tmp para hacer swap
add a4, zero, a5 #cambio de destino <-> aux
add a5, zero, t5 
jal ra, HANOI_RECURSIVO
jal ra, MOVE
#volvemos a hacer swap 
addi a2, a2, -1 # Reduccion de n, n=n-1
add t5, zero, a3
add a3, zero, a5
add a5, zero, t5 #Movemos destino from <--> aux 
jal ra, HANOI_RECURSIVO
jal zero, RETURN_HANOI

N_1:
jal ra, MOVE
jal zero, RETURN_HANOI

MOVE:
sw ra, 0(sp)	#guardamos ra en stack
add t6, zero, a3 # Cargamos la direccion de la pila origen al stack pointer
addi t4, zero, 0 # Reiniciamos el contador de discos encontrados
jal ra, POP # Brincamos a Stack y guardamos direccion de retorno
add t6, zero, a4 # Cargamos la direccion de la pila destino al stack pointer
jal ra, STACK
lw ra, 0(sp)
jalr zero, ra, 0

POP:
lw t2, 0(t6)
beq t2, zero, EMPTY_ORG # Verifica si estamos en la pinta de la pila
sw zero, 0(t6) # Damos pop al primer elemento de la pila origen
jalr zero, ra, 0

STACK:
addi t4, t4, 1
lw t3, 0(t6)
beq t3, zero, EMPTY_DEST
addi t6, t6, -4
jal zero, SAVE_DESTINY

EMPTY_ORG:
addi t6, t6, 4
jal zero, POP

EMPTY_DEST:
beq t4, s0, SAVE_DESTINY
addi t6, t6, 4
jal zero, STACK

SAVE_DESTINY:
sw t2, 0(t6)
jalr zero, ra, 0

RETURN_HANOI:
addi sp, sp, 20 #almacenamos 5 cosas en stack de 4(word lenght) cada una 5*4 20
lw ra, 0(sp)
lw a2, 16(sp)
lw a3, 12(sp)
lw a4, 8(sp)
lw a5, 4(sp)
jalr zero, ra, 0

EXIT: #fin del programa