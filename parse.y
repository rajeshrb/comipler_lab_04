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
				
		$1->print();
		enable =1;
	} 
	| translation_unit function_definition 
	{
		$2->print();		
		enable =1;
	} 
        ;

function_definition
	: type_specifier fun_declarator compound_statement 
	{
		$$=new method($2,$3);
	} 
	;

type_specifier
	: VOID 
	{
		$$="void";
		if(enable==1){type_s = "void";enable = 0;}
	}	
        | INT  
	{
		$$="int";
		if(enable==1){type_s = "int";enable = 0;}
	}
	| FLOAT 
	{
		$$="float";
		if(enable==1){type_s = "float";enable = 0;}
	}
    ;

fun_declarator
	: IDENTIFIER '(' parameter_list ')' 
	{
		//$$ = $3;
		//_curr = $$;
		//cout<<"fun ";	
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
		
		_curr=new _Function(type_s,"default");		
		_curr->add_parameter($1);
	}
	| parameter_list ',' parameter_declaration 
	{
		
		_curr->add_parameter($3);
	}
	;

parameter_declaration
	: type_specifier declarator 
	{
		$$=new _Identifier($1,$2);
	}
        ;

declarator
	: IDENTIFIER {$$=$1;}
	
	| declarator '[' constant_expression ']'
	 {
		
		if($3->_type == "float")
			{
			cout<<no_lines<<": error : The Array Index of \'"<<$1<<"' "<<"can\'t be of any type other than int in line.\n";
			}
		else
			{
				$$=$1;
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
	/*	if($2.type == "int")
		{
			$$ = new return_ast($2);
		}
		else
		{
			cout << "Error in return statement at line :";
		}*/
		$$ = new return_ast($2);
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
		/*if($1.type == $3.type)
		{ 
			$$ = new ass_ast($1,$3);
		}
		else
		{
			if($1.type == "int" and $3.type=="float")
			{
				$1.num = (int)($3.num);
				$$ = new ass_ast($1,$3);
			}
			else 
			{
				if($1.type == "float" and $3.type=="int")
				{
					$$ = new ass_ast($1,$3);
				}
				else cout<<"error at line : type mismatch . \n";
			}
		}	*/

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
	} 
	;

equality_expression
	: relational_expression 
	{
		$$ = $1;
	} 
        | equality_expression EQ_OP relational_expression 
	{
		$$ = new eq_op_ast($1,$3);
	}	
	| equality_expression NE_OP relational_expression
	{
		$$ = new ne_op_ast($1,$3);
	}
	;
relational_expression
	: additive_expression
	{
		$$ = $1;
	} 
        | relational_expression '<' additive_expression 
	{
		$$ = new lt_ast($1,$3);
	}
	| relational_expression '>' additive_expression 
	{
		$$ = new gt_ast($1,$3);
	}
	| relational_expression LE_OP additive_expression 
	{
		$$ = new le_op_ast($1,$3);
	}
        | relational_expression GE_OP additive_expression 
	{
		$$ = new ge_op_ast($1,$3);
	}
	;

additive_expression 
	: multiplicative_expression
	{
		$$ = $1;
	}
	| additive_expression '+' multiplicative_expression 
	{
		$$ = new plus_ast($1,$3);
	}
	| additive_expression '-' multiplicative_expression 
	{
		$$ = new minus_ast($1,$3);
	}
	;

multiplicative_expression
	: unary_expression
	{
		$$ = $1;
	}
	| multiplicative_expression '*' unary_expression 
	{
		$$ = new mult_ast($1,$3);
	}
	| multiplicative_expression '/' unary_expression 
	{
		$$ = new devide_ast($1,$3);
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
		}
		else if($1 == '!')
		{
		$$ = new not_ast($2);
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
	}
	| IDENTIFIER '(' expression_list ')' 
	{
		//cout<< " hi";
		$$ = new funcall_ast($3,new identifier_ast($1));
	}
	| l_expression INC_OP
	{
		$$ = new pp_ast($1);
	}
	;

primary_expression
	: l_expression
	{
		$$ = $1;
	}
        | l_expression '=' expression 				// added this production
	{
		$$ = new assign_ast($1,$3);
	}
	| INT_CONSTANT
	{
		$$ = new intconst($1);
	}
	| FLOAT_CONSTANT
	{
		$$ = new floatconst($1);
	}
        | STRING_LITERAL
	{
		$$ = new stringconst($1);
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
	}
        | l_expression '[' expression ']' 
	{
		$$ = new index_ast($1,$3);
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
	| declarator_list ',' declarator 
	;
