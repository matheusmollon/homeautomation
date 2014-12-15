char lido; // lê o byte de inicio do protocolo
char ID[4]; // armazena protocolo de identificacao
char EX[4]; // armazena protocolo de iluminacao

float barreira; // responsável pela leitura da entrada analógica do circuito da barreira
float alarme;   // responsável pela leitura da entrada analógica do circuito do sensor do portão
float LDR; // sensor de luminosidade

int flagExecutar = 0;
int estado = 0;
int sirene2 = 0; //flag de sinalização de disparo do alarme
int sirene =0;   // flag de sinalização de disparo da barreira
int cercaIR =0; //variável global responsável pelo ligar e desligar do sistema de alarme da barreira infravermelho(1-liga/0- desliga)
int sensorIR =0; //variável global responsável pelo ligar .;e desligar do sistema de alarme do sensor infravermelho(1-liga /0 - desliga)
int AutoTimer = 0;// responsável pela temporização das lâmpadas a partir do acionamento do portão
int cont = 0;
int off =0;
int bound =0;
char resp=0;

void lerProtocolo(void); // função para leitura dos protocolos
void executarProtocolo(void); // função para execução do protocolos
void respondeProtocolo(char, char, char, char, char);
void servoRotate0(void);
void servoRotate90(void);
void gerencia_alarme(void);
void iluminacao_automatizada(void);

void main() {
  UART1_init(9600);
  Delay_ms(100);
  // configurações do PORTD
  
  TRISD =0;
  PORTD.RD0 = 1;
  PORTD.RD1 = 1;
  PORTD.RD2 = 1;
  PORTD.RD3 = 1;
  PORTD.RD4 = 1;
  PORTD.RD5 = 1;
  PORTD.RD6 = 1;
  PORTD.RD7 = 1;
  
  //Configurações do PORTC
  TRISC.RC1 = 0;
  
  // configurações do PORTE para as sirenes 1 e 2
  TRISE.RE0 =0;
  PORTE.RE0 =0;
  ADCON1 = 0b00001100; //define A0,A1 e A2 como saídas analógicas para os sensores
  TRISA.RA0 =1;
  TRISA.RA1 =1;
  TRISA.RA2 =1;
  
  //configurações gerais de interrupção
  RCON.IPEN = 1;
  INTCON.GIEH = 1;
  INTCON.GIEL = 1;
  
  //configuração da interrupção do timer 0
  T0CON = 0b10000111;
  INTCON.TMR0IF = 0; // zera o flag de estouro do timer0
  INTCON.TMR0IE = 0; //desabilita a interrupção
  INTCON2.TMR0IP =1; // alta prioridade
   // estouro a cada 15 segundos -->(6942)d --> (1B1E)h
   TMR0H =0x1B;
   TMR0L =0x1E;
   
  //configuração de interrupção de recepção da USART
  IPR1.RCIP = 0;//baixa prioridade
  PIR1.RCIF = 0;
  PIE1.RCIE = 1; //Enable da interrupção Serial RX

  //Configurar o timer 2 para gerar um PWM com periodo de 500us (Tpwm=500us)
  //Utilizar pré-escala do timer 2 para 16, ou seja, T2CKPS=16

  //PR2 = [Tpwm/(4*TOSC*T2CKPS)]-1    P/ T2CKPS=16,  e TOSC=1/FOSC=1/4MHz
  // Agora é necessário configurar os registradores T2CON e PR2
  T2CON=0b00000111;
  PR2=31; //30.25=~31

  //Configurar o PWM inicialmente com duty-cycle de 25%, sendo dutycycle=(Ton/Tpwm)*100 (Ton=25%*Tpwm=125us)
  // Ton é configurado pelo registrador  DC[9:0]
  //DC[9:0]=Ton/(TOSC*T2CKPS[1:0])  P/ T2CKPS=16
  //Os 8 bits mais significativos de DC[9:0] ficam em CCPR2L e os 2 bits menos significativos ficam
  // em CCP2CON<4:5>
  // Agora é necessário configurar os registradores CCP2L e CCP2 CON

  //100% -ligado
  //CCPR2l = 0b00000000;
  //CCP2CON = 0b00001100;

  //75%
  //125us/(0.25us*16) = 31.25 =~ 32
  //0b0000100000
  //CCPR2l = 0b00001000;
  //CCP2CON = 0b00001100;

  //50%
  //250us/(0.25us*16) = 62.5 =~ 63
  //0b0000111111
  //CCPR2l = 0b00001111;
  //CCP2CON = 0b00111100;

  //25%
  //375us/(0.25us*16) = 93.75 =~ 94
  //0b0001011110
  //CCPR2l = 0b00010111;
  //CCP2CON = 0b00101100;

  //0% - desligado
  CCPR2l = 0b11111111;
  CCP2CON = 0b00111100;

  while(1) {
        gerencia_alarme();
        iluminacao_automatizada();
  }
}

