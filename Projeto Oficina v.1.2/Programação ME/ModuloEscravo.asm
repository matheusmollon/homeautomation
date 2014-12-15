
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
;ModuloEscravo.c,49 :: 		TRISE.RE1 =0;
	BCF         TRISE+0, 1 
;ModuloEscravo.c,50 :: 		PORTE.RE1 =0;
	BCF         PORTE+0, 1 
;ModuloEscravo.c,51 :: 		PORTE.RE0 =0;
	BCF         PORTE+0, 0 
;ModuloEscravo.c,52 :: 		ADCON1 = 0b00001100; //define A0,A1 e A2 como saídas analógicas para os sensores
	MOVLW       12
	MOVWF       ADCON1+0 
;ModuloEscravo.c,53 :: 		TRISA.RA0 =1;
	BSF         TRISA+0, 0 
;ModuloEscravo.c,54 :: 		TRISA.RA1 =1;
	BSF         TRISA+0, 1 
;ModuloEscravo.c,55 :: 		TRISA.RA2 =1;
	BSF         TRISA+0, 2 
;ModuloEscravo.c,58 :: 		RCON.IPEN = 1;
	BSF         RCON+0, 7 
;ModuloEscravo.c,59 :: 		INTCON.GIEH = 1;
	BSF         INTCON+0, 7 
;ModuloEscravo.c,60 :: 		INTCON.GIEL = 1;
	BSF         INTCON+0, 6 
;ModuloEscravo.c,63 :: 		T0CON = 0b10000111;
	MOVLW       135
	MOVWF       T0CON+0 
;ModuloEscravo.c,64 :: 		INTCON.TMR0IF = 0; // zera o flag de estouro do timer0
	BCF         INTCON+0, 2 
;ModuloEscravo.c,65 :: 		INTCON.TMR0IE = 0; //desabilita a interrupção
	BCF         INTCON+0, 5 
;ModuloEscravo.c,66 :: 		INTCON2.TMR0IP =1; // alta prioridade
	BSF         INTCON2+0, 2 
;ModuloEscravo.c,68 :: 		TMR0H =0x1B;
	MOVLW       27
	MOVWF       TMR0H+0 
;ModuloEscravo.c,69 :: 		TMR0L =0x1E;
	MOVLW       30
	MOVWF       TMR0L+0 
;ModuloEscravo.c,72 :: 		IPR1.RCIP = 0;//baixa prioridade
	BCF         IPR1+0, 5 
;ModuloEscravo.c,73 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;ModuloEscravo.c,74 :: 		PIE1.RCIE = 1; //Enable da interrupção Serial RX
	BSF         PIE1+0, 5 
;ModuloEscravo.c,81 :: 		T2CON=0b00000111;
	MOVLW       7
	MOVWF       T2CON+0 
;ModuloEscravo.c,82 :: 		PR2=31; //30.25=~31
	MOVLW       31
	MOVWF       PR2+0 
;ModuloEscravo.c,114 :: 		CCPR2l = 0b11111111;
	MOVLW       255
	MOVWF       CCPR2L+0 
;ModuloEscravo.c,115 :: 		CCP2CON = 0b00111100;
	MOVLW       60
	MOVWF       CCP2CON+0 
;ModuloEscravo.c,117 :: 		while(1) {
L_main1:
;ModuloEscravo.c,118 :: 		gerencia_alarme();
	CALL        _gerencia_alarme+0, 0
;ModuloEscravo.c,119 :: 		iluminacao_automatizada();
	CALL        _iluminacao_automatizada+0, 0
;ModuloEscravo.c,120 :: 		}
	GOTO        L_main1
;ModuloEscravo.c,121 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt_low:
	MOVWF       ___Low_saveWREG+0 
	MOVF        STATUS+0, 0 
	MOVWF       ___Low_saveSTATUS+0 
	MOVF        BSR+0, 0 
	MOVWF       ___Low_saveBSR+0 

;ModuloEscravo.c,123 :: 		void interrupt_low() {
;ModuloEscravo.c,124 :: 		if(PIR1.RCIF == 1) { // indica que a interrupção foi disparada pela Serial RX
	BTFSS       PIR1+0, 5 
	GOTO        L_interrupt_low3
;ModuloEscravo.c,125 :: 		PIR1.RCIF = 0; // limpa flag que gerou a interrupção
	BCF         PIR1+0, 5 
;ModuloEscravo.c,126 :: 		lerProtocolo();
	CALL        _lerProtocolo+0, 0
;ModuloEscravo.c,127 :: 		}
L_interrupt_low3:
;ModuloEscravo.c,128 :: 		}
L_end_interrupt_low:
L__interrupt_low144:
	MOVF        ___Low_saveBSR+0, 0 
	MOVWF       BSR+0 
	MOVF        ___Low_saveSTATUS+0, 0 
	MOVWF       STATUS+0 
	SWAPF       ___Low_saveWREG+0, 1 
	SWAPF       ___Low_saveWREG+0, 0 
	RETFIE      0
; end of _interrupt_low

_interrupt:

;ModuloEscravo.c,129 :: 		void interrupt(){
;ModuloEscravo.c,130 :: 		if(INTCON.TMR0IF==1){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt4
;ModuloEscravo.c,131 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;ModuloEscravo.c,132 :: 		if(cont !=4){
	MOVLW       0
	XORWF       _cont+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt147
	MOVLW       4
	XORWF       _cont+0, 0 
L__interrupt147:
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt5
;ModuloEscravo.c,133 :: 		cont++;
	INFSNZ      _cont+0, 1 
	INCF        _cont+1, 1 
;ModuloEscravo.c,134 :: 		}
	GOTO        L_interrupt6
L_interrupt5:
;ModuloEscravo.c,135 :: 		else if(cont == 4){
	MOVLW       0
	XORWF       _cont+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt148
	MOVLW       4
	XORWF       _cont+0, 0 
L__interrupt148:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt7
;ModuloEscravo.c,136 :: 		cont =0;
	CLRF        _cont+0 
	CLRF        _cont+1 
;ModuloEscravo.c,137 :: 		off=1;
	MOVLW       1
	MOVWF       _off+0 
	MOVLW       0
	MOVWF       _off+1 
;ModuloEscravo.c,138 :: 		}
L_interrupt7:
L_interrupt6:
;ModuloEscravo.c,140 :: 		TMR0H =0x1B;
	MOVLW       27
	MOVWF       TMR0H+0 
;ModuloEscravo.c,141 :: 		TMR0L =0x1E;
	MOVLW       30
	MOVWF       TMR0L+0 
;ModuloEscravo.c,142 :: 		}
L_interrupt4:
;ModuloEscravo.c,143 :: 		}
L_end_interrupt:
L__interrupt146:
	RETFIE      1
