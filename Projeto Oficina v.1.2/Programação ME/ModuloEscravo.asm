
_main:

;ModuloEscravo.c,29 :: 		void main() {
;ModuloEscravo.c,30 :: 		UART1_init(9600);
	MOVLW       25
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;ModuloEscravo.c,31 :: 		Delay_ms(100);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	NOP
	NOP
;ModuloEscravo.c,34 :: 		TRISD =0;
	CLRF        TRISD+0 
;ModuloEscravo.c,35 :: 		PORTD.RD0 = 1;
	BSF         PORTD+0, 0 
;ModuloEscravo.c,36 :: 		PORTD.RD1 = 1;
	BSF         PORTD+0, 1 
;ModuloEscravo.c,37 :: 		PORTD.RD2 = 1;
	BSF         PORTD+0, 2 
;ModuloEscravo.c,38 :: 		PORTD.RD3 = 1;
	BSF         PORTD+0, 3 
;ModuloEscravo.c,39 :: 		PORTD.RD4 = 1;
	BSF         PORTD+0, 4 
;ModuloEscravo.c,40 :: 		PORTD.RD5 = 1;
	BSF         PORTD+0, 5 
;ModuloEscravo.c,41 :: 		PORTD.RD6 = 1;
	BSF         PORTD+0, 6 
;ModuloEscravo.c,42 :: 		PORTD.RD7 = 1;
	BSF         PORTD+0, 7 
;ModuloEscravo.c,45 :: 		TRISC.RC1 = 0;
	BCF         TRISC+0, 1 
;ModuloEscravo.c,48 :: 		TRISE.RE0 =0;
	BCF         TRISE+0, 0 
;ModuloEscravo.c,49 :: 		PORTE.RE0 =0;
	BCF         PORTE+0, 0 
;ModuloEscravo.c,50 :: 		ADCON1 = 0b00001100; //define A0,A1 e A2 como saídas analógicas para os sensores
	MOVLW       12
	MOVWF       ADCON1+0 
;ModuloEscravo.c,51 :: 		TRISA.RA0 =1;
	BSF         TRISA+0, 0 
;ModuloEscravo.c,52 :: 		TRISA.RA1 =1;
	BSF         TRISA+0, 1 
;ModuloEscravo.c,53 :: 		TRISA.RA2 =1;
	BSF         TRISA+0, 2 
;ModuloEscravo.c,56 :: 		RCON.IPEN = 1;
	BSF         RCON+0, 7 
;ModuloEscravo.c,57 :: 		INTCON.GIEH = 1;
	BSF         INTCON+0, 7 
;ModuloEscravo.c,58 :: 		INTCON.GIEL = 1;
	BSF         INTCON+0, 6 
;ModuloEscravo.c,61 :: 		T0CON = 0b10000111;
	MOVLW       135
	MOVWF       T0CON+0 
;ModuloEscravo.c,62 :: 		INTCON.TMR0IF = 0; // zera o flag de estouro do timer0
	BCF         INTCON+0, 2 
;ModuloEscravo.c,63 :: 		INTCON.TMR0IE = 0; //desabilita a interrupção
	BCF         INTCON+0, 5 
;ModuloEscravo.c,64 :: 		INTCON2.TMR0IP =1; // alta prioridade
	BSF         INTCON2+0, 2 
;ModuloEscravo.c,66 :: 		TMR0H =0x1B;
	MOVLW       27
	MOVWF       TMR0H+0 
;ModuloEscravo.c,67 :: 		TMR0L =0x1E;
	MOVLW       30
	MOVWF       TMR0L+0 
;ModuloEscravo.c,70 :: 		IPR1.RCIP = 0;//baixa prioridade
	BCF         IPR1+0, 5 
;ModuloEscravo.c,71 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;ModuloEscravo.c,72 :: 		PIE1.RCIE = 1; //Enable da interrupção Serial RX
	BSF         PIE1+0, 5 
;ModuloEscravo.c,79 :: 		T2CON=0b00000111;
	MOVLW       7
	MOVWF       T2CON+0 
;ModuloEscravo.c,80 :: 		PR2=31; //30.25=~31
	MOVLW       31
	MOVWF       PR2+0 
;ModuloEscravo.c,112 :: 		CCPR2l = 0b11111111;
	MOVLW       255
	MOVWF       CCPR2L+0 
;ModuloEscravo.c,113 :: 		CCP2CON = 0b00111100;
	MOVLW       60
	MOVWF       CCP2CON+0 
;ModuloEscravo.c,115 :: 		while(1) {
L_main1:
;ModuloEscravo.c,116 :: 		gerencia_alarme();
	CALL        _gerencia_alarme+0, 0
;ModuloEscravo.c,117 :: 		iluminacao_automatizada();
	CALL        _iluminacao_automatizada+0, 0
;ModuloEscravo.c,118 :: 		}
	GOTO        L_main1
;ModuloEscravo.c,119 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt_low:
	MOVWF       ___Low_saveWREG+0 
	MOVF        STATUS+0, 0 
	MOVWF       ___Low_saveSTATUS+0 
	MOVF        BSR+0, 0 
	MOVWF       ___Low_saveBSR+0 

;ModuloEscravo.c,121 :: 		void interrupt_low() {
;ModuloEscravo.c,122 :: 		if(PIR1.RCIF == 1) { // indica que a interrupção foi disparada pela Serial RX
	BTFSS       PIR1+0, 5 
	GOTO        L_interrupt_low3
;ModuloEscravo.c,123 :: 		PIR1.RCIF = 0; // limpa flag que gerou a interrupção
	BCF         PIR1+0, 5 
;ModuloEscravo.c,124 :: 		lerProtocolo();
	CALL        _lerProtocolo+0, 0
;ModuloEscravo.c,125 :: 		}
L_interrupt_low3:
;ModuloEscravo.c,126 :: 		}
L_end_interrupt_low:
L__interrupt_low149:
	MOVF        ___Low_saveBSR+0, 0 
	MOVWF       BSR+0 
	MOVF        ___Low_saveSTATUS+0, 0 
	MOVWF       STATUS+0 
	SWAPF       ___Low_saveWREG+0, 1 
	SWAPF       ___Low_saveWREG+0, 0 
	RETFIE      0
; end of _interrupt_low

_interrupt:

;ModuloEscravo.c,127 :: 		void interrupt(){
;ModuloEscravo.c,128 :: 		if(INTCON.TMR0IF==1){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt4
;ModuloEscravo.c,129 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;ModuloEscravo.c,130 :: 		if(cont !=4){
	MOVLW       0
	XORWF       _cont+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt152
	MOVLW       4
	XORWF       _cont+0, 0 
L__interrupt152:
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt5
;ModuloEscravo.c,131 :: 		cont++;
	INFSNZ      _cont+0, 1 
	INCF        _cont+1, 1 
;ModuloEscravo.c,132 :: 		}
	GOTO        L_interrupt6
L_interrupt5:
;ModuloEscravo.c,133 :: 		else if(cont == 4){
	MOVLW       0
	XORWF       _cont+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt153
	MOVLW       4
	XORWF       _cont+0, 0 
L__interrupt153:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt7
;ModuloEscravo.c,134 :: 		cont =0;
	CLRF        _cont+0 
	CLRF        _cont+1 
;ModuloEscravo.c,135 :: 		off=1;
	MOVLW       1
	MOVWF       _off+0 
	MOVLW       0
	MOVWF       _off+1 
;ModuloEscravo.c,136 :: 		}
L_interrupt7:
L_interrupt6:
;ModuloEscravo.c,138 :: 		TMR0H =0x1B;
	MOVLW       27
	MOVWF       TMR0H+0 
;ModuloEscravo.c,139 :: 		TMR0L =0x1E;
	MOVLW       30
	MOVWF       TMR0L+0 
;ModuloEscravo.c,140 :: 		}
L_interrupt4:
;ModuloEscravo.c,141 :: 		}
L_end_interrupt:
L__interrupt151:
	RETFIE      1
; end of _interrupt

_lerProtocolo:

;ModuloEscravo.c,143 :: 		void lerProtocolo(void) {
;ModuloEscravo.c,145 :: 		if(UART1_Data_Ready()) {
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_lerProtocolo8
;ModuloEscravo.c,147 :: 		lido = UART1_Read(); // lê o byte de inicio do protocolo
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _lido+0 
;ModuloEscravo.c,149 :: 		if(flagExecutar == 1) {
	MOVLW       0
	XORWF       _flagExecutar+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__lerProtocolo155
	MOVLW       1
	XORWF       _flagExecutar+0, 0 
L__lerProtocolo155:
	BTFSS       STATUS+0, 2 
	GOTO        L_lerProtocolo9
;ModuloEscravo.c,150 :: 		if(lido == '(') { // se for '(' indica que o protocolo de execução
	MOVF        _lido+0, 0 
	XORLW       40
	BTFSS       STATUS+0, 2 
	GOTO        L_lerProtocolo10
;ModuloEscravo.c,151 :: 		UART1_Read_Text(EX, ")", 4);
	MOVLW       _EX+0
	MOVWF       FARG_UART1_Read_Text_Output+0 
	MOVLW       hi_addr(_EX+0)
	MOVWF       FARG_UART1_Read_Text_Output+1 
	MOVLW       ?lstr1_ModuloEscravo+0
	MOVWF       FARG_UART1_Read_Text_Delimiter+0 
	MOVLW       hi_addr(?lstr1_ModuloEscravo+0)
	MOVWF       FARG_UART1_Read_Text_Delimiter+1 
	MOVLW       4
	MOVWF       FARG_UART1_Read_Text_Attempts+0 
	CALL        _UART1_Read_Text+0, 0
;ModuloEscravo.c,152 :: 		executarProtocolo();
	CALL        _executarProtocolo+0, 0
;ModuloEscravo.c,153 :: 		}
L_lerProtocolo10:
;ModuloEscravo.c,154 :: 		flagExecutar = 0;
	CLRF        _flagExecutar+0 
	CLRF        _flagExecutar+1 
;ModuloEscravo.c,155 :: 		}
	GOTO        L_lerProtocolo11
L_lerProtocolo9:
;ModuloEscravo.c,156 :: 		else if(lido == '[') { // se for '[' indica que o protocolo eh de identificação do módulo
	MOVF        _lido+0, 0 
	XORLW       91
	BTFSS       STATUS+0, 2 
	GOTO        L_lerProtocolo12
;ModuloEscravo.c,157 :: 		UART1_Read_Text(ID, "]", 4);
	MOVLW       _ID+0
	MOVWF       FARG_UART1_Read_Text_Output+0 
	MOVLW       hi_addr(_ID+0)
	MOVWF       FARG_UART1_Read_Text_Output+1 
	MOVLW       ?lstr2_ModuloEscravo+0
	MOVWF       FARG_UART1_Read_Text_Delimiter+0 
	MOVLW       hi_addr(?lstr2_ModuloEscravo+0)
	MOVWF       FARG_UART1_Read_Text_Delimiter+1 
	MOVLW       4
	MOVWF       FARG_UART1_Read_Text_Attempts+0 
	CALL        _UART1_Read_Text+0, 0
;ModuloEscravo.c,158 :: 		executarProtocolo();
	CALL        _executarProtocolo+0, 0
;ModuloEscravo.c,159 :: 		flagExecutar = 1;
	MOVLW       1
	MOVWF       _flagExecutar+0 
	MOVLW       0
	MOVWF       _flagExecutar+1 
;ModuloEscravo.c,160 :: 		}
L_lerProtocolo12:
L_lerProtocolo11:
;ModuloEscravo.c,161 :: 		}
L_lerProtocolo8:
;ModuloEscravo.c,162 :: 		}
L_end_lerProtocolo:
	RETURN      0
; end of _lerProtocolo

_executarProtocolo:

;ModuloEscravo.c,164 :: 		void executarProtocolo(void) {
;ModuloEscravo.c,167 :: 		if(ID[0] == 'M') { //O ID deste módulo é M01
	MOVF        _ID+0, 0 
	XORLW       77
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo13
;ModuloEscravo.c,168 :: 		if(ID[1] == '0') {
	MOVF        _ID+1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo14
;ModuloEscravo.c,169 :: 		if(ID[2] == '1') {
	MOVF        _ID+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo15
;ModuloEscravo.c,171 :: 		ID[0] = '0' ;
	MOVLW       48
	MOVWF       _ID+0 
;ModuloEscravo.c,172 :: 		respondeProtocolo('+', 'M', '0', '1', '+');
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       77
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       48
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       49
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	CALL        _respondeProtocolo+0, 0
;ModuloEscravo.c,173 :: 		}
L_executarProtocolo15:
;ModuloEscravo.c,174 :: 		}
L_executarProtocolo14:
;ModuloEscravo.c,175 :: 		}
	GOTO        L_executarProtocolo16
L_executarProtocolo13:
;ModuloEscravo.c,177 :: 		else if(EX[0] == 'I') { //O EX começa com I no protocolo de iluminação
	MOVF        _EX+0, 0 
	XORLW       73
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo17
;ModuloEscravo.c,179 :: 		if(EX[1] == 'A') { // LED A
	MOVF        _EX+1, 0 
	XORLW       65
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo18
;ModuloEscravo.c,180 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,181 :: 		if(EX[2] == '1')
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo19
;ModuloEscravo.c,182 :: 		PORTD.RD0 = 0;
	BCF         PORTD+0, 0 
	GOTO        L_executarProtocolo20
L_executarProtocolo19:
;ModuloEscravo.c,183 :: 		else if(EX[2] == '0')
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo21
;ModuloEscravo.c,184 :: 		PORTD.RD0 = 1;
	BSF         PORTD+0, 0 
L_executarProtocolo21:
L_executarProtocolo20:
;ModuloEscravo.c,185 :: 		}
L_executarProtocolo18:
;ModuloEscravo.c,187 :: 		if(EX[1] == 'B') { // LED B
	MOVF        _EX+1, 0 
	XORLW       66
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo22
;ModuloEscravo.c,188 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,189 :: 		if(EX[2] == '1')
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo23
;ModuloEscravo.c,190 :: 		PORTD.RD1 = 0;
	BCF         PORTD+0, 1 
	GOTO        L_executarProtocolo24
L_executarProtocolo23:
;ModuloEscravo.c,191 :: 		else if(EX[2] == '0')
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo25
;ModuloEscravo.c,192 :: 		PORTD.RD1 = 1;
	BSF         PORTD+0, 1 
L_executarProtocolo25:
L_executarProtocolo24:
;ModuloEscravo.c,193 :: 		}
L_executarProtocolo22:
;ModuloEscravo.c,195 :: 		if(EX[1] == 'C') { // LED C
	MOVF        _EX+1, 0 
	XORLW       67
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo26
;ModuloEscravo.c,196 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,197 :: 		if(EX[2] == '1')
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo27
;ModuloEscravo.c,198 :: 		PORTD.RD2 = 0;
	BCF         PORTD+0, 2 
	GOTO        L_executarProtocolo28
L_executarProtocolo27:
;ModuloEscravo.c,199 :: 		else if(EX[2] == '0')
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo29
;ModuloEscravo.c,200 :: 		PORTD.RD2 = 1;
	BSF         PORTD+0, 2 
L_executarProtocolo29:
L_executarProtocolo28:
;ModuloEscravo.c,201 :: 		}
L_executarProtocolo26:
;ModuloEscravo.c,203 :: 		if(EX[1] == 'D') { // LED D
	MOVF        _EX+1, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo30
;ModuloEscravo.c,204 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,205 :: 		if(EX[2] == '1')
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo31
;ModuloEscravo.c,206 :: 		PORTD.RD3 = 0;
	BCF         PORTD+0, 3 
	GOTO        L_executarProtocolo32
L_executarProtocolo31:
;ModuloEscravo.c,207 :: 		else if(EX[2] == '0')
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo33
;ModuloEscravo.c,208 :: 		PORTD.RD3 = 1;
	BSF         PORTD+0, 3 
L_executarProtocolo33:
L_executarProtocolo32:
;ModuloEscravo.c,209 :: 		}
L_executarProtocolo30:
;ModuloEscravo.c,211 :: 		if(EX[1] == 'E') { // LED E
	MOVF        _EX+1, 0 
	XORLW       69
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo34
;ModuloEscravo.c,212 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,213 :: 		if(EX[2] == '1')
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo35
;ModuloEscravo.c,214 :: 		PORTD.RD4 = 0;
	BCF         PORTD+0, 4 
	GOTO        L_executarProtocolo36
L_executarProtocolo35:
;ModuloEscravo.c,215 :: 		else if(EX[2] == '0')
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo37
;ModuloEscravo.c,216 :: 		PORTD.RD4 = 1;
	BSF         PORTD+0, 4 
L_executarProtocolo37:
L_executarProtocolo36:
;ModuloEscravo.c,217 :: 		}
L_executarProtocolo34:
;ModuloEscravo.c,219 :: 		if(EX[1] == 'F') { // Todos LEDs
	MOVF        _EX+1, 0 
	XORLW       70
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo38
;ModuloEscravo.c,220 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,221 :: 		if(EX[2] == '1') {
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo39
;ModuloEscravo.c,222 :: 		PORTD.RD0 = 0; //liga todos os LEDS
	BCF         PORTD+0, 0 
;ModuloEscravo.c,223 :: 		PORTD.RD1 = 0;
	BCF         PORTD+0, 1 
;ModuloEscravo.c,224 :: 		PORTD.RD2 = 0;
	BCF         PORTD+0, 2 
;ModuloEscravo.c,225 :: 		PORTD.RD3 = 0;
	BCF         PORTD+0, 3 
;ModuloEscravo.c,226 :: 		PORTD.RD4 = 0;
	BCF         PORTD+0, 4 
;ModuloEscravo.c,227 :: 		}
	GOTO        L_executarProtocolo40
L_executarProtocolo39:
;ModuloEscravo.c,228 :: 		else if(EX[2] == '0'){
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo41
;ModuloEscravo.c,229 :: 		PORTD.RD0 = 1; //desliga todos os LEDS
	BSF         PORTD+0, 0 
;ModuloEscravo.c,230 :: 		PORTD.RD1 = 1;
	BSF         PORTD+0, 1 
;ModuloEscravo.c,231 :: 		PORTD.RD2 = 1;
	BSF         PORTD+0, 2 
;ModuloEscravo.c,232 :: 		PORTD.RD3 = 1;
	BSF         PORTD+0, 3 
;ModuloEscravo.c,233 :: 		PORTD.RD4 = 1;
	BSF         PORTD+0, 4 
;ModuloEscravo.c,234 :: 		}
L_executarProtocolo41:
L_executarProtocolo40:
;ModuloEscravo.c,235 :: 		}
L_executarProtocolo38:
;ModuloEscravo.c,237 :: 		EX[0] = '0';
	MOVLW       48
	MOVWF       _EX+0 
;ModuloEscravo.c,239 :: 		respondeProtocolo( '+', 'T', 'E', 'P', '+');
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       84
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       69
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       80
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	CALL        _respondeProtocolo+0, 0
;ModuloEscravo.c,240 :: 		}
	GOTO        L_executarProtocolo42
L_executarProtocolo17:
;ModuloEscravo.c,242 :: 		else if(EX[0] == 'P') { // O EX começa com P no protocolo do portão
	MOVF        _EX+0, 0 
	XORLW       80
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo43
;ModuloEscravo.c,243 :: 		if(EX[1] == 'G'){
	MOVF        _EX+1, 0 
	XORLW       71
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo44
;ModuloEscravo.c,244 :: 		if(EX[2] == '0')
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo45
;ModuloEscravo.c,245 :: 		servoRotate90();
	CALL        _servoRotate90+0, 0
	GOTO        L_executarProtocolo46
L_executarProtocolo45:
;ModuloEscravo.c,246 :: 		else if (EX[2] == '1')
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo47
;ModuloEscravo.c,247 :: 		servoRotate0();
	CALL        _servoRotate0+0, 0
L_executarProtocolo47:
L_executarProtocolo46:
;ModuloEscravo.c,248 :: 		}
L_executarProtocolo44:
;ModuloEscravo.c,250 :: 		EX[0] = '0';
	MOVLW       48
	MOVWF       _EX+0 
;ModuloEscravo.c,252 :: 		respondeProtocolo( '+', 'T', 'E', 'P', '+');
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       84
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       69
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       80
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	CALL        _respondeProtocolo+0, 0
;ModuloEscravo.c,253 :: 		}
	GOTO        L_executarProtocolo48
L_executarProtocolo43:
;ModuloEscravo.c,255 :: 		else if(EX[0] == 'D') { // O EX começa com D no protocolo de dimerização
	MOVF        _EX+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo49
;ModuloEscravo.c,256 :: 		if(EX[1] == 'H') {
	MOVF        _EX+1, 0 
	XORLW       72
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo50
;ModuloEscravo.c,257 :: 		if(EX[2] == '4') { // Ligado 100%
	MOVF        _EX+2, 0 
	XORLW       52
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo51
;ModuloEscravo.c,258 :: 		CCPR2l = 0b00000000;
	CLRF        CCPR2L+0 
;ModuloEscravo.c,259 :: 		CCP2CON = 0b00001100;
	MOVLW       12
	MOVWF       CCP2CON+0 
;ModuloEscravo.c,260 :: 		}
	GOTO        L_executarProtocolo52
L_executarProtocolo51:
;ModuloEscravo.c,261 :: 		else if(EX[2] == '3') { // Ligado 75%
	MOVF        _EX+2, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo53
;ModuloEscravo.c,262 :: 		CCPR2l = 0b00001000;
	MOVLW       8
	MOVWF       CCPR2L+0 
;ModuloEscravo.c,263 :: 		CCP2CON = 0b00001100;
	MOVLW       12
	MOVWF       CCP2CON+0 
;ModuloEscravo.c,264 :: 		}
	GOTO        L_executarProtocolo54
L_executarProtocolo53:
;ModuloEscravo.c,265 :: 		else if(EX[2] == '2') { // Ligado 50%
	MOVF        _EX+2, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo55
;ModuloEscravo.c,266 :: 		CCPR2l = 0b00001111;
	MOVLW       15
	MOVWF       CCPR2L+0 
;ModuloEscravo.c,267 :: 		CCP2CON = 0b00111100;
	MOVLW       60
	MOVWF       CCP2CON+0 
;ModuloEscravo.c,268 :: 		}
	GOTO        L_executarProtocolo56
L_executarProtocolo55:
;ModuloEscravo.c,269 :: 		else if(EX[2] == '1') { // Ligado 25%
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo57
;ModuloEscravo.c,270 :: 		CCPR2l = 0b00010111;
	MOVLW       23
	MOVWF       CCPR2L+0 
;ModuloEscravo.c,271 :: 		CCP2CON = 0b00101100;
	MOVLW       44
	MOVWF       CCP2CON+0 
;ModuloEscravo.c,272 :: 		}
	GOTO        L_executarProtocolo58
L_executarProtocolo57:
;ModuloEscravo.c,273 :: 		else if(EX[2] == '0') { // Desligado
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo59
;ModuloEscravo.c,274 :: 		CCPR2l = 0b11111111;
	MOVLW       255
	MOVWF       CCPR2L+0 
;ModuloEscravo.c,275 :: 		CCP2CON = 0b00111100;
	MOVLW       60
	MOVWF       CCP2CON+0 
;ModuloEscravo.c,276 :: 		}
L_executarProtocolo59:
L_executarProtocolo58:
L_executarProtocolo56:
L_executarProtocolo54:
L_executarProtocolo52:
;ModuloEscravo.c,277 :: 		}
L_executarProtocolo50:
;ModuloEscravo.c,279 :: 		EX[0] = '0';
	MOVLW       48
	MOVWF       _EX+0 
;ModuloEscravo.c,281 :: 		respondeProtocolo( '+', 'T', 'E', 'P', '+');
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       84
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       69
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       80
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	CALL        _respondeProtocolo+0, 0
;ModuloEscravo.c,282 :: 		}
	GOTO        L_executarProtocolo60
L_executarProtocolo49:
;ModuloEscravo.c,284 :: 		else if(EX[0] == 'A'){ // parte do protocolo responsável pelo funcionamento dos alarmes
	MOVF        _EX+0, 0 
	XORLW       65
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo61
;ModuloEscravo.c,285 :: 		if(EX[1] == 'I'){    // indica o alarme A que representa a Barreira infravermelho
	MOVF        _EX+1, 0 
	XORLW       73
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo62
;ModuloEscravo.c,286 :: 		if(EX[2] == '1'){  // ativa barreira infravermelho
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo63
;ModuloEscravo.c,287 :: 		cercaIR = 1;
	MOVLW       1
	MOVWF       _cercaIR+0 
	MOVLW       0
	MOVWF       _cercaIR+1 
;ModuloEscravo.c,288 :: 		}
	GOTO        L_executarProtocolo64
L_executarProtocolo63:
;ModuloEscravo.c,289 :: 		else if(EX[2] =='0'){ // desativa barreita intravermelho
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo65
;ModuloEscravo.c,290 :: 		cercaIR = 0;
	CLRF        _cercaIR+0 
	CLRF        _cercaIR+1 
;ModuloEscravo.c,291 :: 		}
L_executarProtocolo65:
L_executarProtocolo64:
;ModuloEscravo.c,292 :: 		}
L_executarProtocolo62:
;ModuloEscravo.c,294 :: 		EX[0] = '0';
	MOVLW       48
	MOVWF       _EX+0 
;ModuloEscravo.c,296 :: 		respondeProtocolo( '+', 'T', 'E', 'P', '+');
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       84
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       69
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       80
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	CALL        _respondeProtocolo+0, 0
;ModuloEscravo.c,297 :: 		}
	GOTO        L_executarProtocolo66
L_executarProtocolo61:
;ModuloEscravo.c,299 :: 		else if(EX[0] == 'C'){ // parte do protocolo responsável pela iluminação automatizada
	MOVF        _EX+0, 0 
	XORLW       67
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo67
;ModuloEscravo.c,301 :: 		if(EX[1] == '1'){    // indica que o acendimento automatizado da luz pelo LDR está ativo
	MOVF        _EX+1, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo68
;ModuloEscravo.c,302 :: 		estado = 1;
	MOVLW       1
	MOVWF       _estado+0 
	MOVLW       0
	MOVWF       _estado+1 
;ModuloEscravo.c,303 :: 		resp = EX[2];
	MOVF        _EX+2, 0 
	MOVWF       _resp+0 
;ModuloEscravo.c,304 :: 		}
	GOTO        L_executarProtocolo69
L_executarProtocolo68:
;ModuloEscravo.c,305 :: 		else if(EX[1] =='0'){ // indica que a iluminação automatizada está desattivada
	MOVF        _EX+1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo70
;ModuloEscravo.c,306 :: 		estado = 3;
	MOVLW       3
	MOVWF       _estado+0 
	MOVLW       0
	MOVWF       _estado+1 
;ModuloEscravo.c,307 :: 		resp = EX[2];
	MOVF        _EX+2, 0 
	MOVWF       _resp+0 
;ModuloEscravo.c,308 :: 		}
L_executarProtocolo70:
L_executarProtocolo69:
;ModuloEscravo.c,310 :: 		EX[0] = '0';
	MOVLW       48
	MOVWF       _EX+0 
;ModuloEscravo.c,312 :: 		respondeProtocolo( '+', 'T', 'E', 'P', '+');
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       84
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       69
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       80
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	CALL        _respondeProtocolo+0, 0
;ModuloEscravo.c,313 :: 		}
	GOTO        L_executarProtocolo71
L_executarProtocolo67:
;ModuloEscravo.c,315 :: 		else if(EX[0] =='H'){ //controle automatizado das lampadas ao abrir o portão
	MOVF        _EX+0, 0 
	XORLW       72
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo72
;ModuloEscravo.c,316 :: 		if (EX[1] == '0'){
	MOVF        _EX+1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo73
;ModuloEscravo.c,317 :: 		servoRotate90();
	CALL        _servoRotate90+0, 0
;ModuloEscravo.c,318 :: 		}
	GOTO        L_executarProtocolo74
L_executarProtocolo73:
;ModuloEscravo.c,319 :: 		else if(EX[1] == '1'){
	MOVF        _EX+1, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo75
;ModuloEscravo.c,320 :: 		servoRotate0();
	CALL        _servoRotate0+0, 0
;ModuloEscravo.c,321 :: 		}
L_executarProtocolo75:
L_executarProtocolo74:
;ModuloEscravo.c,323 :: 		EX[0] = 0;
	CLRF        _EX+0 
;ModuloEscravo.c,325 :: 		respondeProtocolo( '+', 'T', 'E', 'P', '+');
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       84
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       69
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       80
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	CALL        _respondeProtocolo+0, 0
;ModuloEscravo.c,326 :: 		}
L_executarProtocolo72:
L_executarProtocolo71:
L_executarProtocolo66:
L_executarProtocolo60:
L_executarProtocolo48:
L_executarProtocolo42:
L_executarProtocolo16:
;ModuloEscravo.c,327 :: 		}
L_end_executarProtocolo:
	RETURN      0
; end of _executarProtocolo

_respondeProtocolo:

;ModuloEscravo.c,329 :: 		void respondeProtocolo(char r1, char r2, char r3, char r4, char r5) {
;ModuloEscravo.c,350 :: 		UART1_Write(r1);
	MOVF        FARG_respondeProtocolo_r1+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloEscravo.c,351 :: 		UART1_Write(r2);
	MOVF        FARG_respondeProtocolo_r2+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloEscravo.c,352 :: 		UART1_Write(r3);
	MOVF        FARG_respondeProtocolo_r3+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloEscravo.c,353 :: 		UART1_Write(r4);
	MOVF        FARG_respondeProtocolo_r4+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloEscravo.c,354 :: 		UART1_Write(r5);
	MOVF        FARG_respondeProtocolo_r5+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloEscravo.c,357 :: 		}
L_end_respondeProtocolo:
	RETURN      0
; end of _respondeProtocolo

_servoRotate0:

;ModuloEscravo.c,359 :: 		void servoRotate0()
;ModuloEscravo.c,362 :: 		for(i=0;i<50;i++)
	CLRF        R1 
	CLRF        R2 
L_servoRotate076:
	MOVLW       0
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__servoRotate0159
	MOVLW       50
	SUBWF       R1, 0 
L__servoRotate0159:
	BTFSC       STATUS+0, 0 
	GOTO        L_servoRotate077
;ModuloEscravo.c,364 :: 		PORTD.RD5 = 1;
	BSF         PORTD+0, 5 
;ModuloEscravo.c,365 :: 		Delay_us(2200);
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       218
	MOVWF       R13, 0
L_servoRotate079:
	DECFSZ      R13, 1, 1
	BRA         L_servoRotate079
	DECFSZ      R12, 1, 1
	BRA         L_servoRotate079
	NOP
;ModuloEscravo.c,367 :: 		PORTD.RD5 = 0;
	BCF         PORTD+0, 5 
;ModuloEscravo.c,368 :: 		Delay_us(17800);
	MOVLW       24
	MOVWF       R12, 0
	MOVLW       28
	MOVWF       R13, 0
L_servoRotate080:
	DECFSZ      R13, 1, 1
	BRA         L_servoRotate080
	DECFSZ      R12, 1, 1
	BRA         L_servoRotate080
	NOP
;ModuloEscravo.c,362 :: 		for(i=0;i<50;i++)
	INFSNZ      R1, 1 
	INCF        R2, 1 
;ModuloEscravo.c,370 :: 		}
	GOTO        L_servoRotate076
