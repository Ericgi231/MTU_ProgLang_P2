#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <util/string_utils.h>
#include <util/symtab.h>
#include <util/dlink.h>
#include "reg.h"
#include "codegen.h"
#include "symfields.h"
#include "types.h"

/** prints a line to the standard out from a DList atom
 */
static void printLine(DNode a) {
	printf("%s\n",(char*)dlinkNodeAtom(a));
}

/** writes mips code to print newline to the instruction list
 */
static void writeNewLine(){
    char *inst = nssave(1,"#Write new line"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
    inst = nssave(1,"\tli $v0, 4"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
    inst = nssave(1,"\tla $a0, .newline"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
    inst = nssave(1,"\tsyscall"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
}

/** writes mips code to print string or int to instruction list
 * @param index index into symtab
 * @param sys sys code to set [1, 4]
 */
void writeFunc(int index, int sys){
	char *regName = (char*)SymGetFieldByIndex(symtab, index, SYM_NAME_FIELD); //get name of register
    char *inst;
    if (sys == 4) { //write string
        inst = nssave(1,"#Write string"); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        inst = nssave(1,"\tli $v0, 4"); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
    } else { //write int
        inst = nssave(1,"#Write integer"); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        inst = nssave(1,"\tli $v0, 1"); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
    }
    inst = nssave(2,"\tmove $a0, ", regName); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
    inst = nssave(1,"\tsyscall"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
    writeNewLine();
}

/** writes mips code to read int to instruction list
 * @param index index into symtab
 */
void readFunc(int index){
    char *regName = (char*)SymGetFieldByIndex(symtab, index, SYM_NAME_FIELD);
    char *inst = nssave(1,"#Read integer"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
    inst = nssave(1,"\tli $v0, 5"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
    inst = nssave(1,"\tsyscall"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
    inst = nssave(3,"\tsw $v0, 0(", regName, ")"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
}

/** writes mips code to perform bitwise operations to instruction list
 * @param reg1 first register
 * @param reg2 second register
 * @param op operation [|, &, !]
 * @return index to register in symtab
 */
int bitwise(int reg1, int reg2, int op){
    char *regName1 = (char*)SymGetFieldByIndex(symtab, reg1, SYM_NAME_FIELD);
    char *regName2 = (char*)SymGetFieldByIndex(symtab, reg2, SYM_NAME_FIELD);
    char *inst = nssave(1,"#Bitwise operation"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list

    int regOut = getFreeIntegerRegisterIndex(symtab);
    char* regName3 = nssave(1, SymGetFieldByIndex(symtab, regOut, SYM_NAME_FIELD));

    switch (op)
    {
    case 0:
        inst = nssave(6,"\tor ", regName3, ", ", regName1, ", ", regName2); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    case 1:
        inst = nssave(6,"\tand ", regName3, ", ", regName1, ", ", regName2); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    case 2:
        inst = nssave(5,"\txori ", regName3, ", ", regName1, ", 1"); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    }

    int reg = SymGetFieldByIndex(symtab, reg1, SYMTAB_REGISTER_INDEX_FIELD);
    freeIntegerRegister(reg);
    reg = SymGetFieldByIndex(symtab, reg2, SYMTAB_REGISTER_INDEX_FIELD);
    freeIntegerRegister(reg);

    return regOut;
}

/** writes mips code to perform bitwise operations to instruction list
 * @param reg1 first register
 * @param reg2 second register
 * @param op operation [==, !=, <=, <, >=, >]
 * @return index to register in symtab
 */
int comp(int reg1, int reg2, int op){
    char *regName1 = (char*)SymGetFieldByIndex(symtab, reg1, SYM_NAME_FIELD);
    char *regName2 = (char*)SymGetFieldByIndex(symtab, reg2, SYM_NAME_FIELD);
    char *inst = nssave(1,"#Compare operation"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list

    int regOut = getFreeIntegerRegisterIndex(symtab);
    char* regName3 = nssave(1, SymGetFieldByIndex(symtab, regOut, SYM_NAME_FIELD));

    switch (op)
    {
    case 0:
        inst = nssave(6,"\tseq ", regName3, ", ", regName1, ", ", regName2); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    case 1:
        inst = nssave(6,"\tsne ", regName3, ", ", regName1, ", ", regName2); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    case 2:
        inst = nssave(6,"\tsle ", regName3, ", ", regName1, ", ", regName2); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    case 3:
        inst = nssave(6,"\tslt ", regName3, ", ", regName1, ", ", regName2); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    case 4:
        inst = nssave(6,"\tsge ", regName3, ", ", regName1, ", ", regName2); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    case 5:
        inst = nssave(6,"\tsgt ", regName3, ", ", regName1, ", ", regName2); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    }

    int reg = SymGetFieldByIndex(symtab, reg1, SYMTAB_REGISTER_INDEX_FIELD);
    freeIntegerRegister(reg);
    reg = SymGetFieldByIndex(symtab, reg2, SYMTAB_REGISTER_INDEX_FIELD);
    freeIntegerRegister(reg);

    return regOut;
}

/** writes mips code to perform bitwise operations to instruction list
 * @param reg1 first register
 * @param reg2 second register
 * @param op operation [+, -]
 * @return index to register in symtab
 */
int math(int reg1, int reg2, int op){
    char *regName1 = (char*)SymGetFieldByIndex(symtab, reg1, SYM_NAME_FIELD);
    char *regName2 = (char*)SymGetFieldByIndex(symtab, reg2, SYM_NAME_FIELD);
    char *inst = nssave(1,"#Math operation"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list

    int regOut = getFreeIntegerRegisterIndex(symtab);
    char* regName3 = nssave(1, SymGetFieldByIndex(symtab, regOut, SYM_NAME_FIELD));

    switch (op)
    {
    case 0:
        inst = nssave(6,"\tadd ", regName3, ", ", regName1, ", ", regName2); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    case 1:
        inst = nssave(6,"\tsub ", regName3, ", ", regName1, ", ", regName2); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    }

    int reg = SymGetFieldByIndex(symtab, reg1, SYMTAB_REGISTER_INDEX_FIELD);
    freeIntegerRegister(reg);
    reg = SymGetFieldByIndex(symtab, reg2, SYMTAB_REGISTER_INDEX_FIELD);
    freeIntegerRegister(reg);

    return regOut;
}

/** writes mips code to perform bitwise operations to instruction list
 * @param reg1 first register
 * @param reg2 second register
 * @param op operation [*, /]
 * @return index to register in symtab
 */
int advancedMath(int reg1, int reg2, int op){
    char *regName1 = (char*)SymGetFieldByIndex(symtab, reg1, SYM_NAME_FIELD);
    char *regName2 = (char*)SymGetFieldByIndex(symtab, reg2, SYM_NAME_FIELD);
    char *inst = nssave(1,"#Math operation"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list

    int regOut = getFreeIntegerRegisterIndex(symtab);
    char* regName3 = nssave(1, SymGetFieldByIndex(symtab, regOut, SYM_NAME_FIELD));

    switch (op)
    {
    case 0:
        inst = nssave(6,"\tmul ", regName3, ", ", regName1, ", ", regName2); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    case 1:
        inst = nssave(6,"\tdiv ", regName3, ", ", regName1, ", ", regName2); //create instruction
        dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
        break;
    }

    int reg = SymGetFieldByIndex(symtab, reg1, SYMTAB_REGISTER_INDEX_FIELD);
    freeIntegerRegister(reg);
    reg = SymGetFieldByIndex(symtab, reg2, SYMTAB_REGISTER_INDEX_FIELD);
    freeIntegerRegister(reg);

    return regOut;
}

/** writes mips code for entery into function to instruction list
 * @param index index into symtab for name of function
 */
void functionBegin(int index) {
	char *name = (char*)SymGetFieldByIndex(symtab,index,SYM_NAME_FIELD); 
	char* inst = nssave(2, "\t.globl ", name);
	dlinkAppend(iList,dlinkNodeAlloc(inst));
    inst = nssave(2, name, ":\tnop");
	dlinkAppend(iList,dlinkNodeAlloc(inst));
    inst = nssave(1, "\tmove $fp, $sp");
	dlinkAppend(iList,dlinkNodeAlloc(inst));
}

/** Writes mips code for exit to the instruction list
 */
void exitProgram() {
	char *inst = nssave(1,"#End program"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
    inst = nssave(1,"\tli $v0, 10"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
    inst = nssave(1,"\tsyscall"); //create instruction
    dlinkAppend(iList,dlinkNodeAlloc(inst)); //add instruction to list
}

/** writes all mips code for complete output
 */
void programMain(){
    printf("\t.data\n");	
    printf(".newline: .asciiz \"\\n\"\n");	                                              
    dlinkApply(dList,(DLinkApplyFunc)printLine);
    printf("\t.text\n");
    dlinkApply(iList,(DLinkApplyFunc)printLine);
}