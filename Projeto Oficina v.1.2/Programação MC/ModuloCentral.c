//variáveis globais:
//variáveis de protocolo
char lido;// lê o byte de inicio do protocolo
char ID[4];// armazena protocolo de identificacao
char ME[11];// armazena protocolo de envio ao ME {[M0X](IXX)}
char RE[4];// armazena protocolo de resposta

//flags
int flag;

//-----------------------------------------------------//
//protótipos das funções
//funções de protocolo
void lerProtocolo(void);// função para leitura dos protocolos
void executarProtocolo(void); //função para execução do protocolos
void respondeProtocolo(char, char, char, char, char);// função que responde um protocolo
void enviarProtocolo(char, char, char, char, char);// função que envia um protocolo ao ME

void main() {
  UART1_init(9600);
  Delay_ms(100);
   /*
  //inicializar variáveis
  flag = 0;

  TRISD = 0;
  PORTD.RD0 = 1;
  */
  //configurações gerais de interrupção
  RCON.IPEN = 1;
  INTCON.GIEH = 1;
  INTCON.GIEL = 1;
  /*
  //configurações do timer 0
  T0CON = 0b10000111;
  INTCON.TMR0IF = 0; // zera o flag do timer
  INTCON.TMR0IE = 0; // interrupção desativada
  INTCON2.TMR0IP = 1; // alta prioridade
  //tempo para 10 segundos -->(26474)d --> (676A)h
  //TMR0H = 0x67;
  //TMR0L = 0x6A;

  //configuração timer 1
  PIR1.TMR1IF = 0; //Flag do estouro do timer 1, inicializa como 0
  PIE1.TMR1IE = 0; //TMR1 desabilitado
  IPR1.TMR1IP = 0; //baixa prioridade
  T1CON = 0b10110001;
  // estouro a cada 1ms
  // T1 = 4.Tosc.T1CKPS1:T1CKPS0.(65536-TMR1H:TMR1L)
  // T1 = Tcy.prescaler.(65536-carga inicial)
  // carga inicial = 64536
  // 64536 = 0xFC18
  //TMR1H = 0xFC;
  //TMR1L = 0x18;
   */

  //configuração de interrupção de recepção da USART
  IPR1.RCIP = 1; //baixa prioridade
  PIR1.RCIF = 0; //flag de sinalização
  PIE1.RCIE = 1; //Enable da interrupção Serial RX

  while(1) {
  }
}

/*
void interrupt(){
  if(INTCON.TMR0IF == 1){
    flag = 1;
    PORTD.RD0 = ~PORTD.RD0;
    INTCON.TMR0IF = 0;
    INTCON.TMR0IE = 0; // desativa a interrupção do timer 0
    TMR1H = 0xFC;
    TMR1L = 0x18;
    PIE1.TMR1IE = 1;
  }
}
*/

void interrupt() {
  if(PIR1.RCIF == 1) { // indica que a interrupção foi disparada pela Serial RX
    PIR1.RCIF == 0; // limpa flag que gerou a interrupção
    lerProtocolo();
  }
  if(PIR1.TMR1IF == 1){
    PIE1.TMR1IE = 0;
    PIR1.TMR1IF = 0;
    executarProtocolo();
  }
}

void lerProtocolo(void) { //função que lê o protocolo e chama sua execução

  if(UART1_Data_Ready()) {

    lido = UART1_Read(); // lê o byte de inicio do protocolo

    if(lido == '[') { // se for '[' indica que o protocolo eh de identificação do módulo
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

  //vetor ID indica protocolo de identificação
  if(ID[0] == 'M') { //O ID deste módulo é M00
    if(ID[1] == '0') {
      if(ID[2] == '0') {
        respondeProtocolo('+', ID[0], ID[1], ID[2], '+');
        ID[0] = '0' ;
        //TMR0H = 0x67;
        //TMR0L = 0x6A;
        //INTCON.TMR0IE = 1; // ativa interrupção do timer 0
      }
    }
  }

  //vetor ME indica protocolo para Módulo Escravo
  else if(ME[0] == '[' && ME[4] == ']') { // Os 5 primeiro bytes são para protocolo de ID
    enviarProtocolo(ME[0], ME[1], ME[2], ME[3], ME[4]);
    ME[0] = '0';
  }

  else if(ME[1] == RE[0] && ME[2] == RE[1] && ME[3] == RE[2]) {
    //vetor ME indica protocolo para Módulo Escravo
    if(ME[5] == '(' && ME[9] == ')') { // Os 5 últimos para executar protocolos no ME
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
  UART1_Write(r1);
  UART1_Write(r2);
  UART1_Write(r3);
  UART1_Write(r4);
  UART1_Write(r5);
  checksum = (0xFF - ((0x10 + 0x01 + 0xFF + 0xFF + 0xFF + 0xFE + r1 + r2 + r3 + r4 + r5) & 0xFF));
  UART1_Write(checksum);
}

void enviarProtocolo(char r1, char r2, char r3, char r4, char r5) {

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
  UART1_Write(r1);
  UART1_Write(r2);
  UART1_Write(r3);
  UART1_Write(r4);
  UART1_Write(r5);
  checksum = (0xFF - ((0x10 + 0x01 + 0xFF + 0xFF + 0xFF + 0xFE + r1 + r2 + r3 + r4 + r5) & 0xFF));
  UART1_Write(checksum);
}