L_servoRotate077:
;ModuloEscravo.c,371 :: 		if(EX[2] !='0'&& EX[2] !='1'){
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSC       STATUS+0, 2 
	GOTO        L_servoRotate083
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSC       STATUS+0, 2 
	GOTO        L_servoRotate083
L__servoRotate0145:
;ModuloEscravo.c,372 :: 		autoTimer =1;
	MOVLW       1
	MOVWF       _AutoTimer+0 
	MOVLW       0
	MOVWF       _AutoTimer+1 
;ModuloEscravo.c,373 :: 		estado =1;
	MOVLW       1
	MOVWF       _estado+0 
	MOVLW       0
	MOVWF       _estado+1 
;ModuloEscravo.c,374 :: 		resp = EX[2];
	MOVF        _EX+2, 0 
	MOVWF       _resp+0 
;ModuloEscravo.c,375 :: 		}
L_servoRotate083:
;ModuloEscravo.c,376 :: 		}
L_end_servoRotate0:
	RETURN      0
; end of _servoRotate0

_servoRotate90:

;ModuloEscravo.c,378 :: 		void servoRotate90()
;ModuloEscravo.c,381 :: 		for(i=0;i<50;i++)
	CLRF        R1 
	CLRF        R2 
L_servoRotate9084:
	MOVLW       0
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__servoRotate90161
	MOVLW       50
	SUBWF       R1, 0 
