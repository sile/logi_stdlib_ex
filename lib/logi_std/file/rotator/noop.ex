defmodule LogiStd.File.Rotator.Noop do
  @moduledoc """
  A noop `LogiStd.File.Rotator` implementation.
  """

  @doc "Creates a new rotator instance."
  @spec new :: LogiStd.File.Rotator.rotator
  def new do
    :logi_sink_file_rotator_noop.new
  end
end
