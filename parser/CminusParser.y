/*******************************************************/
/*                     Cminus Parser                   */
/*                                                     */
/*******************************************************/

/*********************DEFINITIONS***********************/
%{
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <string.h>
#include <util/general.h>
#include <util/symtab.h>
#include <util/symtab_stack.h>
#include <util/dlink.h>
#include <util/string_utils.h>
/* added */
#include <codegen/symfields.h>
#include <codegen/types.h>
#include <codegen/codegen.h>
#include <codegen/reg.h>

#define SYMTABLE_SIZE 100
#define SYMTAB_VALUE_FIELD     "value"

/*********************EXTERNAL DECLARATIONS***********************/

EXTERN(void,Cminus_error,(const char*));

EXTERN(int,Cminus_lex,(void));

char *fileName;

SymTable symtab;

/* added */
static int gp = 0;
static int dataIndex = 0;
DList iList;
DList dList;
/* */

extern int Cminus_lineno;

extern FILE *Cminus_in;

%}

%name-prefix="Cminus_"
%defines

%start Program

%token AND
%token ELSE
%token EXIT
%token FOR
%token IF 		
%token INTEGER 
%token NOT 		
%token OR 		
%token READ
%token WHILE
%token WRITE
%token LBRACE
%token RBRACE
%token LE
%token LT
%token GE
%token GT
%token EQ
%token NE
%token ASSIGN
%token COMMA
%token SEMICOLON
%token LBRACKET
%token RBRACKET
%token LPAREN
%token RPAREN
%token PLUS
%token TIMES
%token IDENTIFIER
%token DIVIDE
%token RETURN
%token STRING	
%token INTCON
%token MINUS

%left OR
%left AND
%left NOT
%left LT LE GT GE NE EQ
%left PLUS MINUS
%left TIMES DIVDE

/* added */

/***********************PRODUCTIONS****************************/
%%
   Program		: Procedures 
		{
			//printf("<Program> -> <Procedures>\n");
			programMain();
		}
	  	| DeclList Procedures
		{
			//printf("<Program> -> <DeclList> <Procedures>\n");
			programMain();
		}
          ;

Procedures 	: ProcedureDecl Procedures
		{
			//printf("<Procedures> -> <ProcedureDecl> <Procedures>\n");
		}
	   	|
		{
			//printf("<Procedures> -> epsilon\n");
		}
	   	;

ProcedureDecl : ProcedureHead ProcedureBody
		{
			//printf("<ProcedureDecl> -> <ProcedureHead> <ProcedureBody>\n");
    		exitProgram();
		}
              ;

ProcedureHead : FunctionDecl DeclList 
		{
			//printf("<ProcedureHead> -> <FunctionDecl> <DeclList>\n");
			functionBegin($1);
		}
	      | FunctionDecl
		{
			//printf("<ProcedureHead> -> <FunctionDecl>\n");
			functionBegin($1);
		}
              ;

FunctionDecl :  Type IDENTIFIER LPAREN RPAREN LBRACE 
		{
			//printf("<FunctionDecl> ->  <Type> <IDENTIFIER> <LP> <RP> <LBR>\n"); 
			$$ = $2;
		}
	      	;

ProcedureBody : StatementList RBRACE
		{
			//printf("<ProcedureBody> -> <StatementList> <RBR>\n");
		}
	      ;


DeclList 	: Type IdentifierList  SEMICOLON 
		{
			//printf("<DeclList> -> <Type> <IdentifierList> <SC>\n");
			$$ = $2;
		}		
	   	| DeclList Type IdentifierList SEMICOLON
	 	{
			//printf("<DeclList> -> <DeclList> <Type> <IdentifierList> <SC>\n");
	 	}
          	;


IdentifierList 	: VarDecl  
		{
			//printf("<IdentifierList> -> <VarDecl>\n");
			$$ = $1;
		}
						
                | IdentifierList COMMA VarDecl
		{
			//printf("<IdentifierList> -> <IdentifierList> <CM> <VarDecl>\n");
		}
                ;

VarDecl 	: IDENTIFIER
		{ 
			//printf("<VarDecl> -> <IDENTIFIER\n");
			gp+=4; //increase offset for next variable
			SymPutFieldByIndex(symtab,$1,SYMTAB_OFFSET_FIELD,gp); 
			$$ = $1; //return index to variable
		}
		| IDENTIFIER LBRACKET INTCON RBRACKET
                {
			//printf("<VarDecl> -> <IDENTIFIER> <LBK> <INTCON> <RBK>\n");
		}
		;

