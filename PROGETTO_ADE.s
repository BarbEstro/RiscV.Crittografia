#Progetto Ade
#Autore-Barbieri Emanuele Luca
#Matricola-6147014
.data
stringa_errore1: .string "Errore Mychiper: ALG #-che?"
stringa_errore2: .string "Errore Mychiper: cifratura non eseguibile per troppe C"
stringa_errore3: .string "Errore Myplaintext: troppo lungo da cifrare"
stringa_errore4: .string "Errore Mychiper: sequenza non consentica, troppo lunga"
stringaMessaggio1: .string "ALG_A:"
stringaMessaggio2: .string "ALG_B:"
stringaMessaggio3: .string "ALG_C:"
stringaMessaggio4: .string "ALG_D:"
stringaMessaggio5: .string "La tua stringa e': "
stringa_Messaggio6: .string "ESECUZIONE DECIFRATURA"
mychiper: .string "ABCDA"
k: .word 10
key: .string "OLE"
myplaintext: .string "Ciao, mi chiamo Emanuele matricola: 6147014"
space: .string "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "
stringaV: .string ""
.text
#FASE DI BLOCCO ERRORI

#controllo mychiper massimo 5 caratteri

la a0,mychiper
jal lunghezzaArray
la a1,stringa_errore4
li t0,6 
bge a0,t0,errore_controllo

#controllo mychiper: disponibilit? algoritmi

la a0,mychiper
jal controllo1
la a1,stringa_errore1
beq a0,zero,errore_controllo

#controllare myplaintext lunghezza < 100

la a0,myplaintext
jal lunghezzaArray
la a1,stringa_errore3
li t0,100
bge a0,t0,errore_controllo

#controllo per eseguire un tot di C

la a0,mychiper
#controllo_conteggioC(a0 = stringa)
jal controllo_conteggioC
beq a0,zero,finito_controllo
add s0,a0,zero #salvo conteggio per confronto
la a0,myplaintext
#lunghezzaArray(a0 = stringa)
jal lunghezzaArray
#controllo2(a0 = int_lunghezzaArray)
jal controllo2
bge a0,s0,finito_controllo
la a1,stringa_errore2
j errore_controllo

finito_controllo:
#FASE DI RICAVO SPAZIO
la a0,space
jal lunghezzaArray
add s3,a0,zero # salvo la lunghezza,usata in cancella
la a0,space
jal cancella

#INIZIO CIFRATURA & DECIFRATURA
#Stampa Intro
la a1,stringaMessaggio5
li a0,4
ecall
li a1,13
li a0,2
ecall
la a1,myplaintext
li a0,4
ecall
li a1,13
li a0,2
ecall
main:

li s0,0 #indice di mychiper
lw s1,k 
li s2,0 #segnale per cifrautura e decifratura

loop:
la a0,mychiper
li t0,65 #A
li t1,66
li t2,67
li t3,68

add t5,s0,a0
lb t6,0(t5)
#fase di controllo
beq s2,zero,decifratura_false
beq t6,zero,end_main
decifratura_false:
beq t6,zero,decifratura
beq t6,t0,algoritmo_A
beq t6,t1,algoritmo_B
bne t6,t2,continua
beq s2,zero,cifraturaC
j algoritmo_C_decifratura
cifraturaC:
j algoritmo_C
continua:
beq t6,t3,algoritmo_D

decifratura:
#Per la decifratura
la a1,stringa_Messaggio6
li a0,4
ecall
li a1,13
li a0,2
ecall
la a0,mychiper
sub s1,zero,s1 #-k 
li s0,0 #l'indice viene ripristinato
li s2,1 #decifratura true
j algoritmo_E
#----------------------------ALGORITMO A----------------------------------#
algoritmo_A:

la s3,myplaintext 
li s4,97 
li s5,123 
li s6,65
li s7,91

li t0,0

loop_A:
add t1,t0,s3
lb a1,0(t1)
beq a1,zero,end_loop_A
blt a1,s7,maiusc
blt a1,s5,minusc
j aggiorna

maiusc:
blt a1,s6,aggiorna
add a0,zero,s1 #lw a0,k sostituisce
add a2,s6,zero
add a3,s7,zero
jal miniciclo
sb a0,0(t1)
j aggiorna

