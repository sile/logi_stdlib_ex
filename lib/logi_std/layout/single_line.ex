defmodule LogiStd.Layout.SingleLine do
  @moduledoc """
  A `Logi.Layout` implementation which removes newline characters from output messages.
  """

  @doc "Creates a new layout instance."
  @spec new(Logi.Layout.layout) :: Logi.Layout.layout
  def new(layout) do
    :logi_layout_single_line.new layout
  end
end
