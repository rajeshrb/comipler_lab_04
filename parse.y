//Sunday 22 March 2015 02:46:22 AM IST 
%scanner Scanner.h
%scanner-token-function d_scanner.lex()

%token VOID INT FLOAT FLOAT_CONSTANT INT_CONSTANT AND_OP OR_OP EQ_OP NE_OP LE_OP GE_OP STRING_LITERAL IF ELSE WHILE FOR RETURN IDENTIFIER INC_OP COMMENTS

%polymorphic exp : ExpAst* ; stmt : StmtAst*; Int : int; Float : float; String : string; expsl : exps * ; funs : list<method *>* ; fun :
method* ; Char : char ; Id : identifier_ast * ; aref : ArrayRef_ast *; Block : block_ast *; Identifier : _Identifier *;

%type <fun> function_definition
%type <funs> translation_unit
%type <exp> expression equality_expression relational_expression additive_expression multiplicative_expression unary_expression primary_expression postfix_expression logical_and_expression constant_expression 
%type <expsl> expression_list
%type <aref> l_expression
%type <Block> statement_list compound_statement 
%type <Id> fun_declarator
%type <stmt>  statement selection_statement iteration_statement assignment_statement
%type <Char> unary_operator
%type <Int> INT_CONSTANT
%type <Float> FLOAT_CONSTANT
%type <String> STRING_LITERAL IDENTIFIER type_specifier declarator
%type <Identifier> parameter_declaration
%%

translation_unit
	: function_definition
	{
		/*unordered_map<string,_Function*>::iterator it;
		for(it=Functions.begin(); it!=Functions.end(); it++)
		{
			it->second->print();
		}
		cout <<"*************\n";*/
		//_curr->print();	
		if(!err)$1->print();
		enable =1;
	} 
	| translation_unit function_definition 
	{
		/*unordered_map<string,_Function*>::iterator it;
		for(it=Functions.begin(); it!=Functions.end(); it++)
		{
			it->second->print();
		}
		cout <<"*************\n";*/		
		//_curr->print();		
		if(!err)$2->print();		
		enable =1;
	} 
        ;

function_definition
	: type_specifier fun_declarator compound_statement 
	{
		if(Functions.insert(make_pair($2->id,_curr)).second)
		{
			$$=new method($2,$3);
		}
		else
		{
			$$=new method($2,$3);
			//$$=NULL;
			cout<<no_lines<<" : error : "<<$2->id<<" Has been Declared previously . \n";
		}
	} 
	;

type_specifier
	: VOID 
	{
		$$="void";
		if(enable==1){type_s = "void";enable = 0;}
		else _vtype = "void";
	}	
        | INT  
	{
		$$="int";
		if(enable==1){type_s = "int";enable = 0;}
		else _vtype = "int";
	}
	| FLOAT 
	{
		$$="float";
		if(enable==1){type_s = "float";enable = 0;}
		else _vtype = "float";
	}
    ;

fun_declarator
	: IDENTIFIER '(' parameter_list ')' 
	{
		_curr->change_fname($1);	
		$$ = new identifier_ast($1);
	}
        | IDENTIFIER '(' ')' 
	{
		_curr = new _Function(type_s,$1);
		//cout<<$1<<endl;
		$$ = new identifier_ast($1);
		//_curr = $$;
	}
	;

parameter_list
	: parameter_declaration 
	{
		_posp=1;
		_curr=new _Function(type_s,"default");		
		if(!(_curr->add_parameter($1))) cout<<no_lines<<": error : redeclaration of parameters . \n";
		else _curr->parameters_pos.insert(make_pair(_posp,$1->type));

	}
	| parameter_list ',' parameter_declaration 
	{
		_posp++;		
		if(!(_curr->add_parameter($3))) cout<<no_lines<<": error : redeclaration of parameters . \n";
		else _curr->parameters_pos.insert(make_pair(_posp,$3->type));
	}
	;

parameter_declaration
	: type_specifier declarator 
	{
		$$=new _Identifier($2,$1,_dima);
		_dima=0;
		if($1=="void"){cout<<no_lines<<": error : parameter type can't be void . \n";err=1;}
		
	}
        ;