minusc:
blt a1,s4,aggiorna
add a0,zero,s1 #lw a0,k
add a2,s4,zero
add a3,s5,zero
jal miniciclo
sb a0,0(t1)
j aggiorna

aggiorna:
addi t0,t0,1
j loop_A



end_loop_A:
la a1,stringaMessaggio1
li a0,4
ecall
li t0,13
add a1,t0,zero
li a0,2
ecall
add a1,s3,zero
li a0,4
ecall
add a1,t0,zero
li a0,2
ecall
addi s0,s0,1 #incremento indice
j loop

#-------------------------------ALGORITMO B-------------------------------#
algoritmo_B:

#inizio algoritmo
li s3,32
li s4,128
la s5,myplaintext
la a0,key
#a0 = indirizzo stringa
jal lunghezzaArray


add s6,a0,zero #salvo in s6 la lunghezza
li s7,0 #indice per key

#Fase Algoritmo
li t0,0 #per il loop

loop_algoritmo_blocchi:
	add t1,t0,s5
	lb t2,0(t1)
	beq t2,zero,end_loopB
	blt t2,s3,salta
	bge t2,s4,salta
	la a0,key
	add a1,s7,zero #carico l'indice
	jal ciclo_key
	# a0 valore key[indice]
	add s7,a1,zero
	add a1,t2,zero #carico valore
	#fase decisionale tra cifratura e decifratura
	beq s2,zero,esegui_formula
	jal formula_decifratura
	j avanti
esegui_formula:
	jal formula
avanti:
	sb a0,0(t1)
	addi s7,s7,1
salta:
	addi t0,t0,1
	
	j loop_algoritmo_blocchi
	

end_loopB:
	la a1,stringaMessaggio2
	li a0,4
	ecall
	li t0,13
	add a1,t0,zero
	li a0,2
	ecall
	add a1,s5,zero
	li a0,4
	ecall
	li t0,13
	add a1,t0,zero
	li a0,2
	ecall
	addi s0,s0,1
	j loop

#-------------------------------ALGORITMO C ------------------------------#
#CIFRATURA
algoritmo_C:
la a0,stringaV #indirizzo SV
la a1,myplaintext #indirizzo stringa
li s3,45 # -
li s4,32 # spazio
li s5,0 #contatore primo loop
li s6,0 #contatore stringa_vuota ( nel main)
li s7,31 #valore usato per marcare


loop1:
add t0,a1,s5 #indirizzo
lb a1,0(t0) #lettera_myplaintext
lb s8,1(t0) #lettera_myplaintext successiva
beq a1,zero,end_loop
beq a1,s7,aggiornamento 
add a2,s6,zero #inserisco il contatore
jal inserisci_carattere
addi s6,s6,1 #aumento il contatore
add a2,a1,zero
la a1,myplaintext
#a0 stringaV #a1 stringa #a2 carattere da cercare
jal inserisci_posizione
add a2,zero,a0 
#inserimento spazio
beq s8,zero,aggiornamento
la a0,stringaV
add a1,zero,s4
jal inserisci_carattere
addi s6,a2,1
aggiornamento:
addi s5,s5,1
la a0,stringaV
la a1,myplaintext
j loop1


end_loop:
#qui inizia il passaggio da stringaV a myplaintext
la a0,stringaV
la a1,myplaintext
jal conversione
la a0,stringaV
jal lunghezzaArray
add s3,a0,zero
la a0,stringaV
jal cancella
la a1,stringaMessaggio3
li a0,4
ecall
li t0,13
add a1,t0,zero
li a0,2
ecall
la a1,myplaintext
li a0,4
ecall
li a1,13
li a0,2
ecall
addi s0,s0,1
j loop

#DECIFRATURA C
algoritmo_C_decifratura:

la a0,myplaintext
li s3,0 #indice per l'intero loop
li s4,32
li s5,45
jal lunghezzaArray
add s6,a0,zero

loop_esterno:
la a0,myplaintext
add t0,s3,a0 #indirizzo
lb s7,0(t0)
beq s7,zero,end_decifraturaC
addi s3,s3,1
loop_interno:
jal definisci_numero 
addi s3,s3,1
beq a0,s4,loop_esterno
beq a0,s5,update
#INIZIA A DEFINIRE IL NUMERO
jal dammi_il_numero
add s3,a1,zero
la t0,stringaV
add t1,a0,t0 #stringaV[valore]
sb s7,0(t1)
update:
beq s3,s6,loop_esterno #istruzione da aggiustare con len(stringa)
la a0,myplaintext
j loop_interno

