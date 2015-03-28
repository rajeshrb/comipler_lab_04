#include <iostream>
#include <stdlib.h>
#include <string>
#include <map> 
#include <list>
#include <unordered_map>
using namespace std;
/*////////////////////////////////////////////
//////////////////   START     ///////////////
////////////////////////////////////////////*/


/*////////////////////////////////////////////
//////////  MAIN CLASS  //////////////////////
///////////////////////////////////////////*/
class abstract_astnode
{
    protected:
        virtual void print () = 0;
       // virtual std::string generate_code(const symbolTable&) = 0;
       // virtual basic_types getType() = 0;
        //virtual bool checkTypeofAST() = 0;
   // protected:
      //  virtual void setType(basic_types) = 0;
   // private:
       // typeExp astnode_type;
};

/*////////////////////////////////////////////
////////// Chirdren of MAIN CLASS  //////////
///////////////////////////////////////////*/
  
class StmtAst : public abstract_astnode
{
public:
    virtual void print() {} ;
    StmtAst(){}
};
class ExpAst : public abstract_astnode
{
    public:
        float num;
        string _type;
        string _ftype;
        ExpAst() {}
        virtual void print() {} ;
        void _print();
};

/*class arrayRef : public abstract_astnode
{
public:
    
    virtual void print();
};*/

/*////////////////////////////////////////////
//////////  children of StmtAst //////////////
////////////////////////////////////////////*/
class block_ast : public StmtAst
{
public:
list<StmtAst *> stlist;
block_ast(StmtAst *S);
void add(StmtAst *S);
void print();
};

class seq_ast : public StmtAst
{
protected:
    StmtAst * left;
    StmtAst * right;
public:
    seq_ast(StmtAst *L,StmtAst *R);
    void print();
};

class ass_ast : public StmtAst
{
protected:
    ExpAst *left;
    ExpAst *right;
public:
    void print();
    ass_ast(ExpAst *L,ExpAst *R);
};

class return_ast : public StmtAst
{
protected:
    ExpAst *exp;
public:
    void print();
    return_ast(ExpAst *E);
};

class if_ast : public StmtAst
{
protected:
    ExpAst *exp;
    StmtAst *st1;
    StmtAst *st2;
public:
    void print();
    if_ast(ExpAst *E,StmtAst *S1,StmtAst *S2);
};

class while_ast : public StmtAst
{
protected:
    ExpAst *exp;
    StmtAst *st;
public:
    void print();
    while_ast(ExpAst *E,StmtAst *S);
};

class for_ast : public StmtAst
{
protected:
    ExpAst *exp1;
    ExpAst *exp2;
    ExpAst *exp3;
    StmtAst *st;
public:
    void print();
    for_ast(ExpAst *E1,ExpAst *E2,ExpAst *E3,StmtAst *S);
};

/*////////////////////////////////////////////
//////////  children of ExpAst ///////////////
////////////////////////////////////////////*/
class exps : public ExpAst
{
public:
list<ExpAst *> Elist;
void addE(ExpAst *E);
void print();
exps(ExpAst *E);
};

class op_ast : public ExpAst
{
public:
        ExpAst *left;
        ExpAst *right;
        op_ast(ExpAst *,ExpAst *);
};

class unary_op_ast : public ExpAst
{
protected:
    ExpAst *exp;
public:
  //  virtual void print();
    unary_op_ast(ExpAst *E);
};

class floatconst : public ExpAst
{
public:
    floatconst(float val);
    void print();
};

class intconst : public ExpAst
{
public:
    intconst(int val);
    void print();
    ~intconst();
    
};

class stringconst : public ExpAst
{
protected:
    string s;
public:
    stringconst(string S);
    void print();
    ~stringconst();
    
};

class ArrayRef_ast : public ExpAst
{
public:
    ArrayRef_ast() {};
    virtual void print() {};
    //~ArrayRef_ast();
};

class identifier_ast : public ArrayRef_ast
{
    
public:
    string id;
    identifier_ast(string I);
    void print();
    ~identifier_ast();
    
};

class index_ast : public ArrayRef_ast
{
public: 
ExpAst *exp;
ArrayRef_ast *ar;
index_ast(ArrayRef_ast *A,ExpAst *E);
void print();
};

