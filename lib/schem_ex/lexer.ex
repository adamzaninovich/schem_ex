defmodule SchemEx.Lexer do
  def tokenize(code) when is_binary(code) do
    code
    |> String.split(~r{[() \n]}, include_captures: true)
    |> Enum.reject(&empty_tokens/1)
  end
  def tokenize(_code), do: {:error, "SchemEx.Lexer.tokenize expects a string of code."}

  defp empty_tokens(" "), do: true
  defp empty_tokens("\n"), do: true
  defp empty_tokens("\r"), do: true
  defp empty_tokens("\r\n"), do: true
  defp empty_tokens(""), do: true
  defp empty_tokens(_), do: false
end