#definisci_numero(a0 = indirizzo)
definisci_numero:
addi sp,sp,-8
sw ra,4(sp)
add t0,s3,zero #metto l'indice in una variabile temporanea 
add t1,t0,a0 #indirizzo 
lb a1,1(t1) #temp 
lb a0,0(t1) #valore 
beq a0,s5,passa_oltre
beq a0,s4,passa_oltre
sb a0,0(sp)
add a0,a1,zero
jal boolean_decimal
beq a0,zero,no_decimal
lb a0,0(sp)#ripristina valore di a0 
j passa_oltre
no_decimal:
lb a1,0(sp) #ripristino a0 
li a0,48 #dato che a0 e' il valore decimale, ho posto a0 = 48 cioe' zero
passa_oltre:
lw ra,4(sp)
addi sp,sp,8
jr ra

#a0 = valore
boolean_decimal:
li t0,1
li t1,45
li t2,32
beq a0,t1,cambia
beq a0,t2,cambia
beq a0,zero,cambia
j passa_avanti
cambia:
li t0,0
passa_avanti:
add a0,t0,zero
jr ra

#riceve i valori calcolati da definisci_numero che a sua volta sono passati 
# a dammi_il_numero
stringa_numero:
li t0,48
sub a0,a0,t0
sub a1,a1,t0
li t1,10
mul t2,a0,t1
add a0,t2,a1
jr ra

#prende due valori: a0,a1
dammi_il_numero:
addi sp,sp,-8
add t0,s3,zero #indice
sw ra,4(sp)
sw t0,0(sp)
li t0,48
beq a0,t0,noDecimale
jal stringa_numero
lw t0,0(sp)
addi t0,t0,1
addi a0,a0,-1 #decrementi il numero principale
j fine_numero
noDecimale:
jal stringa_numero
addi a0,a0,-1
lw t0,0(sp)
fine_numero:
lw ra,4(sp)
addi sp,sp,8
add a1,t0,zero
jr ra

end_decifraturaC:
la a0,myplaintext
jal lunghezzaArray
add s3,a0,zero
la a0,myplaintext
jal cancella
#Adesso che myplaintext e' vuoto inserisco il nuovo myplaintext
la a0,stringaV
la a1,myplaintext
jal conversione
la a0,stringaV
jal lunghezzaArray
add s3,a0,zero
la a0,stringaV
jal cancella
la a1,stringaMessaggio3
li a0,4
ecall
li t0,13
add a1,t0,zero
li a0,2
ecall
la a1,myplaintext
li a0,4
ecall
li a1,13
li a0,2
ecall
addi s0,s0,1
j loop


#---------------------------ALGORITMO D-------------------------------#

algoritmo_D:

la a0,myplaintext
li s3,123 #z+1
li s4,97 #a
li s5,91 #Z+1
li s6,65 #a
li s7,58 #9+1
li s8,48 #0

li t0,0
#inizio loop
loopD:
add t1,t0,a0 #indirizzo a0
lb a0,0(t1)
beq a0,zero,end_loopD
blt a0,s7,numero
blt a0,s5,maiuscolo
blt a0,s3,minuscolo
j aggiornaD
numero:
blt a0,s8,aggiornaD
jal numeroConversione
sb a0,0(t1)
j aggiornaD
maiuscolo:
blt a0,s6,aggiornaD
li a1,1 #variabile booleana
jal definisciDistanza
jal convertireCarattere
sb a0,0(t1)
j aggiornaD
minuscolo:
blt a0,s4,aggiornaD
li a1,0 # variabile booleana
jal definisciDistanza
jal convertireCarattere
sb a0,0(t1)
aggiornaD:
addi t0,t0,1
la a0,myplaintext
j loopD

end_loopD:
la a1,stringaMessaggio4
li a0,4
ecall
li t0,13
add a1,t0,zero
li a0,2
ecall
la a1,myplaintext
li a0,4
ecall
li t0,13
add a1,t0,zero
li a0,2
ecall
addi s0,s0,1
j loop

#----------------------------ALGORITMO E-------------------------------#

algoritmo_E:

jal lunghezzaArray
addi s3,a0,-1 # lunghezza array-1
la a0,mychiper
li a1,0
add a2,zero,s3

loop_inversion:
bge a1,a2,end_inversion
jal swap
addi a1,a1,1
addi a2,a2,-1
j loop_inversion


end_inversion:
j loop



#-----------------------METODI UTILIZZATI------------------------------#
#metodo per la lunghezza di una stringa
#lunghezzaArray(a0 = stringa)
lunghezzaArray: 
		li t0,0 #indice=0
loop_lunghezzaArray:
		add t1,a0,t0
		lb t2,0(t1)
		beq t2,zero,end_loop_LunghezzaArray
		addi t0,t0,1
		j loop_lunghezzaArray

end_loop_LunghezzaArray:
	add a0,t0,zero
	jr ra

#metodo per algortimo A
#a0 = k, a1 = valore_carattere, a2= estremo_inf, a3 = estremo_sup
miniciclo:
add t2,a1,a0

loop_miniciclo_inf:
bge t2,a2,loop_miniciclo_sup
sub t2,a2,t2
sub t2,a3,t2
j loop_miniciclo_inf

loop_miniciclo_sup:
blt t2,a3,fine
sub t2,t2,a3
add t2,a2,t2
j loop_miniciclo_sup

fine:
add a0,t2,zero
jr ra

#metodi per algortimi B

ciclo_key:
#passati come parametri a0 indirizzo key, a1 indice
	bne a1,s6,salta_istruzione
	li a1,0
salta_istruzione:
	add t3,a0,a1
	lb a0,0(t3)
	jr ra

#a0 = valore_key, a1 = valore_lettera
formula:
	addi sp,sp,-4
	sw ra,0(sp)
	sub t2,a0,s3
	sub t3,a1,s3
	add a0,t2,t3
	jal modulo
	add a0,a0,s3
	lw ra,0(sp)
	addi sp,sp,4
	jr ra
#stessi parametri di formula
formula_decifratura:
addi sp,sp,-4
	sw ra,0(sp)
 add t2,a0,zero #conservo Valore Key
	sub a0,a1,s3 #valore_stringa-32
	jal modulo
	add t5,zero,a0
	sub a0,t2,s3 
	jal modulo
	add t3,zero,a0
	sub t4,t5,t3
	bge t4,zero,positivo
	addi t4,t4,128
	j finish
	positivo:
	add t4,t4,s3
	finish:
	lw ra,0(sp)
	addi sp,sp,4
	add a0,t4,zero	
	jr ra


modulo:
 li t3,96
 div t4,a0,t3
mul t4,t4,t3
sub a0,a0,t4
jr ra

#algortimi per la D
#a0 = numero
numeroConversione:
li t2,57
sub a0,t2,a0
add a0,s8,a0
jr ra

#a0=valore lettera, a1=boolean
definisciDistanza:
li t2,1
bne a1,t2,minuscolo2
addi a0,a0,-65
j salta_fuction
minuscolo2:
addi a0,a0,-97
salta_fuction:
jr ra

#a0 = distanza, a1 = bool
convertireCarattere:
li t2,1 # serve per l'uguaglianza
li t3,122 # z
li t4,90 # Z
bne a1,t2,minuscolo3
sub a0,t3,a0
j salta2
minuscolo3:
sub a0,t4,a0
salta2:
jr ra

#Algoritmi per la E
# a0 = indirizzo, a1= primo elemento, a2 = ultimo valore
swap:
add t0,a0,a2
lb t1,0(t0) # carico in t1 l'ultimo carattere della stringa
add t2,a0,a1
lb t3,0(t2)
sb t1,0(t2)
sb t3,0(t0)
jr ra

#Algoritmi C cifratura
#a0 = l'indirizzo, a2 = indice, a1 = carattere
inserisci_carattere:
add t3,a0,a2 #aggiornamento stringaV
sb a1,0(t3)
jr ra