class funcall_ast :public ExpAst
{
protected:
    identifier_ast *funname;
    ExpAst *expslist;
public:
    funcall_ast(ExpAst *explist,identifier_ast *S);
    void print();
};

/*////////////////////////////////////////////
//////////  children of op_ast ///////////////
////////////////////////////////////////////*/

class or_ast : public op_ast
{
    public:
        or_ast(ExpAst *L,ExpAst *R);
        void print();
};
class and_ast : public op_ast
{
    public:
        and_ast(ExpAst *L,ExpAst *R);
        void print();
};
class eq_op_ast : public op_ast
{
    public:
        eq_op_ast(ExpAst *L,ExpAst *R);
        void print();
};
class ne_op_ast : public op_ast
{
    public:
        ne_op_ast(ExpAst *L,ExpAst *R);
        void print();
};
class lt_ast : public op_ast
{
    public:
        lt_ast(ExpAst *L,ExpAst *R);
        void print();
};
class gt_ast : public op_ast
{
    public:
        gt_ast(ExpAst *L,ExpAst *R);
        void print();
};
class le_op_ast : public op_ast
{
    public:
        le_op_ast(ExpAst *L,ExpAst *R);
        void print();
};
class ge_op_ast : public op_ast
{
    public:
        ge_op_ast(ExpAst *L,ExpAst *R);
        void print();
};
class plus_ast : public op_ast
{
    public:
        plus_ast(ExpAst *L,ExpAst *R);
        void print();
};
class minus_ast : public op_ast
{
    public:
        minus_ast(ExpAst *L,ExpAst *R);
        void print();
};
class mult_ast : public op_ast
{
    public:
        mult_ast(ExpAst *L,ExpAst *R);
        void print();
};
class devide_ast : public op_ast
{
    public:
        devide_ast(ExpAst *L,ExpAst *R);
        void print();
};
class assign_ast : public op_ast
{
    public:
        assign_ast(ExpAst *L,ExpAst *R);
        void print();
};
/*////////////////////////////////////////////
//////////  children of unary_op_ast /////////
////////////////////////////////////////////*/
class uminus_ast : public unary_op_ast
{
    public:
        uminus_ast(ExpAst *E);
        void print();
};

class not_ast : public unary_op_ast
{
public:
    not_ast(ExpAst *E);
    void print();
    ~not_ast();
    
};

class pp_ast : public unary_op_ast
{
public:
    pp_ast(ExpAst *E);
    void print();
   // ~pp_ast();
    
};
/*/////////////////////////////////////
////////////   Program  ///////////////
/////////////////////////////////////*/

class method 
{
protected:
    identifier_ast *id;
    block_ast *block;
public:
    method(identifier_ast *I,block_ast *stmtlist);
    void print();
};

class program
{
	protected:
	list<method *> funs;
	public:
	program(method *);
    void addm(method *);
    void print();

};


/********** symbol table ***************/

class _Identifier               /* variable */
{
    public:
        string type;        
        string token_name;
        int dimension;
        int size;
        int offset;
        _Identifier(string,string,int,int,int);
        void print();
};

class _Function                 /* a function details */
{
                   
    
    public:
        string token_name; 
        string type; 
        unordered_map<string,_Identifier*> declarations;        /* all local veriables */
        unordered_map<string,_Identifier*> parameters;            /* parameters and thier types */
        map<int,string> parameters_pos;
        _Function(string,string);                           
        bool add_parameter(_Identifier*);
        bool add_declaration(_Identifier*);
        void change_fname(string);
        void print();
};


extern unordered_map<string,_Function*> Functions;
extern program* _prog;
extern int err;

//_Function * curr;
/************ Error details ******************/
class _Error
{
    int line_no;                /* line at which error occured */
    int error_code;         /* kind of error, 0 for non-declaration, 1 for re-declaration, 2 for type incompatibility, 3 for  syntax error, 4 for floating point*/
    string error_msg;           /* error msg to be printed */
    public:
        _Error(int,int,string);             /* create a instance of error */
        void report_error();                /*  report the error */
};

/*////////////////////////////////////////////
//////////////////    END      ///////////////
////////////////////////////////////////////*/
