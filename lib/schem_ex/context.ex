defmodule SchemEx.GlobalContext do
  use Agent

  def ensure_started() do
    with nil <- Process.whereis(__MODULE__) do
      {:ok, _pid} = start_link(nil)
      :ok
    else
      pid when is_pid(pid) -> :ok
    end
  end

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(id) do
    :ok = ensure_started()
    Agent.get(__MODULE__, &Map.get(&1, id, :notfound))
  end

  def put(id, value) do
    :ok = ensure_started()
    Agent.update(__MODULE__, &Map.put(&1, id, value))
  end
end

defmodule SchemEx.Context do
  @moduledoc """
  SchemEx context

  Contains a scope in the form of a map and a parent context
  """

  @type scope  :: map()
  @type parent :: SchemEx.Context.t()
                | nil

  @type t :: %__MODULE__{
    scope:  scope,
    parent: parent
  }

  defstruct scope:  %{},
            parent: nil

  def new(scope, parent\\nil) do
    %__MODULE__{scope: scope, parent: parent}
  end

  def get(nil, id) do
    SchemEx.GlobalContext.get(id)
  end
  def get(%__MODULE__{scope: scope, parent: parent}, id) do
    if id in Map.keys(scope) do
      Map.get(scope, id)
    else
      get(parent, id)
    end
  end
end
