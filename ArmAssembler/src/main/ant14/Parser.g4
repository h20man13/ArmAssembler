grammar Parser;

instruction : bInstr
		 	| blInstr
			| bxInstr
			| ldmInstr
			| ldrByteInstr
			| ldrDefInstr
			| mlaInstr
			| mrsInstr
			| msrDefInstr
			| msrPrivInstr
			| mulInstr
			| stmInstr
			| strByteInstr
			| strDefInstr
			| swiInstr
			| swpInstr
			| addInstr
			| andInstr
			| eorInstr
			| subInstr
			| rsbInstr
			| adcInstr
			| sbcInstr
			| rscInstr
			| tstInstr
			| teqInstr
			| cmpInstr
			| orrInstr
			| movInstr
			| bicInstr
			| mvnInstr
			;

bInstr : B COND? expression;
blInstr : BL COND? expression;
bxInstr : BX COND? REG;
ldmInstr : LDM COND? ADDRESSINGMODE REG T? COMMA rList BXOR?;
ldrByteInstr : LDR COND? B? T? REG COMMA address;
ldrDefInstr : LDR COND? TRANSFERTYPE REG COMMA address;
mlaInstr : MLA COND? S? REG COMMA REG COMMA REG COMMA REG;
mrsInstr : MRS COND? REG COMMA PSR;
msrDefInstr : MSR COND? PSR COMMA REG;
msrPrivInstr : MSR COND? (PSRF COMMA (REG | poundExpression));
mulInstr : MUL COND? S? REG COMMA REG COMMA REG;
stmInstr : STM COND? ADDRESSINGMODE REG EXP? COMMA rList BXOR?;
strByteInstr : STR COND? B? T? REG COMMA address;
strDefInstr : STR COND? H REG COMMA address;
swiInstr : SWI COND? expression;
swpInstr : SWP COND? B? REG COMMA REG COMMA '[' REG ']';
addInstr : ADD COND? S? REG COMMA REG COMMA op2;
andInstr : AND COND? S? REG COMMA REG COMMA op2;
eorInstr : EOR COND? S? REG COMMA REG COMMA op2;
subInstr : SUB COND? S? REG COMMA REG COMMA op2;
rsbInstr : RSB COND? S? REG COMMA REG COMMA op2;
adcInstr : ADC COND? S? REG COMMA REG COMMA op2;
sbcInstr : SBC COND? S? REG COMMA REG COMMA op2;
rscInstr : RSC COND? S? REG COMMA REG COMMA op2;
tstInstr : TST COND? REG COMMA op2;
teqInstr : TEQ COND? REG COMMA op2;
cmpInstr : CMP COND? REG COMMA op2;
orrInstr : ORR COND? S? REG COMMA REG COMMA op2;
movInstr : MOV COND? S? REG COMMA REG COMMA op2;
bicInstr : BIC COND? S? REG COMMA REG COMMA op2;
mvnInstr : MVN COND? S? REG COMMA REG COMMA op2;

/*
 * The following are used for Data Processing Instructions
 */


op2 : REG (COMMA shift)?
    | poundExpression
    ;

shift : SHIFTNAME REG
      | SHIFTNAME poundExpression
      | RPX
      ;

rList : LCURL rValue+ RCURL;
rValue : REG ('-' REG)?;

/*
 * Below is code for dealing with expressions
 */
poundExpression: HASH expression;
expression : andExpr (LOR andExpr)*;
andExpr : relational (LAND relational)*;
relational : primary ((EQ|NE|RLT|RGT|RLE|RGE) primary)?;
primary : bitwise ((PLUS|MINUS) bitwise)*;
bitwise : term ((BOR|BAND|BXOR) term)*;
term: unary ((TIMES|DIV|MOD|LSHIFT|RSHIFT) unary)*;
unary: (PLUS|MINUS)? number;
number: NUMBER;
label: IDENT;

/*
 * Below is the code for dealing with addresses
 */

address : expression
	| '[' REG ']'
	| '[' REG COMMA poundExpression ']' EXP?
	| '[' REG COMMA ('+'|'-')? REG (COMMA shift)? ']' EXP?
	| '[' REG ']' COMMA poundExpression
	| '[' REG ']' COMMA ('+'|'-')? REG (COMMA shift)?
	;



