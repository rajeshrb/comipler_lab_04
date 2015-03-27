all: lex.cc parse.cc main.cc Scanner.h Scannerbase.h Scanner.ih Parser.h Parserbase.h Parser.ih 
	./sedscript
	@sed -i '/#include "Parser.h"/a string type_s = "default";int enable = 1;_Function * _curr;unordered_map<string,_Function*> Functions; extern int no_lines;int err=1;' Parser.ih;
	@sed -i '/#include "Parserbase.h"/a int no_lines=1;' Scanner.ih;
	@g++   --std=c++0x classes.cc lex.cc parse.cc main.cc ;
	@./a.out <test-assembly > junk;
lex.cc: lex.l Scanner.ih 
	@./cond_remove_scannerih; 
	@flexc++ lex.l; 
#	@sed -i '/include/a #include "Parserbase.h"' Scanner.ih; 

parse.cc: parse.y Parser.ih Parser.h Parserbase.h
	./rmParse
	@bisonc++  parse.y;
#	@sed -i '/include/a #include "classes.h"' Parser.ih;
	@sed -i '/include <type_traits>/a #include "classes.h"' Parserbase.h;
#	bisonc++   --construction -V parse.y; 
#	sed -i '/ifndef/a #include "tree_util.hh"' Parserbase.h;
#	sed -i '/ifndef/a #include "tree.hh"' Parserbase.h;
#	./sedscript
     
Parser.ih: parse.y
Parser.h:  parse.y
Parserbase.h: parse.y
Scanner.ih: lex.l
Scanner.h: lex.l
Scannerbase.h: lex.l