Type     	: INTEGER 
		{ 
			//printf("<Type> -> <INTEGER>\n");
		}
                ;

Statement 	: Assignment
		{ 
			//printf("<Statement> -> <Assignment>\n");
		}
                | IfStatement
		{ 
			//printf("<Statement> -> <IfStatement>\n");
		}
		| WhileStatement
		{ 
			//printf("<Statement> -> <WhileStatement>\n");
		}
                | IOStatement 
		{ 
			//printf("<Statement> -> <IOStatement>\n");
		}
		| ReturnStatement
		{ 
			//printf("<Statement> -> <ReturnStatement>\n");
		}
		| ExitStatement	
		{ 
			//printf("<Statement> -> <ExitStatement>\n");
		}
		| CompoundStatement
		{ 
			//printf("<Statement> -> <CompoundStatement>\n");
		}
                ;

Assignment      : Variable ASSIGN Expr SEMICOLON
		{
			//printf("<Assignment> -> <Variable> <ASSIGN> <Expr> <SC>\n");
			char *regAddressName = (char*)SymGetFieldByIndex(symtab, $1, SYM_NAME_FIELD); //get name of address register
			char *regValueName = (char*)SymGetFieldByIndex(symtab, $3, SYM_NAME_FIELD); //get name of address register
			char *inst = nssave(1,"#Assign value to address"); //create instruction
    		dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
			inst = nssave(5,"\tsw ", regValueName, ", 0(", regAddressName, ")"); //create instruction
    		dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
			int reg = SymGetFieldByIndex(symtab, $1, SYMTAB_REGISTER_INDEX_FIELD);
			freeIntegerRegister(reg);
			reg = SymGetFieldByIndex(symtab, $3, SYMTAB_REGISTER_INDEX_FIELD);
			freeIntegerRegister(reg);
		}
                ;
				
IfStatement	: IF TestAndThen ELSE CompoundStatement
		{
			//printf("<IfStatement> -> <IF> <TestAndThen> <ELSE> <CompoundStatement>\n");
		}
		| IF TestAndThen
		{
			//printf("<IfStatement> -> <IF> <TestAndThen>\n");
		}
		;
		
				
TestAndThen	: Test CompoundStatement
		{
			//printf("<TestAndThen> -> <Test> <CompoundStatement>\n");
		}
		;
				
Test		: LPAREN Expr RPAREN
		{
			//printf("<Test> -> <LP> <Expr> <RP>\n");
		}
		;
	

WhileStatement  : WhileToken WhileExpr Statement
		{
			//printf("<WhileStatement> -> <WhileToken> <WhileExpr> <Statement>\n");
		}
                ;
                
WhileExpr	: LPAREN Expr RPAREN
		{
			//printf("<WhileExpr> -> <LP> <Expr> <RP>\n");
		}
		;
				
WhileToken	: WHILE
		{
			//printf("<WhileToken> -> <WHILE>\n");
		}
		;


IOStatement     : READ LPAREN Variable RPAREN SEMICOLON
		{
		    //printf("<IOStatement> -> <READ> <LP> <Variable> <RP> <SC>\n");
			readFunc($3);
			int reg = (int)SymGetFieldByIndex(symtab, $3, SYMTAB_REGISTER_INDEX_FIELD);
			freeIntegerRegister(reg);
		}
                | WRITE LPAREN Expr RPAREN SEMICOLON
		{
			//printf("<IOStatement> -> <WRITE> <LP> <Expr> <RP> <SC>\n");
			writeFunc($3, 1);
			int reg = (int)SymGetFieldByIndex(symtab, $3, SYMTAB_REGISTER_INDEX_FIELD);
			freeIntegerRegister(reg);
		}
                | WRITE LPAREN StringConstant RPAREN SEMICOLON         
		{
			//printf("<IOStatement> -> <WRITE> <LP> <StringConstant> <RP> <SC>\n");
			writeFunc($3, 4);
			int reg = (int)SymGetFieldByIndex(symtab, $3, SYMTAB_REGISTER_INDEX_FIELD);
			freeIntegerRegister(reg);
		}
                ;

ReturnStatement : RETURN Expr SEMICOLON
		{
			//printf("<ReturnStatement> -> <RETURN> <Expr> <SC>\n");
		}
                ;

ExitStatement 	: EXIT SEMICOLON
		{
			//printf("<ExitStatement> -> <EXIT> <SC>\n");
			exitProgram();
		}
		;

CompoundStatement : LBRACE StatementList RBRACE
		{
			//printf("<CompoundStatement> -> <LBR> <StatementList> <RBR>\n");
		}
                ;