inserisci_posizione:
addi sp,sp,-20 # 5 posizioni
sw ra,16(sp)
li t0,0 #contatore stringa
add t1,s6,zero #contatore stringaV
loop_posizione:
add t2,t0,a1 #stringa[i]
lb t3,0(t2)
beq t3,zero,end_loop2
beq t3,s7,aggiornamento_loop
bne t3,a2,aggiornamento_loop
sb s7,0(t2) #marcatura
add a1,s3,zero #trattino 
sb a2,12(sp) #carico il carattere
add a2,t1,zero #contatore
#a0 stringaV #a1 trattino #a2 contatore
jal inserisci_carattere
addi t1,t1,1
sw t0,8(sp)
sw t1,4(sp)
sw a0,0(sp)
add a0,t0,zero
#a0 indice da trasformare in numero
addi a0,a0,1 #perche' vuole da 1
jal numero_stringa
add t0,a0,zero
add t1,a1,zero
lw a0,0(sp) #indirizzo stringa vuota
lw a2,4(sp) #contatore stringa vuota
li t2,48
beq t0,t2,no_decimale
add a1,t0,zero #valore decimale
#a0 stringaV #a1 valore intero decimale #a2 contatore stringa vuota
jal inserisci_carattere
addi a2,a2,1 #contatore stringa vuota
no_decimale:
#inserimento forse di a2 non serve
add a1,t1,zero
#a0 stringaV #a1 valore numerico #a2 contatore
jal inserisci_carattere
addi t1,a2,1
lw t0,8(sp)
lb a2,12(sp) #carattere
la a1,myplaintext
aggiornamento_loop:
addi t0,t0,1
j loop_posizione

end_loop2:
lw ra,16(sp)
addi sp,sp,20
add a0,t1,zero
jr ra

#a0 = posizione
numero_stringa:
li t0,48
li t1,48 #valore decimale
li t2,0 #count
li t3,9
loop_while:
bge t2,a0,end_while
bne t2,t3,else
li t2,0
addi t1,t1,1
li t0,48
addi a0,a0,-10
j loop_while
else:
addi t0,t0,1
addi t2,t2,1
j loop_while
end_while:
add a0,t1,zero #valore decimale
add a1,t0,zero
jr ra


#algoritmo usato per entrambi
#cancella(a0 = space,s3 = lunghezza salvata) 

cancella:
li t0,0 #indice
add t1,zero,zero #valore che serve per cancellare
cancella_loop:
bge t0,s3,cancella_end_loop
add t2,t0,a0
sb t1,0(t2)
addi t0,t0,1
j cancella_loop
cancella_end_loop:
jr ra

conversione:
li t0,0
ciclo_conversione:
add t1,t0,a0 #indirizzo stringaV
add t2,t0,a1 #indirizzo myplaintext
lb t3,0(t1) #valore stringaV
beq t3,zero,end_ciclo_conversione
sb t3,0(t2)
addi t0,t0,1
j ciclo_conversione
end_ciclo_conversione:
jr ra

#------------------------------METODI DI CONTROLLO-------------------------#
#controllo1(a0 = stringa)

controllo1:
li t0,0 # contatore
li t1,65 # A
li t2,69 # E
li t3,1 #valore booleano TRUE

loop_controllo1:
add t4,t0,a0
lb t5,0(t4)
beq t5,zero,end_controllo1
blt t5,t1,trovato_errore1
bge t5,t2,trovato_errore1
addi t0,t0,1
j loop_controllo1
trovato_errore1:
li t3,0  #FALSE
end_controllo1:
add a0,t3,zero
jr ra

#controllo2 (a0 = int lunghezzaArray)
controllo2:
li t0,1 #contatore = 1, perch? almeno 1 pu? farlo
li t1,100 # i 100 caratteri che non devono essere superati
add t2,a0,zero 
again:
slli t3,t2,2 #t2*4
addi t4,t2,-1 #(t2-1)
add t2,t3,t4
bge t2,t1,end_loop_controllo2
addi t0,t0,1
j again
end_loop_controllo2:
add a0,t0,zero
jr ra

#conteggio C = conta quanti C sono presenti nella stringa
#controllo_conteggioC (a0 = stringa)

controllo_conteggioC:
li t0,0 
li t1,67
li t2,0 #count_C
controllo2_zero_loop:
add t3,a0,t0 #indirizzo
lb t4,0(t3) 
beq t4,zero,end_loop_controllo2_zero
bne t4,t1,salta_controllo2_zero
addi t2,t2,1
salta_controllo2_zero:
addi t0,t0,1
j controllo2_zero_loop
end_loop_controllo2_zero:
add a0,t2,zero
jr ra


errore_controllo:
li a0,4
ecall


end_main:
