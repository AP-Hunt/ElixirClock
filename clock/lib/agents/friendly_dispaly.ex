defmodule Clock.Agents.FriendlyDisplay do
  @moduledoc """
  Displays a friendly date when receiving a tick event
  """

  use GenEvent
  use Timex

  # GenEvent callbacks
  def handle_event({:tick, datetime}, messages) do
    {_, date_string} = datetime |> DateFormat.format("Hi! The time is %A %d %b %Y", :strftime)
    IO.puts date_string
    {:ok, [datetime|messages]}
  end
end
