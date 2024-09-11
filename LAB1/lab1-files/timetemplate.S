# timetemplate.S
# Written 2015 by F Lundevall
# Ported 2024/06 by W Szczerek (from MIPS to RISC-V)
# Copyright abandonded - this file is in the public domain.

#############################################################
# Choose the macro syntax for RARS or DTEK-V board.         #
# The syntax for RARS is probably due to its MIPS heritage. #
#############################################################
###################
# Macros for RARS #
###################
.macro	PUSH (%reg)
	addi	sp,sp,-4
	sw	%reg,0(sp) 
.end_macro

.macro	POP (%reg)
	lw	%reg,0(sp)
	addi	sp,sp,4
.end_macro
###################
# Macros for DTEK #
###################
#.macro	PUSH reg
#	addi sp,sp,-4
#	sw \reg,0(sp) 
#.endm
#
#.macro	POP reg
#	lw	\reg,0(sp)
#	addi	sp,sp,4
#.endm
#############################################################

	.data
	.align 2
mytime:	.word 	0x5957
timstr:	.asciz 	"text more text lots of text\0"
	.text
	.globl timetemplate, tick, time2string

# Function for displaying a string with a newline at the end	
display_string:	
	li a7,4
	ecall
	li a0, 10
	li a7,11
	ecall
	jr ra
	
timetemplate:
	la	a0, timstr
	jal     display_string
	
	# wait a little
	li	a0, 2		# ms
	jal	delay
	
	# call tick
	la 	a0, mytime
	jal	tick
	
	# call your function time2string
	la	a0, timstr
	la	t0, mytime
	lw	a1, 0(t0)
	jal	time2string
	
	# go back and do it all again
	j	timetemplate

	
# tick: update time pointed to by $a0
tick:	lw	t0, 0(a0)	# get time
	addi	t0, t0, 1	# increase
	andi	t1, t0, 0xf	# check lowest digit
	sltiu	t2, t1, 0xa	# if digit < a, okay
	bnez	t2, tiend
	addi	t0, t0, 0x6	# adjust lowest digit
	
	andi	t1, t0, 0xf0	# check next digit
	sltiu	t2, t1, 0x60	# if digit < 6, okay
	bnez	t2, tiend
	addi	t0, t0, 0xa0	# adjust digit
	
	li	t3, 0xF
	slli	t3, t3, 0x8
	and	t1, t0, t3	# check minute digit
	addi	t3, x0, 0xA
	slli	t3, t3, 0x8
	slt	t2, t1, t3	# if digit < a, okay
	bnez	t2, tiend
	addi	t0, t0, 0x600	# adjust digit - this one's okay, it's lower than 0x7FF 
	
	li	t3, 0xF
	slli	t3, t3, 0xC
	and	t1, t0, t3	# check last digit
	addi	t3, x0, 0x6
	slli	t3, t3, 0xC
	slt	t2, t1, t3	# if digit < 6, okay
	bnez	t2, tiend
	
	li	t3, 0xA
	slli	t3, t3, 0xC
	add	t0, t0, t3	# adjust last digit
tiend:	sw	t0,0(a0)	# save updated result
	jr	ra		# return

#########################################################
# Place for your functions: time2string, hex2asc, delay.#
#########################################################

hex2asc:
	li	a0, 4		# test number (from 0 to 15)
	
	addi    sp,sp,-4
	sw      ra,0(sp)
	
	jal	hexasc		# call hexasc
	
	li	a7, 11	# write a0 to stdout
	ecall

	lw      ra,0(sp)
	addi    sp,sp,4
	jr      ra	

  # You can write your own code for hexasc here
  #
   
hexasc:
# numbeers under 10 will be negative
	andi    a0,a0,0xf   # only the 4 least significant bits are interesting
 	addi	a0,a0,-10   # a0 = a0 - 10
 	blt	a0,zero,under    # if a0 < 0, jump to under
 	addi	a0,a0,0x41   # a0 = a0 + 0x41
 	jr	ra

under:
	addi	a0,a0,0x3a   # a0 = a0 + 0x30 + 0x0a
	jr	ra
	
delay:
	ble a0, zero, while_done #if ms <= 0 exit while loop
	addi a0, a0, -1 #decrement ms by 1
	
	li s0, 0 #add i = 0
	li t0, 25000 #add constant for comparison

for: #(for int i=0; i < 4711; i = i+1)
	bge s0, t0, for_done # i > 4711?
	addi s0, s0, 1 # i = i + 1
	j for #repeat loop

for_done:
	j delay #for done
	
while_done:
	jr ra #while done

time2string:
	PUSH ra 
	PUSH s0
	mv s0, a0 #put the pointer to the string in a register
	
	#Second number of seconds
	srli a0,a1,12  #shift bits to the right
	andi a0,a0, 0xF #remove all unnecesary bits(the ones to the left)
	
	jal hexasc #convert to ASCII
	sb a0, 0(s0) #store converted charecter on the string
	
	#First number of seconds
	srli a0, a1, 8 #Same as above
	andi a0, a0, 0xF
	
	jal hexasc
	sb a0,1(s0)
	
	#:
	li t0, 0x3A
	sb t0, 2(s0) #put : in the string
	
	#last number of minutes
	srli a0,a1, 4 #same as above
	andi a0,a0, 0xF
	
	jal hexasc
	sb a0, 3(s0)
	
	#first number of minutes
	andi a0, a1, 0xF
	
	jal hexasc
	sb a0,4(s0)
	
	# null byte
	li t0,0x00
	sb t0, 5(s0)
	
	POP s0 #restore the string pointer register so it can be displayed
	POP ra
	jr ra