declarator
	: IDENTIFIER {$$=$1;}
	
	| declarator '[' constant_expression ']'
	 {
		
		if($3->_type == "float")
			{
			cout<<no_lines<<": error : The Array Index of \'"<<$1<<"' "<<"can\'t be of any type other than int .\n";
			err=1;
			}
		else
			{
				$$=$1;
				_dima++;
			}
	}
        ;

constant_expression 
        : INT_CONSTANT {$$ = new intconst($1);$$->_type = "int";}
        | FLOAT_CONSTANT {$$ = new floatconst($1);$$->_type = "float";}
        ;

compound_statement
	: '{' '}' 
	{		
		$$ = new block_ast(NULL);
		//cout<<"Compound"<<endl;
	} 
	| '{' statement_list '}'
	{
		$$ = $2;
	} 
        | '{' declaration_list statement_list '}' 
	{
		$$ = $3;
	} 
	;

statement_list
	: statement
	{
		$$= new block_ast($1);
	} 		
        | statement_list statement
	{
		$$ = $1;
		$1->add($2);
	} 	
	;

statement
        : '{' statement_list '}'  //a solution to the local decl problem
	{
		$$ = $2;
	} 
        | selection_statement 
	{
		$$ = $1;
	} 	
        | iteration_statement 
	{
		$$ = $1;
	} 	
	| assignment_statement	
	{
		$$ = $1;
	} 
        | RETURN expression ';'	
	{
		$$ = new return_ast($2);
		
		if(($2->_ftype=="int" || $2->_ftype =="float") &&(type_s=="int" || type_s=="float"))
		{
			$2->_ftype=type_s;
		}
		else
		{
		err=1;
		cout <<no_lines<<": error : return type error. Expected "<<type_s<<" given "<<$2->_type<<" . \n";
		}
		
		
	} 
        ;

assignment_statement
	: ';'
	{
		$$ = new ass_ast(NULL,NULL);
	} 								
	|  l_expression '=' expression ';'
	{
		
		$$ = new ass_ast($1,$3);
		
		if($1->_ftype == $3->_ftype);
		
		else
		{
			if($1->_ftype == "int" and $3->_ftype=="float")
			{
				$3->_ftype="int";
				$1->num = (int)($3->num);
				//$$ = new ass_ast($1,$3);
			}
			else 
			{
				if($1->_ftype == "float" and $3->_ftype=="int")
				{
					$3->_ftype="float";
					$1->num = (float)($3->num);
					//$$ = new ass_ast($1,$3);
				}
				else {
					cout<<no_lines<<" : error : expected right operand type is "<<$1->_type<<" but given is "<<$3->_type<<".\n";
					err=1;
					}
			}
		}

	} 	
	;

expression
        : logical_and_expression 
	{
		$$ = $1;
	} 
        | expression OR_OP logical_and_expression
	{
		$$ = new or_ast($1,$3);
		$$->_type = "int";
		$$->_ftype="int"; 
	} 
	;

logical_and_expression
        : equality_expression
	{
		$$ = $1;
	} 
        | logical_and_expression AND_OP equality_expression 
	{
		$$ = new and_ast($1,$3);
		$$->_type = "int";
		$$->_ftype="int"; 
	} 
	;

equality_expression
	: relational_expression 
	{
		$$ = $1;
	} 
        | equality_expression EQ_OP relational_expression 
	{
		
		if($1->_ftype == $3->_ftype)
		{	
			$$ = new eq_op_ast($1,$3);	
			$$->_type=$3->_ftype;
			$$->_ftype=$3->_ftype;
		}
		else
		{
			if($1->_ftype == "int" && $3->_ftype == "float")
			{
				$1->_ftype="float";
				$$ = new eq_op_ast($1,$3);
				$$->_type="int";
				$$->_ftype="int";
			}
			else if($3->_ftype == "int" && $1->_ftype == "float")
				{
					$3->_ftype = "float";
					$$ = new eq_op_ast($1,$3);
					$$->_type="int";
					$$->_ftype="int";
				}
				else {cout<<no_lines<<" : error : type mismatch . comparison between "<<$1->_ftype<<" and "<<$3->_ftype<<". \n";
					$$ = new eq_op_ast($1,$3);err=1;}
		}
	}	
	| equality_expression NE_OP relational_expression
	{
		
		if($1->_ftype == $3->_ftype)
		{	$$ = new ne_op_ast($1,$3);	
			$$->_type=$3->_ftype;
			$$->_ftype=$3->_ftype;
		}
		else
		{
			if($1->_ftype == "int" && $3->_ftype == "float")
			{
				$1->_ftype="float";
				$$ = new ne_op_ast($1,$3);
				$$->_type="int";
				$$->_ftype="int";
			}
			else if($3->_ftype == "int" && $1->_ftype == "float")
				{
					$3->_ftype = "float";
					$$ = new ne_op_ast($1,$3);
					$$->_type="int";
					$$->_ftype="int";
				}
				else 
					{
					cout<<no_lines<<" : error : type mismatch . comparison between "<<$1->_ftype<<" and "<<$3->_ftype<<". \n";err=1;
					$$ = new ne_op_ast($1,$3);
					}
		}
	}
	;
