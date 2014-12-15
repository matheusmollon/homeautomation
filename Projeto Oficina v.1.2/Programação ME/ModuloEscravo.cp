#line 1 "C:/Users/User/Desktop/teste hardware/final/Projeto Oficina v.1.2/Programação ME/ModuloEscravo.c"
char lido;
char ID[4];
char EX[4];

float barreira;
float alarme;
float LDR;

int flagExecutar = 0;
int estado = 0;
int sirene2 = 0;
int sirene =0;
int cercaIR =0;
int sensorIR =0;
int AutoTimer = 0;
int cont = 0;
int off =0;
int bound =0;
char resp=0;

void lerProtocolo(void);
void executarProtocolo(void);
void respondeProtocolo(char, char, char, char, char);
void servoRotate0(void);
void servoRotate90(void);
void gerencia_alarme(void);
void iluminacao_automatizada(void);

void main() {
 UART1_init(9600);
 Delay_ms(100);


 TRISD =0;
 PORTD.RD0 = 1;
 PORTD.RD1 = 1;
 PORTD.RD2 = 1;
 PORTD.RD3 = 1;
 PORTD.RD4 = 1;
 PORTD.RD5 = 1;
 PORTD.RD6 = 1;
 PORTD.RD7 = 1;


 TRISC.RC1 = 0;


 TRISE.RE0 =0;
 TRISE.RE1 =0;
 PORTE.RE1 =0;
 PORTE.RE0 =0;
 ADCON1 = 0b00001100;
 TRISA.RA0 =1;
 TRISA.RA1 =1;
 TRISA.RA2 =1;


 RCON.IPEN = 1;
 INTCON.GIEH = 1;
 INTCON.GIEL = 1;


 T0CON = 0b10000111;
 INTCON.TMR0IF = 0;
 INTCON.TMR0IE = 0;
 INTCON2.TMR0IP =1;

 TMR0H =0x1B;
 TMR0L =0x1E;


 IPR1.RCIP = 0;
 PIR1.RCIF = 0;
 PIE1.RCIE = 1;






 T2CON=0b00000111;
 PR2=31;
#line 114 "C:/Users/User/Desktop/teste hardware/final/Projeto Oficina v.1.2/Programação ME/ModuloEscravo.c"
 CCPR2l = 0b11111111;
 CCP2CON = 0b00111100;

 while(1) {
 gerencia_alarme();
 iluminacao_automatizada();
 }
}

void interrupt_low() {
 if(PIR1.RCIF == 1) {
 PIR1.RCIF = 0;
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

 TMR0H =0x1B;
 TMR0L =0x1E;
 }
 }

void lerProtocolo(void) {

 if(UART1_Data_Ready()) {

 lido = UART1_Read();


 if(lido == '(') {
 UART1_Read_Text(EX, ")", 4);
 executarProtocolo();
 }
 else if(lido == '[') {
 UART1_Read_Text(ID, "]", 4);
 executarProtocolo();
 }
 }
}

void executarProtocolo(void) {


 if(ID[0] == 'M') {
 if(ID[1] == '0') {
 if(ID[2] == '1') {

 ID[0] = '0' ;
 respondeProtocolo('+', 'M', '0', '1', '+');
 }
 }
 }

 else if(EX[0] == 'I') {

 if(EX[1] == 'A') {
 estado =0;
 if(EX[2] == '1')
 PORTD.RD0 = 0;
 else if(EX[2] == '0')
 PORTD.RD0 = 1;
 }

 if(EX[1] == 'B') {
 estado =0;
 if(EX[2] == '1')
 PORTD.RD1 = 0;
 else if(EX[2] == '0')
 PORTD.RD1 = 1;
 }

 if(EX[1] == 'C') {
 estado =0;
 if(EX[2] == '1')
 PORTD.RD2 = 0;
 else if(EX[2] == '0')
 PORTD.RD2 = 1;
 }

 if(EX[1] == 'D') {
 estado =0;
 if(EX[2] == '1')
 PORTD.RD3 = 0;
 else if(EX[2] == '0')
 PORTD.RD3 = 1;
 }

 if(EX[1] == 'E') {
 estado =0;
 if(EX[2] == '1')
 PORTD.RD4 = 0;
 else if(EX[2] == '0')
 PORTD.RD4 = 1;
 }

 EX[0] = '0';

 respondeProtocolo( '+', 'T', 'E', 'P', '+');
 }

 else if(EX[0] == 'P') {
 if(EX[1] == 'F'){
 if(EX[2] == '1')
 servoRotate0();
 else if (EX[2] == '0')
 servoRotate90();
 }

 EX[0] = '0';

 respondeProtocolo( '+', 'T', 'E', 'P', '+');
 }

 else if(EX[0] == 'D') {
 if(EX[1] == 'G') {
 if(EX[2] == '4') {
 CCPR2l = 0b00000000;
 CCP2CON = 0b00001100;
 }
 else if(EX[2] == '3') {
 CCPR2l = 0b00001000;
 CCP2CON = 0b00001100;
 }
 else if(EX[2] == '2') {
 CCPR2l = 0b00001111;
 CCP2CON = 0b00111100;
 }
 else if(EX[2] == '1') {
 CCPR2l = 0b00010111;
 CCP2CON = 0b00101100;
 }
 else if(EX[2] == '0') {
 CCPR2l = 0b11111111;
 CCP2CON = 0b00111100;
 }
 }

 EX[0] = '0';

 respondeProtocolo( '+', 'T', 'E', 'P', '+');
 }

 else if(EX[0] == 'A'){
 if(EX[1] == 'H'){
 if(EX[2] == '1'){
 cercaIR = 1;
 }
 else if(EX[2] =='0'){
 cercaIR = 0;
 }
 }

 EX[0] = '0';

 respondeProtocolo( '+', 'T', 'E', 'P', '+');
 }

 else if(EX[0] == 'C'){

 if(EX[1] == '1'){
 estado = 1;
 resp = EX[2];
 }
 else if(EX[1] =='0'){
 estado = 3;
 resp = EX[2];
 }

 EX[0] = '0';

 respondeProtocolo( '+', 'T', 'E', 'P', '+');
 }

 else if(EX[0] =='H'){
 if (EX[1] == '1'){
 servoRotate0();
 }
 else if(EX[1] == '0'){
 servoRotate90();
 }

 EX[0] = 0;

 respondeProtocolo( '+', 'T', 'E', 'P', '+');
 }
}

