#include "definiciones.h"
 
  .syntax unified
  .global estado_semaforo
  .text
 
 
  .align 2 // Alinear la tabla de direcciones a 4 bytes (2^2 = 4)
// Lista de direcciones de los estados
//Cada dirección se almacena como un valor de 32 bits (long), lo que permite saltar a la función correspondiente según el estado actual.
dir_tabla_estados:
  .long estado_rojo           //0     
  .long estado_rojo_amarillo  //1  
  .long estado_verde          //2 
  .long estado_amarillo       //3 
 
    .thumb_func
 
estado_semaforo:
    push {lr}                       // Guarda el registro de enlace (lr) en la pila para poder regresar después.
    ldr r4, =Base_maquina_0        // Carga la dirección base de la máquina de estados en el registro r4.
    ldr r0, [r4, #var_estado_M0]  // Carga el estado actual de la máquina de estados en el registro r0.  
    lsl r0, #2                   // Desplaza el valor en r0 a la izquierda por 2 bits, multiplicando el número de estado por 4 
    ldr r4, =dir_tabla_estados  // Carga la dirección de la tabla de direcciones de los estados en el registro r4. 
    ldr r1, [r4, r0]           // Carga la dirección del estado correspondiente (según el valor calculado en r0) en el registro r1.    
    bx r1                     // Salta a la dirección almacenada en r1, lo que efectivamente llama a la función del estado correspondiente.    
 
    .thumb_func
estado_rojo:
    ldr r4, =Base_maquina_0            // Carga la dirección base de la máquina de estados en r4
    ldr r0, [r4, #entrada_tiempo_M0]  // Obtiene el tiempo de entrada para el estado en r0. 
    ldr r5, =TIEMPO_ROJO             // Carga el tiempo configurado para el estado ROJO en r5,             
    cmp r0, r5                      // Compara r0 con r5
    blt fin_estado                 // Si r0 es menor, salta a fin_estado, lo que indica que no se ha alcanzado el tiempo suficiente.       
 
    // Salidas
    ldr r0, =GPIOB_PCOR       //PCOR = pone un 1 para clear(0)
    mov r1, #(1 << LED_ROJO) // Configura el pin del LED ROJO para que se apague. 
    str r1, [r0]                      
 
    ldr r0, =GPIOB_PSOR           // PSOR = cuando pone un 1 lo pone en 1
    mov r1, #(1 << LED_AMARILLO) // Enciende el led amarillo 
    str r1, [r0]                                     
    mov r1, #(1 << LED_VERDE)  // Enciende el led verde
    str r1, [r0]                      
 
    // Cambiar al siguiente estado 
    mov r1, #ROJO_AMARILLO              // Cambia el estado actual al siguiente estado (rojo-amarillo).
    str r1, [r4, #var_estado_M0]       // Almacena el nuevo estado.
    mov r2, #0                        // 
    str r2, [r4, entrada_tiempo_M0]  // Resetea el tiempo de entrada
    pop {lr}                        // Restaura el valor anterior del registro de enlace.
    bx lr                          // Salta de vuelta al punto de retorno guardado.
 
    .thumb_func

estado_rojo_amarillo:
    ldr r4, =Base_maquina_0            // Carga la dirección base de la máquina de estados en r4.
    ldr r0, [r4, #entrada_tiempo_M0]  // Carga el tiempo de entrada en el estado rojo-amarillo en r0.
    ldr r5, =TIEMPO_ROJO_AMARILLO    // Carga en r5 el valor predefinido de tiempo máximo para el estado rojo-amarillo.
    cmp r0, r5                      // Compara el tiempo actual (r0) con el tiempo máximo (r5).
    blt fin_estado                 // Si el tiempo aún no ha alcanzado el límite (r0 < r5), salta a fin_estado para finalizar este ciclo. 
 
    // Configura la salida
    ldr r0, =GPIOB_PCOR                              // PCOR = pone un 1 para clear(0)         
    mov r1, #(1 << LED_ROJO) | (1 << LED_AMARILLO)  // Configura el pin del LED ROJO y LED AMARILLO para que se apague. 
    str r1, [r0]                                                        
 
    ldr r0, =GPIOB_PSOR        // PSOR = cuando pone un 1 lo pone en 1
    mov r1, #(1 << LED_VERDE) // Enciende el led verde 
    str r1, [r0]                          
 
    // Cambiar al siguiente estado 
    mov r1, #VERDE                      //Cambia el estado actual al siguiente estado (verde).
    str r1, [r4, #var_estado_M0]       // Almacena el nuevo estado.
    mov r2, #0                        // 
    str r2, [r4, entrada_tiempo_M0]  // Resetea el tiempo de entrada
    pop {lr}                        // Restaura el valor anterior del registro de enlace.
    bx lr                          // Salta de vuelta al punto de retorno guardado.
 
    .thumb_func
estado_verde:
    ldr r4, =Base_maquina_0            // Carga la dirección base de la máquina de estados en r4.
    ldr r0, [r4, #entrada_tiempo_M0]  // Carga el tiempo de entrada en el estado verde en r0.
    ldr r5, =TIEMPO_VERDE            // Carga en r5 el valor predefinido de tiempo máximo para el estado verde.         
    cmp r0, r5                      // Compara el tiempo actual (r0) con el tiempo máximo (r5). 
    blt fin_estado                 // Si el tiempo aún no ha alcanzado el límite (r0 < r5), salta a fin_estado para finalizar este ciclo.     
 
    // Configura salida
    ldr r0, =GPIOB_PCOR        // PCOR = pone un 1 para clear(0)  
    mov r1, #(1 << LED_VERDE) // Configura el pin del LED VERDE para que se apague.
    str r1, [r0]                     
 
    ldr r0, =GPIOB_PSOR              // PSOR = cuando pone un 1 lo pone en 1
    mov r1, #(1 << LED_ROJO)        // Enciende el led rojo   
    str r1, [r0]                         
    mov r1, #(1 << LED_AMARILLO)  // Enciende led amarillo
    str r1, [r0]                          
 
    // Cambiar al siguiente estado 
    mov r1, #AMARILLO                   //Cambia el estado actual al siguiente estado (amarillo).
    str r1, [r4, #var_estado_M0]       // Almacena el nuevo estado. 
    mov r2, #0                        //
    str r2, [r4, entrada_tiempo_M0]  // Resetea el tiempo de entrada
    pop {lr}                        // Restaura el valor anterior del registro de enlace.
    bx lr                          // Salta de vuelta al punto de retorno guardado.
 
    .thumb_func
estado_amarillo:
    ldr r4, =Base_maquina_0            // Carga la dirección base de la máquina de estados en r4.
    ldr r0, [r4, #entrada_tiempo_M0]  // Carga el tiempo de entrada en el estado amarillo en r0.
    ldr r5, =TIEMPO_AMARILLO         // Carga en r5 el valor predefinido de tiempo máximo para el estado amarillo.  
    cmp r0, r5                      // Compara el tiempo actual (r0) con el tiempo máximo (r5).
    blt fin_estado                 // Si el tiempo aún no ha alcanzado el límite (r0 < r5), salta a fin_estado para finalizar este ciclo.          
 
    // Configurar salida
    ldr r0, =GPIOB_PCOR            // PCOR = pone un 1 para clear(0)
    mov r1, #(1 << LED_AMARILLO)  // Configura el pin del LED AMARILLO para que se apague. 
    str r1, [r0]                             
 
    ldr r0, =GPIOB_PSOR          // PSOR = cuando pone un 1 lo pone en 1
    mov r1, #(1 << LED_ROJO)    // Enciende el led rojo    
    str r1, [r0]                             
    mov r1, #(1 << LED_VERDE) //Enciende el led verde   
    str r1, [r0]                 

    // Cambiar al siguiente estado 
    mov r1, #ROJO                       //Cambia el estado actual al siguiente estado (rojo).
    str r1, [r4, #var_estado_M0]       // Almacena el nuevo estado. 
    mov r2, #0                        //
    str r2, [r4, entrada_tiempo_M0]  // Resetea el tiempo de entrada
    pop {lr}                        // Restaura el valor anterior del registro de enlace.
    bx lr                          // Salta de vuelta al punto de retorno guardado.
 
fin_estado:
    pop {lr} //
    bx lr   //