relational_expression
	: additive_expression
	{
		$$ = $1;
	} 
        | relational_expression '<' additive_expression 
	{
		
		if(($1->_ftype == $3->_ftype) && ($1->_ftype == "int" || $1->_ftype=="float"))
		{		
			$$ = new lt_ast($1,$3);
			$$->_type=$3->_ftype;
			$$->_ftype=$3->_ftype;
		}
		else
		{
			if($1->_ftype == "int" && $3->_ftype == "float")
			{
				$1->_ftype="float";
				$$ = new lt_ast($1,$3);
				$$->_type="int";
				$$->_ftype="int";
			}
			else if($3->_ftype == "int" && $1->_ftype == "float")
				{
					$3->_ftype = "float";
					$$ = new lt_ast($1,$3);
					$$->_type="int";
					$$->_ftype="int";
				}
				else 
				{
					cout<<no_lines<<" : error : type mismatch . coparison between "<<$1->_ftype<<" and "<<$3->_ftype<<". \n";err=1;
					$$ = new lt_ast($1,$3);
				}
		}
	}
	| relational_expression '>' additive_expression 
	{
		
		if(($1->_ftype == $3->_ftype) && ($1->_ftype == "int" || $1->_ftype=="float"))
		{		
			$$ = new gt_ast($1,$3);
			$$->_type=$3->_ftype;
			$$->_ftype=$3->_ftype;
		}
		else
		{
			if($1->_ftype == "int" && $3->_ftype == "float")
			{
				$1->_ftype="float";
				$$ = new gt_ast($1,$3);
				$$->_type="int";
				$$->_ftype="int";
			}
			else if($3->_ftype == "int" && $1->_ftype == "float")
				{
					$3->_ftype = "float";
					$$ = new gt_ast($1,$3);
					$$->_type="int";
					$$->_ftype="int";
				}
				else 
				{
					cout<<no_lines<<" : error : type mismatch . comparison between "<<$1->_ftype<<" and "<<$3->_ftype<<". \n";err=1;
					$$ = new gt_ast($1,$3);
				}
		}
	}
	| relational_expression LE_OP additive_expression 
	{
		
		if(($1->_ftype == $3->_ftype) && ($1->_ftype == "int" || $1->_ftype=="float"))
		{		
			$$ = new le_op_ast($1,$3);
			$$->_type=$3->_ftype;
			$$->_ftype=$3->_ftype;
		}
		else
		{
			if($1->_ftype == "int" && $3->_ftype == "float")
			{
				$1->_ftype="float";
				$$ = new le_op_ast($1,$3);
				$$->_type="int";
				$$->_ftype="int";
			}
			else if($3->_ftype == "int" && $1->_ftype == "float")
				{
					$3->_ftype = "float";
					$$ = new le_op_ast($1,$3);
					$$->_type="int";
					$$->_ftype="int";
				}
				else 
				{
					cout<<no_lines<<" : error : type mismatch . comparison between "<<$1->_ftype<<" and "<<$3->_ftype<<". \n";
					err=1;
					$$ = new le_op_ast($1,$3);
				}
		}
	}
        | relational_expression GE_OP additive_expression 
	{
		
		if(($1->_ftype == $3->_ftype) && ($1->_ftype == "int" || $1->_ftype=="float"))
		{		
			$$ = new ge_op_ast($1,$3);
			$$->_type=$3->_ftype;
			$$->_ftype=$3->_ftype;
		}
		else
		{
			if($1->_ftype == "int" && $3->_ftype == "float")
			{
				$1->_ftype="float";
				$$ = new ge_op_ast($1,$3);
				$$->_type="int";
				$$->_ftype="int";
			}
			else if($3->_ftype == "int" && $1->_ftype == "float")
				{
					$3->_ftype = "float";
					$$ = new ge_op_ast($1,$3);
					$$->_type="int";
					$$->_ftype="int";
				}
				else 
				{
					cout<<no_lines<<" : error : type mismatch . comparison between "<<$1->_ftype<<" and "<<$3->_ftype<<". \n";
					err=1;
					$$ = new ge_op_ast($1,$3);
				}
		}
	}
	;