; end of _interrupt

_lerProtocolo:

;ModuloEscravo.c,145 :: 		void lerProtocolo(void) {
;ModuloEscravo.c,147 :: 		if(UART1_Data_Ready()) {
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_lerProtocolo8
;ModuloEscravo.c,149 :: 		lido = UART1_Read(); // lê o byte de inicio do protocolo
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _lido+0 
;ModuloEscravo.c,152 :: 		if(lido == '(') { // se for '(' indica que o protocolo de execução
	MOVF        R0, 0 
	XORLW       40
	BTFSS       STATUS+0, 2 
	GOTO        L_lerProtocolo9
;ModuloEscravo.c,153 :: 		UART1_Read_Text(EX, ")", 4);
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
;ModuloEscravo.c,154 :: 		executarProtocolo();
	CALL        _executarProtocolo+0, 0
;ModuloEscravo.c,155 :: 		}
	GOTO        L_lerProtocolo10
L_lerProtocolo9:
;ModuloEscravo.c,156 :: 		else if(lido == '[') { // se for '[' indica que o protocolo eh de identificação do módulo
	MOVF        _lido+0, 0 
	XORLW       91
	BTFSS       STATUS+0, 2 
	GOTO        L_lerProtocolo11
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
;ModuloEscravo.c,159 :: 		}
L_lerProtocolo11:
L_lerProtocolo10:
;ModuloEscravo.c,160 :: 		}
L_lerProtocolo8:
;ModuloEscravo.c,161 :: 		}
L_end_lerProtocolo:
	RETURN      0
; end of _lerProtocolo

_executarProtocolo:

