  # hexmain.S
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
	.globl hex2asc

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