L__servoRotate90161:
	BTFSC       STATUS+0, 0 
	GOTO        L_servoRotate9085
;ModuloEscravo.c,383 :: 		PORTD.RD5 = 1;
	BSF         PORTD+0, 5 
;ModuloEscravo.c,384 :: 		Delay_us(1500);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_servoRotate9087:
	DECFSZ      R13, 1, 1
	BRA         L_servoRotate9087
	DECFSZ      R12, 1, 1
	BRA         L_servoRotate9087
	NOP
	NOP
;ModuloEscravo.c,385 :: 		PORTD.RD5 = 0;
	BCF         PORTD+0, 5 
;ModuloEscravo.c,386 :: 		Delay_us(18500);
	MOVLW       25
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_servoRotate9088:
	DECFSZ      R13, 1, 1
	BRA         L_servoRotate9088
	DECFSZ      R12, 1, 1
	BRA         L_servoRotate9088
;ModuloEscravo.c,381 :: 		for(i=0;i<50;i++)
	INFSNZ      R1, 1 
	INCF        R2, 1 
;ModuloEscravo.c,387 :: 		}
	GOTO        L_servoRotate9084
L_servoRotate9085:
;ModuloEscravo.c,389 :: 		}
L_end_servoRotate90:
	RETURN      0
; end of _servoRotate90

