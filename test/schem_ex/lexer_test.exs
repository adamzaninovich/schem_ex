defmodule SchemEx.LexerTest do
  use ExUnit.Case
  alias SchemEx.Lexer

  test "tokenize splits up the code into tokens" do
    assert Lexer.tokenize("(1)") == ~w[( 1 )]
    assert Lexer.tokenize("( 1 )") == ~w[( 1 )]
    assert Lexer.tokenize("") == []
    assert Lexer.tokenize("a") == ~w[a]
    assert Lexer.tokenize("(fun a b)") == ~w[( fun a b )]
    assert Lexer.tokenize("()") == ~w[( )]
    assert Lexer.tokenize("(() ())") == ~w[( ( ) ( ) )]
  end
end
