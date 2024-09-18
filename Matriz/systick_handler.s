  .syntax unified
  .global SysTick_Handler
  .text

  .equ Base_maquina_0, 0x20001000      // Dirección base compartida
  .equ entrada_tiempo_M0, 4            // Offset para la entrada de tiempo transcurrido
  .thumb_func

SysTick_Handler:
    push {r4}                         //lleva al stack 
    ldr r4, =Base_maquina_0
    ldr r0, [r4, #entrada_tiempo_M0]  // Leer la variable de tiempo transcurrido
    add r0, r0, #1                    // Incrementar en 1 (1 ms ha transcurrido)
    str r0, [r4, #entrada_tiempo_M0]  // Guardar el valor actualizado
    pop {r4}                          // recupera del stack: esto se hace porque al correr el programa presentaba un error en r4 al hacer operaciones
    bx lr                             // Retornar de la interrupción