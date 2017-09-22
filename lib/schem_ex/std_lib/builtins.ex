defmodule SchemEx.StdLib.Builtins do
  alias SchemEx.Context

  def first([[first | _]]) do
    first
  end

  def rest([[_ | rest]]), do: rest

  def sch_inspect([term]), do: IO.inspect(term)

  def print([term]) do
    IO.puts(term)
    term
  end

  def add([a, b]), do: a+b
  def sub([a, b]), do: a-b
  def mul([a, b]), do: a*b
  def div([a, b]), do: div(a, b)

  def context(), do: context(%Context{scope: %{}, parent: nil})
  def context(%Context{scope: scope, parent: parent}) do
    Context.new(Map.merge(scope, %{
      first: &first/1,
      rest:  &rest/1,
      inspect: &sch_inspect/1,
      print: &print/1,
      +: &add/1,
      -: &sub/1,
      *: &mul/1,
      /: &div/1
    }), parent)
  end
end