additive_expression 
	: multiplicative_expression
	{
		$$ = $1;
	}
	| additive_expression '+' multiplicative_expression 
	{	
		
		if($1->_ftype == $3->_ftype)
		{		
			
			$$=new plus_ast($1,$3);
			$$->_type=$3->_ftype;
			$$->_ftype=$3->_ftype;
		}
		else
		{
			if($1->_ftype == "int" && $3->_ftype == "float")
			{
				$1->_ftype="float";
				$$=new plus_ast($1,$3);
				$$->_type="float";
				$$->_ftype="float";
			}
			else if($3->_ftype == "int" && $1->_ftype == "float")
				{
					$3->_ftype = "float";
					$$=new plus_ast($1,$3);
					$$->_type="float";
					$$->_ftype="float";
				}
				else 
				{
					cout<<no_lines<<" : error : type mismatch . addition between "<<$1->_ftype<<" and "<<$3->_ftype<<". \n";
					$$=new plus_ast($1,$3);
					err=1;
				}
		}	
				
	}
	| additive_expression '-' multiplicative_expression 
	{
		
		if(($1->_ftype == $3->_ftype) && ($1->_ftype == "int" || $1->_ftype=="float"))
		{		
			$$ = new minus_ast($1,$3);
			$$->_type=$3->_ftype;
			$$->_ftype=$3->_ftype;
		}
		else
		{
			if($1->_ftype == "int" && $3->_ftype == "float")
			{
				$1->_ftype="float";
				$$ = new minus_ast($1,$3);
				$$->_type="float";
				$$->_ftype="float";
			}
			else if($3->_ftype == "int" && $1->_ftype == "float")
				{
					$3->_ftype = "float";
					$$ = new minus_ast($1,$3);
					$$->_type="float";
					$$->_ftype="float";
				}
				else 
				{
					cout<<no_lines<<" : error : type mismatch . subtraction between "<<$1->_ftype<<" and "<<$3->_ftype<<". \n";
					err=1;
					$$ = new minus_ast($1,$3);
				}
		}
	}
	;

multiplicative_expression
	: unary_expression
	{
		$$ = $1;
	}
	| multiplicative_expression '*' unary_expression 
	{
		
		if(($1->_ftype == $3->_ftype) && ($1->_ftype == "int" || $1->_ftype=="float"))
		{		
			$$ = new mult_ast($1,$3);
			$$->_type=$3->_ftype;
			$$->_ftype=$3->_ftype;
		}
		else
		{
			if($1->_ftype == "int" && $3->_ftype == "float")
			{
				$1->_ftype="float";
				$$ = new mult_ast($1,$3);
				$$->_type="float";
				$$->_ftype="float";
			}
			else if($3->_ftype == "int" && $1->_ftype == "float")
				{
					$3->_ftype = "float";
					$$ = new mult_ast($1,$3);
					$$->_type="float";
					$$->_ftype="float";
				}
				else 
				{
					cout<<no_lines<<" : error : type mismatch . multiplication between "<<$1->_ftype<<" and "<<$3->_ftype<<". \n";
					err=1;
					$$ = new mult_ast($1,$3);
				}
		}
	}
	| multiplicative_expression '/' unary_expression 
	{
		
		if(($1->_ftype == $3->_ftype) && ($1->_ftype == "int" || $1->_ftype=="float"))
		{		
			$$ = new devide_ast($1,$3);
			$$->_type=$3->_ftype;
			$$->_ftype=$3->_ftype;
		}
		else
		{
			if($1->_ftype == "int" && $3->_ftype == "float")
			{
				$1->_ftype="float";
				$$ = new devide_ast($1,$3);
				$$->_type="float";
				$$->_ftype="float";
			}
			else if($3->_ftype == "int" && $1->_ftype == "float")
				{
					$3->_ftype = "float";
					$$ = new devide_ast($1,$3);
					$$->_type="float";
					$$->_ftype="float";
				}
				else 
				{
					cout<<no_lines<<" : error : type mismatch . subtraction between "<<$1->_ftype<<" and "<<$3->_ftype<<". \n";
					err=1;
					$$ = new devide_ast($1,$3);
				}
		}
		
	}
	;