;ModuloEscravo.c,163 :: 		void executarProtocolo(void) {
;ModuloEscravo.c,166 :: 		if(ID[0] == 'M') { //O ID deste módulo é M01
	MOVF        _ID+0, 0 
	XORLW       77
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo12
;ModuloEscravo.c,167 :: 		if(ID[1] == '0') {
	MOVF        _ID+1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo13
;ModuloEscravo.c,168 :: 		if(ID[2] == '1') {
	MOVF        _ID+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo14
;ModuloEscravo.c,170 :: 		ID[0] = '0' ;
	MOVLW       48
	MOVWF       _ID+0 
;ModuloEscravo.c,171 :: 		respondeProtocolo('+', 'M', '0', '1', '+');
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
;ModuloEscravo.c,172 :: 		}
L_executarProtocolo14:
;ModuloEscravo.c,173 :: 		}
L_executarProtocolo13:
;ModuloEscravo.c,174 :: 		}
	GOTO        L_executarProtocolo15
L_executarProtocolo12:
;ModuloEscravo.c,176 :: 		else if(EX[0] == 'I') { //O EX começa com I no protocolo de iluminação
	MOVF        _EX+0, 0 
	XORLW       73
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo16
;ModuloEscravo.c,178 :: 		if(EX[1] == 'A') { // LED A
	MOVF        _EX+1, 0 
	XORLW       65
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo17
;ModuloEscravo.c,179 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,180 :: 		if(EX[2] == '1')
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo18
;ModuloEscravo.c,181 :: 		PORTD.RD0 = 0;
	BCF         PORTD+0, 0 
	GOTO        L_executarProtocolo19
L_executarProtocolo18:
;ModuloEscravo.c,182 :: 		else if(EX[2] == '0')
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo20
;ModuloEscravo.c,183 :: 		PORTD.RD0 = 1;
	BSF         PORTD+0, 0 
L_executarProtocolo20:
L_executarProtocolo19:
;ModuloEscravo.c,184 :: 		}
L_executarProtocolo17:
;ModuloEscravo.c,186 :: 		if(EX[1] == 'B') { // LED B
	MOVF        _EX+1, 0 
	XORLW       66
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo21
;ModuloEscravo.c,187 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,188 :: 		if(EX[2] == '1')
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo22
;ModuloEscravo.c,189 :: 		PORTD.RD1 = 0;
	BCF         PORTD+0, 1 
	GOTO        L_executarProtocolo23
L_executarProtocolo22:
;ModuloEscravo.c,190 :: 		else if(EX[2] == '0')
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo24
;ModuloEscravo.c,191 :: 		PORTD.RD1 = 1;
	BSF         PORTD+0, 1 
L_executarProtocolo24:
L_executarProtocolo23:
;ModuloEscravo.c,192 :: 		}
L_executarProtocolo21:
;ModuloEscravo.c,194 :: 		if(EX[1] == 'C') { // LED C
	MOVF        _EX+1, 0 
	XORLW       67
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo25
;ModuloEscravo.c,195 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,196 :: 		if(EX[2] == '1')
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo26
;ModuloEscravo.c,197 :: 		PORTD.RD2 = 0;
	BCF         PORTD+0, 2 
	GOTO        L_executarProtocolo27
L_executarProtocolo26:
;ModuloEscravo.c,198 :: 		else if(EX[2] == '0')
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo28
;ModuloEscravo.c,199 :: 		PORTD.RD2 = 1;
	BSF         PORTD+0, 2 
L_executarProtocolo28:
L_executarProtocolo27:
;ModuloEscravo.c,200 :: 		}
L_executarProtocolo25:
;ModuloEscravo.c,202 :: 		if(EX[1] == 'D') { // LED D
	MOVF        _EX+1, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo29
;ModuloEscravo.c,203 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,204 :: 		if(EX[2] == '1')
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo30
;ModuloEscravo.c,205 :: 		PORTD.RD3 = 0;
	BCF         PORTD+0, 3 
	GOTO        L_executarProtocolo31
L_executarProtocolo30:
;ModuloEscravo.c,206 :: 		else if(EX[2] == '0')
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo32
;ModuloEscravo.c,207 :: 		PORTD.RD3 = 1;
	BSF         PORTD+0, 3 
L_executarProtocolo32:
L_executarProtocolo31:
;ModuloEscravo.c,208 :: 		}
L_executarProtocolo29:
;ModuloEscravo.c,210 :: 		if(EX[1] == 'E') { // LED E
	MOVF        _EX+1, 0 
	XORLW       69
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo33
;ModuloEscravo.c,211 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,212 :: 		if(EX[2] == '1')
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo34
;ModuloEscravo.c,213 :: 		PORTD.RD4 = 0;
	BCF         PORTD+0, 4 
	GOTO        L_executarProtocolo35
L_executarProtocolo34:
;ModuloEscravo.c,214 :: 		else if(EX[2] == '0')
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo36
;ModuloEscravo.c,215 :: 		PORTD.RD4 = 1;
	BSF         PORTD+0, 4 
L_executarProtocolo36:
L_executarProtocolo35:
;ModuloEscravo.c,216 :: 		}
L_executarProtocolo33:
;ModuloEscravo.c,218 :: 		EX[0] = '0';
	MOVLW       48
	MOVWF       _EX+0 
;ModuloEscravo.c,220 :: 		respondeProtocolo( '+', 'T', 'E', 'P', '+');
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
;ModuloEscravo.c,221 :: 		}
	GOTO        L_executarProtocolo37
L_executarProtocolo16:
;ModuloEscravo.c,223 :: 		else if(EX[0] == 'P') { // O EX começa com P no protocolo do portão
	MOVF        _EX+0, 0 
	XORLW       80
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo38
;ModuloEscravo.c,224 :: 		if(EX[1] == 'F'){
	MOVF        _EX+1, 0 
	XORLW       70
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo39
;ModuloEscravo.c,225 :: 		if(EX[2] == '1')
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo40
;ModuloEscravo.c,226 :: 		servoRotate0();
	CALL        _servoRotate0+0, 0
	GOTO        L_executarProtocolo41
L_executarProtocolo40:
;ModuloEscravo.c,227 :: 		else if (EX[2] == '0')
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo42
;ModuloEscravo.c,228 :: 		servoRotate90();
	CALL        _servoRotate90+0, 0
L_executarProtocolo42:
L_executarProtocolo41:
;ModuloEscravo.c,229 :: 		}
L_executarProtocolo39:
;ModuloEscravo.c,231 :: 		EX[0] = '0';
	MOVLW       48
	MOVWF       _EX+0 
;ModuloEscravo.c,233 :: 		respondeProtocolo( '+', 'T', 'E', 'P', '+');
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
;ModuloEscravo.c,234 :: 		}
	GOTO        L_executarProtocolo43
L_executarProtocolo38:
;ModuloEscravo.c,236 :: 		else if(EX[0] == 'D') { // O EX começa com D no protocolo de dimerização
	MOVF        _EX+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo44
;ModuloEscravo.c,237 :: 		if(EX[1] == 'G') {
	MOVF        _EX+1, 0 
	XORLW       71
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo45
;ModuloEscravo.c,238 :: 		if(EX[2] == '4') { // Ligado 100%
	MOVF        _EX+2, 0 
	XORLW       52
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo46
;ModuloEscravo.c,239 :: 		CCPR2l = 0b00000000;
	CLRF        CCPR2L+0 
;ModuloEscravo.c,240 :: 		CCP2CON = 0b00001100;
	MOVLW       12
	MOVWF       CCP2CON+0 
;ModuloEscravo.c,241 :: 		}
	GOTO        L_executarProtocolo47
L_executarProtocolo46:
;ModuloEscravo.c,242 :: 		else if(EX[2] == '3') { // Ligado 75%
	MOVF        _EX+2, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo48
;ModuloEscravo.c,243 :: 		CCPR2l = 0b00001000;
	MOVLW       8
	MOVWF       CCPR2L+0 
;ModuloEscravo.c,244 :: 		CCP2CON = 0b00001100;
	MOVLW       12
	MOVWF       CCP2CON+0 
;ModuloEscravo.c,245 :: 		}
	GOTO        L_executarProtocolo49
L_executarProtocolo48:
;ModuloEscravo.c,246 :: 		else if(EX[2] == '2') { // Ligado 50%
	MOVF        _EX+2, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo50
;ModuloEscravo.c,247 :: 		CCPR2l = 0b00001111;
	MOVLW       15
	MOVWF       CCPR2L+0 
;ModuloEscravo.c,248 :: 		CCP2CON = 0b00111100;
	MOVLW       60
	MOVWF       CCP2CON+0 
;ModuloEscravo.c,249 :: 		}
	GOTO        L_executarProtocolo51
L_executarProtocolo50:
;ModuloEscravo.c,250 :: 		else if(EX[2] == '1') { // Ligado 25%
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo52
;ModuloEscravo.c,251 :: 		CCPR2l = 0b00010111;
	MOVLW       23
	MOVWF       CCPR2L+0 
;ModuloEscravo.c,252 :: 		CCP2CON = 0b00101100;
	MOVLW       44
	MOVWF       CCP2CON+0 
;ModuloEscravo.c,253 :: 		}
	GOTO        L_executarProtocolo53
L_executarProtocolo52:
;ModuloEscravo.c,254 :: 		else if(EX[2] == '0') { // Desligado
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo54
;ModuloEscravo.c,255 :: 		CCPR2l = 0b11111111;
	MOVLW       255
	MOVWF       CCPR2L+0 
;ModuloEscravo.c,256 :: 		CCP2CON = 0b00111100;
	MOVLW       60
	MOVWF       CCP2CON+0 
;ModuloEscravo.c,257 :: 		}
L_executarProtocolo54:
L_executarProtocolo53:
L_executarProtocolo51:
L_executarProtocolo49:
L_executarProtocolo47:
;ModuloEscravo.c,258 :: 		}
L_executarProtocolo45:
;ModuloEscravo.c,260 :: 		EX[0] = '0';
	MOVLW       48
	MOVWF       _EX+0 
;ModuloEscravo.c,262 :: 		respondeProtocolo( '+', 'T', 'E', 'P', '+');
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
;ModuloEscravo.c,263 :: 		}
	GOTO        L_executarProtocolo55
L_executarProtocolo44:
;ModuloEscravo.c,265 :: 		else if(EX[0] == 'A'){ // parte do protocolo responsável pelo funcionamento dos alarmes
	MOVF        _EX+0, 0 
	XORLW       65
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo56
;ModuloEscravo.c,266 :: 		if(EX[1] == 'H'){    // indica o alarme A que representa a Barreira infravermelho
	MOVF        _EX+1, 0 
	XORLW       72
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo57
;ModuloEscravo.c,267 :: 		if(EX[2] == '1'){  // ativa barreira infravermelho
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo58
;ModuloEscravo.c,268 :: 		cercaIR = 1;
	MOVLW       1
	MOVWF       _cercaIR+0 
	MOVLW       0
	MOVWF       _cercaIR+1 
;ModuloEscravo.c,269 :: 		}
	GOTO        L_executarProtocolo59
L_executarProtocolo58:
;ModuloEscravo.c,270 :: 		else if(EX[2] =='0'){ // desativa barreita intravermelho
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo60
;ModuloEscravo.c,271 :: 		cercaIR = 0;
	CLRF        _cercaIR+0 
	CLRF        _cercaIR+1 
;ModuloEscravo.c,272 :: 		}
L_executarProtocolo60:
L_executarProtocolo59:
;ModuloEscravo.c,273 :: 		}
L_executarProtocolo57:
;ModuloEscravo.c,275 :: 		EX[0] = '0';
	MOVLW       48
	MOVWF       _EX+0 
;ModuloEscravo.c,277 :: 		respondeProtocolo( '+', 'T', 'E', 'P', '+');
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
;ModuloEscravo.c,278 :: 		}
	GOTO        L_executarProtocolo61
L_executarProtocolo56:
;ModuloEscravo.c,280 :: 		else if(EX[0] == 'C'){ // parte do protocolo responsável pela iluminação automatizada
	MOVF        _EX+0, 0 
	XORLW       67
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo62
;ModuloEscravo.c,282 :: 		if(EX[1] == '1'){    // indica que o acendimento automatizado da luz pelo LDR está ativo
	MOVF        _EX+1, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo63
;ModuloEscravo.c,283 :: 		estado = 1;
	MOVLW       1
	MOVWF       _estado+0 
	MOVLW       0
	MOVWF       _estado+1 
;ModuloEscravo.c,284 :: 		resp = EX[2];
	MOVF        _EX+2, 0 
	MOVWF       _resp+0 
;ModuloEscravo.c,285 :: 		}
	GOTO        L_executarProtocolo64
L_executarProtocolo63:
;ModuloEscravo.c,286 :: 		else if(EX[1] =='0'){ // indica que a iluminação automatizada está desattivada
	MOVF        _EX+1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo65
;ModuloEscravo.c,287 :: 		estado = 3;
	MOVLW       3
	MOVWF       _estado+0 
	MOVLW       0
	MOVWF       _estado+1 
;ModuloEscravo.c,288 :: 		resp = EX[2];
	MOVF        _EX+2, 0 
	MOVWF       _resp+0 
;ModuloEscravo.c,289 :: 		}
L_executarProtocolo65:
L_executarProtocolo64:
;ModuloEscravo.c,291 :: 		EX[0] = '0';
	MOVLW       48
	MOVWF       _EX+0 
;ModuloEscravo.c,293 :: 		respondeProtocolo( '+', 'T', 'E', 'P', '+');
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
;ModuloEscravo.c,294 :: 		}
	GOTO        L_executarProtocolo66
L_executarProtocolo62:
;ModuloEscravo.c,296 :: 		else if(EX[0] =='H'){ //controle automatizado das lampadas ao abrir o portão
	MOVF        _EX+0, 0 
	XORLW       72
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo67
;ModuloEscravo.c,297 :: 		if (EX[1] == '1'){
	MOVF        _EX+1, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo68
;ModuloEscravo.c,298 :: 		servoRotate0();
	CALL        _servoRotate0+0, 0
;ModuloEscravo.c,299 :: 		}
	GOTO        L_executarProtocolo69
L_executarProtocolo68:
;ModuloEscravo.c,300 :: 		else if(EX[1] == '0'){
	MOVF        _EX+1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo70
;ModuloEscravo.c,301 :: 		servoRotate90();
	CALL        _servoRotate90+0, 0
;ModuloEscravo.c,302 :: 		}
L_executarProtocolo70:
L_executarProtocolo69:
;ModuloEscravo.c,304 :: 		EX[0] = 0;
	CLRF        _EX+0 
;ModuloEscravo.c,306 :: 		respondeProtocolo( '+', 'T', 'E', 'P', '+');
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
;ModuloEscravo.c,307 :: 		}
L_executarProtocolo67:
L_executarProtocolo66:
L_executarProtocolo61:
L_executarProtocolo55:
L_executarProtocolo43:
L_executarProtocolo37:
L_executarProtocolo15:
;ModuloEscravo.c,308 :: 		}
L_end_executarProtocolo:
	RETURN      0