/*
 * Below is definitions of all of the tokens to be used
 * B is also declared bit it is declared later at the bottom
 */

ADC : A D C;
ADD : A D D;
AND : A N D;
BIC : B I C;
BL  : B L;
BX  : B X;
CMP : C M P;
EOR : E O R;
LDC : L D C;
LDM : L D M;
LDR : L D R;
MCR : M C R;
MLA : M L A;
MOV : M O V;
MRC : M R C;
MRS : M R S;
MSR : M S R;
MUL : M U L;
MVN : M V N;
ORR : O R R;
RSB : R S B;
RSC : R S C;
SBC : S B C;
STC : S T C;
STM : S T M;
STR : S T R;
SUB : S U B;
SWI : S W I;
SWP : S W P;
TEQ : T E Q;  
TST : T S T;

/*
 * The following are used for ldm and store memory instructions 
 */

TRANSFERTYPE : H
			 | SB
			 | SH
			 ;

SB 			 : S B;
SH 			 : S H;

ADDRESSINGMODE : FD
			   | ED
			   | FA
			   | EA
			   | IA
			   | IB
			   | DA
			   | DB
			   ;
FD : F D;
ED : E D;
FA : F A;
EA : E A;
IA : I A;
IB : I B;
DA : D A;
DB : D B;

/*
 * Below are the shift name variables
 */

ASL : A S L;
LSL : L S L;
LSR : L S R;
ASR : A S R;
ROR : R O R;

SHIFTNAME : ASL
	  	  | LSL
	      | LSR
	      | ASR
	      | ROR
	      ;

RPX : R P X;

/*
 * Below is code for condition codes
 */

EQ : E Q;
NE : N E;
CS : C S;
CC : C C;
MI : M I;
PL : P L;
VS : V S;
VC : V C;
HI : H I;
LS : L S;
GE : G E;
LT : L T;
GT : G T;
LE : L E;
AL : A L;

COND : EQ
     | NE
     | CS
     | CC
     | MI
     | PL
     | VS
     | VC
     | HI
     | LS
     | GE
     | LT
     | GT
     | LE
     | AL
     ;

/*
 * Below is the code for dealing with REGs
 */

REG : R DIGIT DIGIT?;

NUMBER : DIGIT+;

fragment DIGIT : [0-9];

PSR: CPSR
   | CPSR_ALL
   | SPSR
   | SPSR_ALL
   ;

PSRF: CPSR_FLG
    | SPSR_FLG
    ;

CPSR: C P S R;
CPSR_ALL: C P S R '_' A L L;
CPSR_FLG: C P S R '_' F L G;
SPSR: S P S R;
SPSR_ALL: S P S R '_' A L L;
SPSR_FLG: S P S R '_' F L G;	

EXP : '!';

WS : [ \t\r\n]+ -> skip ;

//And here are some operators

COMMA : ',';
LCURL : '{';
RCURL : '}';
REQ : '==';
RNE : '!=';
RLE : '<=';
RLT : '<';
RGE : '>=';
RGT : '>';
TIMES : '*';
MINUS : '-';
PLUS : '+';
MOD : '%';
DIV : '/';
LSHIFT : '<<';
RSHIFT : '>>';
BAND : '&';
BOR : '|';
BXOR : '^';
LAND : '&&';
LOR : '||';
HASH : '#';

fragment LETTER: STARTLETTER | '_' | DIGIT;
fragment STARTLETTER: [a-zA-Z];

IDENT : STARTLETTER LETTER*;

A : ('A'|'a');
B : ('B'|'b');
C : ('C'|'c');
D : ('D'|'d');
E : ('E'|'e');
F : ('F'|'f');
G : ('G'|'g');
H : ('H'|'h');
I : ('I'|'i');
J : ('J'|'j');
K : ('K'|'k');
L : ('L'|'l');
M : ('M'|'m');
N : ('N'|'n');
O : ('O'|'o');
P : ('P'|'p');
Q : ('Q'|'q');
R : ('R'|'r');
S : ('S'|'s');
T : ('T'|'t');
U : ('U'|'u');
V : ('V'|'v');
W : ('W'|'w');
X : ('X'|'x');
Y : ('Y'|'y');
Z : ('Z'|'z');




