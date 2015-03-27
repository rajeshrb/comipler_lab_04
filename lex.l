%%
[ \t\n]+ {}
(\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/)|(\/\/.\*) return Parser::COMMENTS;
"{" 													return '{';
"}" 													return '}';
"[" 													return '[';
"]" 													return ']';
"(" 													return '(';
")" 													return ')';
"+" 													return '+';
"-" 													return '-';
"*" 													return '*';
";" 													return ';';
":" 													return ':';
"/" 													return '/';
"," 													return ',';
">" 													return '>';
"<" 													return '<';
"=" 													return '=';
("++")|("--") 											return Parser::INC_OP;
">=" 													return Parser::GE_OP;
"<=" 													return Parser::LE_OP;
"==" 													return Parser::EQ_OP;
((\!\=)|(\=\=\!)) 										return Parser::NE_OP;
("and")|("&&") 											return Parser::AND_OP;
(("or")|("||")) 										return Parser::OR_OP;
"void" 													return Parser::VOID;
"int" 													return Parser::INT;
"float" 												return Parser::FLOAT;
"return" 												return Parser::RETURN;
"if" 													return Parser::IF;
"else" 													return Parser::ELSE;
"for" 													return Parser::FOR;
"while" 												return Parser::WHILE;
(([1-9][0-9]*)|(0[bB][01]*)|(0[0-7]*)|(0x[0-9a-fA-F]*)) 	{ istringstream sstr(matched());
								  int val;
								  sstr >> val;
								  Parser::d_val__ = val; return Parser::INT_CONSTANT;}
(([0-9]+\.[0-9]*)|(\.[0-9]+))([eE][+-]?[0-9]+)? 		{ istringstream sstr(matched());
								  float val;
								  sstr >> val;
								  Parser::d_val__ = val; return Parser::FLOAT_CONSTANT;}
\"(\\[\\"nt\\]|[^\\"\\])*\"					{ Parser::d_val__ = std::string(matched()); return Parser::STRING_LITERAL;}
[[:alpha:]_][[:alpha:][:digit:]_]*  				{ Parser::d_val__ = std::string(matched()); return Parser::IDENTIFIER;}

%%