; end of _executarProtocolo

_respondeProtocolo:

;ModuloEscravo.c,310 :: 		void respondeProtocolo(char r1, char r2, char r3, char r4, char r5) {
;ModuloEscravo.c,331 :: 		UART1_Write(r1);
	MOVF        FARG_respondeProtocolo_r1+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloEscravo.c,332 :: 		UART1_Write(r2);
	MOVF        FARG_respondeProtocolo_r2+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloEscravo.c,333 :: 		UART1_Write(r3);
	MOVF        FARG_respondeProtocolo_r3+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloEscravo.c,334 :: 		UART1_Write(r4);
	MOVF        FARG_respondeProtocolo_r4+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloEscravo.c,335 :: 		UART1_Write(r5);
	MOVF        FARG_respondeProtocolo_r5+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloEscravo.c,338 :: 		}
L_end_respondeProtocolo:
	RETURN      0
; end of _respondeProtocolo

_servoRotate0:

;ModuloEscravo.c,340 :: 		void servoRotate0()
;ModuloEscravo.c,343 :: 		for(i=0;i<50;i++)
	CLRF        R1 
	CLRF        R2 
L_servoRotate071:
	MOVLW       0
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__servoRotate0153
	MOVLW       50
	SUBWF       R1, 0 
L__servoRotate0153:
	BTFSC       STATUS+0, 0 
	GOTO        L_servoRotate072
;ModuloEscravo.c,345 :: 		PORTD.RD5 = 1;
	BSF         PORTD+0, 5 
