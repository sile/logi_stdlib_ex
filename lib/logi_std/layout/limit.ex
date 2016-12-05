defmodule LogiStd.Layout.Limit do
  @moduledoc """
  A `Logi.Layout` implementation which limits the size of a log message.
  """

  @doc "Creates a new layout instance."
  @spec new(Logi.Layout.layout, options) :: Logi.Layout.layout when
  options: [
    {:max_width, pos_integer | :infinity} |
    {:max_depth, pos_integer | :infinity} |
    {:max_size, pos_integer | :infinity}
  ]
  def new(layout, options \\ []) do
    :logi_layout_limit.new layout, options
  end
end