_gerencia_alarme:

;ModuloEscravo.c,391 :: 		void gerencia_alarme(){
;ModuloEscravo.c,392 :: 		if(cercaIR == 1){
	MOVLW       0
	XORWF       _cercaIR+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerencia_alarme163
	MOVLW       1
	XORWF       _cercaIR+0, 0 
L__gerencia_alarme163:
	BTFSS       STATUS+0, 2 
	GOTO        L_gerencia_alarme89
;ModuloEscravo.c,393 :: 		barreira = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	CALL        _Word2Double+0, 0
	MOVF        R0, 0 
	MOVWF       _barreira+0 
	MOVF        R1, 0 
	MOVWF       _barreira+1 
	MOVF        R2, 0 
	MOVWF       _barreira+2 
	MOVF        R3, 0 
	MOVWF       _barreira+3 
;ModuloEscravo.c,394 :: 		if(barreira > 500 || sirene == 1){
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       122
	MOVWF       R2 
	MOVLW       135
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerencia_alarme146
	MOVLW       0
	XORWF       _sirene+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerencia_alarme164
	MOVLW       1
	XORWF       _sirene+0, 0 
L__gerencia_alarme164:
	BTFSC       STATUS+0, 2 
	GOTO        L__gerencia_alarme146
	GOTO        L_gerencia_alarme92
L__gerencia_alarme146:
;ModuloEscravo.c,395 :: 		sirene =1;
	MOVLW       1
	MOVWF       _sirene+0 
	MOVLW       0
	MOVWF       _sirene+1 
;ModuloEscravo.c,396 :: 		PORTE.RE0 = 1;
	BSF         PORTE+0, 0 
;ModuloEscravo.c,397 :: 		delay_ms(500);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_gerencia_alarme93:
	DECFSZ      R13, 1, 1
	BRA         L_gerencia_alarme93
	DECFSZ      R12, 1, 1
	BRA         L_gerencia_alarme93
	DECFSZ      R11, 1, 1
	BRA         L_gerencia_alarme93
	NOP
	NOP
;ModuloEscravo.c,398 :: 		PORTE.RE0 = 0;
	BCF         PORTE+0, 0 
;ModuloEscravo.c,399 :: 		delay_ms(500);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_gerencia_alarme94:
	DECFSZ      R13, 1, 1
	BRA         L_gerencia_alarme94
	DECFSZ      R12, 1, 1
	BRA         L_gerencia_alarme94
	DECFSZ      R11, 1, 1
	BRA         L_gerencia_alarme94
	NOP
	NOP
;ModuloEscravo.c,400 :: 		}
L_gerencia_alarme92:
;ModuloEscravo.c,401 :: 		}
	GOTO        L_gerencia_alarme95
L_gerencia_alarme89:
;ModuloEscravo.c,402 :: 		else if(cercaIR == 0){
	MOVLW       0
	XORWF       _cercaIR+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerencia_alarme165
	MOVLW       0
	XORWF       _cercaIR+0, 0 
L__gerencia_alarme165:
	BTFSS       STATUS+0, 2 
	GOTO        L_gerencia_alarme96
;ModuloEscravo.c,403 :: 		sirene =0;
	CLRF        _sirene+0 
	CLRF        _sirene+1 
;ModuloEscravo.c,404 :: 		PORTE.RE0 = 0;
	BCF         PORTE+0, 0 
;ModuloEscravo.c,405 :: 		}
L_gerencia_alarme96:
L_gerencia_alarme95:
;ModuloEscravo.c,406 :: 		}
L_end_gerencia_alarme:
	RETURN      0
