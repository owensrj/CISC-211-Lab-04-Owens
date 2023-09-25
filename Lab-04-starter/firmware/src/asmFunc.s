/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */

.global balance,transaction,eat_out,stay_in,eat_ice_cream,we_have_a_problem
.type balance,%gnu_unique_object
.type transaction,%gnu_unique_object
.type eat_out,%gnu_unique_object
.type stay_in,%gnu_unique_object
.type eat_ice_cream,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
balance:           .word     0  /* input/output value */
transaction:       .word     0  /* output value */
eat_out:           .word     0  /* output value */
stay_in:           .word     0  /* output value */
eat_ice_cream:     .word     0  /* output value */
we_have_a_problem: .word     0  /* output value */

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: the integer value returned to the C function
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    LDR r1,=balance
    LDR r2,[r1]
    ADD r0,r0,r2
.endif
    
/*** STUDENTS: Place your code BELOW this line!!! **************/

    /* Initialize r4, r5, and r6 to point to address of variables eat_out, stay_in, and eat_ice_cream */
    LDR r4, =eat_out
    LDR r5, =stay_in
    LDR r6, =eat_ice_cream
    LDR r10, =we_have_a_problem
    
    /* Initialize r7 to 0 for zeroing out variables */
    MOV r7, 0

    /* Zero out variables: eat_out, stay_in, eat_ice_cream, and we_have_a_problem*/
    STR r7, [r4]
    STR r7, [r5]
    STR r7, [r6]
    STR r7, [r10]
   
    /* Initialize r8 and r9 for range checking of transaction*/
    MOV r8, 500      /* Move 500 into r8 */
    ADD r8, r8, 500  /* Add 500 to r8, making r8 = 1000 */

    MOV r9, -1001     /* Move -1001 to r9 */
    ADD r9, r9, 1    /* Add 1 to r9, making r9 = -1000 */


    /* Check transaction amount in r0 for being within the acceptable range [-1000, 1000] */
    CMP r0, r9
    BLT update_we_have_a_problem
    CMP r0, r8
    BGT update_we_have_a_problem

    /* Load current balance to r3 (with r2 as a pointer) and calculate temporary balance */
    LDR r2, =balance
    LDR r3, [r2]
    ADDS r3, r0  /* tmpBalance = balance (r3) + transaction amount (r0) */
    BVS update_we_have_a_problem  /* Check for overflow */
    STR r3, [r2] /* Update the balance variable */
    
    /* Update the transaction variable */
    LDR r11, =transaction
    STR r0, [r11]

    /* Compare balance to zero and set eat_out, stay_in, or eat_ice_cream based on the result */
    CMP r3, 0
    BGT set_eat_out
    BLT set_stay_in
    BEQ set_eat_ice_cream

set_eat_out:
    MOV r7, 1
    STR r7, [r4]
    B update_r0

set_stay_in:
    MOV r7, 1
    STR r7, [r5]
    B update_r0

set_eat_ice_cream:
    MOV r7, 1
    STR r7, [r6]
    B update_r0

update_r0:
    /* Update r0 to the new balance for the return value */
    MOV r0, r3
    B done

update_we_have_a_problem:
    /* If program runs to here, Transaction is not within acceptable range or an overflow occurred */
    LDR r10, =we_have_a_problem
    MOV r7, 1
    STR r7, [r10]
    LDR r11, =transaction
    MOV r7, 0
    STR r7, [r11]
    LDR r1, =balance
    LDR r2, [r1]
    MOV r0, r2
    B done

    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    pop {r4-r11,LR}


    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           



