#include <iostream>
#include "Scanner.h"
#include "Parser.h"

using namespace std;
int main (int argc, char** arg)
{
  Parser parser;
  parser.parse();
  if(Functions.find("main")!=Functions.end())
  {
  		if(err) cout<<"error : programme rejecteed\n";
  		//else _prog->print();
  }
  else
  {
  		cout<<" exit: main not defined\n";
  }
}