; end of _gerencia_alarme

_iluminacao_automatizada:

;ModuloEscravo.c,408 :: 		void iluminacao_automatizada(){
;ModuloEscravo.c,409 :: 		if(estado == 1){ // ativa a iluminação automatizada
	MOVLW       0
	XORWF       _estado+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada167
	MOVLW       1
	XORWF       _estado+0, 0 
L__iluminacao_automatizada167:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada97
;ModuloEscravo.c,410 :: 		LDR = ADC_Read(2); //  leitura do pino analógico do sensor
	MOVLW       2
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	CALL        _Word2Double+0, 0
	MOVF        R0, 0 
	MOVWF       _LDR+0 
	MOVF        R1, 0 
	MOVWF       _LDR+1 
	MOVF        R2, 0 
	MOVWF       _LDR+2 
	MOVF        R3, 0 
	MOVWF       _LDR+3 
;ModuloEscravo.c,411 :: 		if(LDR < 600){// ativa as luzes correspondentes
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       22
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada98
;ModuloEscravo.c,412 :: 		if(resp == '0'){
	MOVF        _resp+0, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada99
;ModuloEscravo.c,413 :: 		PORTD.RD0 = 0; //liga o LED A
	BCF         PORTD+0, 0 
;ModuloEscravo.c,414 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada168
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada168:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada100
;ModuloEscravo.c,415 :: 		INTCON.TMR0IE =1; // ativa interrupção do timer0
	BSF         INTCON+0, 5 
;ModuloEscravo.c,416 :: 		if(off==1){
	MOVLW       0
	XORWF       _off+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada169
	MOVLW       1
	XORWF       _off+0, 0 
L__iluminacao_automatizada169:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada101
;ModuloEscravo.c,417 :: 		PORTD.RD0 =1;
	BSF         PORTD+0, 0 
;ModuloEscravo.c,418 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,419 :: 		off=0;
	CLRF        _off+0 
	CLRF        _off+1 
;ModuloEscravo.c,420 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,421 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,422 :: 		}
L_iluminacao_automatizada101:
;ModuloEscravo.c,423 :: 		}
L_iluminacao_automatizada100:
;ModuloEscravo.c,424 :: 		}
L_iluminacao_automatizada99:
;ModuloEscravo.c,425 :: 		if(resp == '1'){
	MOVF        _resp+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada102
;ModuloEscravo.c,426 :: 		PORTD.RD1 = 0; //liga o LED B
	BCF         PORTD+0, 1 
;ModuloEscravo.c,427 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada170
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada170:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada103
;ModuloEscravo.c,428 :: 		INTCON.TMR0IE =1; // ativa interrupção do timer0
	BSF         INTCON+0, 5 
;ModuloEscravo.c,429 :: 		if(off==1){
	MOVLW       0
	XORWF       _off+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada171
	MOVLW       1
	XORWF       _off+0, 0 
L__iluminacao_automatizada171:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada104
;ModuloEscravo.c,430 :: 		PORTD.RD1 =1;
	BSF         PORTD+0, 1 
;ModuloEscravo.c,431 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,432 :: 		off=0;
	CLRF        _off+0 
	CLRF        _off+1 
;ModuloEscravo.c,433 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,434 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,435 :: 		}
L_iluminacao_automatizada104:
;ModuloEscravo.c,436 :: 		}
L_iluminacao_automatizada103:
;ModuloEscravo.c,437 :: 		}
L_iluminacao_automatizada102:
;ModuloEscravo.c,438 :: 		if(resp == '2'){
	MOVF        _resp+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada105
;ModuloEscravo.c,439 :: 		PORTD.RD2 = 0; //liga o LED C
	BCF         PORTD+0, 2 
;ModuloEscravo.c,440 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada172
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada172:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada106
;ModuloEscravo.c,441 :: 		INTCON.TMR0IE =1; // ativa interrupção do timer0
	BSF         INTCON+0, 5 
;ModuloEscravo.c,442 :: 		if(off==1){
	MOVLW       0
	XORWF       _off+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada173
	MOVLW       1
	XORWF       _off+0, 0 
L__iluminacao_automatizada173:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada107
;ModuloEscravo.c,443 :: 		PORTD.RD2 =1;
	BSF         PORTD+0, 2 
;ModuloEscravo.c,444 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,445 :: 		off=0;
	CLRF        _off+0 
	CLRF        _off+1 
;ModuloEscravo.c,446 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,447 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,448 :: 		}
L_iluminacao_automatizada107:
;ModuloEscravo.c,449 :: 		}
L_iluminacao_automatizada106:
;ModuloEscravo.c,450 :: 		}
L_iluminacao_automatizada105:
;ModuloEscravo.c,451 :: 		if(resp == '3'){
	MOVF        _resp+0, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada108
;ModuloEscravo.c,452 :: 		PORTD.RD3 = 0; //liga o LED D
	BCF         PORTD+0, 3 
;ModuloEscravo.c,453 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada174
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada174:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada109
;ModuloEscravo.c,454 :: 		INTCON.TMR0IE =1; // ativa interrupção do timer0
	BSF         INTCON+0, 5 
;ModuloEscravo.c,455 :: 		if(off==1){
	MOVLW       0
	XORWF       _off+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada175
	MOVLW       1
	XORWF       _off+0, 0 
L__iluminacao_automatizada175:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada110
;ModuloEscravo.c,456 :: 		PORTD.RD3 =1;
	BSF         PORTD+0, 3 
;ModuloEscravo.c,457 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,458 :: 		off=0;
	CLRF        _off+0 
	CLRF        _off+1 
;ModuloEscravo.c,459 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,460 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,461 :: 		}
L_iluminacao_automatizada110:
;ModuloEscravo.c,462 :: 		}
L_iluminacao_automatizada109:
;ModuloEscravo.c,463 :: 		}
L_iluminacao_automatizada108:
;ModuloEscravo.c,464 :: 		if(resp == '4'){
	MOVF        _resp+0, 0 
	XORLW       52
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada111
;ModuloEscravo.c,465 :: 		PORTD.RD4 = 0; //liga o LED E
	BCF         PORTD+0, 4 
;ModuloEscravo.c,466 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada176
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada176:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada112
;ModuloEscravo.c,467 :: 		INTCON.TMR0IE =1; // ativa interrupção do timer0
	BSF         INTCON+0, 5 
;ModuloEscravo.c,468 :: 		if(off==1){
	MOVLW       0
	XORWF       _off+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada177
	MOVLW       1
	XORWF       _off+0, 0 
L__iluminacao_automatizada177:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada113
;ModuloEscravo.c,469 :: 		PORTD.RD4 =1;
	BSF         PORTD+0, 4 
;ModuloEscravo.c,470 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,471 :: 		off=0;
	CLRF        _off+0 
	CLRF        _off+1 
;ModuloEscravo.c,472 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,473 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,474 :: 		}
L_iluminacao_automatizada113:
;ModuloEscravo.c,475 :: 		}
L_iluminacao_automatizada112:
;ModuloEscravo.c,476 :: 		}
L_iluminacao_automatizada111:
;ModuloEscravo.c,477 :: 		if(resp == '5'){
	MOVF        _resp+0, 0 
	XORLW       53
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada114
;ModuloEscravo.c,478 :: 		PORTD.RD0 = 0; //liga todos os LEDS
	BCF         PORTD+0, 0 
;ModuloEscravo.c,479 :: 		PORTD.RD1 = 0;
	BCF         PORTD+0, 1 
;ModuloEscravo.c,480 :: 		PORTD.RD2 = 0;
	BCF         PORTD+0, 2 
;ModuloEscravo.c,481 :: 		PORTD.RD3 = 0;
	BCF         PORTD+0, 3 
;ModuloEscravo.c,482 :: 		PORTD.RD4 = 0;
	BCF         PORTD+0, 4 
;ModuloEscravo.c,483 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada178
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada178:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada115
;ModuloEscravo.c,484 :: 		INTCON.TMR0IE =1; // ativa interrupção do timer0
	BSF         INTCON+0, 5 
;ModuloEscravo.c,485 :: 		if(off==1){
	MOVLW       0
	XORWF       _off+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada179
	MOVLW       1
	XORWF       _off+0, 0 
L__iluminacao_automatizada179:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada116
;ModuloEscravo.c,486 :: 		PORTD.RD0 = 1; //desliga todos os LEDS
	BSF         PORTD+0, 0 
;ModuloEscravo.c,487 :: 		PORTD.RD1 = 1;
	BSF         PORTD+0, 1 
;ModuloEscravo.c,488 :: 		PORTD.RD2 = 1;
	BSF         PORTD+0, 2 
;ModuloEscravo.c,489 :: 		PORTD.RD3 = 1;
	BSF         PORTD+0, 3 
;ModuloEscravo.c,490 :: 		PORTD.RD4 = 1;
	BSF         PORTD+0, 4 
;ModuloEscravo.c,491 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,492 :: 		off=0;
	CLRF        _off+0 
	CLRF        _off+1 
;ModuloEscravo.c,493 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,494 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,495 :: 		}
L_iluminacao_automatizada116:
;ModuloEscravo.c,496 :: 		}
L_iluminacao_automatizada115:
;ModuloEscravo.c,497 :: 		}
L_iluminacao_automatizada114:
;ModuloEscravo.c,498 :: 		}
	GOTO        L_iluminacao_automatizada117
