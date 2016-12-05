defmodule LogiStd.Filter.Frequency do
  @moduledoc """
  A `Logi.Filter` implementation to control log message output frequency.
  """

  @typedoc "Positive milli-seconds."
  @type pos_milliseconds :: pos_integer

  @doc """
  Creates a new filter instance.

  ## Options
  ### max_count
  - Maximum log message count allowed in the given period
  - Default: `5`

  ### period
  - Frequency control period
  - Default: `60000`
  """
  @spec new(options) :: Logi.Filter.filter when
  options: [
    max_count: pos_integer,
    period: pos_milliseconds
  ]
  def new(options) do
    :logi_filter_frequency.new options
  end
end
