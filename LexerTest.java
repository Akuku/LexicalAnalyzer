import java.io.*;

public class LexerTest {
  public static void main(String...z) {
    try {
      Lexer lex = new Lexer(new FileReader(z[0]));
      while(lex.yylex() != null) {}
      System.out.println();
      lex.printTable();
      System.out.println();

      for(int i = 0; i < lex.s.symbol.size(); ++i) {
        System.out.printf("%c ", lex.s.symbol.get(i));
      }

      System.out.println();

      for(int i = 0; i < lex.s.next.size(); ++i) {
        System.out.printf("%d ", lex.s.next.get(i));       
      }

    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}