@ ARM Assembly Project 1
@ E/14/065 & E/14/027
@ Image Processing Library

	.text	@ instruction memory

@original function ------------------------------------

original:
	sub sp,sp,#4

	@store lr in the stack

    str lr,[sp,#0]  
    sub sp,sp,#4

@ copy rowvalue from r4 to r7 -----
    mov r7,r4
@ copy columnvalue from r5 to r8 -----    
    mov r8,r5
 
RowIndex:
    cmp r7,#0
    beq exit
ColumnIndex:    
    cmp r8,#0
    beq precond
    
 @scanning element by element from text-----

    ldr	r0, =formats
	mov	r1, sp	
	bl	scanf

	ldr r10,[sp]
 
 @printing element by element from text-----

    mov r1,r10
	ldr	r0, =formatp
	bl printf;
	sub r8,r8,#1
	b ColumnIndex

precond:
    sub r7,r7,#1
    mov r8,r5
    ldr	r0, =format1
	bl printf
    b RowIndex

exit:
    add sp,sp,#4
    ldr lr,[sp,#0]
    add sp,sp,#4
    mov pc,lr

@invert function ----------------------------------    	

invert:
	sub sp,sp,#4

	@store lr in the stack

    str lr,[sp,#0]  
    sub sp,sp,#4

@ copy rowvalue from r4 to r7 -----
    mov r7,r4
@ copy columnvalue from r5 to r8 -----    
    mov r8,r5
    mov r9,#255
     

invertRow:
    cmp r7,#0
    beq exitInvert
invertColumn:    
    cmp r8,#0
    beq setprecond
    
 @scanning element by element from text-----

    ldr	r0, =formats
	mov	r1, sp	
	bl	scanf

	ldr r10,[sp]
 
 @printing element by element from text-----

	sub r10,r9,r10
    mov r1,r10
	ldr	r0, =formatp
	bl printf;
	sub r8,r8,#1
	b invertColumn

setprecond:
    sub r7,r7,#1
    mov r8,r5
    ldr	r0, =format1
	bl printf
    b invertRow

exitInvert:
    add sp,sp,#4
    ldr lr,[sp,#0]
    add sp,sp,#4
    mov pc,lr

@Rotate function-------------------------

rotate:
	sub sp,sp,#4
    str lr,[sp,#0] 
    mov r7,r4
    mov r8,r5

storeAll:
    cmp r3,#0
    beq print
    sub sp,sp,#4

    ldr	r0, =formats
	mov	r1, sp	
	bl	scanf
    
    sub r3,r3,#1
    b storeAll

print:
     add sp,sp,#4
     mov r7,r4
     mov r8,r5
rowLoop:
    cmp r7,#0
    beq exitRotate
columnLoop:    
    cmp r8,#0
    beq precondRotate

	ldr r1,[sp]
	ldr	r0, =formatp
	bl printf

    add sp,sp,#4
	sub r8,r8,#1
	b columnLoop

precondRotate:
    sub r7,r7,#1
    mov r8,r5
    ldr	r0, =format1
	bl printf
    b rowLoop

exitRotate:
    ldr lr,[sp,#0]    
    add sp,sp,#4
    mov pc,lr 

@Flip function------------------------- 

flip:
	sub sp,sp,#4
    str lr,[sp,#0] 
    mov r7,r5
    mov r8,r4

storeRowbyRow:
    cmp r8,#0
    beq exitFlip

rowLoop1:
    cmp r7,#0
    beq print1
    sub sp,sp,#4

    ldr	r0, =formats
	mov	r1, sp	
	bl	scanf
    
    sub r7,r7,#1
    b rowLoop1

print1:
    sub r8,r8,#1
    mov r7,r5
flipRow:    
    cmp r7,#0
    beq newrow

    ldr r1,[sp]    
    ldr	r0, =formatp	
	bl	printf

    add sp,sp,#4
	sub r7,r7,#1
	b flipRow

newrow:
    mov r7,r5
    ldr	r0, =format1	
	bl	printf
	b storeRowbyRow 

exitFlip:	
    ldr lr,[sp,#0]
    add sp,sp,#4 
    mov pc,lr

	
	.global main
main:
	@ stack handling, 
    @ push (store) lr to the stack
	sub	sp, sp, #4
	str	lr, [sp, #0]


	@allocate stack for input/scanf
	sub	sp, sp, #4

    @scanf for rows
	ldr	r0, =formats
	mov	r1, sp	
	bl	scanf	@scanf("%d",sp)

	@copy rows from the stack to register r4
	ldr	r4, [sp]

	@scanf for columns
	ldr	r0, =formats
	mov	r1, sp	
	bl	scanf	@scanf("%d",sp)
	
	@copy columns from stack to register r5
	ldr	r5, [sp]

	@scanf for opcode
	ldr	r0, =formats
	mov	r1, sp	
	bl	scanf	@scanf("%d",sp)
	
	@copy opcode from stack to register r6
	ldr	r6, [sp]
	
	@release stack
	add	sp, sp, #4

	cmp r6,#0
	beq callOriginal

	cmp r6,#1
	beq callInvert

	cmp r6,#2
	beq callRotate

	cmp r6,#3
	beq callFlip
	bne error

callOriginal:	
	ldr r0,=formato
	bl printf
	bl original
	b end

callInvert:	
	ldr r0,=formati
	bl printf
	bl invert
	b end

callRotate:
   	ldr r0,=formatr
	bl printf
    mul r3,r4,r5	
	bl rotate	
	b end

callFlip:	
    ldr r0,=formatf
	bl printf
	bl flip
	b end

error:
    ldr r0,=formate
    bl printf		

    end:

    @ stack handling (pop lr from the stack) and return
	ldr	lr, [sp, #0]
	add	sp, sp, #4
	mov	pc, lr			
	
.data	@ data memory
formats: .asciz "%d"
formatp: .asciz "%d "
format1: .asciz "\n"
formate: .asciz "Invalid operation\n"
formato: .asciz "Original\n"
formati: .asciz "Inversion\n"
formatr: .asciz "Rotation by 180\n"
formatf: .asciz "Flip\n"
