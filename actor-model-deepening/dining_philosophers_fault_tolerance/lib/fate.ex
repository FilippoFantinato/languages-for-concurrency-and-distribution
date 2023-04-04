defmodule Fate do
  use Supervisor

  def start_link(philosophers) do
    Supervisor.start_link(__MODULE__, philosophers, name: __MODULE__)
  end

  def init(philosophers) do
    Supervisor.init(philosophers, strategy: :one_for_one, max_restarts: 5)
  end
end
