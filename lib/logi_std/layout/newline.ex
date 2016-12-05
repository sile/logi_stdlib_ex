defmodule LogiStd.Layout.Newline do
  @moduledoc """
  A `Logi.Layout` implementation which appends newline character(s) to tail of output messages.
  """

  @typedoc "Newline style."
  @type style :: :lf | :cr | :crlf

  @doc "Creates a new layout instance."
  @spec new(Logi.Layout.layout, style) :: Logi.Layout.layout
  def new(layout, style \\ :lf) do
    :logi_layout_newline.new layout, style
  end
end