unary_expression
	: postfix_expression  
	{
		$$ = $1;
	}				
	| unary_operator postfix_expression
	{
		if($1 == '-')
		{
		$$ = new uminus_ast($2);
		$$->_type==$2->_type;
		$$->_ftype==$2->_ftype;
		}
		else if($1 == '!')
		{
		$$ = new not_ast($2);
		$$->_type==$2->_type;
		$$->_ftype==$2->_ftype;
		}
	} 
	;

postfix_expression
	: primary_expression
	{
		$$ = $1;
	}
        | IDENTIFIER '(' ')'
	{
		$$ = new funcall_ast(new exps(NULL),new identifier_ast($1));
		
		unordered_map<string,_Function *>::const_iterator got = Functions.find ($1);
		if ( got == Functions.end() )
			{
    				cout <<no_lines<<" : error : Function "<<$1<<" not declared in the scope. \n";
				err=1;
			}
 		 else
    		{	
			if(got->second->parameters.empty())
			{	
				$$->_type=(got->second)->type;
				$$->_ftype=(got->second)->type;
			}
			else
			{
				cout<<no_lines<<" : error : "<<$1<<" expects zero arguments.\n";
			}
		}
		//$$->print();
	}
	| IDENTIFIER '(' expression_list ')' 
	{
		//cout<< " hi";
		$$ = new funcall_ast($3,new identifier_ast($1));
		
		list<ExpAst*> larg=$3->Elist;
		unordered_map<string,_Function *>::const_iterator got = Functions.find ($1);
		if (got != Functions.end() )
		{
			if(larg.size()==got->second->parameters.size())    			
			{
				list<ExpAst*>::iterator it=larg.begin();
				map<int,string>::iterator iter=got->second->parameters_pos.begin();
				
				bool compat=1;
				for(;it!=  larg.end() && iter!=got->second->parameters_pos.end(); it++,iter++)
				{
					bool found=0;
					string lstr=(*it)->_ftype, rstr=iter->second;					
					if(lstr==rstr) found=1;
					else
					{
						if(lstr=="int" && rstr=="float") {(*it)->_ftype = "float";found=1;}
						else if(lstr=="float" && rstr=="int") {(*it)->_ftype = "int";found=1;}
					}
					compat=compat && found;
					if(!compat) break;
				}		  				
				if(!compat)
				{
					cout <<no_lines<<" : error : Function "<<$1<<" argument type mismatch . \n";
					err=1;
				}
			}
			else
			{
				cout<<no_lines<<" : error : number of arguments mismatch .\n";
				err=1;
			}
		}
 		else
    		{
			cout<<no_lines<<" : error : the fundtion "<<$1<<" is not defined.\n"<<endl;
			err=1;
		}
		$$->_type=(got->second)->type;
		$$->_ftype=(got->second)->type;
	}
	| l_expression INC_OP
	{
		$$ = new pp_ast($1);
		$$->_type=$1->_type;
		$$->_ftype=$1->_ftype;
	}
	;