;ModuloEscravo.c,346 :: 		Delay_us(800);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       8
	MOVWF       R13, 0
L_servoRotate074:
	DECFSZ      R13, 1, 1
	BRA         L_servoRotate074
	DECFSZ      R12, 1, 1
	BRA         L_servoRotate074
	NOP
;ModuloEscravo.c,347 :: 		PORTD.RD5 = 0;
	BCF         PORTD+0, 5 
;ModuloEscravo.c,348 :: 		Delay_us(19200);
	MOVLW       25
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_servoRotate075:
	DECFSZ      R13, 1, 1
	BRA         L_servoRotate075
	DECFSZ      R12, 1, 1
	BRA         L_servoRotate075
	NOP
;ModuloEscravo.c,343 :: 		for(i=0;i<50;i++)
	INFSNZ      R1, 1 
	INCF        R2, 1 
;ModuloEscravo.c,349 :: 		}
	GOTO        L_servoRotate071
L_servoRotate072:
;ModuloEscravo.c,350 :: 		}
L_end_servoRotate0:
	RETURN      0
; end of _servoRotate0

_servoRotate90:

;ModuloEscravo.c,352 :: 		void servoRotate90()
;ModuloEscravo.c,355 :: 		for(i=0;i<50;i++)
	CLRF        R1 
	CLRF        R2 
L_servoRotate9076:
	MOVLW       0
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__servoRotate90155
	MOVLW       50
	SUBWF       R1, 0 
L__servoRotate90155:
	BTFSC       STATUS+0, 0 
	GOTO        L_servoRotate9077
;ModuloEscravo.c,357 :: 		PORTD.RD5 = 1;
	BSF         PORTD+0, 5 
;ModuloEscravo.c,358 :: 		Delay_us(1500);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_servoRotate9079:
	DECFSZ      R13, 1, 1
	BRA         L_servoRotate9079
	DECFSZ      R12, 1, 1
	BRA         L_servoRotate9079
	NOP
	NOP
;ModuloEscravo.c,359 :: 		PORTD.RD5 = 0;
	BCF         PORTD+0, 5 
;ModuloEscravo.c,360 :: 		Delay_us(18500);
	MOVLW       25
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_servoRotate9080:
	DECFSZ      R13, 1, 1
	BRA         L_servoRotate9080
	DECFSZ      R12, 1, 1
	BRA         L_servoRotate9080
;ModuloEscravo.c,355 :: 		for(i=0;i<50;i++)
	INFSNZ      R1, 1 
	INCF        R2, 1 
;ModuloEscravo.c,361 :: 		}
	GOTO        L_servoRotate9076
L_servoRotate9077:
;ModuloEscravo.c,362 :: 		if(EX[2] !='0'&& EX[2] !='1'){
	MOVF        _EX+2, 0 
	XORLW       48
	BTFSC       STATUS+0, 2 
	GOTO        L_servoRotate9083
	MOVF        _EX+2, 0 
	XORLW       49
	BTFSC       STATUS+0, 2 
	GOTO        L_servoRotate9083
L__servoRotate90140:
;ModuloEscravo.c,363 :: 		autoTimer =1;
	MOVLW       1
	MOVWF       _AutoTimer+0 
	MOVLW       0
	MOVWF       _AutoTimer+1 
;ModuloEscravo.c,364 :: 		estado =1;
	MOVLW       1
	MOVWF       _estado+0 
	MOVLW       0
	MOVWF       _estado+1 
;ModuloEscravo.c,365 :: 		resp = EX[2];
	MOVF        _EX+2, 0 
	MOVWF       _resp+0 
;ModuloEscravo.c,366 :: 		}
L_servoRotate9083:
;ModuloEscravo.c,367 :: 		}
L_end_servoRotate90:
	RETURN      0
; end of _servoRotate90

_gerencia_alarme:

;ModuloEscravo.c,369 :: 		void gerencia_alarme(){
;ModuloEscravo.c,370 :: 		if(cercaIR == 1){
	MOVLW       0
	XORWF       _cercaIR+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerencia_alarme157
	MOVLW       1
	XORWF       _cercaIR+0, 0 
L__gerencia_alarme157:
	BTFSS       STATUS+0, 2 
	GOTO        L_gerencia_alarme84
;ModuloEscravo.c,371 :: 		barreira = ADC_Read(0);
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
;ModuloEscravo.c,372 :: 		if(barreira > 500 || sirene == 1){
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
	GOTO        L__gerencia_alarme141
	MOVLW       0
	XORWF       _sirene+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerencia_alarme158
	MOVLW       1
	XORWF       _sirene+0, 0 
L__gerencia_alarme158:
	BTFSC       STATUS+0, 2 
	GOTO        L__gerencia_alarme141
	GOTO        L_gerencia_alarme87
L__gerencia_alarme141:
;ModuloEscravo.c,373 :: 		sirene =1;
	MOVLW       1
	MOVWF       _sirene+0 
	MOVLW       0
	MOVWF       _sirene+1 
;ModuloEscravo.c,374 :: 		PORTE.RE0 = 1;
	BSF         PORTE+0, 0 
;ModuloEscravo.c,375 :: 		delay_ms(500);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_gerencia_alarme88:
	DECFSZ      R13, 1, 1
	BRA         L_gerencia_alarme88
	DECFSZ      R12, 1, 1
	BRA         L_gerencia_alarme88
	DECFSZ      R11, 1, 1
	BRA         L_gerencia_alarme88
	NOP
	NOP
;ModuloEscravo.c,376 :: 		PORTE.RE0 = 0;
	BCF         PORTE+0, 0 
;ModuloEscravo.c,377 :: 		delay_ms(500);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_gerencia_alarme89:
	DECFSZ      R13, 1, 1
	BRA         L_gerencia_alarme89
	DECFSZ      R12, 1, 1
	BRA         L_gerencia_alarme89
	DECFSZ      R11, 1, 1
	BRA         L_gerencia_alarme89
	NOP
	NOP
;ModuloEscravo.c,378 :: 		}
L_gerencia_alarme87:
;ModuloEscravo.c,379 :: 		}
	GOTO        L_gerencia_alarme90
L_gerencia_alarme84:
;ModuloEscravo.c,380 :: 		else if(cercaIR == 0){
	MOVLW       0
	XORWF       _cercaIR+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerencia_alarme159
	MOVLW       0
	XORWF       _cercaIR+0, 0 
L__gerencia_alarme159:
	BTFSS       STATUS+0, 2 
	GOTO        L_gerencia_alarme91
;ModuloEscravo.c,381 :: 		sirene =0;
	CLRF        _sirene+0 
	CLRF        _sirene+1 
;ModuloEscravo.c,382 :: 		PORTE.RE0 = 1;
	BSF         PORTE+0, 0 
;ModuloEscravo.c,383 :: 		}
L_gerencia_alarme91:
L_gerencia_alarme90:
;ModuloEscravo.c,384 :: 		}
L_end_gerencia_alarme:
	RETURN      0