StatementList   : Statement
		{		
			//printf("<StatementList> -> <Statement>\n");
		}
                | StatementList Statement
		{		
			//printf("<StatementList> -> <StatementList> <Statement>\n");
		}
                ;

Expr            : SimpleExpr
		{
			//printf("<Expr> -> <SimpleExpr>\n");
			$$ = $1;
		}
                | Expr OR SimpleExpr 
		{
			//printf("<Expr> -> <Expr> <OR> <SimpleExpr> \n");
			$$ = bitwise($1, $3, 0);
		}
                | Expr AND SimpleExpr 
		{
			//printf("<Expr> -> <Expr> <AND> <SimpleExpr> \n");
			$$ = bitwise($1, $3, 1);
		}
                | NOT SimpleExpr 
		{
			//printf("<Expr> -> <NOT> <SimpleExpr> \n");
			$$ = bitwise($2, $2, 2);
		}
                ;

SimpleExpr	: AddExpr
		{
			//printf("<SimpleExpr> -> <AddExpr>\n");
			$$ = $1;
		}
                | SimpleExpr EQ AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <EQ> <AddExpr> \n");
			$$ = comp($1, $3, 0);
		}
                | SimpleExpr NE AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <NE> <AddExpr> \n");
			$$ = comp($1, $3, 1);
		}
                | SimpleExpr LE AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <LE> <AddExpr> \n");
			$$ = comp($1, $3, 2);
		}
                | SimpleExpr LT AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <LT> <AddExpr> \n");
			$$ = comp($1, $3, 3);
		}
                | SimpleExpr GE AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <GE> <AddExpr> \n");
			$$ = comp($1, $3, 4);
		}
                | SimpleExpr GT AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <GT> <AddExpr> \n");
			$$ = comp($1, $3, 5);
		}
                ;

AddExpr		:  MulExpr            
		{
			//printf("<AddExpr> -> <MulExpr>\n");
			$$ = $1;
		}
                |  AddExpr PLUS MulExpr
		{
			//printf("<AddExpr> -> <AddExpr> <PLUS> <MulExpr> \n");
			$$ = math($1, $3, 0);
		}
                |  AddExpr MINUS MulExpr
		{
			//printf("<AddExpr> -> <AddExpr> <MINUS> <MulExpr> \n");
			$$ = math($1, $3, 1);
		}
                ;

MulExpr		:  Factor
		{
			//printf("<MulExpr> -> <Factor>\n");
			$$ = $1;
		}
                |  MulExpr TIMES Factor
		{
			//printf("<MulExpr> -> <MulExpr> <TIMES> <Factor> \n");
			$$ = advancedMath($1, $3, 0);
		}
                |  MulExpr DIVIDE Factor
		{
			//printf("<MulExpr> -> <MulExpr> <DIVIDE> <Factor> \n");
			$$ = advancedMath($1, $3, 1);
		}		
                ;
				
Factor          : Variable
		{ 
			//printf("<Factor> -> <Variable>\n");
			char* regAddressName = (char*)SymGetFieldByIndex(symtab, $1, SYM_NAME_FIELD); //get reg name
			int regIndex = getFreeIntegerRegisterIndex(symtab); //get a new reg to store value of reg
			char *regName = (char*) SymGetFieldByIndex(symtab, regIndex, SYM_NAME_FIELD); //get name of new reg
			char* inst  = nssave(1, "#Get variable from address");
			dlinkAppend(iList,dlinkNodeAlloc(inst));
			inst = nssave(5, "\tlw ", regName, ", 0(", regAddressName, ")");
			dlinkAppend(iList, dlinkNodeAlloc(inst));
			int reg = (int)SymGetFieldByIndex(symtab, $1, SYMTAB_REGISTER_INDEX_FIELD);
			freeIntegerRegister(reg);
			$$ = regIndex;
		}
                | Constant
		{ 
			//printf("<Factor> -> <Constant>\n");
			$$ = $1;
		}
                | IDENTIFIER LPAREN RPAREN
       		{	
			//printf("<Factor> -> <IDENTIFIER> <LP> <RP>\n");
		}
         	| LPAREN Expr RPAREN
		{
			//printf("<Factor> -> <LP> <Expr> <RP>\n");
			$$ = $2;
		}
                ;  

