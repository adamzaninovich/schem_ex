defmodule SchemEx.Token do
  defstruct [:type, :value]

  def new(type, value) do
    %__MODULE__{type: type, value: value}
  end
end