; end of _gerencia_alarme

_iluminacao_automatizada:

;ModuloEscravo.c,386 :: 		void iluminacao_automatizada(){
;ModuloEscravo.c,387 :: 		if(estado == 1){ // ativa a iluminação automatizada
	MOVLW       0
	XORWF       _estado+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada161
	MOVLW       1
	XORWF       _estado+0, 0 
L__iluminacao_automatizada161:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada92
;ModuloEscravo.c,388 :: 		LDR = ADC_Read(2); //  leitura do pino analógico do sensor
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
;ModuloEscravo.c,389 :: 		if(LDR < 600){// ativa as luzes correspondentes
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
	GOTO        L_iluminacao_automatizada93
;ModuloEscravo.c,390 :: 		if(resp == '0'){
	MOVF        _resp+0, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada94
;ModuloEscravo.c,391 :: 		PORTD.RD0 = 0; //liga o LED A
	BCF         PORTD+0, 0 
;ModuloEscravo.c,392 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada162
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada162:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada95
;ModuloEscravo.c,393 :: 		INTCON.TMR0IE =1; // ativa interrupção do timer0
	BSF         INTCON+0, 5 
;ModuloEscravo.c,394 :: 		if(off==1){
	MOVLW       0
	XORWF       _off+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada163
	MOVLW       1
	XORWF       _off+0, 0 
L__iluminacao_automatizada163:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada96
;ModuloEscravo.c,395 :: 		PORTD.RD0 =1;
	BSF         PORTD+0, 0 
;ModuloEscravo.c,396 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,397 :: 		off=0;
	CLRF        _off+0 
	CLRF        _off+1 
;ModuloEscravo.c,398 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,399 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,400 :: 		}
L_iluminacao_automatizada96:
;ModuloEscravo.c,401 :: 		}
L_iluminacao_automatizada95:
;ModuloEscravo.c,402 :: 		}
L_iluminacao_automatizada94:
;ModuloEscravo.c,403 :: 		if(resp == '1'){
	MOVF        _resp+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada97
;ModuloEscravo.c,404 :: 		PORTD.RD1 = 0; //liga o LED B
	BCF         PORTD+0, 1 
;ModuloEscravo.c,405 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada164
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada164:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada98
;ModuloEscravo.c,406 :: 		INTCON.TMR0IE =1; // ativa interrupção do timer0
	BSF         INTCON+0, 5 
;ModuloEscravo.c,407 :: 		if(off==1){
	MOVLW       0
	XORWF       _off+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada165
	MOVLW       1
	XORWF       _off+0, 0 
L__iluminacao_automatizada165:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada99
;ModuloEscravo.c,408 :: 		PORTD.RD1 =1;
	BSF         PORTD+0, 1 
;ModuloEscravo.c,409 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,410 :: 		off=0;
	CLRF        _off+0 
	CLRF        _off+1 
;ModuloEscravo.c,411 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,412 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,413 :: 		}
L_iluminacao_automatizada99:
;ModuloEscravo.c,414 :: 		}
L_iluminacao_automatizada98:
;ModuloEscravo.c,415 :: 		}
L_iluminacao_automatizada97:
;ModuloEscravo.c,416 :: 		if(resp == '2'){
	MOVF        _resp+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada100
;ModuloEscravo.c,417 :: 		PORTD.RD2 = 0; //liga o LED C
	BCF         PORTD+0, 2 
;ModuloEscravo.c,418 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada166
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada166:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada101
;ModuloEscravo.c,419 :: 		INTCON.TMR0IE =1; // ativa interrupção do timer0
	BSF         INTCON+0, 5 
;ModuloEscravo.c,420 :: 		if(off==1){
	MOVLW       0
	XORWF       _off+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada167
	MOVLW       1
	XORWF       _off+0, 0 
L__iluminacao_automatizada167:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada102
;ModuloEscravo.c,421 :: 		PORTD.RD2 =1;
	BSF         PORTD+0, 2 
;ModuloEscravo.c,422 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,423 :: 		off=0;
	CLRF        _off+0 
	CLRF        _off+1 
;ModuloEscravo.c,424 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,425 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,426 :: 		}
L_iluminacao_automatizada102:
;ModuloEscravo.c,427 :: 		}
L_iluminacao_automatizada101:
;ModuloEscravo.c,428 :: 		}
L_iluminacao_automatizada100:
;ModuloEscravo.c,429 :: 		if(resp == '3'){
	MOVF        _resp+0, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada103
;ModuloEscravo.c,430 :: 		PORTD.RD3 = 0; //liga o LED D
	BCF         PORTD+0, 3 
;ModuloEscravo.c,431 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada168
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada168:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada104
;ModuloEscravo.c,432 :: 		INTCON.TMR0IE =1; // ativa interrupção do timer0
	BSF         INTCON+0, 5 
;ModuloEscravo.c,433 :: 		if(off==1){
	MOVLW       0
	XORWF       _off+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada169
	MOVLW       1
	XORWF       _off+0, 0 
L__iluminacao_automatizada169:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada105
;ModuloEscravo.c,434 :: 		PORTD.RD3 =1;
	BSF         PORTD+0, 3 
;ModuloEscravo.c,435 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,436 :: 		off=0;
	CLRF        _off+0 
	CLRF        _off+1 
;ModuloEscravo.c,437 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,438 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,439 :: 		}
L_iluminacao_automatizada105:
;ModuloEscravo.c,440 :: 		}
L_iluminacao_automatizada104:
;ModuloEscravo.c,441 :: 		}
L_iluminacao_automatizada103:
;ModuloEscravo.c,442 :: 		if(resp == '4'){
	MOVF        _resp+0, 0 
	XORLW       52
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada106
;ModuloEscravo.c,443 :: 		PORTD.RD4 = 0; //liga o LED E
	BCF         PORTD+0, 4 
;ModuloEscravo.c,444 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada170
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada170:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada107
;ModuloEscravo.c,445 :: 		INTCON.TMR0IE =1; // ativa interrupção do timer0
	BSF         INTCON+0, 5 
;ModuloEscravo.c,446 :: 		if(off==1){
	MOVLW       0
	XORWF       _off+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada171
	MOVLW       1
	XORWF       _off+0, 0 
L__iluminacao_automatizada171:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada108
;ModuloEscravo.c,447 :: 		PORTD.RD4 =1;
	BSF         PORTD+0, 4 
;ModuloEscravo.c,448 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,449 :: 		off=0;
	CLRF        _off+0 
	CLRF        _off+1 
;ModuloEscravo.c,450 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,451 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,452 :: 		}
L_iluminacao_automatizada108:
;ModuloEscravo.c,453 :: 		}
L_iluminacao_automatizada107:
;ModuloEscravo.c,454 :: 		}
L_iluminacao_automatizada106:
;ModuloEscravo.c,455 :: 		if(resp == '5'){
	MOVF        _resp+0, 0 
	XORLW       53
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada109
;ModuloEscravo.c,456 :: 		PORTD.RD0 = 0; //liga todos os LEDS
	BCF         PORTD+0, 0 
;ModuloEscravo.c,457 :: 		PORTD.RD1 = 0;
	BCF         PORTD+0, 1 
;ModuloEscravo.c,458 :: 		PORTD.RD2 = 0;
	BCF         PORTD+0, 2 
;ModuloEscravo.c,459 :: 		PORTD.RD3 = 0;
	BCF         PORTD+0, 3 
;ModuloEscravo.c,460 :: 		PORTD.RD4 = 0;
	BCF         PORTD+0, 4 
;ModuloEscravo.c,461 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada172
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada172:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada110
;ModuloEscravo.c,462 :: 		INTCON.TMR0IE =1; // ativa interrupção do timer0
	BSF         INTCON+0, 5 
;ModuloEscravo.c,463 :: 		if(off==1){
	MOVLW       0
	XORWF       _off+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada173
	MOVLW       1
	XORWF       _off+0, 0 
L__iluminacao_automatizada173:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada111
;ModuloEscravo.c,464 :: 		PORTD.RD0 = 1; //desliga todos os LEDS
	BSF         PORTD+0, 0 
;ModuloEscravo.c,465 :: 		PORTD.RD1 = 1;
	BSF         PORTD+0, 1 
;ModuloEscravo.c,466 :: 		PORTD.RD2 = 1;
	BSF         PORTD+0, 2 
;ModuloEscravo.c,467 :: 		PORTD.RD3 = 1;
	BSF         PORTD+0, 3 
;ModuloEscravo.c,468 :: 		PORTD.RD4 = 1;
	BSF         PORTD+0, 4 
;ModuloEscravo.c,469 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,470 :: 		off=0;
	CLRF        _off+0 
	CLRF        _off+1 
;ModuloEscravo.c,471 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,472 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,473 :: 		}
L_iluminacao_automatizada111:
;ModuloEscravo.c,474 :: 		}
L_iluminacao_automatizada110:
;ModuloEscravo.c,475 :: 		}
L_iluminacao_automatizada109:
;ModuloEscravo.c,476 :: 		}
	GOTO        L_iluminacao_automatizada112
