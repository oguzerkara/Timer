.org 0x0000
jmp start
.org 0x001C
jmp ISRTim
start:
ldi R16, high(RAMEND)
out SPH, R16
ldi R16, low(RAMEND)
out SPL, R16
ldi R16, 0xFF
out DDRA, R16
out DDRB, R16
cli ; stop interrupts
ldi R16, 0x00
out TCCR1A, R16; set entire TCCR1A register to 0
ldi R16, (1<<CS10) | (1<<CS12);; // Timer mode with 1024 prescler
out TCCR1B, R16; same for TCCR1B
ldi R16, 0xF9 // for 1 sec at 16 MHz
out TCNT1H, R16; initialize counter value to 0
ldi R16, 0xE6
out TCNT1L, R16
; enable timer compare interrupt
ldi R16, (1 << TOIE1)
out TIMSK, R16
ldi R24, 0x00
ldi R25, 0x00
sei ;allow interrupts
; set compare match register for 1.0000128001638422 Hz increments
; = 10M/(8) *1s = #ofcounts = 1.25M => 1.25M/2^16 =19.0734 & 2^16*.0734=4800 => 19 overflow + 4800 clock cycle
; turn on normal mode : TCNT1 is default 0x0000
; Set CS12, CS11 and CS10 bits for 8 prescaler
;ldi R16, (1 << CS12)
;out TCCR1B, R16
HERE:
out PORTA,R24
out PORTB,R25
jmp HERE
ISRTim:
adiw R25:R24,1 ;incriment the clock counter for timing
ldi R16, 0xF9 // for 1 sec at 16 MHz
out TCNT1H, R16; initialize counter value to 0
ldi R16, 0xE6
out TCNT1L, R16
reti
