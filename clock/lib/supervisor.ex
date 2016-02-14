defmodule Clock.Supervisor do
  @moduledoc """
  Application-level supervisor
  """

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Clock.Servers.ClockMachine, [[Clock.Agents.ISODisplay, Clock.Agents.FriendlyDisplay]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