L_iluminacao_automatizada93:
;ModuloEscravo.c,477 :: 		else if(LDR > 600){// desativa as luzes correspondentes
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
	GOTO        L_iluminacao_automatizada113
;ModuloEscravo.c,478 :: 		if(resp == '0'){
	MOVF        _resp+0, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada114
;ModuloEscravo.c,479 :: 		PORTD.RD0 = 1; //desliga o LED A
	BSF         PORTD+0, 0 
;ModuloEscravo.c,480 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada174
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada174:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada115
;ModuloEscravo.c,481 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,482 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,483 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,484 :: 		}
L_iluminacao_automatizada115:
;ModuloEscravo.c,486 :: 		}
L_iluminacao_automatizada114:
;ModuloEscravo.c,487 :: 		if(resp == '1'){
	MOVF        _resp+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada116
;ModuloEscravo.c,488 :: 		PORTD.RD1 = 1; //desliga o LED B
	BSF         PORTD+0, 1 
;ModuloEscravo.c,489 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada175
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada175:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada117
;ModuloEscravo.c,490 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,491 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,492 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,493 :: 		}
L_iluminacao_automatizada117:
;ModuloEscravo.c,494 :: 		}
L_iluminacao_automatizada116:
;ModuloEscravo.c,495 :: 		if(resp == '2'){
	MOVF        _resp+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada118
;ModuloEscravo.c,496 :: 		PORTD.RD2 = 1; //desliga o LED C
	BSF         PORTD+0, 2 
;ModuloEscravo.c,497 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada176
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada176:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada119
;ModuloEscravo.c,498 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,499 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,500 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,501 :: 		}
L_iluminacao_automatizada119:
;ModuloEscravo.c,502 :: 		}
L_iluminacao_automatizada118:
;ModuloEscravo.c,503 :: 		if(resp == '3'){
	MOVF        _resp+0, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada120
;ModuloEscravo.c,504 :: 		PORTD.RD3 = 1; //desliga o LED D
	BSF         PORTD+0, 3 
;ModuloEscravo.c,505 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada177
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada177:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada121
;ModuloEscravo.c,506 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,507 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,508 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,509 :: 		}
L_iluminacao_automatizada121:
;ModuloEscravo.c,510 :: 		}
L_iluminacao_automatizada120:
;ModuloEscravo.c,511 :: 		if(resp == '4'){
	MOVF        _resp+0, 0 
	XORLW       52
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada122
;ModuloEscravo.c,512 :: 		PORTD.RD4 = 1; //desliga o LED E
	BSF         PORTD+0, 4 
;ModuloEscravo.c,513 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada178
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada178:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada123
;ModuloEscravo.c,514 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,515 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,516 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,517 :: 		}
L_iluminacao_automatizada123:
;ModuloEscravo.c,518 :: 		}
L_iluminacao_automatizada122:
;ModuloEscravo.c,519 :: 		if(resp == '5'){
	MOVF        _resp+0, 0 
	XORLW       53
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada124
;ModuloEscravo.c,520 :: 		PORTD.RD0 = 1; //desliga todos os LEDS
	BSF         PORTD+0, 0 
;ModuloEscravo.c,521 :: 		PORTD.RD1 = 1;
	BSF         PORTD+0, 1 
;ModuloEscravo.c,522 :: 		PORTD.RD2 = 1;
	BSF         PORTD+0, 2 
;ModuloEscravo.c,523 :: 		PORTD.RD3 = 1;
	BSF         PORTD+0, 3 
;ModuloEscravo.c,524 :: 		PORTD.RD4 = 1;
	BSF         PORTD+0, 4 
;ModuloEscravo.c,525 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada179
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada179:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada125
;ModuloEscravo.c,526 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,527 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,528 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,529 :: 		}
L_iluminacao_automatizada125:
;ModuloEscravo.c,530 :: 		}
L_iluminacao_automatizada124:
;ModuloEscravo.c,531 :: 		}
L_iluminacao_automatizada113:
L_iluminacao_automatizada112:
;ModuloEscravo.c,532 :: 		}
	GOTO        L_iluminacao_automatizada126
