defmodule LogiStd.Sink.HA do
  @moduledoc """
  A sink which provides HA (High Availability) functionality.
  """

  @typedoc """
  Options for this sink.

  ### logger
  - The logger instance which is used to report internal events of the sink process
  - Default: `Logi.default_logger`

  ### strategy
  - Peer selection strategy
  - Default: `:random`
  """
  @type options :: [
    logger: Logi.logger,
    strategy: select_strategy
  ]

  @typedoc """
  Peer selection strategy:
  - `:first_available`: Selects first available peer in the list
  - `:random`: Selects random peer in the list
  """
  @type select_strategy :: :first_available | :random

  @typedoc "Exited peer restarting strategy."
  @type restart_strategy :: %{
    :interval => timeout | {min :: timeout(), max :: timeout()}
  }

  @typedoc """
  A peer specification.

  `:restart` is optional field (default value is `%{:interval => {1000, 60000}}`).
  """
  @type peer :: %{
    :sink => Logi.Sink.sink,
    :restart => restart_strategy
  }

  @doc "Creates a new sink instance."
  @spec new(Logi.Sink.id, [peer], options) :: Logi.Sink.sink
  def new(sink_id, peers, options \\ []) do
    :logi_sink_ha.new sink_id, peers, options
  end
end
