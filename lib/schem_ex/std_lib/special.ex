defmodule SchemEx.StdLib.Special do
  alias SchemEx.Token, as: T
  alias SchemEx.{Context,GlobalContext,Interpreter}

  def lambda([%T{value: :lambda}, parameter_list, body], context) do
    fn(arguments) ->
      lscope =
        parameter_list
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn({%T{value: value}, index}, scope) ->
          Map.put(scope, value, Enum.at(arguments, index))
        end)

      Interpreter.interpret(body, Context.new(lscope, context))
    end
  end

  def define([%T{value: :define}, [%T{type: :id, value: name} | args], expression], context) do
    function = lambda([%T{value: :lambda}, args, expression], context)
    GlobalContext.put(name, function)
    function
  end
  def define([%T{value: :define}, %T{type: :id, value: name}, expression], context) do
    value = Interpreter.interpret(expression, context)
    GlobalContext.put(name, value)
    value
  end

  def sch_if([%T{value: :if}, test_clause, truthy_action, falsy_action], context) do
    if Interpreter.interpret(test_clause, context) do
      Interpreter.interpret(truthy_action, context)
    else
      Interpreter.interpret(falsy_action, context)
    end
  end

  def functions() do
    %{
      define: &define/2,
      lambda: &lambda/2,
      if: &sch_if/2
    }
  end
end
