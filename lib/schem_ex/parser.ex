defmodule SchemEx.Parser do
  alias SchemEx.Token

  def parse(input) do
    {[], parsed} = do_parse(input, [])
    parsed
  end

  defp do_parse([], list) do
    {[], list |> Enum.reverse |> hd}
  end
  defp do_parse(["(" | input], list) do
    {input, sub_list} = do_parse(input, [])
    list = list ++ [sub_list]
      do_parse(input, list)
  end
  defp do_parse([")" | input], list) do
    {input, list}
  end
  defp do_parse([token | input], list) do
    list = list ++ [categorize(token)]
    do_parse(input, list)
  end

  defp categorize("\"" <> _ = str) do
    Token.new(:literal, String.trim(str, "\""))
  end
  defp categorize(token) do
    case parse_number(token) do
      :not_a_number -> Token.new(:id, String.to_atom(token))
      :invalid -> raise SchemEx.ParseError, token
      num -> Token.new(:literal, num)
    end
  end

  defp parse_number(token) do
    case Integer.parse(token) do
      {int, ""} -> int
      _ ->
        case Float.parse(token) do
          {flt, ""} -> flt
          {_num, _} -> :invalid
          :error    -> :not_a_number
        end
    end
  end
end
