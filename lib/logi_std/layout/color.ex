defmodule LogiStd.Layout.Color do
  @moduledoc """
  A `Logi.Layout` implementation which gives color to tty output messages.
  """

  @typedoc " A function which returns ANSI escape code associated with given message context."
  @type color_fun :: (Logi.Context.context -> iodata)

  @doc "Creates a new layout instance."
  @spec new(Logi.Layout.layout, color_fun) :: Logi.Layout.layout
  def new(layout, color \\ &__MODULE__.default_color/1) do
    :logi_layout_color.new layout, color
  end

  @doc "Default color mapping function."
  @spec default_color(Logi.Context.context) :: iodata
  def default_color(context) do
    :logi_layout_color.default_color context
  end
end
