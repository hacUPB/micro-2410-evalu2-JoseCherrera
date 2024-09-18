/*********************************************************************
*                    SEGGER Microcontroller GmbH                     *
*                        The Embedded Experts                        *
**********************************************************************
*                                                                    *
*            (c) 2014 - 2022 SEGGER Microcontroller GmbH             *
*                                                                    *
*       www.segger.com     Support: support@segger.com               *
*                                                                    *
**********************************************************************
*                                                                    *
* All rights reserved.                                               *
*                                                                    *
* Redistribution and use in source and binary forms, with or         *
* without modification, are permitted provided that the following    *
* condition is met:                                                  *
*                                                                    *
* - Redistributions of source code must retain the above copyright   *
*   notice, this condition and the following disclaimer.             *
*                                                                    *
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND             *
* CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,        *
* INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF           *
* MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE           *
* DISCLAIMED. IN NO EVENT SHALL SEGGER Microcontroller BE LIABLE FOR *
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR           *
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT  *
* OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;    *
* OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF      *
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT          *
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE  *
* USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH   *
* DAMAGE.                                                            *
*                                                                    *
*********************************************************************/

/*********************************************************************
*
*       _start
*
*  Function description
*  Defines entry point for an MKE18F16 assembly code only
*  application.
*
*  Additional information
*    Please note, as this is an assembly code only project, the C/C++
*    runtime library has not been initialised. So do not attempt to call
*    any C/C++ library functions because they probably won't work.
*/

  #include "definiciones.h"

  .syntax unified
  .global _start
  .extern estado_leds  
  .text

  .thumb_func

_start:
    bl  init_clks
    bl  init_ports
    bl  init_gpio 
    bl crear_tabla_leds 
    bl systick_config 

    // Máquina de estados
    ldr r4, =Base_maquina_0
    mov r1, #est1                    
    str r1, [r4, #var_estado_M0]
    mov r2, #0
    str r2, [r4, entrada_tiempo_M0]   

//Bucle principal del progrma 
loop_principal:
    bl estado_leds
     
    //bl escribir_leds               
    b loop_principal                  


init_clks:
//CLOCK REGISTRO C
    ldr     r4, =#PCC_BASE
    ldr     r5, =#PCC_PORTC_OFFSET
    mov     r0, #1
    lsl     r0, #PCC_CGC_BIT
    str     r0, [r4, r5]
//CLOCK REGISTRO B
    ldr     r5, =#PCC_PORTB_OFFSET
    str     r0, [r4, r5]
    bx      lr
 
init_gpio:
//GPIO DE REGISTRO C
    ldr     r4, =#GPIOC_BASE
    ldr     r5, =#GPIO_DDR_OFFSET
    ldr     r1, [r4, r5]
    ldr     r0, =#GPIOC
    orr     r0, r1
    str     r0, [r4,r5]
 
 //GPIO DE REGISTRO B
    ldr     r4, =#GPIOB_BASE
    ldr     r1, [r4, r5]
    ldr     r0, =#GPIOB
    orr     r0, r1
    str     r0, [r4,r5]
    bx lr
init_ports:

//Puertos C 
    ldr     r4, =#PORTC_BASE
    mov     r0, #1
    lsl     r0, #PORT_PCR_MUX_BITS
 
    ldr     r5, =#PORTC_PCC8_OFFSET
    str     r0, [r4, r5]
 
    ldr     r5, =#PORTC_PCC9_OFFSET
    str     r0, [r4, r5]
 
    ldr     r5, =#PORTC_PCC10_OFFSET
    str     r0, [r4, r5]
 
    ldr     r5, =#PORTC_PCC11_OFFSET
    str     r0, [r4, r5]

    ldr     r5, =#PORTC_PCC12_OFFSET
    str     r0, [r4, r5]
 
    ldr     r5, =#PORTC_PCC13_OFFSET
    str     r0, [r4, r5]

    ldr     r5, =#PORTC_PCC14_OFFSET
    str     r0, [r4, r5]
 
    ldr     r5, =#PORTC_PCC15_OFFSET
    str     r0, [r4, r5]
 

 //Puertos B 
    ldr     r4, =#PORTB_BASE

    ldr     r5, =#PORTB_PCB10_OFFSET
    str     r0, [r4, r5]
 
    ldr     r5, =#PORTB_PCB11_OFFSET
    str     r0, [r4, r5]
 
    ldr     r5, =#PORTB_PCB12_OFFSET
    str     r0, [r4, r5]
 
    ldr     r5, =#PORTB_PCB13_OFFSET
    str     r0, [r4, r5]
 
    ldr     r5, =#PORTB_PCB14_OFFSET
    str     r0, [r4, r5]

    ldr     r5, =#PORTB_PCB15_OFFSET
    str     r0, [r4, r5]
 
    ldr     r5, =#PORTB_PCB16_OFFSET
    str     r0, [r4, r5]
 
    ldr     r5, =#PORTB_PCB1_OFFSET
    str     r0, [r4, r5]
 
    bx      lr

systick_config:
   // Configurar SysTick 
    ldr r0, =SYST_RVR
    ldr r1, =SYSTICK_RELOAD_1MS
    str r1, [r0]                      

    ldr r0, =SYST_CVR
    mov r1, #0
    str r1, [r0]                      

    ldr r0, =SYST_CSR
    mov r1, #(SYSTICK_ENABLE | SYSTICK_TICKINT | SYSTICK_CLKSOURCE)
    str r1, [r0]                      // Habilitar el SysTick, la interrupción y seleccionar el reloj del procesador
    bx  lr

crear_tabla_leds:
    ldr   r10, =base_logo  // Dirección inicial de memoria para guardar la tabla
    ldr   r1, =leds       // Dirección de la tabla en la memoria de programa
    mov   r2, #8         // Tamaño de la matriz (Filas)  
    mov   r3, #8        // Tamaño de la matriz (columnas)

// En el ejemplo de semaforo es con las filas pero en este caso es con las columnas
loop_columnas:
    ldrb  r0, [r1], #1      // Carga el byte actual de la tabla de LED
    strb  r0, [r10], #1    // Guarda el byte en la dirección de memoria y avanza
    subs  r3, r3, #1      // Decrementa el contador de columnas
    bne   loop_columnas  // Continúa el bucle si no se han procesado todas las columnas
    bx    lr            // Retorna

.section .rodata
leds:
    .byte 0b11111111 //Columna 1
    .byte 0b11000011 //Columna 2
    .byte 0b10100101 //Columna 3
    .byte 0b10011001 //Columna 4
    .byte 0b10011001 //Columna 5
    .byte 0b10100101 //Columna 6
    .byte 0b11000011 //Columna 7
    .byte 0b11111111 //Columna 8

