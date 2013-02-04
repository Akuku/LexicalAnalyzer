/*CS 411 Lexer*/

%%

%class Lexer
%unicode
%line
%column


%{

  public enum tokens {
    t_bool, t_break, t_class, t_double,
    t_else, t_extends, t_for, t_if, t_implements,
    t_int, t_interface, t_newarray, t_println,
    t_readln, t_return, t_string, t_void, t_while,
    t_plus, t_minus, t_multiplication, t_division,
    t_mod, t_less, t_lessequal, t_greater, t_greaterequal,
    t_equal, t_notequal, t_assignop, t_semicolon, t_comma,
    t_period, t_leftparen, t_rightparen, t_leftbracket,
    t_rightbracket, t_leftbrace, t_rightbrace, t_boolconstant,
    t_intconstant, t_doubleconstant, t_stringconstant, t_id
  }

%}

/*The alphabet*/
alpha [a-zA-Z]

/*Base 10 digits*/
digit [0-9]

/*Hex with 0x or 0X followed by 1 or more hex digits*/
hex (0x|0X)[a-fA-F0-9]+

/*Integer is base 10 or 16*/
integer ({digit}+|{hex})

/*Exponents begining with e/E, optional sign, 1+ digits*/
exponent ((E|e)("+"|"-")?({digit})+)

/*Float with optional exponent, and int with exponent*/
double (({digit}+"."{digit}*{exponent}?)|({digit}+{exponent}))

/*Identifiers begin with letter, followed by letter/digit/underscore*/
id {letter}({letter}|{digit}|"_")*

/*double quote, anything but newline and quote, double quote*/
string \"[^"\n]*\" 

/*New line character class*/
newline [\n]

/*spaces and tabs*/
whitespace [ \t]+

%%

/*Ignore comments that match the following*/

/*Multiline*/
"/*"(([^*]|(("*"+)[^*/]))*)("*"+)"/"\n {;}

/*Inline*/
"//"((.)*)\n {;}


/*Keywords*/

bool {System.out.printf("%s ",yytext); return this.tokens.t_bool.ordinal();}
break {System.out.printf("%s ",yytext); return this.tokens.t_break.ordinal();}
class {System.out.printf("%s ",yytext); return this.tokens.t_class.ordinal();}
double {System.out.printf("%s ",yytext); return this.tokens.t_double.ordinal();}
else {System.out.printf("%s ",yytext); return this.tokens.t_else.ordinal();}
extends {System.out.printf("%s ",yytext); return this.tokens.t_extends.ordinal();}
for {System.out.printf("%s ",yytext); return this.tokens.t_for.ordinal();}
if {System.out.printf("%s ",yytext); return this.tokens.t_if.ordinal();}
implements {System.out.printf("%s ",yytext); return this.tokens.t_implements.ordinal();}
int {System.out.printf("%s ",yytext); return this.tokens.t_int.ordinal();}
interface {System.out.printf("%s ",yytext); return this.tokens.t_interface.ordinal();}
newarray {System.out.printf("%s ",yytext); return this.tokens.t_newarray.ordinal();}
println {System.out.printf("%s ",yytext); return this.tokens.t_println.ordinal();}
readln {System.out.printf("%s ",yytext); return this.tokens.t_readln.ordinal();}
return {System.out.printf("%s ",yytext); return this.tokens.t_return.ordinal();}
string {System.out.printf("%s ",yytext); return this.tokens.t_string.ordinal();}
void {System.out.printf("%s ",yytext); return this.tokens.t_void.ordinal();}
while {System.out.printf("%s ",yytext); return this.tokens.t_while.ordinal();}

/*stupid thing has to be declared up here or it will match id */
true|false {System.out.print("boolconstant "); return this.tokens.t_boolconstant.ordinal();}

{identifier} {System.out.print("intconstant "); return this.tokens.t_id.ordinal();}
{whitespace} {;}
{newline} {System.out.println();} /*preserve line breaks*/
{integer} {System.out.print("intconstant "); return this.tokens.t_intconstant.ordinal();}
{double} {System.out.println("doubleconstant"); return this.tokens.t_doubleconstant.ordinal();}
{string} {System.out.println("stringconstant"); return this.tokens.t_stringconstant.ordinal();}

/*Operators and Punctuation*/

"+" {System.out.print("plus "); return this.tokens.t_plus.ordinal();}
"-" {System.out.print("minus "); return this.tokens.t_minus.ordinal();}
"*" {System.out.print("multiplication "); return this.tokens.t_multiplication.ordinal();}
"/" {System.out.print("division "); return this.tokens.t_division.ordinal();}
"%" {System.out.print("mod "); return this.tokens.t_mod.ordinal();}
"<" {System.out.print("less "); return this.tokens.t_less.ordinal();}
"<=" {System.out.print("lessequal "); return this.tokens.t_lessequal.ordinal();}
">" {System.out.print("greater "); return this.tokens.t_greater.ordinal();}
">=" {System.out.print("greaterequal "); return this.tokens.t_greaterequal.ordinal();}
"==" {System.out.print("equal "); return this.tokens.t_equal.ordinal();}
"!=" {System.out.print("notequal "); return this.tokens.t_notequal.ordinal();}
"=" {System.out.print("assignop "); return this.tokens.t_assignop.ordinal();}
";" {System.out.print("semicolon "); return this.tokens.t_semicolon.ordinal();}
"," {System.out.print("comma "); return this.tokens.t_comma.ordinal();}
"." {System.out.print("period "); return this.tokens.t_period.ordinal();}
"(" {System.out.print("leftparen "); return this.tokens.t_leftparen.ordinal();}
")" {System.out.print("rightparen "); return this.tokens.t_rightparen.ordinal();}
"[" {System.out.print("rightbracket "); return this.tokens.t_rightbracket.ordinal();}
"]" {System.out.print("leftbracket "); return this.tokens.t_leftbracket.ordinal();}
"{" {System.out.print("leftbrace "); return this.tokens.t_leftbrace.ordinal();}
"}" {System.out.print("rightbrace "); return this.tokens.t_rightbrace.ordinal();}

