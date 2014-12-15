#line 1 "C:/Users/User/Desktop/teste hardware/final agr vai/Projeto Oficina v.1.2/Programação MC/ModuloCentral.c"


char lido;
char ID[4];
char ME[11];
char RE[4];


int flag;




void lerProtocolo(void);
void executarProtocolo(void);
void respondeProtocolo(char, char, char, char, char);
void enviarProtocolo(char, char, char, char, char);

void main() {
 UART1_init(9600);
 Delay_ms(100);


 RCON.IPEN = 1;
 INTCON.GIEH = 1;
 INTCON.GIEL = 1;


 IPR1.RCIP = 1;
 PIR1.RCIF = 0;
 PIE1.RCIE = 1;

 while(1) {
 }
}

void interrupt() {
 if(PIR1.RCIF == 1) {
 PIR1.RCIF == 0;
 lerProtocolo();
 }
 if(PIR1.TMR1IF == 1){
 PIE1.TMR1IE = 0;
 PIR1.TMR1IF = 0;
 executarProtocolo();
 }
}

void lerProtocolo(void) {

 if(UART1_Data_Ready()) {

 lido = UART1_Read();

 if(lido == '[') {
 UART1_Read_Text(ID, "]", 4);
 executarProtocolo();
 }

 else if(lido == '{') {
 UART1_Read_Text(ME, "}", 11);
 executarProtocolo();
 }

 else if(lido == '+') {
 UART1_Read_Text(RE, "+", 4);
 executarProtocolo();
 }
 }
}

void executarProtocolo(void) {


 if(ID[0] == 'M') {
 if(ID[1] == '0') {
 if(ID[2] == '0') {
 respondeProtocolo('+', ID[0], ID[1], ID[2], '+');
 ID[0] = '0' ;
 }
 }
 }


 else if(ME[0] == '[' && ME[4] == ']') {
 enviarProtocolo(ME[0], ME[1], ME[2], ME[3], ME[4]);
 ME[0] = '0';
 }

 else if(ME[1] == RE[0] && ME[2] == RE[1] && ME[3] == RE[2]) {

 if(ME[5] == '(' && ME[9] == ')') {
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
#line 132 "C:/Users/User/Desktop/teste hardware/final agr vai/Projeto Oficina v.1.2/Programação MC/ModuloCentral.c"
 UART1_Write(r1);
 UART1_Write(r2);
 UART1_Write(r3);
 UART1_Write(r4);
 UART1_Write(r5);
#line 141 "C:/Users/User/Desktop/teste hardware/final agr vai/Projeto Oficina v.1.2/Programação MC/ModuloCentral.c"
}

void enviarProtocolo(char r1, char r2, char r3, char r4, char r5) {
#line 166 "C:/Users/User/Desktop/teste hardware/final agr vai/Projeto Oficina v.1.2/Programação MC/ModuloCentral.c"
 UART1_Write(r1);
 UART1_Write(r2);
 UART1_Write(r3);
 UART1_Write(r4);
 UART1_Write(r5);
#line 175 "C:/Users/User/Desktop/teste hardware/final agr vai/Projeto Oficina v.1.2/Programação MC/ModuloCentral.c"
}
