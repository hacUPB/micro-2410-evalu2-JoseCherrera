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
  .extern estado_semaforo  
  .text
 
  .thumb_func
//Inicio de la funcion principal: 
_start:
    bl PTB_init           // Llama a la subrutina PTB_init, que inicializa el puerto B.
    bl gpioB_init        // Llama a la subrutina gpioB_init, que inicializa los pines del puerto GPIO B.
    bl systick_config   // Llama a la subrutina systick_config, que configura el temporizador SysTick.
 
    // Máquina de estados
    ldr r4, =Base_maquina_0              // Carga la dirección de la máquina de estados en el registro r4.
    mov r1, #ROJO                       // Carga el valor ROJO en el registro r1, que probablemente representa el estado actual del semáforo.
    str r1, [r4, #var_estado_M0]       // Almacena el valor de r1 (estado ROJO) en la variable var_estado_M0 dentro de la máquina de estados.
    mov r2, #0                        // Inicializa el registro r2 con 0, que podría representar un contador o un tiempo.
    str r2, [r4, entrada_tiempo_M0]  // Almacena el valor de r2 en la entrada de tiempo de la máquina de estados.
 
// Bucle principal:
loop_principal:          // Etiqueta que marca el inicio del bucle principal.
    bl estado_semaforo  // Llama a la función estado_semaforo, que probablemente actualiza el estado del semáforo.             
    b loop_principal   // Salta de regreso a loop_principal, creando un bucle infinito.          
 
 
// Configuraciones iniciales
gpioB_init:    
    ldr r0, =GPIOB_PDDR                  // Carga la dirección del registro de dirección de datos del puerto B en r0.
    ldr r1, [r0]                        // Carga el contenido del registro de dirección de datos en r1.
    orr r1, r1, #(1 << LED_ROJO)       // Configura el bit correspondiente al LED ROJO como salida.
    orr r1, r1, #(1 << LED_AMARILLO)  // Configura el bit correspondiente al LED AMARILLO como salida.
    orr r1, r1, #(1 << LED_VERDE)    // Configura el bit correspondiente al LED VERDE como salida.
    str r1, [r0]                    // Almacena el nuevo valor de r1 en el registro de dirección de datos, actualizando las configuraciones de los LEDs. 
 
    ldr r0, =GPIOB_PSOR             // Carga la dirección del registro de Set Output (PSOR) del puerto B en r0.
    mov r1, #(1 << LED_ROJO)       // Establece el LED ROJO en alto (encendido).
    str r1, [r0]                  // Establece el LED ROJO en alto (encendido).
    mov r1, #(1 << LED_AMARILLO) // Establece el LED AMARILLO en alto (encendido).
    str r1, [r0]                // Establece el LED AMARILLO en alto (encendido).     
    mov r1, #(1 << LED_VERDE)  // Establece el LED VERDE en alto (encendido).
    str r1, [r0]              // Establece el LED VERDE en alto (encendido).    
    bx  lr                   // Retorna de la subrutina gpioB_init.
 
 
    // Subrutina de configuración de periféricos
PTB_init:
    // Habilitar el reloj para el puerto B
    ldr r0, =PCC_PORTB             // Carga la dirección del registro de control del puerto B en r0.      
    ldr r1, [r0]                  // Carga el contenido del registro de control en r1.      
    orr r1, r1, #PCC_PORTB_CGC   // Habilita el reloj para el puerto B.       
    str r1, [r0]                // Almacena el nuevo valor en el registro de control del puerto B.       
 
    // Configurar el puerto
    ldr r0, =PORTB_PCR12            // Carga la dirección del registro de control de la pin 12 del puerto B en r0.   
    ldr r1, [r0]                   // Carga el contenido del registro de control del pin 12 en r1  
    bic r1, r1, #(0x7 << 8)       // Limpia los bits de configuración de multiplexión para el pin 12.     
    orr r1, r1, #(MUX_GPIO << 8) // Configura el pin 12 para funcionar como GPIO.  
    str r1, [r0]                // Almacena el nuevo valor en el registro de control del pin 12.    
 
    // Configurar el puerto
    ldr r0, =PORTB_PCR13             // Carga la dirección del registro de control de la pin 13 del puerto B en r0.  
    ldr r1, [r0]                    // Carga el contenido del registro de control del pin 13 en r1
    bic r1, r1, #(0x7 << 8)        // Limpia los bits de configuración de multiplexión para el pin 13. 
    orr r1, r1, #(MUX_GPIO << 8)  // Configura el pin 13 para funcionar como GPIO. 
    str r1, [r0]                 // Almacena el nuevo valor en el registro de control del pin 13. 
 
    // Configurar el puerto
    ldr r0, =PORTB_PCR14             // Carga la dirección del registro de control de la pin 14 del puerto B en r0.   
    ldr r1, [r0]                    // Carga el contenido del registro de control del pin 14 en r1
    bic r1, r1, #(0x7 << 8)        // Limpia los bits de configuración de multiplexión para el pin 14. 
    orr r1, r1, #(MUX_GPIO << 8)  // Configura el pin 14 para funcionar como GPIO. 
    str r1, [r0]                 // Almacena el nuevo valor en el registro de control del pin 14. 
 
    // Retorna de la subrutina PTB_init.
    bx lr 
 
 
systick_config:
   // Configurar SysTick 
    ldr r0, =SYST_RVR            // Carga la dirección del registro de recarga de SysTick en r0.
    ldr r1, =SYSTICK_RELOAD_1MS // Carga el valor de recarga para 1 ms en r1.
    str r1, [r0]               // Almacena el valor de recarga en el registro de recarga de SysTick.       
 
    ldr r0, =SYST_CVR // Carga la dirección del registro de cuenta actual de SysTick en r0.
    mov r1, #0       // Inicializa el registro de cuenta actual en 0.
    str r1, [r0]    // Almacena 0 en el registro de cuenta actual.                  
 
    ldr r0, =SYST_CSR // Carga la dirección del registro de control de SysTick en r0.
    mov r1, #(SYSTICK_ENABLE | SYSTICK_TICKINT | SYSTICK_CLKSOURCE) //Configura el registro de control para habilitar SysTick, habilitar interrupciones y seleccionar el reloj del procesador.
    str r1, [r0]  // Habilitar el SysTick, la interrupción y seleccionar el reloj del procesador -Almacena la configuración en el registro de control de SysTick.
    bx  lr // Retorna de la subrutina systick_config.
