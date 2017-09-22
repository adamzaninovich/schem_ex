defmodule SchemExTest do
  use ExUnit.Case
  alias SchemEx.Token, as: T
  doctest SchemEx

  test "parsing code works" do
    assert SchemEx.parse("((a))") == {:ok, [[T.new(:id, :a)]]}
  end

  test "parsing a nonexistant file returns an error" do
    assert SchemEx.parse_file("nofile") ==
      {:error, ~s(Cannot read file "nofile")}
  end

  test "parsing a file works" do
    assert SchemEx.parse_file("test/fixtures/code.scm") == {:ok,
      [T.new(:id, :define),
       [T.new(:id, :"hofstadter-male-female"),
        T.new(:id, :n)],
       [T.new(:id, :letrec),
        [[T.new(:id, :female),
          [T.new(:id, :lambda),
           [T.new(:id, :n)],
           [T.new(:id, :if),
                  [T.new(:id, :=),
                   T.new(:id, :n),
                   T.new(:literal, 0)],
                   T.new(:literal, 1),
                   [T.new(:id, :-),
                    T.new(:id, :n),
                    [T.new(:id, :male),
                     [T.new(:id, :female),
                      [T.new(:id, :-),
                       T.new(:id, :n),
                       T.new(:literal, 1)]]]]]]],
          [T.new(:id, :male),
           [T.new(:id, :lambda),
            [T.new(:id, :n)],
            [T.new(:id, :if),
                   [T.new(:id, :=),
                    T.new(:id, :n),
                    T.new(:literal, 0)],
                    T.new(:literal, 0),
                    [T.new(:id, :-),
                     T.new(:id, :n),
                     [T.new(:id, :female),
                      [T.new(:id, :male),
                       [T.new(:id, :-),
                        T.new(:id, :n),
                        T.new(:literal, 1)]]]]]]]],
          [T.new(:id, :let),
           T.new(:id, :loop),
           [[T.new(:id, :i),
             T.new(:literal, 0)]],
           [T.new(:id, :if),
                  [T.new(:id, :>),
                   T.new(:id, :i),
                   T.new(:id, :n)],
                   T.new(:id, :"'"), [],
                   [T.new(:id, :cons),
                    [T.new(:id, :cons),
                     [T.new(:id, :female),
                      T.new(:id, :i)],
                     [T.new(:id, :male),
                      T.new(:id, :i)]],
                    [T.new(:id, :loop),
                     [T.new(:id, :+),
                      T.new(:id, :i),
                      T.new(:literal, 1)]]]]]]]}
  end
end
