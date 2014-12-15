//vari�veis globais:
//vari�veis de protocolo
char lido;// l� o byte de inicio do protocolo
char ID[4];// armazena protocolo de identificacao
char ME[11];// armazena protocolo de envio ao ME {[M0X](IXX)}
char RE[4];// armazena protocolo de resposta

//flags
int flag;

//-----------------------------------------------------//
//prot�tipos das fun��es
//fun��es de protocolo
void lerProtocolo(void);// fun��o para leitura dos protocolos
void executarProtocolo(void); //fun��o para execu��o do protocolos
void respondeProtocolo(char, char, char, char, char);// fun��o que responde um protocolo
void enviarProtocolo(char, char, char, char, char);// fun��o que envia um protocolo ao ME

void main() {
  UART1_init(9600);
  Delay_ms(100);
  
  //configura��es gerais de interrup��o
  RCON.IPEN = 1;
  INTCON.GIEH = 1;
  INTCON.GIEL = 1;

  //configura��o de interrup��o de recep��o da USART
  IPR1.RCIP = 1; //alta prioridade
  PIR1.RCIF = 0; //flag de sinaliza��o
  PIE1.RCIE = 1; //Enable da interrup��o Serial RX

  while(1) {
  }
}

void interrupt() {
  if(PIR1.RCIF == 1) { // indica que a interrup��o foi disparada pela Serial RX
    PIR1.RCIF == 0; // limpa flag que gerou a interrup��o
    lerProtocolo();
  }
  if(PIR1.TMR1IF == 1){
    PIE1.TMR1IE = 0;
    PIR1.TMR1IF = 0;
    executarProtocolo();
  }
}

void lerProtocolo(void) { //fun��o que l� o protocolo e chama sua execu��o

  if(UART1_Data_Ready()) {

    lido = UART1_Read(); // l� o byte de inicio do protocolo

    if(lido == '[') { // se for '[' indica que o protocolo eh de identifica��o do m�dulo
      UART1_Read_Text(ID, "]", 4);
      executarProtocolo();
    }

    else if(lido == '{') { // se for '{' indica que o protocolo eh de envio ao ME
      UART1_Read_Text(ME, "}", 11);
      executarProtocolo();
    }

    else if(lido == '+') { // ser for '+' indica que o protocolo eh de resposta
      UART1_Read_Text(RE, "+", 4);
      executarProtocolo();
    }
  }
}

void executarProtocolo(void) {

  //vetor ID indica protocolo de identifica��o
  if(ID[0] == 'M') { //O ID deste m�dulo � M00
    if(ID[1] == '0') {
      if(ID[2] == '0') {
        respondeProtocolo('+', ID[0], ID[1], ID[2], '+');
        ID[0] = '0' ;
      }
    }
  }

  //vetor ME indica protocolo para M�dulo Escravo
  else if(ME[0] == '[' && ME[4] == ']') { // Os 5 primeiro bytes s�o para protocolo de ID
    enviarProtocolo(ME[0], ME[1], ME[2], ME[3], ME[4]);
    ME[0] = '0';
  }

  else if(ME[1] == RE[0] && ME[2] == RE[1] && ME[3] == RE[2]) {
    //vetor ME indica protocolo para M�dulo Escravo
    if(ME[5] == '(' && ME[9] == ')') { // Os 5 �ltimos para executar protocolos no ME
      enviarProtocolo(ME[5], ME[6], ME[7], ME[8], ME[9]);
      ME[5] = '0';
    }
    RE[0] = '0';
  }

  else if(RE[0] == 'T' && RE[1] == 'E' && RE[2] == 'P') {
    respondeProtocolo( '+', 'E', 'O', 'K', '+');
    RE[0] = '0';
  }

  else if(flag == 1){
     respondeProtocolo('+', 'E', 'N', 'O', '+');
     flag =0;
  }
}

void respondeProtocolo(char r1, char r2, char r3, char r4, char r5) {
  /*
  char checksum;

  UART1_Write(0x7E);
  UART1_Write(0x00);
  UART1_Write(0x13);
  UART1_Write(0x10);
  UART1_Write(0x01);
  UART1_Write(0x00);
  UART1_Write(0x00);
  UART1_Write(0x00);
  UART1_Write(0x00);
  UART1_Write(0x00);
  UART1_Write(0x00);
  UART1_Write(0xFF);
  UART1_Write(0xFF);
  UART1_Write(0xFF);
  UART1_Write(0xFE);
  UART1_Write(0x00);
  UART1_Write(0x00);
  */
  UART1_Write(r1);
  UART1_Write(r2);
  UART1_Write(r3);
  UART1_Write(r4);
  UART1_Write(r5);
  /*
  checksum = (0xFF - ((0x10 + 0x01 + 0xFF + 0xFF + 0xFF + 0xFE + r1 + r2 + r3 + r4 + r5) & 0xFF));
  UART1_Write(checksum);
  */
}

void enviarProtocolo(char r1, char r2, char r3, char r4, char r5) {

  /*
  char checksum;

  UART1_Write(0x7E);
  UART1_Write(0x00);
  UART1_Write(0x13);
  UART1_Write(0x10);
  UART1_Write(0x01);
  UART1_Write(0x00);
  UART1_Write(0x00);
  UART1_Write(0x00);
  UART1_Write(0x00);
  UART1_Write(0x00);
  UART1_Write(0x00);
  UART1_Write(0xFF);
  UART1_Write(0xFF);
  UART1_Write(0xFF);
  UART1_Write(0xFE);
  UART1_Write(0x00);
  UART1_Write(0x00);
  */
  UART1_Write(r1);
  UART1_Write(r2);
  UART1_Write(r3);
  UART1_Write(r4);
  UART1_Write(r5);
  /*
  checksum = (0xFF - ((0x10 + 0x01 + 0xFF + 0xFF + 0xFF + 0xFE + r1 + r2 + r3 + r4 + r5) & 0xFF));
  UART1_Write(checksum);
  */
}