defmodule Clock.Servers.ClockMachine do
  @moduledoc """
  ClockMachine sends tick commands out to display agents with the date and time to display
  """

  use GenServer
  use Timex

  def start_link(formatters) do
    GenServer.start_link(__MODULE__, formatters, [])
  end

  def tick(machine) do
    GenServer.call(machine, {:tick})
  end

  def stop(machine) do
    GenServer.call(machine, {:stop})
  end

  ## GenServer callbacks
  def init(formatters) do
    {:ok, eventer} = create_genevent()

    add_handler_to_eventer = &GenEvent.add_handler(eventer, &1, [])
    Enum.each(formatters, add_handler_to_eventer)

    {_, ticker} = :timer.apply_interval(:timer.seconds(4), __MODULE__, :tick, [self()])
    {:ok, %{:events => eventer, :ticker => ticker}}
  end

  defp create_genevent do
    GenEvent.start
  end

  def handle_call({:tick}, _from, state) do
    GenEvent.notify(state[:events], {:tick, Date.now})
    {:reply, :ok, state}
  end

  def handle_call({:stop}, _from, state) do
    IO.puts "Handling stop"
    :timer.cancel(state[:ticker])
    {:reply, :ok, state}
  end
end