void interrupt_low() {
  if(PIR1.RCIF == 1) { // indica que a interrupção foi disparada pela Serial RX
    PIR1.RCIF = 0; // limpa flag que gerou a interrupção
    lerProtocolo();
  }
}
 void interrupt(){
    if(INTCON.TMR0IF==1){
       INTCON.TMR0IF=0;
       if(cont !=4){
        cont++;
       }
       else if(cont == 4){
        cont =0;
        off=1;
       }
       // estouro a cada 15 segundos -->(6942)d --> (1B1E)h
       TMR0H =0x1B;
       TMR0L =0x1E;
    }
 }
 
void lerProtocolo(void) {

  if(UART1_Data_Ready()) {

    lido = UART1_Read(); // lê o byte de inicio do protocolo

    if(flagExecutar == 1) {
      if(lido == '(') { // se for '(' indica que o protocolo de execução
        UART1_Read_Text(EX, ")", 4);
        executarProtocolo();
      }
      flagExecutar = 0;
    }
    else if(lido == '[') { // se for '[' indica que o protocolo eh de identificação do módulo
      UART1_Read_Text(ID, "]", 4);
      executarProtocolo();
      flagExecutar = 1;
    }
  }
}

void executarProtocolo(void) {

  //vetor ID indica protocolo de identificação
  if(ID[0] == 'M') { //O ID deste módulo é M01
    if(ID[1] == '0') {
      if(ID[2] == '1') {

        ID[0] = '0' ;
        respondeProtocolo('+', 'M', '0', '1', '+');
      }
    }
  }

  else if(EX[0] == 'I') { //O EX começa com I no protocolo de iluminação

    if(EX[1] == 'A') { // LED A
      estado =0;
      if(EX[2] == '1')
        PORTD.RD0 = 0;
      else if(EX[2] == '0')
        PORTD.RD0 = 1;
    }

    if(EX[1] == 'B') { // LED B
      estado =0;
      if(EX[2] == '1')
        PORTD.RD1 = 0;
      else if(EX[2] == '0')
        PORTD.RD1 = 1;
    }

    if(EX[1] == 'C') { // LED C
      estado =0;
      if(EX[2] == '1')
        PORTD.RD2 = 0;
      else if(EX[2] == '0')
        PORTD.RD2 = 1;
    }

    if(EX[1] == 'D') { // LED D
      estado =0;
      if(EX[2] == '1')
        PORTD.RD3 = 0;
      else if(EX[2] == '0')
        PORTD.RD3 = 1;
    }

    if(EX[1] == 'E') { // LED E
      estado =0;
      if(EX[2] == '1')
        PORTD.RD4 = 0;
      else if(EX[2] == '0')
        PORTD.RD4 = 1;
    }
    
    if(EX[1] == 'F') { // Todos LEDs
      estado =0;
      if(EX[2] == '1') {
        PORTD.RD0 = 0; //liga todos os LEDS
        PORTD.RD1 = 0;
        PORTD.RD2 = 0;
        PORTD.RD3 = 0;
        PORTD.RD4 = 0;
      }
      else if(EX[2] == '0'){
        PORTD.RD0 = 1; //desliga todos os LEDS
        PORTD.RD1 = 1;
        PORTD.RD2 = 1;
        PORTD.RD3 = 1;
        PORTD.RD4 = 1;
      }
    }

    EX[0] = '0';

    respondeProtocolo( '+', 'T', 'E', 'P', '+');
  }

  else if(EX[0] == 'P') { // O EX começa com P no protocolo do portão
    if(EX[1] == 'G'){
      if(EX[2] == '0')
        servoRotate90()
      else if (EX[2] == '1')
        servoRotate0();
    }

    EX[0] = '0';
    
    respondeProtocolo( '+', 'T', 'E', 'P', '+');
  }
  
  else if(EX[0] == 'D') { // O EX co,eça com D no protocolo de dimerização
    if(EX[1] == 'H') {
      if(EX[2] == '4') { // Ligado 100%
        CCPR2l = 0b00000000;
        CCP2CON = 0b00001100;
      }
      else if(EX[2] == '3') { // Ligado 75%
        CCPR2l = 0b00001000;
        CCP2CON = 0b00001100;
      }
      else if(EX[2] == '2') { // Ligado 50%
        CCPR2l = 0b00001111;
        CCP2CON = 0b00111100;
      }
      else if(EX[2] == '1') { // Ligado 25%
        CCPR2l = 0b00010111;
        CCP2CON = 0b00101100;
      }
      else if(EX[2] == '0') { // Desligado
        CCPR2l = 0b11111111;
        CCP2CON = 0b00111100;
      }
    }
    
    EX[0] = '0';
    
    respondeProtocolo( '+', 'T', 'E', 'P', '+');
  }
  
  else if(EX[0] == 'A'){ // parte do protocolo responsável pelo funcionamento dos alarmes
    if(EX[1] == 'I'){    // indica o alarme A que representa a Barreira infravermelho
      if(EX[2] == '1'){  // ativa barreira infravermelho
        cercaIR = 1;
        }
      else if(EX[2] =='0'){ // desativa barreita intravermelho
        cercaIR = 0;
      }
    }

    EX[0] = '0';
    
    respondeProtocolo( '+', 'T', 'E', 'P', '+');
  }

  else if(EX[0] == 'C'){ // parte do protocolo responsável pela iluminação automatizada

    if(EX[1] == '1'){    // indica que o acendimento automatizado da luz pelo LDR está ativo
      estado = 1;
      resp = EX[2];
    }
    else if(EX[1] =='0'){ // indica que a iluminação automatizada está desattivada
      estado = 3;
      resp = EX[2];
    }

    EX[0] = '0';
    
    respondeProtocolo( '+', 'T', 'E', 'P', '+');
  }

  else if(EX[0] =='H'){ //controle automatizado das lampadas ao abrir o portão
    if (EX[1] == '0'){
      servoRotate90();
    }
    else if(EX[1] == '1'){
      servoRotate0();
    }
    
    EX[0] = 0;
    
    respondeProtocolo( '+', 'T', 'E', 'P', '+');
  }
}

