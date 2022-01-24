#ifndef CODEGEN_H_
#define CODEGEN_H_

#include <util/symtab.h>
#include <codegen/types.h>

#define SYSCALL_PRINT_INTEGER "1"	/**< The syscall code for printing an integer */
#define SYSCALL_PRINT_FLOAT "2"	/**< The syscall code for printing a float */
#define SYSCALL_PRINT_STRING "4"	/**< The syscall code for printing a string */
#define SYSCALL_READ_INTEGER "5"	/**< The syscall code for reading an integer */
#define SYSCALL_READ_FLOAT "6"	/**< The syscall code for reading a float */
#define SYSCALL_EXIT "10"			/**< The syscall code for exiting the interpreter */

extern DList iList;
extern DList dList;
extern SymTable symtab;

void programMain();
void writeFunc(int index, int sys);
void readFunc(int index);
void functionBegin(int index);
void exitProgram();
int bitwise(int reg1, int reg2, int op);
int comp(int reg1, int reg2, int op);
int math(int reg1, int reg2, int op);
int advancedMath(int reg1, int reg2, int op);

#endif /*CODEGEN_H_*/

