.text

    // Direcciones de los registros SysTick
    .equ SYSTICK_BASE, 0xE000E010        // Base del SysTick
    .equ SYST_CSR, (SYSTICK_BASE + 0x0)  // SysTick Control and Status Register
    .equ SYST_RVR, (SYSTICK_BASE + 0x4)  // SysTick Reload Value Register
    .equ SYST_CVR, (SYSTICK_BASE + 0x8)  // SysTick Current Value Register
 
    .equ SYSTICK_ENABLE, 0x1             // Bit para habilitar el SysTick
    .equ SYSTICK_TICKINT, 0x2            // Bit para habilitar la interrupción del SysTick
    .equ SYSTICK_CLKSOURCE, 0x4          // Bit para seleccionar el reloj del procesador
 
    .equ SYSTICK_RELOAD_1MS, 48000-1     // Valor para recargar el SysTick cada 1 ms (suponiendo un reloj de 48 MHz)
 
    .equ Base_maquina_0, 0x20001000      // Dirección base compartida
    .equ var_estado_M0, 0                // Offset para la variable de estado
    .equ entrada_tiempo_M0, 4            // Offset para la entrada de tiempo transcurrido
 
    // Direcciones de los registros GPIO (Ejemplo para Kinetis K64)
    .equ GPIOB_PDDR, 0x400FF054          // Registro de dirección de datos del puerto B
    .equ GPIOB_PDOR, 0x400FF040          // Registro de salida de datos del puerto B
    .equ GPIOB_PTOR, 0x400FF04C          // Registro de alternancia de datos del puerto B
    .equ GPIOB_PSOR, 0x400FF044          // Registro de establecer bits de salida en puerto B
    .equ GPIOB_PCOR, 0x400FF048          // Registro de limpiar bits de salida en puerto B
 
    // Definición de los registros y valores
    .equ PCC_BASE, 0x40065000              // Base del PCC (Peripheral Clock Control)
    .equ PCC_PORTB, (PCC_BASE + 0x128)      // Offset para el PCC del puerto B
    .equ PORTB_BASE, 0x4004A000            // Base del PORTB
    .equ PORTB_PCR12, (PORTB_BASE + 0x30)  // PCR para PTB12
    .equ PORTB_PCR13, (PORTB_BASE + 0x34)  // PCR para PTB13
    .equ PORTB_PCR14, (PORTB_BASE + 0x38)  // PCR para PTB14
    .equ MUX_GPIO, 0x1                     // Configuración Mux para GPIO (Alternativa 1)
    .equ PCC_PORTB_CGC, (1 << 30)          // Bit para habilitar el reloj del puerto B
 
    // Bits correspondientes a los LEDs
    .equ LED_ROJO, 12                    // LED Rojo conectado a PTB12
    .equ LED_AMARILLO, 13                // LED Amarillo conectado a PTB13
    .equ LED_VERDE, 14                   // LED Verde conectado a PTB14
 
    // Bits correspondientes a los LEDs
    .equ LED_ROJO, 12                    // LED Rojo conectado a PTB12
    .equ LED_AMARILLO, 13                // LED Amarillo conectado a PTB13
    .equ LED_VERDE, 14                   // LED Verde conectado a PTB14
 
    // Definición de los tiempos en ciclos de reloj (ajustar según la frecuencia del microcontrolador)
    .equ TIEMPO_ROJO, 5000               
    .equ TIEMPO_ROJO_AMARILLO, 3000      
    .equ TIEMPO_VERDE, 5000              
    .equ TIEMPO_AMARILLO, 2000           
 
    // Definición de los estados
    .equ ROJO, 0
    .equ ROJO_AMARILLO, 1
    .equ VERDE, 2
    .equ AMARILLO, 3