L_iluminacao_automatizada98:
;ModuloEscravo.c,499 :: 		else if(LDR > 600){// desativa as luzes correspondentes
	MOVF        _LDR+0, 0 
	MOVWF       R4 
	MOVF        _LDR+1, 0 
	MOVWF       R5 
	MOVF        _LDR+2, 0 
	MOVWF       R6 
	MOVF        _LDR+3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       22
	MOVWF       R2 
	MOVLW       136
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada118
;ModuloEscravo.c,500 :: 		if(resp == '0'){
	MOVF        _resp+0, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada119
;ModuloEscravo.c,501 :: 		PORTD.RD0 = 1; //desliga o LED A
	BSF         PORTD+0, 0 
;ModuloEscravo.c,502 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada180
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada180:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada120
;ModuloEscravo.c,503 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,504 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,505 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,506 :: 		}
L_iluminacao_automatizada120:
;ModuloEscravo.c,508 :: 		}
L_iluminacao_automatizada119:
;ModuloEscravo.c,509 :: 		if(resp == '1'){
	MOVF        _resp+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada121
;ModuloEscravo.c,510 :: 		PORTD.RD1 = 1; //desliga o LED B
	BSF         PORTD+0, 1 
;ModuloEscravo.c,511 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada181
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada181:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada122
;ModuloEscravo.c,512 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,513 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,514 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,515 :: 		}
L_iluminacao_automatizada122:
;ModuloEscravo.c,516 :: 		}
L_iluminacao_automatizada121:
;ModuloEscravo.c,517 :: 		if(resp == '2'){
	MOVF        _resp+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada123
;ModuloEscravo.c,518 :: 		PORTD.RD2 = 1; //desliga o LED C
	BSF         PORTD+0, 2 
;ModuloEscravo.c,519 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada182
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada182:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada124
;ModuloEscravo.c,520 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,521 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,522 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,523 :: 		}
L_iluminacao_automatizada124:
;ModuloEscravo.c,524 :: 		}
L_iluminacao_automatizada123:
;ModuloEscravo.c,525 :: 		if(resp == '3'){
	MOVF        _resp+0, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada125
;ModuloEscravo.c,526 :: 		PORTD.RD3 = 1; //desliga o LED D
	BSF         PORTD+0, 3 
;ModuloEscravo.c,527 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada183
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada183:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada126
;ModuloEscravo.c,528 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,529 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,530 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,531 :: 		}
L_iluminacao_automatizada126:
;ModuloEscravo.c,532 :: 		}
L_iluminacao_automatizada125:
;ModuloEscravo.c,533 :: 		if(resp == '4'){
	MOVF        _resp+0, 0 
	XORLW       52
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada127
;ModuloEscravo.c,534 :: 		PORTD.RD4 = 1; //desliga o LED E
	BSF         PORTD+0, 4 
;ModuloEscravo.c,535 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada184
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada184:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada128
;ModuloEscravo.c,536 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,537 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,538 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,539 :: 		}
L_iluminacao_automatizada128:
;ModuloEscravo.c,540 :: 		}
L_iluminacao_automatizada127:
;ModuloEscravo.c,541 :: 		if(resp == '5'){
	MOVF        _resp+0, 0 
	XORLW       53
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada129
;ModuloEscravo.c,542 :: 		PORTD.RD0 = 1; //desliga todos os LEDS
	BSF         PORTD+0, 0 
;ModuloEscravo.c,543 :: 		PORTD.RD1 = 1;
	BSF         PORTD+0, 1 
;ModuloEscravo.c,544 :: 		PORTD.RD2 = 1;
	BSF         PORTD+0, 2 
;ModuloEscravo.c,545 :: 		PORTD.RD3 = 1;
	BSF         PORTD+0, 3 
;ModuloEscravo.c,546 :: 		PORTD.RD4 = 1;
	BSF         PORTD+0, 4 
;ModuloEscravo.c,547 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada185
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada185:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada130
;ModuloEscravo.c,548 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,549 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,550 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,551 :: 		}
L_iluminacao_automatizada130:
;ModuloEscravo.c,552 :: 		}
L_iluminacao_automatizada129:
;ModuloEscravo.c,553 :: 		}
L_iluminacao_automatizada118:
L_iluminacao_automatizada117:
;ModuloEscravo.c,554 :: 		}
	GOTO        L_iluminacao_automatizada131
