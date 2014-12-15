
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
;ModuloCentral.c,30 :: 		RCON.IPEN = 1;
	BSF         RCON+0, 7 
;ModuloCentral.c,31 :: 		INTCON.GIEH = 1;
	BSF         INTCON+0, 7 
;ModuloCentral.c,32 :: 		INTCON.GIEL = 1;
	BSF         INTCON+0, 6 
;ModuloCentral.c,58 :: 		IPR1.RCIP = 1; //baixa prioridade
	BSF         IPR1+0, 5 
;ModuloCentral.c,59 :: 		PIR1.RCIF = 0; //flag de sinalização
	BCF         PIR1+0, 5 
;ModuloCentral.c,60 :: 		PIE1.RCIE = 1; //Enable da interrupção Serial RX
	BSF         PIE1+0, 5 
;ModuloCentral.c,62 :: 		while(1) {
L_main1:
;ModuloCentral.c,63 :: 		}
	GOTO        L_main1
;ModuloCentral.c,64 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;ModuloCentral.c,80 :: 		void interrupt() {
;ModuloCentral.c,81 :: 		if(PIR1.RCIF == 1) { // indica que a interrupção foi disparada pela Serial RX
	BTFSS       PIR1+0, 5 
	GOTO        L_interrupt3
;ModuloCentral.c,83 :: 		lerProtocolo();
	CALL        _lerProtocolo+0, 0
;ModuloCentral.c,84 :: 		}
L_interrupt3:
;ModuloCentral.c,85 :: 		if(PIR1.TMR1IF == 1){
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt4
;ModuloCentral.c,86 :: 		PIE1.TMR1IE = 0;
	BCF         PIE1+0, 0 
;ModuloCentral.c,87 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;ModuloCentral.c,88 :: 		executarProtocolo();
	CALL        _executarProtocolo+0, 0
;ModuloCentral.c,89 :: 		}
L_interrupt4:
;ModuloCentral.c,90 :: 		}
L_end_interrupt:
L__interrupt37:
	RETFIE      1
; end of _interrupt

_lerProtocolo:

;ModuloCentral.c,92 :: 		void lerProtocolo(void) { //função que lê o protocolo e chama sua execução
;ModuloCentral.c,94 :: 		if(UART1_Data_Ready()) {
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_lerProtocolo5
;ModuloCentral.c,96 :: 		lido = UART1_Read(); // lê o byte de inicio do protocolo
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _lido+0 
;ModuloCentral.c,98 :: 		if(lido == '[') { // se for '[' indica que o protocolo eh de identificação do módulo
	MOVF        R0, 0 
	XORLW       91
	BTFSS       STATUS+0, 2 
	GOTO        L_lerProtocolo6
;ModuloCentral.c,99 :: 		UART1_Read_Text(ID, "]", 4);
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
;ModuloCentral.c,100 :: 		executarProtocolo();
	CALL        _executarProtocolo+0, 0
;ModuloCentral.c,101 :: 		}
	GOTO        L_lerProtocolo7
L_lerProtocolo6:
;ModuloCentral.c,103 :: 		else if(lido == '{') { // se for '{' indica que o protocolo eh de envio ao ME
	MOVF        _lido+0, 0 
	XORLW       123
	BTFSS       STATUS+0, 2 
	GOTO        L_lerProtocolo8
;ModuloCentral.c,104 :: 		UART1_Read_Text(ME, "}", 11);
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
;ModuloCentral.c,105 :: 		executarProtocolo();
	CALL        _executarProtocolo+0, 0
;ModuloCentral.c,106 :: 		}
	GOTO        L_lerProtocolo9
L_lerProtocolo8:
;ModuloCentral.c,108 :: 		else if(lido == '+') { // ser for '+' indica que o protocolo eh de resposta
	MOVF        _lido+0, 0 
	XORLW       43
	BTFSS       STATUS+0, 2 
	GOTO        L_lerProtocolo10
;ModuloCentral.c,109 :: 		UART1_Read_Text(RE, "+", 4);
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
;ModuloCentral.c,110 :: 		executarProtocolo();
	CALL        _executarProtocolo+0, 0
;ModuloCentral.c,111 :: 		}
L_lerProtocolo10:
L_lerProtocolo9:
L_lerProtocolo7:
;ModuloCentral.c,112 :: 		}
L_lerProtocolo5:
;ModuloCentral.c,113 :: 		}
L_end_lerProtocolo:
	RETURN      0
; end of _lerProtocolo

_executarProtocolo:

