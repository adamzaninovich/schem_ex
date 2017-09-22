defmodule SchemEx.Interpreter do
  alias SchemEx.Context
  alias SchemEx.Token, as: T

  defp std_lib_context(), do: SchemEx.StdLib.Builtins.context()
  defp special_functions(), do: SchemEx.StdLib.Special.functions()

  def interpret(input) do
    interpret(input, std_lib_context())
  end
  def interpret(input, context) do
    case input do
      input when is_list(input) -> interpret_list(input, context)
      %T{type: :id, value: id}  -> Context.get(context, id)
      %T{value: literal}        -> literal
    end
  end

  @special_names Map.keys(SchemEx.StdLib.Special.functions())

  def interpret_list([%T{value: name} | _] = input, context) when name in @special_names do
    special_functions()[name].(input, context)
  end
  def interpret_list(input, context) do
    input
    |> Enum.map(&interpret(&1, context))
    |> handle_interpreted_list()
  end

  defp handle_interpreted_list([f | args]) when is_function(f, 1), do: f.(args)
  defp handle_interpreted_list([f | _args]) when is_function(f) do
    raise RuntimeError, message: "function #{inspect f} is not arity of 1"
  end
  defp handle_interpreted_list(list), do: list
end
