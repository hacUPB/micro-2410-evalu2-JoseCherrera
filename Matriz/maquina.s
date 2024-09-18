#include "definiciones.h"
 
  .syntax unified
  .global estado_leds
  .text
 
    .thumb_func 
estado_leds:
    push {lr}                        // Guarda el registro de enlace (lr) en el stack. lr contiene la dirección de retorno.
    ldr r4, =Base_maquina_0         // Carga en r4 la dirección base de la máquina de estados.
    ldr r0, [r4, #var_estado_M0]   // Carga en r0 el valor del estado actual desde la variable var_estado_M0.
    lsl r0, #2                    // Desplaza el valor de (r0) 2 bits a la izquierda, multiplicándolo por 4 (se usa para obtener el offset de una tabla).
    ldr r4, =dir_tabla_estados   // Carga la dirección base de la tabla de estados en r4.
     ldr r1, [r4, r0]           // Carga en r1 la dirección de la subrutina correspondiente al estado actual.
    bx r1                      // Salta a la subrutina del estado, usando la dirección que está en r1.
 
    .thumb_func

ESTADO1: 
    ldr r4, =Base_maquina_0             // Carga en r4 la dirección base de la máquina de estados.
    ldr r0, [r4, #entrada_tiempo_M0]   // Carga en r0 el valor del tiempo de entrada de este estado. 
    ldr r5, =TIEMPO                   // Carga en r5 el tiempo máximo que debe durar el estado.
    cmp r0, r5                       // Compara el tiempo actual (r0) con el tiempo límite (r5).
    blt fin_estado                  // Si el tiempo actual es menor que el tiempo límite, salta a fin_estado para terminar el estado.

    // Desactiva las filas
    ldr     r0, =#GPIOB_BASE // Carga la dirección base del puerto GPIO B.
    ldr     r5, =#GPIOB     // Carga en r5 el valor que desactiva las filas.           

    str     r5, [r0, #GPIO_PDOR_OFFSET] //Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las filas del LED.

    // Desactiva las columnas
    ldr     r10, =#GPIOC_BASE             // Carga la dirección base del puerto GPIO C.
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r1 para desactivar la columna en el puerto GPIO C.
    ldr     r0, =#CEROS                 // Las columnas se desantivan activan con 0
    and     r5, r1, r0                 // Usa la AND logica para desactivar la columna sin afectar los otros bits

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las columnas del LED.

    
    //Activa la primera columna
    ldr     r10, =#GPIOC_BASE              // Carga la dirección base del puerto GPIO C.
    ldr     r11, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r11 para activar la columna en el puerto GPIO C.
    mov     r9, #1                       // Carga en r9 un 1, que representa la activación de una columna.
    lsl     r9, #GPIOC8_OFFSET          // Desplaza r9 para activar la columna deseada (en este caso con el pin 8 del registro C).
    orr     r5, r11, r9                // Usa OR lógico para activar la columna sin afectar otros bits.

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 para activar la columna en el puerto GPIO C.

    //Activación de Filas
    ldr  r6, =#base_logo // Carga la dirección base de los datos almacenados en RAM (que probablemente contienen el patrón de LEDs).
    ldrb r7, [r6]       // Toma la informacion guardada en la RAM de la estado1 //Carga un byte desde la RAM en r7.
 
    bl Escribirfilas // Llama a la subrutina Escribirfilas para actualizar las filas del LED según el dato cargado.


    // Cambiar al siguiente estado 
    mov r1, #est2                       // Cambia el estado de la máquina a la siguiente columna (est2 en este caso).
    str r1, [r4, #var_estado_M0]       // Le dice a la maquina que el estado es el siguiente y guarda el nuevo estado en var_estado_M0.
    mov r2, #0                        // Reinicia el contador de tiempo.
    str r2, [r4, entrada_tiempo_M0]  // Guarda el tiempo reiniciado en entrada_tiempo_M0.
    pop {lr}                        // Restaura el registro de enlace (dirección de retorno). 
    bx lr                          // Retorna al punto de llamada.

    .thumb_func
     
ESTADO2: 
    ldr r4, =Base_maquina_0             // Carga en r4 la dirección base de la máquina de estados.
    ldr r0, [r4, #entrada_tiempo_M0]   // Carga en r0 el valor del tiempo de entrada de este estado. 
    ldr r5, =TIEMPO                   // Carga en r5 el tiempo máximo que debe durar el estado.
    cmp r0, r5                       // Compara el tiempo actual (r0) con el tiempo límite (r5).
    blt fin_estado                  // Si el tiempo actual es menor que el tiempo límite, salta a fin_estado para terminar el estado.
    

    // Desactiva las filas
    ldr     r0, =#GPIOB_BASE // Carga la dirección base del puerto GPIO B.
    ldr     r5, =#GPIOB     // Carga en r5 el valor que desactiva las filas.   


    str     r5, [r0, #GPIO_PDOR_OFFSET] //Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las filas del LED.

    // Desactiva las columnas
    ldr     r10, =#GPIOC_BASE             // Carga la dirección base del puerto GPIO C.
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r1 para desactivar la columna en el puerto GPIO C.
    ldr     r0, =#CEROS                 // Las columnas se desantivan activan con 0
    and     r5, r1, r0                 // Usa la AND logica para desactivar la columna sin afectar los otros bits

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las columnas del LED.

    
    //Activa la segunda columna
    ldr     r10, =#GPIOC_BASE               // Carga la dirección base del puerto GPIO C.
    ldr     r11, [r10, #GPIO_PDOR_OFFSET]  // Escribe el valor de r11 para activar la columna en el puerto GPIO C.
    mov     r9, #1                        // Carga en r9 un 1, que representa la activación de una columna.
    lsl     r9, #GPIOC9_OFFSET           // Desplaza r9 para activar la columna deseada (en este caso con el pin 9 del registro C).
    orr     r5, r11, r9                 // Usa OR lógico para activar la columna sin afectar otros bits.

    str     r5, [r10, #GPIO_PDOR_OFFSET]  // Escribe el valor de r5 para activar la columna en el puerto GPIO C.

    //Activación de Filas
    ldr  r6, =#base_logo // Carga la dirección base de los datos almacenados en RAM (que probablemente contienen el patrón de LEDs).
    ldrb r7, [r6,est2]  // Toma la informacion guardada en la RAM de la estado2 //Carga un byte desde la RAM en r7.
 
    bl Escribirfilas // Llama a la subrutina Escribirfilas para actualizar las filas del LED según el dato cargado.
      
    // Cambiar al siguiente estado 
    mov r1, #est3                       // Cambia el estado de la máquina a la siguiente columna (est3 en este caso).
    str r1, [r4, #var_estado_M0]       // Le dice a la maquina que el estado es el siguiente y guarda el nuevo estado en var_estado_M0.
    mov r2, #0                        // Reinicia el contador de tiempo.
    str r2, [r4, entrada_tiempo_M0]  // Guarda el tiempo reiniciado en entrada_tiempo_M0.
    pop {lr}                        // Restaura el registro de enlace (dirección de retorno). 
    bx lr                          // Retorna al punto de llamada.

    .thumb_func 

ESTADO3:
    ldr r4, =Base_maquina_0             // Carga en r4 la dirección base de la máquina de estados.
    ldr r0, [r4, #entrada_tiempo_M0]   // Carga en r0 el valor del tiempo de entrada de este estado. 
    ldr r5, =TIEMPO                   // Carga en r5 el tiempo máximo que debe durar el estado.
    cmp r0, r5                       // Compara el tiempo actual (r0) con el tiempo límite (r5).
    blt fin_estado                  // Si el tiempo actual es menor que el tiempo límite, salta a fin_estado para terminar el estado.
    
    // Desactiva las filas
    ldr     r0, =#GPIOB_BASE // Carga la dirección base del puerto GPIO B.
    ldr     r5, =#GPIOB     // Carga en r5 el valor que desactiva las filas.           


    str     r5, [r0, #GPIO_PDOR_OFFSET] //Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las filas del LED.

    // Desactiva las columnas
    ldr     r10, =#GPIOC_BASE             // Carga la dirección base del puerto GPIO C.
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r1 para desactivar la columna en el puerto GPIO C.
    ldr     r0, =#CEROS                 // Las columnas se desantivan activan con 0
    and     r5, r1, r0                 // Usa la AND logica para desactivar la columna sin afectar los otros bits

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las columnas del LED.

    //Activa la tercera columna
    ldr     r10, =#GPIOC_BASE              // Carga la dirección base del puerto GPIO C.
    ldr     r11, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r11 para activar la columna en el puerto GPIO C.
    mov     r9, #1                       // Carga en r9 un 1, que representa la activación de una columna.
    lsl     r9, #GPIOC10_OFFSET         // Desplaza r9 para activar la columna deseada (en este caso con el pin 10 del registro C).
    orr     r5, r11, r9                // Usa OR lógico para activar la columna sin afectar otros bits.

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 para activar la columna en el puerto GPIO C.

    //Activación de Filas
    ldr  r6, =#base_logo // Carga la dirección base de los datos almacenados en RAM (que probablemente contienen el patrón de LEDs).
    ldrb r7, [r6,est3]  // Toma la informacion guardada en la RAM de la estado3 //Carga un byte desde la RAM en r7.
 
    bl Escribirfilas // Llama a la subrutina Escribirfilas para actualizar las filas del LED según el dato cargado.

    // Cambiar al siguiente estado 
    mov r1, #est4                       // Cambia el estado de la máquina a la siguiente columna (est2 en este caso).
    str r1, [r4, #var_estado_M0]       // Le dice a la maquina que el estado es el siguiente y guarda el nuevo estado en var_estado_M0.
    mov r2, #0                        // Reinicia el contador de tiempo.
    str r2, [r4, entrada_tiempo_M0]  // Guarda el tiempo reiniciado en entrada_tiempo_M0.
    pop {lr}                        // Restaura el registro de enlace (dirección de retorno). 
    bx lr                          // Retorna al punto de llamada.

    .thumb_func 

ESTADO4:
    ldr r4, =Base_maquina_0             // Carga en r4 la dirección base de la máquina de estados.
    ldr r0, [r4, #entrada_tiempo_M0]   // Carga en r0 el valor del tiempo de entrada de este estado. 
    ldr r5, =TIEMPO                   // Carga en r5 el tiempo máximo que debe durar el estado.
    cmp r0, r5                       // Compara el tiempo actual (r0) con el tiempo límite (r5).
    blt fin_estado                  // Si el tiempo actual es menor que el tiempo límite, salta a fin_estado para terminar el estado.
    
    // Desactiva las filas
    ldr     r0, =#GPIOB_BASE // Carga la dirección base del puerto GPIO B.
    ldr     r5, =#GPIOB     // Carga en r5 el valor que desactiva las filas.    


    str     r5, [r0, #GPIO_PDOR_OFFSET] //Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las filas del LED.

    // Desactiva las columnas
    ldr     r10, =#GPIOC_BASE             // Carga la dirección base del puerto GPIO C.
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r1 para desactivar la columna en el puerto GPIO C.
    ldr     r0, =#CEROS                 // Las columnas se desantivan activan con 0
    and     r5, r1, r0                 // Usa la AND logica para desactivar la columna sin afectar los otros bits

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las columnas del LED.

    //Activa la cuarta columna
    ldr     r10, =#GPIOC_BASE              // Carga la dirección base del puerto GPIO C.
    ldr     r11, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r11 para activar la columna en el puerto GPIO C. 
    mov     r9, #1                       // Carga en r9 un 1, que representa la activación de una columna.
    lsl     r9, #GPIOC11_OFFSET         // Desplaza r9 para activar la columna deseada (en este caso con el pin 11 del registro C).
    orr     r5, r11, r9                // Usa OR lógico para activar la columna sin afectar otros bits.

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 para activar la columna en el puerto GPIO C.

    //Activación de Filas
    ldr  r6, =#base_logo // Carga la dirección base de los datos almacenados en RAM (que probablemente contienen el patrón de LEDs).
    ldrb r7, [r6,est4]  // Toma la informacion guardada en la RAM de la estado4 //Carga un byte desde la RAM en r7.
 
    bl Escribirfilas // Llama a la subrutina Escribirfilas para actualizar las filas del LED según el dato cargado.

    // Cambiar al siguiente estado 
    mov r1, #est5                       // Cambia el estado de la máquina a la siguiente columna (est2 en este caso).
    str r1, [r4, #var_estado_M0]       // Le dice a la maquina que el estado es el siguiente y guarda el nuevo estado en var_estado_M0.
    mov r2, #0                        // Reinicia el contador de tiempo.
    str r2, [r4, entrada_tiempo_M0]  // Guarda el tiempo reiniciado en entrada_tiempo_M0.
    pop {lr}                        // Restaura el registro de enlace (dirección de retorno). 
    bx lr                          // Retorna al punto de llamada.


    .thumb_func 

ESTADO5:
    ldr r4, =Base_maquina_0             // Carga en r4 la dirección base de la máquina de estados.
    ldr r0, [r4, #entrada_tiempo_M0]   // Carga en r0 el valor del tiempo de entrada de este estado. 
    ldr r5, =TIEMPO                   // Carga en r5 el tiempo máximo que debe durar el estado.
    cmp r0, r5                       // Compara el tiempo actual (r0) con el tiempo límite (r5).
    blt fin_estado                  // Si el tiempo actual es menor que el tiempo límite, salta a fin_estado para terminar el estado.
    

    // Desactiva las filas
    ldr     r0, =#GPIOB_BASE // Carga la dirección base del puerto GPIO B.
    ldr     r5, =#GPIOB     // Carga en r5 el valor que desactiva las filas.  

    str     r5, [r0, #GPIO_PDOR_OFFSET] //Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las filas del LED.

    // Desactiva las columnas 
    ldr     r10, =#GPIOC_BASE             // Carga la dirección base del puerto GPIO C.
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r1 para desactivar la columna en el puerto GPIO C.
    ldr     r0, =#CEROS                 // Las columnas se desantivan activan con 0
    and     r5, r1, r0                 // Usa la AND logica para desactivar la columna sin afectar los otros bits

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las columnas del LED.
    
    //Activa la quinta columna
    ldr     r10, =#GPIOC_BASE              // Carga la dirección base del puerto GPIO C.
    ldr     r11, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r11 para activar la columna en el puerto GPIO C.
    mov     r9, #1                       // Carga en r9 un 1, que representa la activación de una columna.
    lsl     r9, #GPIOC12_OFFSET         // Desplaza r9 para activar la columna deseada (en este caso con el pin 12 del registro C).
    orr     r5, r11, r9                // Usa OR lógico para activar la columna sin afectar otros bits.

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 para activar la columna en el puerto GPIO C.

    //Activación de Filas
    ldr  r6, =#base_logo // Carga la dirección base de los datos almacenados en RAM (que probablemente contienen el patrón de LEDs).
    ldrb r7, [r6,est5]  // Toma la informacion guardada en la RAM de la estado5 //Carga un byte desde la RAM en r7.
 
    bl Escribirfilas // Llama a la subrutina Escribirfilas para actualizar las filas del LED según el dato cargado.
    
    // Cambiar al siguiente estado 
    mov r1, #est6                       // Cambia el estado de la máquina a la siguiente columna (est2 en este caso).
    str r1, [r4, #var_estado_M0]       // Le dice a la maquina que el estado es el siguiente y guarda el nuevo estado en var_estado_M0.
    mov r2, #0                        // Reinicia el contador de tiempo.
    str r2, [r4, entrada_tiempo_M0]  // Guarda el tiempo reiniciado en entrada_tiempo_M0.
    pop {lr}                        // Restaura el registro de enlace (dirección de retorno). 
    bx lr                          // Retorna al punto de llamada.

    .thumb_func 

ESTADO6:
    ldr r4, =Base_maquina_0             // Carga en r4 la dirección base de la máquina de estados.
    ldr r0, [r4, #entrada_tiempo_M0]   // Carga en r0 el valor del tiempo de entrada de este estado. 
    ldr r5, =TIEMPO                   // Carga en r5 el tiempo máximo que debe durar el estado.
    cmp r0, r5                       // Compara el tiempo actual (r0) con el tiempo límite (r5).
    blt fin_estado                  // Si el tiempo actual es menor que el tiempo límite, salta a fin_estado para terminar el estado.
    
    // Desactiva las filas
    ldr     r0, =#GPIOB_BASE // Carga la dirección base del puerto GPIO B.
    ldr     r5, =#GPIOB     // Carga en r5 el valor que desactiva las filas.      


    str     r5, [r0, #GPIO_PDOR_OFFSET] //Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las filas del LED.

    // Desactiva las columnas
    ldr     r10, =#GPIOC_BASE             // Carga la dirección base del puerto GPIO C.
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r1 para desactivar la columna en el puerto GPIO C.
    ldr     r0, =#CEROS                 // Las columnas se desantivan activan con 0
    and     r5, r1, r0                 // Usa la AND logica para desactivar la columna sin afectar los otros bits

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las columnas del LED.

    
    //Activa la sexta columna
    ldr     r10, =#GPIOC_BASE              // Carga la dirección base del puerto GPIO C.
    ldr     r11, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r11 para activar la columna en el puerto GPIO C.
    mov     r9, #1                       // Carga en r9 un 1, que representa la activación de una columna.
    lsl     r9, #GPIOC13_OFFSET         // Desplaza r9 para activar la columna deseada (en este caso con el pin 13 del registro C).
    orr     r5, r11, r9                // Usa OR lógico para activar la columna sin afectar otros bits.

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 para activar la columna en el puerto GPIO C.

    //Activación de Filas
    ldr  r6, =#base_logo // Carga la dirección base de los datos almacenados en RAM (que probablemente contienen el patrón de LEDs).
    ldrb r7, [r6,est6]  // Toma la informacion guardada en la RAM de la estado6 //Carga un byte desde la RAM en r7.
 
    bl Escribirfilas // Llama a la subrutina Escribirfilas para actualizar las filas del LED según el dato cargado.

    // Cambiar al siguiente estado 
    mov r1, #est7                       // Cambia el estado de la máquina a la siguiente columna (est2 en este caso).
    str r1, [r4, #var_estado_M0]       // Le dice a la maquina que el estado es el siguiente y guarda el nuevo estado en var_estado_M0.
    mov r2, #0                        // Reinicia el contador de tiempo.
    str r2, [r4, entrada_tiempo_M0]  // Guarda el tiempo reiniciado en entrada_tiempo_M0.
    pop {lr}                        // Restaura el registro de enlace (dirección de retorno). 
    bx lr                          // Retorna al punto de llamada.
    
    .thumb_func 
     
ESTADO7:
    ldr r4, =Base_maquina_0             // Carga en r4 la dirección base de la máquina de estados.
    ldr r0, [r4, #entrada_tiempo_M0]   // Carga en r0 el valor del tiempo de entrada de este estado. 
    ldr r5, =TIEMPO                   // Carga en r5 el tiempo máximo que debe durar el estado.
    cmp r0, r5                       // Compara el tiempo actual (r0) con el tiempo límite (r5).
    blt fin_estado                  // Si el tiempo actual es menor que el tiempo límite, salta a fin_estado para terminar el estado.
    

    // Desactiva las filas
    ldr     r0, =#GPIOB_BASE // Carga la dirección base del puerto GPIO B.
    ldr     r5, =#GPIOB     // Carga en r5 el valor que desactiva las filas.           

    str     r5, [r0, #GPIO_PDOR_OFFSET] //Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las filas del LED.

    // Desactiva las columnas
    ldr     r10, =#GPIOC_BASE             // Carga la dirección base del puerto GPIO C.
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r1 para desactivar la columna en el puerto GPIO C.
    ldr     r0, =#CEROS                 // Las columnas se desantivan activan con 0
    and     r5, r1, r0                 // Usa la AND logica para desactivar la columna sin afectar los otros bits

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las columnas del LED.

    //Activa la septima columna 
    ldr     r10, =#GPIOC_BASE              // Carga la dirección base del puerto GPIO C.
    ldr     r11, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r11 para activar la columna en el puerto GPIO C.
    mov     r9, #1                       // Carga en r9 un 1, que representa la activación de una columna.
    lsl     r9, #GPIOC14_OFFSET         // Desplaza r9 para activar la columna deseada (en este caso con el pin 14 del registro C).
    orr     r5, r11, r9                // Usa OR lógico para activar la columna sin afectar otros bits.

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 para activar la columna en el puerto GPIO C.

    //Activación de Filas
    ldr  r6, =#base_logo // Carga la dirección base de los datos almacenados en RAM (que probablemente contienen el patrón de LEDs).
    ldrb r7, [r6,est7]  // Toma la informacion guardada en la RAM de la estado7 //Carga un byte desde la RAM en r7.
 
    bl Escribirfilas // Llama a la subrutina Escribirfilas para actualizar las filas del LED según el dato cargado.

    // Cambiar al siguiente estado 
    mov r1, #est8                       // Cambia el estado de la máquina a la siguiente columna (est2 en este caso).
    str r1, [r4, #var_estado_M0]       // Le dice a la maquina que el estado es el siguiente y guarda el nuevo estado en var_estado_M0.
    mov r2, #0                        // Reinicia el contador de tiempo.
    str r2, [r4, entrada_tiempo_M0]  // Guarda el tiempo reiniciado en entrada_tiempo_M0.
    pop {lr}                        // Restaura el registro de enlace (dirección de retorno). 
    bx lr                          // Retorna al punto de llamada.

    .thumb_func 

ESTADO8:
    ldr r4, =Base_maquina_0             // Carga en r4 la dirección base de la máquina de estados.
    ldr r0, [r4, #entrada_tiempo_M0]   // Carga en r0 el valor del tiempo de entrada de este estado. 
    ldr r5, =TIEMPO                   // Carga en r5 el tiempo máximo que debe durar el estado.
    cmp r0, r5                       // Compara el tiempo actual (r0) con el tiempo límite (r5).
    blt fin_estado                  // Si el tiempo actual es menor que el tiempo límite, salta a fin_estado para terminar el estado.
    

    // Desactiva las filas
    ldr     r0, =#GPIOB_BASE // Carga la dirección base del puerto GPIO B.
    ldr     r5, =#GPIOB     // Carga en r5 el valor que desactiva las filas.           

    str     r5, [r0, #GPIO_PDOR_OFFSET] //Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las filas del LED.

    // Desactiva las columnas
    ldr     r10, =#GPIOC_BASE             // Carga la dirección base del puerto GPIO C.
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r1 para desactivar la columna en el puerto GPIO C.
    ldr     r0, =#CEROS                 // Las columnas se desantivan activan con 0
    and     r5, r1, r0                 // Usa la AND logica para desactivar la columna sin afectar los otros bits

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 en el registro de salida de datos (PDOR), desactivando las columnas del LED.

    
    //Activa la octava columna
    ldr     r10, =#GPIOC_BASE              // Carga la dirección base del puerto GPIO C.
    ldr     r11, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r11 para activar la columna en el puerto GPIO C.
    mov     r9, #1                       // Carga en r9 un 1, que representa la activación de una columna.
    lsl     r9, #GPIOC15_OFFSET         // Desplaza r9 para activar la columna deseada (en este caso con el pin 15 del registro C).
    orr     r5, r11, r9                // Usa OR lógico para activar la columna sin afectar otros bits.

    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribe el valor de r5 para activar la columna en el puerto GPIO C.

    //Activación de Filas
    ldr  r6, =#base_logo // Carga la dirección base de los datos almacenados en RAM (que probablemente contienen el patrón de LEDs).
    ldrb r7, [r6,est8]  // Toma la informacion guardada en la RAM de la estado8 //Carga un byte desde la RAM en r7.
 
    bl Escribirfilas // Llama a la subrutina Escribirfilas para actualizar las filas del LED según el dato cargado.


    // Cambiar al siguiente estado 
    mov r1, #est1                       // Cambia el estado de la máquina a la siguiente columna (est2 en este caso).
    str r1, [r4, #var_estado_M0]       // Le dice a la maquina que el estado es el siguiente y guarda el nuevo estado en var_estado_M0.
    mov r2, #0                        // Reinicia el contador de tiempo.
    str r2, [r4, entrada_tiempo_M0]  // Guarda el tiempo reiniciado en entrada_tiempo_M0.
    pop {lr}                        // Restaura el registro de enlace (dirección de retorno). 
    bx lr                          // Retorna al punto de llamada.


 
fin_estado:
    pop {lr}
    bx lr

// Este apartado se utiliza para encender las filas de la matriz
Escribirfilas: 

    mov  r8, #1       // Cargar el valor 1 en r8
    and  r9, r7, r8  // r9 = r7 AND r8 (verifica si el bit 0 de r7 es 1)
    cmp  r8, r9     // Comparar r8 con r9 (compara si el bit 0 está activo)
    beq f1      // Si son iguales, salta a fila1 (bit 0 activo) 

    lsl  r8, #1      // Desplazar r8 una posición a la izquierda (r8 = 2)
    and  r9, r7, r8 // r9 = r7 AND r8 (verifica si el bit 1 de r7 es 1)   
    cmp  r8, r9    // Comparar r8 con r9 (compara si el bit 1 está activo)
    beq f2     // Si son iguales, salta a fila2 (bit 1 activo)

    lsl  r8, #1      // Desplazar r8 una posición a la izquierda (r8 = 4)
    and  r9, r7, r8 // r9 = r7 AND r8 (verifica si el bit 2 de r7 es 1)   
    cmp r8, r9     // Comparar r8 con r9 (compara si el bit 2 está activo)
    beq f3     // Si son iguales, salta a fila3 (bit 2 activo)

    lsl  r8, #1      // Desplazar r8 una posición a la izquierda (r8 = 8)
    and  r9, r7, r8 // r9 = r7 AND r8 (verifica si el bit 3 de r7 es 1)   
    cmp r8, r9     // Comparar r8 con r9 (compara si el bit 3 está activo)
    beq f4     // Si son iguales, salta a fila4 (bit 3 activo)

    lsl  r8, #1       // Desplazar r8 una posición a la izquierda (r8 = 16)
    and  r9, r7, r8  // r9 = r7 AND r8 (verifica si el bit 4 de r7 es 1) 
    cmp r8, r9      // Comparar r8 con r9 (compara si el bit 4 está activo)
    beq f5      // Si son iguales, salta a fila5 (bit 4 activo)

    lsl  r8, #1       // Desplazar r8 una posición a la izquierda (r8 = 32)
    and  r9, r7, r8  // r9 = r7 AND r8 (verifica si el bit 5 de r7 es 1)   
    cmp r8, r9      // Comparar r8 con r9 (compara si el bit 5 está activo)
    beq f6      // Si son iguales, salta a fila5 (bit 5 activo)

    lsl  r8, #1      // Desplazar r8 una posición a la izquierda (r8 = 64)
    and  r9, r7, r8 // r9 = r7 AND r8 (verifica si el bit 6 de r7 es 1)      
    cmp r8, r9     // Comparar r8 con r9 (compara si el bit 6 está activo)
    beq f7     // Si son iguales, salta a fila5 (bit 6 activo) 

    lsl  r8, #1       // Desplazar r8 una posición a la izquierda (r8 = 128)
    and  r9, r7, r8  // r9 = r7 AND r8 (verifica si el bit 7 de r7 es 1)   
    cmp r8, r9      // Comparar r8 con r9 (compara si el bit 7 está activo)
    beq f8      // Si son iguales, salta a fila5 (bit 7 activo) 

    bx lr //

//Subrutina para activar la fila para el estado 1 
f1: 
    ldr     r10, =#GPIOB_BASE             // Cargar la dirección base del GPIOB en r10
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Cargar el valor del registro de salida en r1
    
    mov     r0, #1               // Cargar 1 en r0 (corresponde al bit 0)
    lsl     r0, #GPIOB10_OFFSET // Desplazar a la posición correspondiente a GPIOB10 (Pin 10 del registro B)
    bic     r5, r1, r0         // Limpiar el bit correspondiente (pone a 0)
    
    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribir el nuevo valor de r5 al registro de salida
    
    lsl  r8, #1      
    and  r9, r7, r8    
    cmp  r8, r9    
    beq f2     


    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f3

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f4

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f5

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f6

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f7

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f8

    bx lr

//Subrutina para activar la fila para el estado 2 
f2: 
    ldr     r10, =#GPIOB_BASE             // Cargar la dirección base del GPIOB en r10
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Cargar el valor del registro de salida en r1
    
    mov     r0, #1               // Cargar 1 en r0 (corresponde al bit 1)
    lsl     r0, #GPIOB11_OFFSET // Desplazar a la posición correspondiente a GPIOB11 (Pin 11 del registro B)
    bic     r5, r1, r0         // Limpiar el bit correspondiente (pone a 0)
    
    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribir el nuevo valor de r5 al registro de salida


    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f3

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f4

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f5

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f6

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f7

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f8

    bx lr 

//Subrutina para activar la fila para el estado 3 
f3: 
    ldr     r10, =#GPIOB_BASE             // Cargar la dirección base del GPIOB en r10
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Cargar el valor del registro de salida en r1
    
    mov     r0, #1               // Cargar 1 en r0 (corresponde al bit 2)
    lsl     r0, #GPIOB12_OFFSET // Desplazar a la posición correspondiente a GPIOB12 (Pin 12 del registro B)
    bic     r5, r1, r0         // Limpiar el bit correspondiente (pone a 0)
    
    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribir el nuevo valor de r5 al registro de salida
    
    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f4

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f5

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f6

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f7

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f8

    bx lr 
//Subrutina para activar la fila para el estado 4 
f4: 
    ldr     r10, =#GPIOB_BASE             // Cargar la dirección base del GPIOB en r10
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Cargar el valor del registro de salida en r1
    
    mov     r0, #1               // Cargar 1 en r0 (corresponde al bit 3)
    lsl     r0, #GPIOB13_OFFSET // Desplazar a la posición correspondiente a GPIOB13 (Pin 13 del registro B)
    bic     r5, r1, r0         // Limpiar el bit correspondiente (pone a 0)
    
    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribir el nuevo valor de r5 al registro de salida


    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f5

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f6

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f7

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f8

    bx lr  

//Subrutina para activar la fila para el estado 5 
f5: 
    ldr     r10, =#GPIOB_BASE             // Cargar la dirección base del GPIOB en r10
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Cargar el valor del registro de salida en r1
    
    mov     r0, #1               // Cargar 1 en r0 (corresponde al bit 4)
    lsl     r0, #GPIOB14_OFFSET // Desplazar a la posición correspondiente a GPIOB14 (Pin 14 del registro B)
    bic     r5, r1, r0         // Limpiar el bit correspondiente (pone a 0)
    
    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribir el nuevo valor de r5 al registro de salida


    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f6

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f7

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f8

    bx lr  

//Subrutina para activar la fila para el estado 6 
f6: 
    ldr     r10, =#GPIOB_BASE             // Cargar la dirección base del GPIOB en r10
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Cargar el valor del registro de salida en r1
    
    mov     r0, #1               // Cargar 1 en r0 (corresponde al bit 5) 
    lsl     r0, #GPIOB15_OFFSET // Desplazar a la posición correspondiente a GPIOB15 (Pin 15 del registro B)
    bic     r5, r1, r0         // Limpiar el bit correspondiente (pone a 0)
    
    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribir el nuevo valor de r5 al registro de salida


    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f7

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f8

    bx lr
     
//Subrutina para activar la fila para el estado 7 
f7: 
    ldr     r10, =#GPIOB_BASE             // Cargar la dirección base del GPIOB en r10
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Cargar el valor del registro de salida en r1
    
    mov     r0, #1               // Cargar 1 en r0 (corresponde al bit 6) 
    lsl     r0, #GPIOB16_OFFSET // Desplazar a la posición correspondiente a GPIOB16 (Pin 16 del registro B)
    bic     r5, r1, r0         // Limpiar el bit correspondiente (pone a 0)
    
    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribir el nuevo valor de r5 al registro de salida
    

    lsl  r8, #1
    and  r9, r7, r8    
    cmp r8, r9
    beq f8

    bx lr

//Subrutina para activar la fila para el estado 8 
f8: 
    ldr     r10, =#GPIOB_BASE             // Cargar la dirección base del GPIOB en r10
    ldr     r1, [r10, #GPIO_PDOR_OFFSET] // Cargar el valor del registro de salida en r1
    
    mov     r0, #1              // Cargar 1 en r0 (corresponde al bit 7) 
    lsl     r0, #GPIOB1_OFFSET // Desplazar a la posición correspondiente a GPIOB1 (Pin 1 del registro B)
    bic     r5, r1, r0        // Limpiar el bit correspondiente (pone a 0)
    
    str     r5, [r10, #GPIO_PDOR_OFFSET] // Escribir el nuevo valor de r5 al registro de salida

    bx lr // Retorna de la subrutina a la dirección almacenada en el registro lr.


.section .rodata

      .align 2  
                  
// Lista de direcciones de los estados

dir_tabla_estados: // guarda estos datos en una lista: la direccion se pone automaticamente
  .long ESTADO1     
  .long ESTADO2         
  .long ESTADO3   
  .long ESTADO4   
  .long ESTADO5
  .long ESTADO6
  .long ESTADO7
  .long ESTADO8       
 