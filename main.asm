;
; lab1.asm.asm
;
; Created: 9/3/2024 9:55:51 PM
; Author : Juan Postiglione
;


; Replace with your application code

; Including definition files
.include "ATxmega128A1Udef.inc"

; Define NULL value
.equ NULL = 0x00

; Define number 77
.equ number77 = 77

; Define number 95
.equ number95 = 95

; Define number 2
.equ number2 = 2

; Define number 8
.equ number8 = 8
 
; program memory constants
.cseg
.org 0xF086

; Create Input table
IN_TABLE:
.db 37, 127, 'æ', 0xE4, '?', 0b11100100, 'j', 0b11000110, 224, 0x37, 38, 0b01111101, 'Ú', 202
.db NULL
; Calculate the end of the table
IN_TABLE_END:

; Data memory constant
.dseg
.org 0x2783
; Create Output table
OUT_TABLE: .byte(IN_TABLE_END - IN_TABLE)

.cseg

.org 0
	rjmp MAIN

.org 0x100

MAIN:
; Pointer to the Input table in program memory (Using RAMP)
 
ldi ZL, byte3(IN_TABLE << 1)
out CPU_RAMPZ, ZL
ldi ZH, byte2(IN_TABLE << 1)
ldi ZL, byte1(IN_TABLE << 1)

; Pointer to the output table in data memory
ldi YL, low(OUT_TABLE)
ldi YH, high(OUT_TABLE)

; Load register 17 with NULL value
ldi r17, NULL

; Load register 18 with number 77
ldi r18, number77

; Load register 19 with number 95
ldi r19, number95

; Load register 20 with number 2
ldi r20, number2

; Load to register 21 with number 8
ldi r21, number8

; Create a loop to read from program memory (Input Table)
LOOP:
elpm r16, Z+

; Compare if both registers to see if they are equal
cp r16, r17

; Branch to DONE Label if they are equal to NULL
breq DONE

; Check if bit 6 of register 16 is set 
bst r16, 6
brts tset ; Branch if bit 6 is set
brtc tclear ; Branch if bit 6 is cleared


; Branch if bit 6 is set, then divide by 2
tset:
lsr r16

; Compare bothe registers to see if they are greater than 95
cp r16, r19
brsh greater95 ; Branch if register 16 is greater than 95
brne LOOP ; Branch to store value if is not greater than 95

; Branch if r16 is greater than 95, then add 2
greater95:
add r16, r20
brne store ; Branch to store value 

; Branch if bit 6 is clear, then multiply by 2
tclear:
lsl r16

; Compare both register to see if register 16 is less than 77
cp r16, r18
brlo less77 ; Branch if r16 is less than 77
brsh LOOP ; Branch to store value if r16 is not less than 77

; Branch if r16 us less than 77, then subtract 8
less77:
sub r16, r21
brne store ; Branch to store value

; If not equal to NULL, continue with the program...
; Store r16 value to the pointer location in data memory (Output table)

store: ;Branch to store value
st Y+, r16 

; Branch to LOOP if both register are not equal to NULL
brne LOOP

; END program LOOP
DONE:
	rjmp DONE



