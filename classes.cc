#include <iostream>
#include "classes.h"
#include <cstdio>
#include <unordered_map>
using namespace std;
int no_spaces = 0;
program * root;
void print_space(int n)
{
for(int i=0;i<n;i++)
{
cout << " ";
}
}

block_ast::block_ast(StmtAst *S)
{
	stlist.push_back(S);
}

void block_ast::add(StmtAst *S)
{
	stlist.push_back(S);
}

void block_ast::print()
{
if(stlist.begin() == stlist.end())
{
print_space(no_spaces);
cout<<"(empty)";
}
else {
print_space(no_spaces);
cout<<"(BLOCK [\n";
no_spaces +=8; 
list<StmtAst *>::iterator it;

for(it = stlist.begin();it!=stlist.end();it++)
{
(*it)->print();
cout<<endl;
}
print_space(no_spaces);
cout<<"])\n";
no_spaces -=8; 
}
}


seq_ast::seq_ast(StmtAst *L,StmtAst *R)
{
	left = L;
	right = R;
}

void seq_ast::print()
{
	cout<<"(";
	left->print();
	cout<<")\n";
	cout<<"(";
	right->print();
	cout<<")";
	
}


ass_ast::ass_ast(ExpAst *L,ExpAst *R)
{
	left = L;
	right = R;
}

void ass_ast::print()
{
	if(left==NULL && right == NULL)
	{
		print_space(no_spaces);
		cout<<"(empty)";
	}
	else
	{
	print_space(no_spaces);
	cout<<"(Assign_Exp(";
	left->print();
	cout<<")(";
	right->print();
	cout<<"))";
	}
}

return_ast::return_ast(ExpAst *E)
{
	exp = E;
	
}
void return_ast::print()
{
	print_space(no_spaces);
	cout<<"(Return_Exp(";
	exp->print();
	cout<<"))";
}

if_ast::if_ast(ExpAst *E,StmtAst *S1,StmtAst *S2)
{
	exp = E;
	st1 = S1;
	st2 = S2;
}
void if_ast::print()
{
	print_space(no_spaces);
	cout<<"(If((";
	no_spaces+=4;
	exp->print();
	cout<<") \n";
	st1->print();
	st2->print();
	//print_space(no_spaces);
	cout<<endl;
	print_space(no_spaces);
	cout<<"))";
	no_spaces-=4;
	
}

while_ast::while_ast(ExpAst *E,StmtAst *S)
{
	exp = E;
	st = S;
}
void while_ast::print()
{
	print_space(no_spaces);
	cout<<"(While((";
	exp->print();
	cout<<")\n";
	no_spaces+=8;
	st->print();
	print_space(no_spaces);
	cout<<"))";
	no_spaces-=8;
}

for_ast::for_ast(ExpAst *E1,ExpAst *E2,ExpAst *E3,StmtAst *S)
{
	exp1 = E1;
	exp2 = E2;
	exp3 = E3;
	st   = S;
}
void for_ast::print()
{
	print_space(no_spaces);
	cout<<"(For((";
	exp1->print();
	cout<<")\n";
	no_spaces+=6;
	print_space(no_spaces);
	cout<<"(";
	exp2->print();
	cout<<")\n";
	print_space(no_spaces);
	cout<<"(";
	exp3->print();
	cout<<")\n";
	//print_space(no_spaces);
	//cout<<"(";
	st->print();
	cout<<"))";
	no_spaces-=6;
}

/*////////////////////////////////////////////
//////////  children of ExpAst ///////////////
////////////////////////////////////////////*/

void exps::print()
{
	list<ExpAst *>::iterator it;
	for(it = Elist.begin();it != Elist.end();it++)
	{
		cout<<"(";
		(*it)->print();
		cout<<") ";
	}
}
void exps::addE(ExpAst *E)
{
	Elist.push_back(E);
}

exps::exps(ExpAst *E)
{
	Elist.push_back(E);
}

op_ast::op_ast(ExpAst *L,ExpAst *R)
{
	left = L;
	right= R;
}

unary_op_ast::unary_op_ast(ExpAst *E)
{
	exp = E;
}
// Function call
funcall_ast::funcall_ast(ExpAst *explist,identifier_ast *S):expslist(explist),funname(S){} 
void funcall_ast::print()
{
	if(_type != _ftype)
	{
		cout<<"TO_"<<_ftype<<"(";
		cout<<"Fun_Call \"";
		funname->print();
		cout<<"\" ";
		expslist->print();
		cout<<")";
	}
	else
	{
	cout<<"Fun_Call \"";
	funname->print();
	cout<<"\" ";
	expslist->print();
	}
	
	
}
//end

floatconst::floatconst(float val)
{

	num = val;
}
void floatconst::print()
{
	if(_type != _ftype)
	{
		cout<<"TO_"<<_ftype<<"(";
		cout<<"FloatConst "<<num;
		cout<<")";
	}
	else
	{
		cout<<"FloatConst "<<num;
	}
}

