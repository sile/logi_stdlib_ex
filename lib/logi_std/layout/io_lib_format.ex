defmodule LogiStd.Layout.IoLibFormat do
  @moduledoc """
  A `Logi.Layout` implementation which uses `:io_lib.format/2` function to format log messages.
  """

  @doc "Creates a new layout instance."
  @spec new :: Logi.Layout.layout
  def new do
    :logi_layout_io_lib_format.new
  end
end