void respondeProtocolo(char r1, char r2, char r3, char r4, char r5) {

  //char checksum;

  //UART1_Write(0x7E);
  //UART1_Write(0x00);
  //UART1_Write(0x13);
  //UART1_Write(0x10);
  //UART1_Write(0x01);
  //UART1_Write(0x00);
  //UART1_Write(0x00);
  //UART1_Write(0x00);
  //UART1_Write(0x00);
  //UART1_Write(0x00);
  //UART1_Write(0x00);
  //UART1_Write(0x00);
  //UART1_Write(0x00);
  //UART1_Write(0xFF);
  //UART1_Write(0xFE);
  //UART1_Write(0x00);
  //UART1_Write(0x00);
  UART1_Write(r1);
  UART1_Write(r2);
  UART1_Write(r3);
  UART1_Write(r4);
  UART1_Write(r5);
  //checksum = (0xFF - ((0x10 + 0x01 + 0x00 + 0x00 + 0xFF + 0xFE + r1 + r2 + r3 + r4 + r5) & 0xFF));
  //UART1_Write(checksum);
}

void servoRotate0()
{
  unsigned int i;
  for(i=0;i<50;i++)
  {
    PORTD.RD5 = 1;
    Delay_us(2200);
    //Delay_us(800);
    PORTD.RD5 = 0;
    Delay_us(17800);
    //Delay_us(19200);
  }
   if(EX[2] !='0'&& EX[2] !='1'){
     autoTimer =1;
     estado =1;
     resp = EX[2];
  }
}

void servoRotate90()
{
  unsigned int i;
  for(i=0;i<50;i++)
  {
    PORTD.RD5 = 1;
    Delay_us(1500);
    PORTD.RD5 = 0;
    Delay_us(18500);
  }

}

void gerencia_alarme(){
  if(cercaIR == 1){
    barreira = ADC_Read(0);
    if(barreira > 500 || sirene == 1){
      sirene =1;
      PORTE.RE0 = 1;
      delay_ms(500);
      PORTE.RE0 = 0;
      delay_ms(500);
    }
  }
  else if(cercaIR == 0){
    sirene =0;
    PORTE.RE0 = 0;
  }
}

