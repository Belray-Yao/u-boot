/*
 * A lowlevel_init function that sets up the stack to call a C function to
 * perform further init.
 *
 * (C) Copyright 2010
 * Texas Instruments, <www.ti.com>
 *
 * Author :
 *	Aneesh V	<aneesh@ti.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <asm-offsets.h>
#include <config.h>
#include <linux/linkage.h>

ENTRY(lowlevel_init)
	/*
	 * Setup a temporary stack. Global data is not available yet.
	 */
	ldr	sp, =CONFIG_SYS_INIT_SP_ADDR
	bic	sp, sp, #7 /* 8-byte alignment for ABI compliance */
#ifdef CONFIG_SPL_DM
	mov	r9, #0
#else
	/*
	 * Set up global data for boards that still need it. This will be
	 * removed soon.
	 */
#ifdef CONFIG_SPL_BUILD
	ldr	r9, =gdata
#else
	sub	sp, sp, #GD_SIZE
	bic	sp, sp, #7
	mov	r9, sp
#endif
#endif
    /* set GPIO to enable UART */
    @ GPIO setting for UART for UART0/1
    ldr r0, =0x11400000
    ldr r1, =0x22222222
    str     r1, [r0]
    ldr r0, =0x11400020
    ldr r1, =0x222222
    str r1, [r0]

    ldr r0, =0x10030000
    ldr r1, =0x666666
    ldr r2, =0x0C250
    str r1, [r0, r2]
    ldr r1, =0x777777
    ldr r2, =0x0C550
    str r1, [r0, r2]

    ldr r0, =0xEC000000
    ldr r1, =0x111
    str r1, [r0, #0x08]

    mov r1, #0x3
    str r1, [r0, #0x0]

    ldr r1, =0x3c5
    str r1, [r0, #0x04]

    ldr r1, =0x2B /*  UDIV(43) = ((82,500,000 / 16 / 115200) - 1) */
    str r1, [r0, #0x28]

    ldr r1, =0xC /* UFRACVAL(12) = ((((82,500,000 / 16 / 115200) - 1) - 43) *     16) */
    str r1, [r0, #0x2C]

	ldr r1, =0x4f4f4f4f
    str r1, [r0, #0x20]      @'O'

	ldr r1, =0x4f4f4f4f
    str r1, [r0, #0x20]      @'O'

	/*
	 * Save the old lr(passed in ip) and the current lr to stack
	 */
	push	{ip, lr}

	/*
	 * Call the very early init function. This should do only the
	 * absolute bare minimum to get started. It should not:
	 *
	 * - set up DRAM
	 * - use global_data
	 * - clear BSS
	 * - try to start a console
	 *
	 * For boards with SPL this should be empty since SPL can do all of
	 * this init in the SPL board_init_f() function which is called
	 * immediately after this.
	 */
	bl	s_init
	pop	{ip, pc}
ENDPROC(lowlevel_init)


