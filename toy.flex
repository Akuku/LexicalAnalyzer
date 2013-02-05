/*CS 411 Lexer*/

import java.util.ArrayList;

%%

%public
%class Lexer
%intwrap
%unicode
%line
%column
%eofclose


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

  public class symbol_table {
    public int [] control = new int[52];
    public ArrayList<Integer> next = new ArrayList<Integer>();
    public ArrayList<Character> symbol = new ArrayList<Character>();
    
    public symbol_table() {
        for (int i = 0; i < this.control.length; ++i) {
            this.control[i] = -1; 
        }
    }
  }

  public symbol_table s = new symbol_table();

  // Return array index of character
  public int alphaIndex(char c) {
    int v = c;
    if (v >= 97) {
        return v - 97 + 26;
    }
    return v - 65; 
  }

  public void trie(String str) {
    int value = alphaIndex(str.charAt(0));
    int ptr = s.control[value];

    if (ptr == -1) { // Undefined
        // point to last 
        s.control[value] = s.symbol.size();
        // add the rest of the characters
        for (int i = 1; i < str.length(); ++i) {
            s.symbol.add(str.charAt(i));
        }
        s.symbol.add('@'); 
    }
    else { // Defined
        
        int i = 1; // 2nd character, 'i' is the symbol counter
        boolean exit = false;

        if(str.length() == 1) {
            return;
        }

        while(!exit) {
            if (s.symbol.get(ptr) == str.charAt(i)) {
                // if endmarker
                if(str.length() -1 <= i) {
                    exit = true;
                    break; 
                }
                i++; 
                ptr++;
            }
            else if((s.next.size() > ptr) && (s.next.get(ptr) != -1)) {
                ptr = s.next.get(ptr);
            }
            else {

                while(s.next.size() <= ptr) {
                    s.next.add(-1);
                } // grow the (next) array

                // Set next available which will 
                // always be size() (dynamically allocated)
                s.next.set(ptr,s.symbol.size()); 

                while(i < str.length()) {
                    s.symbol.add(str.charAt(i++));
                }
                s.symbol.add('@');

                exit = true;
                break;
            }
        }


    }

  }

  // public void printTable() {
  //   String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  //   System.out.printf("%10s","");
  //   int j = 0;
  //   for (int i = 0; i < s.control.length; ++i) {
  //       System.out.printf("%c    ",alpha.charAt(i));
  //       int k = 0;
  //       if((i+1) % 10 == 0) {
  //           k = i;
  //           System.out.printf("%n%10s", "switch");
  //       }
  //       for(; j<=k; ++j) {
  //           System.out.printf("%3d ", s.control[i]);
  //       }
  //       if(k > 0) {
  //           System.out.println("\n");
  //       }
  //   }
  // }

    public void printTable() {
        String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
        for (int i = 0; i < 52; ++i) {
            System.out.printf("%c : %d%n", alpha.charAt(i), s.control[i]);
        }
    }

%}

/*The alphabet*/
letter = [a-zA-Z]

/*Base 10 digits*/
digit = [0-9]

/*Hex with 0x or 0X followed by 1 or more hex digits*/
hex = (0x|0X)[a-fA-F0-9]+

/*Integer is base 10 or 16*/
integer = ({digit}+|{hex})

/*Exponents begining with e/E, optional sign, 1+ digits*/
exponent = ((E|e)("+"|"-")?({digit})+)

/*Float with optional exponent, and int with exponent*/
double = (({digit}+"."{digit}*{exponent}?)|({digit}+{exponent}))

/*Identifiers begin with letter, followed by letter/digit/underscore*/
identifier = {letter}({letter}|{digit}|"_")*

/*double quote, anything but newline and quote, double quote*/
string = \"([^\"\n])*\"

/*New line character class*/
newline = \n

/*spaces and tabs*/
whitespace = [ \t]+

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}
Comment = ({TraditionalComment}|{EndOfLineComment})

%%

/*Ignore comments that match the following*/

{Comment} { }