primary_expression
	: l_expression
	{
		$$ = $1;
	}
        | l_expression '=' expression 				// added this production
	{
		
		if($1->_ftype == $3->_ftype)
		{ 
			$$ = new assign_ast($1,$3);
			$$->_type=$3->_ftype;
			$$->_ftype=$3->_ftype;
		}
		else
		{
			if($1->_ftype == "int" and $3->_ftype=="float")
			{
				$3->_ftype="int";
				$1->num = (int)($3->num);
				$$ = new assign_ast($1,$3);
			}
			else 
			{
				if($1->_ftype == "float" and $3->_ftype=="int")
				{
					$3->_ftype="float";
					$1->num = (float)($3->num);
					$$ = new assign_ast($1,$3);
				}
				else 
				{
					cout<<no_lines<<" : error : expected right operand type is "<<$1->_type<<" but given is "<<$3->_type<<".\n";
					err=1;
					$$ = new assign_ast($1,$3);
				}
			}
		}
	}
	| INT_CONSTANT
	{
		$$ = new intconst($1);
		$$->_type="int";
		$$->_ftype="int";
	}
	| FLOAT_CONSTANT
	{
		$$ = new floatconst($1);
		$$->_type="float";
		$$->_ftype="float";
	}
        | STRING_LITERAL
	{
		$$ = new stringconst($1);
		$$->_type="string";
		$$->_ftype="string";
	}
	| '(' expression ')' 
	{
		$$ = $2;
	}	
	;

l_expression
        : IDENTIFIER
	{
		$$ = new identifier_ast($1);
		unordered_map<string,_Identifier*>::const_iterator got1=(_curr->parameters).find($1);
		unordered_map<string,_Identifier*>::const_iterator got2=(_curr->declarations).find($1);
		if ( (got1 ==(_curr->parameters).end()))
		{
			if(got2 == (_curr->declarations).end())
			{
    				cout <<no_lines<<" : error : Variable "<<$1<<" not declared In this scope . \n";
				err=1;
			}
			else
			{
				_vtype=got2->second->type;
				int s=got2->second->dimension;
				for(int i=0; i<s; i++) _vtype+="*";
			}
		}
 		 else
    		{	
			//$$ = new identifier_ast($1);
			//cout<<"1 :"<<(got->second)->type<<endl;
			_vtype=got1->second->type;
				int s=got1->second->dimension;
				for(int i=0; i<s; i++) _vtype+="*";

		}
		$$->_type=_vtype;
		$$->_ftype=_vtype;
		
	}
        | l_expression '[' expression ']' 
	{
		//_dima++;
		$$ = new index_ast($1,$3);
		int k=_vtype.size()-1;
		if(k>=0 && _vtype[k]=='*') _vtype=_vtype.substr(0,k);
		$$->_type=_vtype;
		$$->_ftype=_vtype;
	}
		
        ;
expression_list
        : expression
	{
		$$ = new exps($1);
	}
        | expression_list ',' expression
	{
		$$ = $1;
		$1->addE($3);
	}
        ;
unary_operator
        : '-'
	{
		$$ = '-';
	}	
	| '!' 	
	{
		$$ = '!';
	}
	;

selection_statement
        : IF '(' expression ')' statement ELSE statement 
	{
		$$ = new if_ast($3,$5,$7);
	}
	;

iteration_statement
	: WHILE '(' expression ')' statement 
	{
		$$ = new while_ast($3,$5);
	}	
        | FOR '(' expression ';' expression ';' expression ')' statement  //modi
	{
		$$ = new for_ast($3,$5,$7,$9);
	}
        ;

declaration_list
        : declaration  					
        | declaration_list declaration
	;

declaration
	: type_specifier declarator_list';'
	;

declarator_list
	: declarator
	{
		if(_vtype=="void") 
		{
			cout<<no_lines<<": error : data type of variable "<<$1<<" can't be void .\n";
		}
		else
		{
			if(_curr->add_declaration(new _Identifier($1,_vtype,_dima)));
			else 
			{
				err=1;cout<<no_lines<<": error : redeclaration of variable "<<$1<<" in the scope of "<<_curr->token_name<<" . \n";
			}
		}
		_dima=0;
	}
	| declarator_list ',' declarator
	{
		if(_vtype=="void") 
		{
			cout<<no_lines<<": error : data type of variable "<<$3<<" can't be void .\n";
		}
		else
		{
			if(_curr->add_declaration(new _Identifier($3,_vtype,_dima)));
			else 
			{
				err=1;cout<<no_lines<<": error : redeclaration of variable "<<$3<<" in the scope of "<<_curr->token_name<<" . \n";
			}
		}
		_dima=0;
	}
	;