intconst::intconst(int val)
{
	num = val;
}
void intconst::print()
{
	if(_type != _ftype)
	{
		cout<<"TO_"<<_ftype<<"(";
		cout<<"IntConst "<<num;
		cout<<")";
	}
	else
	{
		cout<<"IntConst "<<num;
	}
}

stringconst::stringconst(string S)
{
	s = S;
}
void stringconst::print()
{
	cout<<"StringLiteral "<<s;
}

identifier_ast::identifier_ast(string I)
{
	id = I;
}
void identifier_ast::print()
{
	if(_type!=_ftype)
	{
		cout<<"TO_"<<_ftype<<"(";
		cout << "Id \""<<id<<"\"";
		cout<<")";
	}
	else
	cout << "Id \""<<id<<"\"";
}
//arrayref
index_ast::index_ast(ArrayRef_ast *A,ExpAst *E)
{
	exp = E;
	ar = A;
}
void index_ast::print()
{
	cout<<"Index (";
	ar->print();
	cout<<") (";
	exp->print();
	cout<<")";
}
//ed
/*////////////////////////////////////////////
//////////  children of op_ast ///////////////
////////////////////////////////////////////*/

or_ast::or_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void or_ast::print() 
{
	cout << "Or (";
	left->print();
	cout <<") (";
	right->print();
	cout<<")";
	
}
and_ast::and_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void and_ast::print() 
{
	cout << "And (";
	left->print();
	cout <<") (";
	right->print();
	cout<<")";
	
}
eq_op_ast::eq_op_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void eq_op_ast::print() 
{
	cout << "EQ_OP (";
	left->print();
	cout <<") (";
	right->print();
	cout<<")";
	
}

ne_op_ast::ne_op_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void ne_op_ast::print() 
{
	cout << "NE_OP (";
	left->print();
	cout <<") (";
	right->print();
	cout<<")";
	
}

lt_ast::lt_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void lt_ast::print() 
{
	cout << "LT (";
	left->print();
	cout <<") (";
	right->print();
	cout<<")";
	
}
gt_ast::gt_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void gt_ast::print() 
{
	cout << "GT (";
	left->print();
	cout <<") (";
	right->print();
	cout<<")";
	
}

le_op_ast::le_op_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void le_op_ast::print() 
{
	cout << "LE_OP (";
	left->print();
	cout <<") (";
	right->print();
	cout<<")";
	
}

ge_op_ast::ge_op_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void ge_op_ast::print() 
{
	cout << "GE_OP (";
	left->print();
	cout <<") (";
	right->print();
	cout<<")";
	
}

plus_ast::plus_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void plus_ast::print() 
{
	cout << "PLUS (";
	left->print();
	cout <<") (";
	right->print();
	cout<<")";
	
}

minus_ast::minus_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void minus_ast::print() 
{
	cout << "MINUS (";
	left->print();
	cout <<") (";
	right->print();
	cout<<")";
	
}

mult_ast::mult_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void mult_ast::print() 
{
	cout << "MULT (";
	left->print();
	cout <<") (";
	right->print();
	cout<<")";
	
}

devide_ast::devide_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void devide_ast::print() 
{
	cout << "DEVIDE (";
	left->print();
	cout <<") (";
	right->print();
	cout<<")";
	
}

assign_ast::assign_ast(ExpAst *L,ExpAst *R):op_ast(L,R) {}


void assign_ast::print()
{
	cout<<"Assign_Exp(";
	left->print();
	cout<<")(";
	right->print();
	cout<<")";
}
/*////////////////////////////////////////////
//////////  children of unary_op_ast /////////
////////////////////////////////////////////*/

uminus_ast::uminus_ast(ExpAst *E):unary_op_ast(E){}
void uminus_ast::print()
{
	cout<<"UMINUS (";
	exp->print();
	cout<<")";
}

not_ast::not_ast(ExpAst *E):unary_op_ast(E){}
void not_ast::print()
{
	cout<<"NOT (";
	exp->print();
	cout<<")";
}

pp_ast::pp_ast(ExpAst *E):unary_op_ast(E){}
void pp_ast::print()
{
	cout<<"PP (";
	exp->print();
	cout<<")";
}

method::method(identifier_ast *I,block_ast *stmtlist):id(I),block(stmtlist){}
void method::print()
{
	cout<<"Function : ";
	id->print();
	cout<<"\n";
	//cout<<"hbhj";
	block->print();
	cout<<"\n";
}
program::program(list<method *> *funlist):funs(funlist) {}

/*void symbol_t::adds(string N,string T)
{
	stypes.insert(pair(N,T));
}
symbol_t global;
unordered_map <string,symbol_t * > f_ptr;
*/
