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
void ExpAst::_print()
{
	if(_type == _ftype)
	{
		print();
	}
	else
	{
		cout<<"TO_"<<_ftype<<"(";
		print();
		cout<<")";
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
	left->_print();
	cout<<")(";
	right->_print();
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
	exp->_print();
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
	exp->_print();
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
	exp->_print();
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
		(*it)->_print();
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
	right = R;
}

unary_op_ast::unary_op_ast(ExpAst *E)
{
	exp = E;
}
// Function call
funcall_ast::funcall_ast(ExpAst *explist,identifier_ast *S):expslist(explist),funname(S){} 
void funcall_ast::print()
{
	
	cout<<"Fun_Call \"";
	funname->print();
	cout<<"\" ";
	expslist->print();
}
//end

floatconst::floatconst(float val)
{

	num = val;
}
void floatconst::print()
{
	
		cout<<"FloatConst "<<num;
	
}

intconst::intconst(int val)
{
	num = val;
}
void intconst::print()
{
	
		cout<<"IntConst "<<num;
	
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
	exp->_print();
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
	left->_print();
	cout <<") (";
	right->_print();
	cout<<")";
	
}
and_ast::and_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void and_ast::print() 
{
	cout << "And (";
	left->_print();
	cout <<") (";
	right->_print();
	cout<<")";
	
}
eq_op_ast::eq_op_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void eq_op_ast::print() 
{
	cout << "EQ_OP (";
	left->_print();
	cout <<") (";
	right->_print();
	cout<<")";
	
}

ne_op_ast::ne_op_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void ne_op_ast::print() 
{
	cout << "NE_OP (";
	left->_print();
	cout <<") (";
	right->_print();
	cout<<")";
	
}

lt_ast::lt_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void lt_ast::print() 
{
	cout << "LT (";
	left->_print();
	cout <<") (";
	right->_print();
	cout<<")";
	
}
gt_ast::gt_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void gt_ast::print() 
{
	cout << "GT (";
	left->_print();
	cout <<") (";
	right->_print();
	cout<<")";
	
}

le_op_ast::le_op_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void le_op_ast::print() 
{
	cout << "LE_OP (";
	left->_print();
	cout <<") (";
	right->_print();
	cout<<")";
	
}

ge_op_ast::ge_op_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void ge_op_ast::print() 
{
	cout << "GE_OP (";
	left->_print();
	cout <<") (";
	right->_print();
	cout<<")";
	
}

plus_ast::plus_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void plus_ast::print() 
{
	cout << "PLUS (";
	left->_print();
	cout <<") (";
	right->_print();
	cout<<")";
	
}

minus_ast::minus_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void minus_ast::print() 
{
	cout << "MINUS (";
	left->_print();
	cout <<") (";
	right->_print();
	cout<<")";
	
}

mult_ast::mult_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void mult_ast::print() 
{
	cout << "MULT (";
	left->_print();
	cout <<") (";
	right->_print();
	cout<<")";
	
}

devide_ast::devide_ast(ExpAst *L,ExpAst *R):op_ast(L,R){}
void devide_ast::print() 
{
	cout << "DEVIDE (";
	left->_print();
	cout <<") (";
	right->_print();
	cout<<")";
	
}

assign_ast::assign_ast(ExpAst *L,ExpAst *R):op_ast(L,R) {}


void assign_ast::print()
{
	cout<<"Assign_Exp(";
	left->_print();
	cout<<")(";
	right->_print();
	cout<<")";
}
/*////////////////////////////////////////////
//////////  children of unary_op_ast /////////
////////////////////////////////////////////*/

uminus_ast::uminus_ast(ExpAst *E):unary_op_ast(E){}
void uminus_ast::print()
{
	cout<<"UMINUS (";
	exp->_print();
	cout<<")";
}

not_ast::not_ast(ExpAst *E):unary_op_ast(E){}
void not_ast::print()
{
	cout<<"NOT (";
	exp->_print();
	cout<<")";
}

pp_ast::pp_ast(ExpAst *E):unary_op_ast(E){}
void pp_ast::print()
{
	cout<<"PP (";
	exp->_print();
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

/********** symbol table ***************/

_Identifier::_Identifier(string var_name,string var_type):type(var_type),token_name(var_name){}

void _Identifier::print()
{
	cout<<type<<" "<<token_name<<endl;
}

_Function::_Function(string func_type,string func_name):type(func_type), token_name(func_name){}

void _Function::change_fname(string N)
{
	token_name = N;
}

bool _Function::add_parameter(_Identifier* var)
{
	return parameters.insert(make_pair(var->token_name,var)).second;	
}

/*bool _Function::add_declaration(_Identifier* var)
{
	return declarations.insert(make_pair(var->token_name,var)).second;
}*/

void _Function::print()
{
	unordered_map<string,_Identifier*>::iterator it;
	cout<<"Function variables\n";
	for(it=parameters.begin(); it!=parameters.end(); it++)
	{
		it->second->print();
	}

}

/*
bool _GlobalTable::add_function(_Function* func)
{
	return Functions.insert(make_pair(func->toke_name,func)).second;
}*/

/****************** Error details ************************/
_Error::_Error(int line_no, int err_code, string err_msg): line_no(line_no), error_code(err_code), error_msg(err_msg){}
void _Error::report_error()
{
	cout<<line_no<<": error :"<<error_msg<<endl;
}

/*void symbol_t::adds(string N,string T)
{
	stypes.insert(pair(N,T));
}
symbol_t global;
unordered_map <string,symbol_t * > f_ptr;
*/
