defmodule SchemEx.ParseError do
  defexception [:message]

  def exception(token) do
    msg = "#{inspect token} is not a valid token"
    %__MODULE__{message: msg}
  end
end