;ModuloCentral.c,115 :: 		void executarProtocolo(void) {
;ModuloCentral.c,118 :: 		if(ID[0] == 'M') { //O ID deste módulo é M00
	MOVF        _ID+0, 0 
	XORLW       77
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo11
;ModuloCentral.c,119 :: 		if(ID[1] == '0') {
	MOVF        _ID+1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo12
;ModuloCentral.c,120 :: 		if(ID[2] == '0') {
	MOVF        _ID+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo13
;ModuloCentral.c,121 :: 		respondeProtocolo('+', ID[0], ID[1], ID[2], '+');
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
;ModuloCentral.c,122 :: 		ID[0] = '0' ;
	MOVLW       48
	MOVWF       _ID+0 
;ModuloCentral.c,126 :: 		}
L_executarProtocolo13:
;ModuloCentral.c,127 :: 		}
L_executarProtocolo12:
;ModuloCentral.c,128 :: 		}
	GOTO        L_executarProtocolo14
L_executarProtocolo11:
;ModuloCentral.c,131 :: 		else if(ME[0] == '[' && ME[4] == ']') { // Os 5 primeiro bytes são para protocolo de ID
	MOVF        _ME+0, 0 
	XORLW       91
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo17
	MOVF        _ME+4, 0 
	XORLW       93
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo17
L__executarProtocolo34:
;ModuloCentral.c,132 :: 		enviarProtocolo(ME[0], ME[1], ME[2], ME[3], ME[4]);
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
;ModuloCentral.c,133 :: 		ME[0] = '0';
	MOVLW       48
	MOVWF       _ME+0 
;ModuloCentral.c,134 :: 		}
	GOTO        L_executarProtocolo18
L_executarProtocolo17:
;ModuloCentral.c,136 :: 		else if(ME[1] == RE[0] && ME[2] == RE[1] && ME[3] == RE[2]) {
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
;ModuloCentral.c,138 :: 		if(ME[5] == '(' && ME[9] == ')') { // Os 5 últimos para executar protocolos no ME
	MOVF        _ME+5, 0 
	XORLW       40
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo24
	MOVF        _ME+9, 0 
	XORLW       41
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo24
L__executarProtocolo32:
;ModuloCentral.c,139 :: 		enviarProtocolo(ME[5], ME[6], ME[7], ME[8], ME[9]);
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
;ModuloCentral.c,140 :: 		ME[5] = '0';
	MOVLW       48
	MOVWF       _ME+5 
;ModuloCentral.c,141 :: 		}
L_executarProtocolo24:
;ModuloCentral.c,142 :: 		RE[0] = '0';
	MOVLW       48
	MOVWF       _RE+0 
;ModuloCentral.c,143 :: 		}
	GOTO        L_executarProtocolo25
L_executarProtocolo21:
;ModuloCentral.c,145 :: 		else if(RE[0] == 'T' && RE[1] == 'E' && RE[2] == 'P') {
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
;ModuloCentral.c,146 :: 		respondeProtocolo( '+', 'E', 'O', 'K', '+');
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
;ModuloCentral.c,147 :: 		RE[0] = '0';
	MOVLW       48
	MOVWF       _RE+0 
;ModuloCentral.c,148 :: 		}
	GOTO        L_executarProtocolo29
L_executarProtocolo28:
;ModuloCentral.c,150 :: 		else if(flag == 1){
	MOVLW       0
	XORWF       _flag+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__executarProtocolo40
	MOVLW       1
	XORWF       _flag+0, 0 
L__executarProtocolo40:
	BTFSS       STATUS+0, 2 
	GOTO        L_executarProtocolo30
;ModuloCentral.c,151 :: 		respondeProtocolo('+', 'E', 'N', 'O', '+');
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
;ModuloCentral.c,152 :: 		flag =0;
	CLRF        _flag+0 
	CLRF        _flag+1 
;ModuloCentral.c,153 :: 		}
L_executarProtocolo30:
L_executarProtocolo29:
L_executarProtocolo25:
L_executarProtocolo18:
L_executarProtocolo14:
;ModuloCentral.c,154 :: 		}
L_end_executarProtocolo:
	RETURN      0
; end of _executarProtocolo

_respondeProtocolo:

