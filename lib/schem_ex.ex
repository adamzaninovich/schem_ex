defmodule SchemEx do
  @moduledoc """
  A simple Scheme interpreter written in Elixir

  The interpretation of code consists of 2 main stages.
  1. Parsing the code into an Abstract Syntax Tree (AST).
  2. Evaluating the AST and running the program.

  Step 1 is broken down into 2 sub-steps.
  a. The Lexer, which takes the code and breaks it up into tokens.
  b. The Parser, which takes the tokens and forms the AST.
  """

  @doc """
  Parse a string of Scheme code into a runnable AST
  """
  def parse(code) do
    parsed =
      code
      |> SchemEx.Lexer.tokenize()
      |> SchemEx.Parser.parse()
    {:ok, parsed}
  end

  @doc """
  Parses a file of Scheme code
  """
  def parse_file(path) do
    case File.read(path) do
      {:ok, code} -> parse(code)
      _ -> {:error, "Cannot read file #{inspect path}"}
    end
  end

  def run(code) do
    {:ok, ast} = parse(code)
    SchemEx.Interpreter.interpret(ast)
  end

  def run_multiline(code) do
    code
    |> String.split("\n", trim: true)
    |> Enum.map(&SchemEx.run/1)
    |> Enum.reverse
    |> hd
  end
end