L_iluminacao_automatizada92:
;ModuloEscravo.c,533 :: 		else if(estado ==3){
	MOVLW       0
	XORWF       _estado+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada180
	MOVLW       3
	XORWF       _estado+0, 0 
L__iluminacao_automatizada180:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada127
;ModuloEscravo.c,534 :: 		if(resp == '0'){
	MOVF        _resp+0, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada128
;ModuloEscravo.c,535 :: 		PORTD.RD0 = 1; //desliga o LED A
	BSF         PORTD+0, 0 
;ModuloEscravo.c,536 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada181
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada181:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada129
;ModuloEscravo.c,537 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,538 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,539 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,540 :: 		}
L_iluminacao_automatizada129:
;ModuloEscravo.c,541 :: 		}
L_iluminacao_automatizada128:
;ModuloEscravo.c,542 :: 		if(resp == '1'){
	MOVF        _resp+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada130
;ModuloEscravo.c,543 :: 		PORTD.RD1 = 1; //desliga o LED B
	BSF         PORTD+0, 1 
;ModuloEscravo.c,544 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada182
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada182:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada131
;ModuloEscravo.c,545 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,546 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,547 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,548 :: 		}
L_iluminacao_automatizada131:
;ModuloEscravo.c,549 :: 		}
L_iluminacao_automatizada130:
;ModuloEscravo.c,550 :: 		if(resp == '2'){
	MOVF        _resp+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada132
;ModuloEscravo.c,551 :: 		PORTD.RD2 = 1; //desliga o LED C
	BSF         PORTD+0, 2 
;ModuloEscravo.c,552 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada183
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada183:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada133
;ModuloEscravo.c,553 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,554 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,555 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,556 :: 		}
L_iluminacao_automatizada133:
;ModuloEscravo.c,557 :: 		}
L_iluminacao_automatizada132:
;ModuloEscravo.c,558 :: 		if(resp == '3'){
	MOVF        _resp+0, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada134
;ModuloEscravo.c,559 :: 		PORTD.RD3 = 1; //desliga o LED D
	BSF         PORTD+0, 3 
;ModuloEscravo.c,560 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada184
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada184:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada135
;ModuloEscravo.c,561 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,562 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,563 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,564 :: 		}
L_iluminacao_automatizada135:
;ModuloEscravo.c,565 :: 		}
L_iluminacao_automatizada134:
;ModuloEscravo.c,566 :: 		if(resp == '4'){
	MOVF        _resp+0, 0 
	XORLW       52
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada136
;ModuloEscravo.c,567 :: 		PORTD.RD4 = 1; //desliga o LED E
	BSF         PORTD+0, 4 
;ModuloEscravo.c,568 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada185
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada185:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada137
;ModuloEscravo.c,569 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,570 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,571 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,572 :: 		}
L_iluminacao_automatizada137:
;ModuloEscravo.c,573 :: 		}
L_iluminacao_automatizada136:
;ModuloEscravo.c,574 :: 		if(resp == '5'){
	MOVF        _resp+0, 0 
	XORLW       53
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada138
;ModuloEscravo.c,575 :: 		PORTD.RD0 = 1; //desliga todos os LEDS
	BSF         PORTD+0, 0 
;ModuloEscravo.c,576 :: 		PORTD.RD1 = 1;
	BSF         PORTD+0, 1 
;ModuloEscravo.c,577 :: 		PORTD.RD2 = 1;
	BSF         PORTD+0, 2 
;ModuloEscravo.c,578 :: 		PORTD.RD3 = 1;
	BSF         PORTD+0, 3 
;ModuloEscravo.c,579 :: 		PORTD.RD4 = 1;
	BSF         PORTD+0, 4 
;ModuloEscravo.c,580 :: 		if(AutoTimer ==1){
	MOVLW       0
	XORWF       _AutoTimer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__iluminacao_automatizada186
	MOVLW       1
	XORWF       _AutoTimer+0, 0 
L__iluminacao_automatizada186:
	BTFSS       STATUS+0, 2 
	GOTO        L_iluminacao_automatizada139
;ModuloEscravo.c,581 :: 		AutoTimer =0;
	CLRF        _AutoTimer+0 
	CLRF        _AutoTimer+1 
;ModuloEscravo.c,582 :: 		estado =0;
	CLRF        _estado+0 
	CLRF        _estado+1 
;ModuloEscravo.c,583 :: 		INTCON.TMR0IE =0;
	BCF         INTCON+0, 5 
;ModuloEscravo.c,584 :: 		}
L_iluminacao_automatizada139:
;ModuloEscravo.c,585 :: 		}
L_iluminacao_automatizada138:
;ModuloEscravo.c,586 :: 		}
L_iluminacao_automatizada127:
L_iluminacao_automatizada126:
;ModuloEscravo.c,587 :: 		}
L_end_iluminacao_automatizada:
	RETURN      0
; end of _iluminacao_automatizada