void respondeProtocolo(char r1, char r2, char r3, char r4, char r5) {
#line 331 "C:/Users/User/Desktop/teste hardware/final/Projeto Oficina v.1.2/Programação ME/ModuloEscravo.c"
 UART1_Write(r1);
 UART1_Write(r2);
 UART1_Write(r3);
 UART1_Write(r4);
 UART1_Write(r5);


}

void servoRotate0()
{
 unsigned int i;
 for(i=0;i<50;i++)
 {
 PORTD.RD5 = 1;
 Delay_us(800);
 PORTD.RD5 = 0;
 Delay_us(19200);
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
 if(EX[2] !='0'&& EX[2] !='1'){
 autoTimer =1;
 estado =1;
 resp = EX[2];
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
 PORTE.RE0 = 1;
 }
}

void iluminacao_automatizada(){
 if(estado == 1){
 LDR = ADC_Read(2);
 if(LDR < 600){
 if(resp == '0'){
 PORTD.RD0 = 0;
 if(AutoTimer ==1){
 INTCON.TMR0IE =1;
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
 PORTD.RD1 = 0;
 if(AutoTimer ==1){
 INTCON.TMR0IE =1;
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
 PORTD.RD2 = 0;
 if(AutoTimer ==1){
 INTCON.TMR0IE =1;
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
 PORTD.RD3 = 0;
 if(AutoTimer ==1){
 INTCON.TMR0IE =1;
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
 PORTD.RD4 = 0;
 if(AutoTimer ==1){
 INTCON.TMR0IE =1;
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
 PORTD.RD0 = 0;
 PORTD.RD1 = 0;
 PORTD.RD2 = 0;
 PORTD.RD3 = 0;
 PORTD.RD4 = 0;
 if(AutoTimer ==1){
 INTCON.TMR0IE =1;
 if(off==1){
 PORTD.RD0 = 1;
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
 else if(LDR > 600){
 if(resp == '0'){
 PORTD.RD0 = 1;
 if(AutoTimer ==1){
 AutoTimer =0;
 estado =0;
 INTCON.TMR0IE =0;
 }

 }
 if(resp == '1'){
 PORTD.RD1 = 1;
 if(AutoTimer ==1){
 AutoTimer =0;
 estado =0;
 INTCON.TMR0IE =0;
 }
 }
 if(resp == '2'){
 PORTD.RD2 = 1;
 if(AutoTimer ==1){
 AutoTimer =0;
 estado =0;
 INTCON.TMR0IE =0;
 }
 }
 if(resp == '3'){
 PORTD.RD3 = 1;
 if(AutoTimer ==1){
 AutoTimer =0;
 estado =0;
 INTCON.TMR0IE =0;
 }
 }
 if(resp == '4'){
 PORTD.RD4 = 1;
 if(AutoTimer ==1){
 AutoTimer =0;
 estado =0;
 INTCON.TMR0IE =0;
 }
 }
 if(resp == '5'){
 PORTD.RD0 = 1;
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
 PORTD.RD0 = 1;
 if(AutoTimer ==1){
 AutoTimer =0;
 estado =0;
 INTCON.TMR0IE =0;
 }
 }
 if(resp == '1'){
 PORTD.RD1 = 1;
 if(AutoTimer ==1){
 AutoTimer =0;
 estado =0;
 INTCON.TMR0IE =0;
 }
 }
 if(resp == '2'){
 PORTD.RD2 = 1;
 if(AutoTimer ==1){
 AutoTimer =0;
 estado =0;
 INTCON.TMR0IE =0;
 }
 }
 if(resp == '3'){
 PORTD.RD3 = 1;
 if(AutoTimer ==1){
 AutoTimer =0;
 estado =0;
 INTCON.TMR0IE =0;
 }
 }
 if(resp == '4'){
 PORTD.RD4 = 1;
 if(AutoTimer ==1){
 AutoTimer =0;
 estado =0;
 INTCON.TMR0IE =0;
 }
 }
 if(resp == '5'){
 PORTD.RD0 = 1;
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
