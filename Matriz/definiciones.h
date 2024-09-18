.text

//************************************************************* DECLARACIONES DEL SYSTICK *************************************************************

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

.thumb_func

// TIEMPO
.equ TIEMPO, 1     //Tiempo Límite de persepcion del hombre



// BASE LOGO
.equ base_logo, 0x20000000 //Declaro la dirección inicial de memoria para guardar la tabla

//CEROS
.equ CEROS, 0b00000000000000000 //Bits en cero para las columnas

//************************************************************* DECLARACIONES DE GPIO *************************************************************
//Direcciones de registro GPIO
.equ    GPIOB_BASE, 0x400FF040 //Declaro el gpio del puerto B
.equ    GPIOC_BASE, 0x400FF080 //Declaro el gpio del puerto C

.equ    GPIOC8_OFFSET, 8
.equ    GPIOC9_OFFSET, 9
.equ    GPIOC10_OFFSET, 10
.equ    GPIOC11_OFFSET, 11
.equ    GPIOC12_OFFSET, 12
.equ    GPIOC13_OFFSET, 13
.equ    GPIOC14_OFFSET, 14
.equ    GPIOC15_OFFSET, 15

.equ    GPIOC, 0b11111111111111111 //Pongo todos los pines en 1 por pereza jajaja

.equ    GPIOB10_OFFSET, 10
.equ    GPIOB11_OFFSET, 11
.equ    GPIOB12_OFFSET, 12
.equ    GPIOB13_OFFSET, 13
.equ    GPIOB14_OFFSET, 14
.equ    GPIOB15_OFFSET, 15
.equ    GPIOB16_OFFSET, 16
.equ    GPIOB1_OFFSET, 1
//.equ    GPIOB17_OFFSET, 17 // Recordar al profesor que este pin esta quemado :v

.equ    GPIOB, 0b11111111111111111 //Pongo todos los pines en 1 tambien por pereza jajaja

//Comandos del gpio para activar y desactivar las filas y las columnas de la matriz
.equ    GPIO_DDR_OFFSET, 0x14
.equ    GPIO_PDOR_OFFSET, 0x0
.equ    GPIO_PDIR_OFFSET, 0x10

//************************************************************* DECLARACIONES DE PUERTOS *************************************************************
//Definicion de los registro y los valores 
.equ    PCC_BASE, 0x40065000 //Puerto base 
.equ    PCC_PORTC_OFFSET, 0x12C //Declaro la salida del puerto C
.equ    PCC_PORTB_OFFSET, 0x128 //Declaro la salida del puerto B
.equ    PCC_CGC_BIT, 30


.equ    PORTC_BASE, 0x4004B000 //Declaro la base del puerto C
.equ    PORTB_BASE, 0x4004A000 //Declaro la base del puerto B
.equ    PORT_PCR_MUX_BITS, 0x8

// Columnas -> 1
.equ    PORTC_PCC8_OFFSET,  0x20 //1 SV21
.equ    PORTC_PCC9_OFFSET,  0x24 //2 SV21
.equ    PORTC_PCC10_OFFSET, 0x28 //3 SV19
.equ    PORTC_PCC11_OFFSET, 0x2C //4 SV19
.equ    PORTC_PCC12_OFFSET, 0x30 //5 SV19
.equ    PORTC_PCC13_OFFSET, 0x34 //6 SV19
.equ    PORTC_PCC14_OFFSET, 0x38 //7 SV19
.equ    PORTC_PCC15_OFFSET, 0x3C //8 SV19

// Filas -> 0
.equ    PORTB_PCB10_OFFSET, 0x28 //1 SV23
.equ    PORTB_PCB11_OFFSET, 0x2C //2 SV23
.equ    PORTB_PCB12_OFFSET, 0x30 //3 SV21
.equ    PORTB_PCB13_OFFSET, 0x34 //4 SV21
.equ    PORTB_PCB14_OFFSET, 0x38 //5 SV21
.equ    PORTB_PCB15_OFFSET, 0x3C //6 SV21
.equ    PORTB_PCB16_OFFSET, 0x40 //7 SV21
.equ    PORTB_PCB1_OFFSET, 0x04 //8 SV20
//.equ    PORTB_PCB17_OFFSET, 0x44 //8 SV21

//*************************************** ESTADOS **************************************************
// DEFINICION ESTADOS
    .equ est1, 0
    .equ est2, 1
    .equ est3, 2
    .equ est4, 3
    .equ est5, 4
    .equ est6, 5
    .equ est7, 6
    .equ est8, 7
 