Variable        : IDENTIFIER
		{
			//printf("<Variable> -> <IDENTIFIER>\n");
			int regIndex = getFreeIntegerRegisterIndex(symtab); //get a free register
			char *regName = (char*)SymGetFieldByIndex(symtab, regIndex, SYM_NAME_FIELD); //get the name of the register
			int offset = (int)SymGetFieldByIndex(symtab, $1, SYMTAB_OFFSET_FIELD); //get the offset from gp to variable
			int size = snprintf(NULL, 0, "%d", offset); //convert int to string
			char *offsetString = malloc(size+1);
			snprintf(offsetString, size+1, "%d", offset);
			char *inst = nssave(1,"#Load variable address"); //create instruction
			dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
			inst = nssave(4,"\taddi ", regName, ", $gp, ", offsetString); //build instruction
			dlinkAppend(iList,dlinkNodeAlloc(inst)); //append instruction to instruction list
			free(offsetString);
			$$ = regIndex; //return index of reg
		}
                | IDENTIFIER LBRACKET Expr RBRACKET    
               	{
			//printf("<Variable> -> <IDENTIFIER> <LBK> <Expr> <RBK>\n");
               	}
                ;			       

StringConstant 	: STRING
		{ 
			//printf("<StringConstant> -> <STRING>\n");
			char *varName = (char*)SymGetFieldByIndex(symtab,$1,SYM_NAME_FIELD); //get value of string
			char *label = (char*)malloc(sizeof(char)*100); //make space for label in data section
			snprintf(label,100,".string%d",dataIndex); //create label
			dataIndex++;
			char *data = nssave(4, label, ": .asciiz \"", varName, "\""); //make data string
			dlinkAppend(dList,dlinkNodeAlloc(data)); //add data string to list
			int regIndex = getFreeIntegerRegisterIndex(symtab); //get register
			char *regName = (char*)SymGetFieldByIndex(symtab, regIndex, SYM_NAME_FIELD); //get name of register
			char *inst = nssave(1,"#Load constant string"); //create instruction
			dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
			inst = nssave(4,"\tla ", regName, ", ", label); //make instruction
			dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
			free(label);
			$$ = regIndex; //return reg index
		}
                ;

Constant        : INTCON
		{ 
			//printf("<Constant> -> <INTCON>\n");
			int regIndex = getFreeIntegerRegisterIndex(symtab); //get register
			char* regName = (char*)SymGetFieldByIndex(symtab,regIndex,SYM_NAME_FIELD); //get name of register
			int size = snprintf(NULL, 0, "%d", $1); //convert int to string
			char *numString = malloc(size+1);
			snprintf(numString, size+1, "%d", $1);
			char *inst = nssave(1,"#Load constant integer"); //create instruction
			dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
			inst = nssave(4,"\tli ", regName, ", ", numString); //create instruction
			dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
			free(numString);
			$$ = regIndex; //return reg index
		}
                ;

%%


/********************C ROUTINES *********************************/



void Cminus_error(const char *s)
{
  fprintf(stderr,"%s: line %d: %s\n",fileName,Cminus_lineno,s);
}

int Cminus_wrap() {
	return 1;
}

static void initialize(char* inputFileName) {

	Cminus_in = fopen(inputFileName,"r");
	if (Cminus_in == NULL) {
		fprintf(stderr,"Error: Could not open file %s\n",inputFileName);
		exit(-1);
	}

	char* dotChar = rindex(inputFileName,'.');
	int endIndex = strlen(inputFileName) - strlen(dotChar);
	char *outputFileName = nssave(2,substr(inputFileName,0,endIndex),".s");
	stdout = freopen(outputFileName,"w",stdout);
	if (stdout == NULL) {
		fprintf(stderr,"Error: Could not open file %s\n",outputFileName);
		exit(-1);
	}

	symtab = SymInit(SYMTABLE_SIZE);
	/* added */
	SymInitField(symtab,SYMTAB_OFFSET_FIELD,(Generic)-1,NULL);
	SymInitField(symtab,SYMTAB_REGISTER_INDEX_FIELD,(Generic)-1,NULL);
	initRegisters(); //regs
	iList = dlinkListAlloc(NULL); //inst list
	dList = dlinkListAlloc(NULL); //data list
}

static void finalize() {
    SymKillField(symtab,SYMTAB_OFFSET_FIELD);
    SymKillField(symtab,SYMTAB_REGISTER_INDEX_FIELD);
    SymKill(symtab);
	/* added */
	//clean stuff
	cleanupRegisters(); //regs
	dlinkFreeNodesAndAtoms(iList); //inst list
	dlinkFreeNodesAndAtoms(dList); //data list
	/* */
    fclose(Cminus_in);
    fclose(stdout);

}

int main(int argc, char** argv)
{	
	fileName = argv[1];
	initialize(fileName);
	
    Cminus_parse();
  
  	finalize();
  
  	return 0;
}
/******************END OF C ROUTINES**********************/
