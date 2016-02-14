defmodule Clock.Agents.ISODisplay do
  @moduledoc """
  Displays datetime values in the ISO 8601 format
  """

  use GenEvent
  use Timex

  # GenEvent callbacks
  def handle_event({:tick, datetime}, messages) do
    {_, date_string} = datetime |> DateFormat.format("{ISO}")
    IO.puts date_string
    {:ok, [datetime|messages]}
  end
end