void iluminacao_automatizada(){
  if(estado == 1){ // ativa a iluminação automatizada
    LDR = ADC_Read(2); //  leitura do pino analógico do sensor
    if(LDR < 600){// ativa as luzes correspondentes
      if(resp == '0'){
        PORTD.RD0 = 0; //liga o LED A
        if(AutoTimer ==1){
          INTCON.TMR0IE =1; // ativa interrupção do timer0
          if(off==1){
            PORTD.RD0 =1;
            AutoTimer =0;
            off=0;
            estado =0;
            INTCON.TMR0IE =0;
          }
        }
      }
      if(resp == '1'){
        PORTD.RD1 = 0; //liga o LED B
        if(AutoTimer ==1){
          INTCON.TMR0IE =1; // ativa interrupção do timer0
          if(off==1){
            PORTD.RD1 =1;
            AutoTimer =0;
            off=0;
            estado =0;
            INTCON.TMR0IE =0;
          }
        }
      }
      if(resp == '2'){
        PORTD.RD2 = 0; //liga o LED C
        if(AutoTimer ==1){
          INTCON.TMR0IE =1; // ativa interrupção do timer0
          if(off==1){
            PORTD.RD2 =1;
            AutoTimer =0;
            off=0;
            estado =0;
            INTCON.TMR0IE =0;
          }
        }
      }
      if(resp == '3'){
        PORTD.RD3 = 0; //liga o LED D
        if(AutoTimer ==1){
          INTCON.TMR0IE =1; // ativa interrupção do timer0
          if(off==1){
            PORTD.RD3 =1;
            AutoTimer =0;
            off=0;
            estado =0;
            INTCON.TMR0IE =0;
          }
        }
      }
      if(resp == '4'){
        PORTD.RD4 = 0; //liga o LED E
        if(AutoTimer ==1){
          INTCON.TMR0IE =1; // ativa interrupção do timer0
          if(off==1){
            PORTD.RD4 =1;
            AutoTimer =0;
            off=0;
            estado =0;
            INTCON.TMR0IE =0;
          }
        }
      }
      if(resp == '5'){
        PORTD.RD0 = 0; //liga todos os LEDS
        PORTD.RD1 = 0;
        PORTD.RD2 = 0;
        PORTD.RD3 = 0;
        PORTD.RD4 = 0;
        if(AutoTimer ==1){
          INTCON.TMR0IE =1; // ativa interrupção do timer0
          if(off==1){
            PORTD.RD0 = 1; //desliga todos os LEDS
            PORTD.RD1 = 1;
            PORTD.RD2 = 1;
            PORTD.RD3 = 1;
            PORTD.RD4 = 1;
            AutoTimer =0;
            off=0;
            estado =0;
            INTCON.TMR0IE =0;
          }
        }
      }
    }
    else if(LDR > 600){// desativa as luzes correspondentes
      if(resp == '0'){
        PORTD.RD0 = 1; //desliga o LED A
        if(AutoTimer ==1){
          AutoTimer =0;
          estado =0;
          INTCON.TMR0IE =0;
        }

      }
      if(resp == '1'){
        PORTD.RD1 = 1; //desliga o LED B
        if(AutoTimer ==1){
          AutoTimer =0;
          estado =0;
          INTCON.TMR0IE =0;
        }
      }
      if(resp == '2'){
        PORTD.RD2 = 1; //desliga o LED C
        if(AutoTimer ==1){
          AutoTimer =0;
          estado =0;
          INTCON.TMR0IE =0;
        }
      }
      if(resp == '3'){
        PORTD.RD3 = 1; //desliga o LED D
        if(AutoTimer ==1){
          AutoTimer =0;
          estado =0;
          INTCON.TMR0IE =0;
        }
      }
      if(resp == '4'){
        PORTD.RD4 = 1; //desliga o LED E
        if(AutoTimer ==1){
          AutoTimer =0;
          estado =0;
          INTCON.TMR0IE =0;
        }
      }
      if(resp == '5'){
        PORTD.RD0 = 1; //desliga todos os LEDS
        PORTD.RD1 = 1;
        PORTD.RD2 = 1;
        PORTD.RD3 = 1;
        PORTD.RD4 = 1;
        if(AutoTimer ==1){
          AutoTimer =0;
          estado =0;
          INTCON.TMR0IE =0;
        }
      }
    }
  }
  else if(estado ==3){
    if(resp == '0'){
      PORTD.RD0 = 1; //desliga o LED A
      if(AutoTimer ==1){
        AutoTimer =0;
        estado =0;
        INTCON.TMR0IE =0;
      }
    }
    if(resp == '1'){
      PORTD.RD1 = 1; //desliga o LED B
      if(AutoTimer ==1){
        AutoTimer =0;
        estado =0;
        INTCON.TMR0IE =0;
      }
    }
    if(resp == '2'){
      PORTD.RD2 = 1; //desliga o LED C
      if(AutoTimer ==1){
        AutoTimer =0;
        estado =0;
        INTCON.TMR0IE =0;
      }
    }
    if(resp == '3'){
      PORTD.RD3 = 1; //desliga o LED D
      if(AutoTimer ==1){
        AutoTimer =0;
        estado =0;
        INTCON.TMR0IE =0;
      }
    }
    if(resp == '4'){
      PORTD.RD4 = 1; //desliga o LED E
      if(AutoTimer ==1){
        AutoTimer =0;
        estado =0;
        INTCON.TMR0IE =0;
      }
    }
    if(resp == '5'){
      PORTD.RD0 = 1; //desliga todos os LEDS
      PORTD.RD1 = 1;
      PORTD.RD2 = 1;
      PORTD.RD3 = 1;
      PORTD.RD4 = 1;
      if(AutoTimer ==1){
        AutoTimer =0;
        estado =0;
        INTCON.TMR0IE =0;
      }
    }
  }
}