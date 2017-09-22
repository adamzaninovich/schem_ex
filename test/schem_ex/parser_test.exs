defmodule SchemEx.ParserTest do
  use ExUnit.Case
  alias SchemEx.{Parser,ParseError}
  alias SchemEx.Token, as: T

  test "parse converts tokens into an AST" do
    assert Parser.parse(~w[a]) == T.new(:id, :a)
    assert Parser.parse(~w["a"]) == T.new(:literal, "a")
    assert Parser.parse(~w[5]) == T.new(:literal, 5)
    assert Parser.parse(~w[3.5]) == T.new(:literal, 3.5)
    assert Parser.parse(~w[( )]) == []
    assert Parser.parse(~w[( a )]) == [T.new(:id, :a)]
    assert Parser.parse(~w[( dup "a" 2 )]) == [T.new(:id, :dup), T.new(:literal, "a"), T.new(:literal, 2)]
    assert Parser.parse(~w[( a ( b ) c )]) == [T.new(:id, :a), [T.new(:id, :b)], T.new(:id, :c)]
    assert Parser.parse(~w[( ( ) ( ) )]) == [[],[]]
  end

  test "parse raises an error if the code is invalid" do
    assert_raise ParseError, ~s("3a" is not a valid token), fn ->
      Parser.parse(~w[3a])
    end
    assert_raise ParseError, ~s("3.5a" is not a valid token), fn ->
      Parser.parse(~w[( add 3 3.5a )])
    end
  end
end