{string} {System.out.print("stringconstant "); return tokens.t_stringconstant.ordinal();}

/*Keywords*/

bool {System.out.printf("%s ",yytext()); return tokens.t_bool.ordinal();}
break {System.out.printf("%s ",yytext()); return tokens.t_break.ordinal();}
class {System.out.printf("%s ",yytext()); return tokens.t_class.ordinal();}
double {System.out.printf("%s ",yytext()); return tokens.t_double.ordinal();}
else {System.out.printf("%s ",yytext()); return tokens.t_else.ordinal();}
extends {System.out.printf("%s ",yytext()); return tokens.t_extends.ordinal();}
for {System.out.printf("%s ",yytext()); return tokens.t_for.ordinal();}
if {System.out.printf("%s ",yytext()); return tokens.t_if.ordinal();}
implements {System.out.printf("%s ",yytext()); return tokens.t_implements.ordinal();}
int {System.out.printf("%s ",yytext()); return tokens.t_int.ordinal();}
interface {System.out.printf("%s ",yytext()); return tokens.t_interface.ordinal();}
newarray {System.out.printf("%s ",yytext()); return tokens.t_newarray.ordinal();}
println {System.out.printf("%s ",yytext()); return tokens.t_println.ordinal();}
readln {System.out.printf("%s ",yytext()); return tokens.t_readln.ordinal();}
return {System.out.printf("%s ",yytext()); return tokens.t_return.ordinal();}
string {System.out.printf("%s ",yytext()); return tokens.t_string.ordinal();}
void {System.out.printf("%s ",yytext()); return tokens.t_void.ordinal();}
while {System.out.printf("%s ",yytext()); return tokens.t_while.ordinal();}

/*stupid thing has to be declared up here or it will match id */
true|false {System.out.print("boolconstant "); return tokens.t_boolconstant.ordinal();}

{identifier} {System.out.print("id ");trie(yytext());return tokens.t_id.ordinal();}
{whitespace} { }
{newline} {System.out.print("\n");} /*preserve line breaks*/
{integer} {System.out.print("intconstant "); return tokens.t_intconstant.ordinal();}
{double} {System.out.print("doubleconstant "); return tokens.t_doubleconstant.ordinal();}


/*Operators and Punctuation*/

"+" {System.out.print("plus "); return tokens.t_plus.ordinal();}
"-" {System.out.print("minus "); return tokens.t_minus.ordinal();}
"*" {System.out.print("multiplication "); return tokens.t_multiplication.ordinal();}
"/" {System.out.print("division "); return tokens.t_division.ordinal();}
"%" {System.out.print("mod "); return tokens.t_mod.ordinal();}
"<" {System.out.print("less "); return tokens.t_less.ordinal();}
"<=" {System.out.print("lessequal "); return tokens.t_lessequal.ordinal();}
">" {System.out.print("greater "); return tokens.t_greater.ordinal();}
">=" {System.out.print("greaterequal "); return tokens.t_greaterequal.ordinal();}
"==" {System.out.print("equal "); return tokens.t_equal.ordinal();}
"!=" {System.out.print("notequal "); return tokens.t_notequal.ordinal();}
"=" {System.out.print("assignop "); return tokens.t_assignop.ordinal();}
";" {System.out.print("semicolon "); return tokens.t_semicolon.ordinal();}
"," {System.out.print("comma "); return tokens.t_comma.ordinal();}
"." {System.out.print("period "); return tokens.t_period.ordinal();}
"(" {System.out.print("leftparen "); return tokens.t_leftparen.ordinal();}
")" {System.out.print("rightparen "); return tokens.t_rightparen.ordinal();}
"[" {System.out.print("rightbracket "); return tokens.t_rightbracket.ordinal();}
"]" {System.out.print("leftbracket "); return tokens.t_leftbracket.ordinal();}
"{" {System.out.print("leftbrace "); return tokens.t_leftbrace.ordinal();}
"}" {System.out.print("rightbrace "); return tokens.t_rightbrace.ordinal();}

. { /* illegal chars */ }