;ModuloCentral.c,156 :: 		void respondeProtocolo(char r1, char r2, char r3, char r4, char r5) {
;ModuloCentral.c,160 :: 		UART1_Write(0x7E);
	MOVLW       126
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,161 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,162 :: 		UART1_Write(0x13);
	MOVLW       19
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,163 :: 		UART1_Write(0x10);
	MOVLW       16
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,164 :: 		UART1_Write(0x01);
	MOVLW       1
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,165 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,166 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,167 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,168 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,169 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,170 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,171 :: 		UART1_Write(0xFF);
	MOVLW       255
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,172 :: 		UART1_Write(0xFF);
	MOVLW       255
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,173 :: 		UART1_Write(0xFF);
	MOVLW       255
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,174 :: 		UART1_Write(0xFE);
	MOVLW       254
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,175 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,176 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,177 :: 		UART1_Write(r1);
	MOVF        FARG_respondeProtocolo_r1+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,178 :: 		UART1_Write(r2);
	MOVF        FARG_respondeProtocolo_r2+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,179 :: 		UART1_Write(r3);
	MOVF        FARG_respondeProtocolo_r3+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,180 :: 		UART1_Write(r4);
	MOVF        FARG_respondeProtocolo_r4+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,181 :: 		UART1_Write(r5);
	MOVF        FARG_respondeProtocolo_r5+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,182 :: 		checksum = (0xFF - ((0x10 + 0x01 + 0xFF + 0xFF + 0xFF + 0xFE + r1 + r2 + r3 + r4 + r5) & 0xFF));
	MOVF        FARG_respondeProtocolo_r1+0, 0 
	ADDLW       12
	MOVWF       R0 
	MOVF        FARG_respondeProtocolo_r2+0, 0 
	ADDWF       R0, 1 
	MOVF        FARG_respondeProtocolo_r3+0, 0 
	ADDWF       R0, 1 
	MOVF        FARG_respondeProtocolo_r4+0, 0 
	ADDWF       R0, 1 
	MOVF        FARG_respondeProtocolo_r5+0, 0 
	ADDWF       R0, 1 
	MOVLW       255
	ANDWF       R0, 1 
	MOVF        R0, 0 
	SUBLW       255
	MOVWF       FARG_UART1_Write_data_+0 
;ModuloCentral.c,183 :: 		UART1_Write(checksum);
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,184 :: 		}
L_end_respondeProtocolo:
	RETURN      0
; end of _respondeProtocolo

_enviarProtocolo:

;ModuloCentral.c,186 :: 		void enviarProtocolo(char r1, char r2, char r3, char r4, char r5) {
;ModuloCentral.c,190 :: 		UART1_Write(0x7E);
	MOVLW       126
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,191 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,192 :: 		UART1_Write(0x13);
	MOVLW       19
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,193 :: 		UART1_Write(0x10);
	MOVLW       16
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,194 :: 		UART1_Write(0x01);
	MOVLW       1
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,195 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,196 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,197 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,198 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,199 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,200 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,201 :: 		UART1_Write(0xFF);
	MOVLW       255
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,202 :: 		UART1_Write(0xFF);
	MOVLW       255
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,203 :: 		UART1_Write(0xFF);
	MOVLW       255
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,204 :: 		UART1_Write(0xFE);
	MOVLW       254
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,205 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,206 :: 		UART1_Write(0x00);
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,207 :: 		UART1_Write(r1);
	MOVF        FARG_enviarProtocolo_r1+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,208 :: 		UART1_Write(r2);
	MOVF        FARG_enviarProtocolo_r2+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,209 :: 		UART1_Write(r3);
	MOVF        FARG_enviarProtocolo_r3+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,210 :: 		UART1_Write(r4);
	MOVF        FARG_enviarProtocolo_r4+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,211 :: 		UART1_Write(r5);
	MOVF        FARG_enviarProtocolo_r5+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,212 :: 		checksum = (0xFF - ((0x10 + 0x01 + 0xFF + 0xFF + 0xFF + 0xFE + r1 + r2 + r3 + r4 + r5) & 0xFF));
	MOVF        FARG_enviarProtocolo_r1+0, 0 
	ADDLW       12
	MOVWF       R0 
	MOVF        FARG_enviarProtocolo_r2+0, 0 
	ADDWF       R0, 1 
	MOVF        FARG_enviarProtocolo_r3+0, 0 
	ADDWF       R0, 1 
	MOVF        FARG_enviarProtocolo_r4+0, 0 
	ADDWF       R0, 1 
	MOVF        FARG_enviarProtocolo_r5+0, 0 
	ADDWF       R0, 1 
	MOVLW       255
	ANDWF       R0, 1 
	MOVF        R0, 0 
	SUBLW       255
	MOVWF       FARG_UART1_Write_data_+0 
;ModuloCentral.c,213 :: 		UART1_Write(checksum);
	CALL        _UART1_Write+0, 0
;ModuloCentral.c,214 :: 		}
L_end_enviarProtocolo:
	RETURN      0
; end of _enviarProtocolo