L_iluminacao_automatizada97:
;ModuloEscravo.c,555 :: 		else if(estado ==3){
	MOVLW       0
	XORWF       _estado+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada186
	MOVLW       3
	XORWF       _estado+0, 0 
L__iluminacao_automatizada186:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada132
;ModuloEscravo.c,556 :: 		if(resp == '0'){
	MOVF        _resp+0, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada133
;ModuloEscravo.c,557 :: 		PORTD.RD0 = 1; //desliga o LED A
	BSF         PORTD+0, 0 
;ModuloEscravo.c,558 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada187
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada187:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada134
;ModuloEscravo.c,559 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,560 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,561 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,562 :: 		}
L_iluminacao_automatizada134:
;ModuloEscravo.c,563 :: 		}
L_iluminacao_automatizada133:
;ModuloEscravo.c,564 :: 		if(resp == '1'){
	MOVF        _resp+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada135
;ModuloEscravo.c,565 :: 		PORTD.RD1 = 1; //desliga o LED B
	BSF         PORTD+0, 1 
;ModuloEscravo.c,566 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada188
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada188:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada136
;ModuloEscravo.c,567 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,568 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,569 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,570 :: 		}
L_iluminacao_automatizada136:
;ModuloEscravo.c,571 :: 		}
L_iluminacao_automatizada135:
;ModuloEscravo.c,572 :: 		if(resp == '2'){
	MOVF        _resp+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada137
;ModuloEscravo.c,573 :: 		PORTD.RD2 = 1; //desliga o LED C
	BSF         PORTD+0, 2 
;ModuloEscravo.c,574 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada189
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada189:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada138
;ModuloEscravo.c,575 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,576 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,577 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,578 :: 		}
L_iluminacao_automatizada138:
;ModuloEscravo.c,579 :: 		}
L_iluminacao_automatizada137:
;ModuloEscravo.c,580 :: 		if(resp == '3'){
	MOVF        _resp+0, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada139
;ModuloEscravo.c,581 :: 		PORTD.RD3 = 1; //desliga o LED D
	BSF         PORTD+0, 3 
;ModuloEscravo.c,582 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada190
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada190:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada140
;ModuloEscravo.c,583 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,584 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,585 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,586 :: 		}
L_iluminacao_automatizada140:
;ModuloEscravo.c,587 :: 		}
L_iluminacao_automatizada139:
;ModuloEscravo.c,588 :: 		if(resp == '4'){
	MOVF        _resp+0, 0 
	XORLW       52
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada141
;ModuloEscravo.c,589 :: 		PORTD.RD4 = 1; //desliga o LED E
	BSF         PORTD+0, 4 
;ModuloEscravo.c,590 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada191
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada191:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada142
;ModuloEscravo.c,591 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,592 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,593 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,594 :: 		}
L_iluminacao_automatizada142:
;ModuloEscravo.c,595 :: 		}
L_iluminacao_automatizada141:
;ModuloEscravo.c,596 :: 		if(resp == '5'){
	MOVF        _resp+0, 0 
	XORLW       53
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada143
;ModuloEscravo.c,597 :: 		PORTD.RD0 = 1; //desliga todos os LEDS
	BSF         PORTD+0, 0 
;ModuloEscravo.c,598 :: 		PORTD.RD1 = 1;
	BSF         PORTD+0, 1 
;ModuloEscravo.c,599 :: 		PORTD.RD2 = 1;
	BSF         PORTD+0, 2 
;ModuloEscravo.c,600 :: 		PORTD.RD3 = 1;
	BSF         PORTD+0, 3 
;ModuloEscravo.c,601 :: 		PORTD.RD4 = 1;
	BSF         PORTD+0, 4 
;ModuloEscravo.c,602 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada192
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada192:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada144
;ModuloEscravo.c,603 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,604 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,605 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,606 :: 		}
L_iluminacao_automatizada144:
;ModuloEscravo.c,607 :: 		}
L_iluminacao_automatizada143:
;ModuloEscravo.c,608 :: 		}
L_iluminacao_automatizada132:
L_iluminacao_automatizada131:
;ModuloEscravo.c,609 :: 		}
L_end_iluminacao_automatizada:
	RETURN      0
; end of _iluminacao_automatizada
