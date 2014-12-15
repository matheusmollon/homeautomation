
_main:

;ModuloCentral.c,19 :: 		void main() {
;ModuloCentral.c,20 :: 		UART1_init(9600);
	MOVLW       25
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;ModuloCentral.c,21 :: 		Delay_ms(100);
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
;ModuloCentral.c,24 :: 		RCON.IPEN = 1;
	BSF         RCON+0, 7 
;ModuloCentral.c,25 :: 		INTCON.GIEH = 1;
	BSF         INTCON+0, 7 
;ModuloCentral.c,26 :: 		INTCON.GIEL = 1;
	BSF         INTCON+0, 6 
;ModuloCentral.c,29 :: 		IPR1.RCIP = 1; //alta prioridade
	BSF         IPR1+0, 5 
;ModuloCentral.c,30 :: 		PIR1.RCIF = 0; //flag de sinalização
	BCF         PIR1+0, 5 
;ModuloCentral.c,31 :: 		PIE1.RCIE = 1; //Enable da interrupção Serial RX
	BSF         PIE1+0, 5 
;ModuloCentral.c,33 :: 		while(1) {
L_main1:
;ModuloCentral.c,34 :: 		}
	GOTO        L_main1
;ModuloCentral.c,35 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;ModuloCentral.c,37 :: 		void interrupt() {
;ModuloCentral.c,38 :: 		if(PIR1.RCIF == 1) { // indica que a interrupção foi disparada pela Serial RX
	BTFSS       PIR1+0, 5 
	GOTO        L_interrupt3
;ModuloCentral.c,40 :: 		lerProtocolo();
	CALL        _lerProtocolo+0, 0
;ModuloCentral.c,41 :: 		}
L_interrupt3:
;ModuloCentral.c,42 :: 		if(PIR1.TMR1IF == 1){
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt4
;ModuloCentral.c,43 :: 		PIE1.TMR1IE = 0;
	BCF         PIE1+0, 0 
;ModuloCentral.c,44 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;ModuloCentral.c,45 :: 		executarProtocolo();
	CALL        _executarProtocolo+0, 0
;ModuloCentral.c,46 :: 		}
L_interrupt4:
;ModuloCentral.c,47 :: 		}
L_end_interrupt:
L__interrupt37:
	RETFIE      1
; end of _interrupt

_lerProtocolo:

;ModuloCentral.c,49 :: 		void lerProtocolo(void) { //função que lê o protocolo e chama sua execução
;ModuloCentral.c,51 :: 		if(UART1_Data_Ready()) {
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_lerProtocolo5
;ModuloCentral.c,53 :: 		lido = UART1_Read(); // lê o byte de inicio do protocolo
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _lido+0 
;ModuloCentral.c,55 :: 		if(lido == '[') { // se for '[' indica que o protocolo eh de identificação do módulo
	MOVF        R0, 0 
	XORLW       91
	BTFSS       STATUS+0, 2 
	GOTO        L_lerProtocolo6
;ModuloCentral.c,56 :: 		UART1_Read_Text(ID, "]", 4);
	MOVLW       _ID+0
	MOVWF       FARG_UART1_Read_Text_Output+0 
	MOVLW       hi_addr(_ID+0)
	MOVWF       FARG_UART1_Read_Text_Output+1 
	MOVLW       ?lstr1_ModuloCentral+0
	MOVWF       FARG_UART1_Read_Text_Delimiter+0 
	MOVLW       hi_addr(?lstr1_ModuloCentral+0)
	MOVWF       FARG_UART1_Read_Text_Delimiter+1 
	MOVLW       4
	MOVWF       FARG_UART1_Read_Text_Attempts+0 
	CALL        _UART1_Read_Text+0, 0
;ModuloCentral.c,57 :: 		executarProtocolo();
	CALL        _executarProtocolo+0, 0
;ModuloCentral.c,58 :: 		}
	GOTO        L_lerProtocolo7
L_lerProtocolo6:
;ModuloCentral.c,60 :: 		else if(lido == '{') { // se for '{' indica que o protocolo eh de envio ao ME
	MOVF        _lido+0, 0 
	XORLW       123
	BTFSS       STATUS+0, 2 
	GOTO        L_lerProtocolo8
;ModuloCentral.c,61 :: 		UART1_Read_Text(ME, "}", 11);
	MOVLW       _ME+0
	MOVWF       FARG_UART1_Read_Text_Output+0 
	MOVLW       hi_addr(_ME+0)
	MOVWF       FARG_UART1_Read_Text_Output+1 
	MOVLW       ?lstr2_ModuloCentral+0
	MOVWF       FARG_UART1_Read_Text_Delimiter+0 
	MOVLW       hi_addr(?lstr2_ModuloCentral+0)
	MOVWF       FARG_UART1_Read_Text_Delimiter+1 
	MOVLW       11
	MOVWF       FARG_UART1_Read_Text_Attempts+0 
	CALL        _UART1_Read_Text+0, 0
;ModuloCentral.c,62 :: 		executarProtocolo();
	CALL        _executarProtocolo+0, 0
;ModuloCentral.c,63 :: 		}
	GOTO        L_lerProtocolo9
L_lerProtocolo8:
;ModuloCentral.c,65 :: 		else if(lido == '+') { // ser for '+' indica que o protocolo eh de resposta
	MOVF        _lido+0, 0 
	XORLW       43
	BTFSS       STATUS+0, 2 
	GOTO        L_lerProtocolo10
;ModuloCentral.c,66 :: 		UART1_Read_Text(RE, "+", 4);
	MOVLW       _RE+0
	MOVWF       FARG_UART1_Read_Text_Output+0 
	MOVLW       hi_addr(_RE+0)
	MOVWF       FARG_UART1_Read_Text_Output+1 
	MOVLW       ?lstr3_ModuloCentral+0
	MOVWF       FARG_UART1_Read_Text_Delimiter+0 
	MOVLW       hi_addr(?lstr3_ModuloCentral+0)
	MOVWF       FARG_UART1_Read_Text_Delimiter+1 
	MOVLW       4
	MOVWF       FARG_UART1_Read_Text_Attempts+0 
	CALL        _UART1_Read_Text+0, 0
;ModuloCentral.c,67 :: 		executarProtocolo();
	CALL        _executarProtocolo+0, 0
;ModuloCentral.c,68 :: 		}
L_lerProtocolo10:
L_lerProtocolo9:
L_lerProtocolo7:
;ModuloCentral.c,69 :: 		}
L_lerProtocolo5:
;ModuloCentral.c,70 :: 		}
L_end_lerProtocolo:
	RETURN      0
; end of _lerProtocolo

_executarProtocolo:

;ModuloCentral.c,72 :: 		void executarProtocolo(void) {
;ModuloCentral.c,75 :: 		if(ID[0] == 'M') { //O ID deste módulo é M00
	MOVF        _ID+0, 0 
	XORLW       77
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo11
;ModuloCentral.c,76 :: 		if(ID[1] == '0') {
	MOVF        _ID+1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo12
;ModuloCentral.c,77 :: 		if(ID[2] == '0') {
	MOVF        _ID+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo13
;ModuloCentral.c,78 :: 		respondeProtocolo('+', ID[0], ID[1], ID[2], '+');
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	MOVF        _ID+0, 0 
	MOVWF       FARG_respondeProtocolo+0 
	MOVF        _ID+1, 0 
	MOVWF       FARG_respondeProtocolo+0 
	MOVF        _ID+2, 0 
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	CALL        _respondeProtocolo+0, 0
;ModuloCentral.c,79 :: 		ID[0] = '0' ;
	MOVLW       48
	MOVWF       _ID+0 
;ModuloCentral.c,80 :: 		}
L_executarProtocolo13:
;ModuloCentral.c,81 :: 		}
L_executarProtocolo12:
;ModuloCentral.c,82 :: 		}
	GOTO        L_executarProtocolo14
L_executarProtocolo11:
;ModuloCentral.c,85 :: 		else if(ME[0] == '[' && ME[4] == ']') { // Os 5 primeiro bytes são para protocolo de ID
	MOVF        _ME+0, 0 
	XORLW       91
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo17
	MOVF        _ME+4, 0 
	XORLW       93
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo17
L__executarProtocolo34:
;ModuloCentral.c,86 :: 		enviarProtocolo(ME[0], ME[1], ME[2], ME[3], ME[4]);
	MOVF        _ME+0, 0 
	MOVWF       FARG_enviarProtocolo+0 
	MOVF        _ME+1, 0 
	MOVWF       FARG_enviarProtocolo+0 
	MOVF        _ME+2, 0 
	MOVWF       FARG_enviarProtocolo+0 
	MOVF        _ME+3, 0 
	MOVWF       FARG_enviarProtocolo+0 
	MOVF        _ME+4, 0 
	MOVWF       FARG_enviarProtocolo+0 
	CALL        _enviarProtocolo+0, 0
;ModuloCentral.c,87 :: 		ME[0] = '0';
	MOVLW       48
	MOVWF       _ME+0 
;ModuloCentral.c,88 :: 		}
	GOTO        L_executarProtocolo18
L_executarProtocolo17:
;ModuloCentral.c,90 :: 		else if(ME[1] == RE[0] && ME[2] == RE[1] && ME[3] == RE[2]) {
	MOVF        _ME+1, 0 
	XORWF       _RE+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo21
	MOVF        _ME+2, 0 
	XORWF       _RE+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo21
	MOVF        _ME+3, 0 
	XORWF       _RE+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo21
L__executarProtocolo33:
;ModuloCentral.c,92 :: 		if(ME[5] == '(' && ME[9] == ')') { // Os 5 últimos para executar protocolos no ME
	MOVF        _ME+5, 0 
	XORLW       40
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo24
	MOVF        _ME+9, 0 
	XORLW       41
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo24
L__executarProtocolo32:
;ModuloCentral.c,93 :: 		enviarProtocolo(ME[5], ME[6], ME[7], ME[8], ME[9]);
	MOVF        _ME+5, 0 
	MOVWF       FARG_enviarProtocolo+0 
	MOVF        _ME+6, 0 
	MOVWF       FARG_enviarProtocolo+0 
	MOVF        _ME+7, 0 
	MOVWF       FARG_enviarProtocolo+0 
	MOVF        _ME+8, 0 
	MOVWF       FARG_enviarProtocolo+0 
	MOVF        _ME+9, 0 
	MOVWF       FARG_enviarProtocolo+0 
	CALL        _enviarProtocolo+0, 0
;ModuloCentral.c,94 :: 		ME[5] = '0';
	MOVLW       48
	MOVWF       _ME+5 
;ModuloCentral.c,95 :: 		}
L_executarProtocolo24:
;ModuloCentral.c,96 :: 		RE[0] = '0';
	MOVLW       48
	MOVWF       _RE+0 
;ModuloCentral.c,97 :: 		}
	GOTO        L_executarProtocolo25
L_executarProtocolo21:
;ModuloCentral.c,99 :: 		else if(RE[0] == 'T' && RE[1] == 'E' && RE[2] == 'P') {
	MOVF        _RE+0, 0 
	XORLW       84
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo28
	MOVF        _RE+1, 0 
	XORLW       69
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo28
	MOVF        _RE+2, 0 
	XORLW       80
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo28
L__executarProtocolo31:
;ModuloCentral.c,100 :: 		respondeProtocolo( '+', 'E', 'O', 'K', '+');
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       69
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       79
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       75
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	CALL        _respondeProtocolo+0, 0
;ModuloCentral.c,101 :: 		RE[0] = '0';
	MOVLW       48
	MOVWF       _RE+0 
;ModuloCentral.c,102 :: 		}
	GOTO        L_executarProtocolo29
L_executarProtocolo28:
;ModuloCentral.c,104 :: 		else if(flag == 1){
	MOVLW       0
	XORWF       _flag+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__executarProtocolo40
	MOVLW       1
	XORWF       _flag+0, 0 
L__executarProtocolo40:
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo30
;ModuloCentral.c,105 :: 		respondeProtocolo('+', 'E', 'N', 'O', '+');
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       69
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       78
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       79
	MOVWF       FARG_respondeProtocolo+0 
	MOVLW       43
	MOVWF       FARG_respondeProtocolo+0 
	CALL        _respondeProtocolo+0, 0
;ModuloCentral.c,106 :: 		flag =0;
	CLRF        _flag+0 
	CLRF        _flag+1 
;ModuloCentral.c,107 :: 		}
L_executarProtocolo30:
L_executarProtocolo29:
L_executarProtocolo25:
L_executarProtocolo18:
L_executarProtocolo14:
;ModuloCentral.c,108 :: 		}
L_end_executarProtocolo:
	RETURN      0
; end of _executarProtocolo

_respondeProtocolo:

;ModuloCentral.c,110 :: 		void respondeProtocolo(char r1, char r2, char r3, char r4, char r5) {
;ModuloCentral.c,132 :: 		UART1_Write(r1);
	MOVF        FARG_respondeProtocolo_r1+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,133 :: 		UART1_Write(r2);
	MOVF        FARG_respondeProtocolo_r2+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,134 :: 		UART1_Write(r3);
	MOVF        FARG_respondeProtocolo_r3+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,135 :: 		UART1_Write(r4);
	MOVF        FARG_respondeProtocolo_r4+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,136 :: 		UART1_Write(r5);
	MOVF        FARG_respondeProtocolo_r5+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,141 :: 		}
L_end_respondeProtocolo:
	RETURN      0
; end of _respondeProtocolo

_enviarProtocolo:

;ModuloCentral.c,143 :: 		void enviarProtocolo(char r1, char r2, char r3, char r4, char r5) {
;ModuloCentral.c,166 :: 		UART1_Write(r1);
	MOVF        FARG_enviarProtocolo_r1+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,167 :: 		UART1_Write(r2);
	MOVF        FARG_enviarProtocolo_r2+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,168 :: 		UART1_Write(r3);
	MOVF        FARG_enviarProtocolo_r3+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,169 :: 		UART1_Write(r4);
	MOVF        FARG_enviarProtocolo_r4+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,170 :: 		UART1_Write(r5);
	MOVF        FARG_enviarProtocolo_r5+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,175 :: 		}
L_end_enviarProtocolo:
	RETURN      0
; end of _enviarProtocolo
