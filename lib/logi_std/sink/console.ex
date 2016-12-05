defmodule LogiStd.Sink.Console do
  @moduledoc """
  A sink which prints log messages to the console.

  Behaviours: `Logi.SinkWriter`.

  ## Note

  The sink has no overload protections,
  so it is recommended to use it together with (for example) `LogiStd.Sink.FlowLimiter`
  in a production environment.

  ## Examples

  ```
  iex> Logi.Channel.install_sink(LogiStd.Sink.Console.new(:foo), :info)

  iex> require Logi
  iex> Logi.info "hello world"
  #OUTPUT# 2016-12-05 23:11:53.711 [info] nonode@nohost <0.159.0> nil:nil:5 [] hello world
  ```

  Uses other layout:

  ```
  iex> Logi.Channel.install_sink(LogiStd.Sink.Console.new(:foo, LogiStd.Layout.IoLibFormat.new), :info).
  iex> Logi.info "hello world"
  #OUTPUT# hello world
  ```
  """

  @doc "Creates a new sink."
  @spec new(Logi.Sink.id, Logi.Layout.layout) :: Logi.Sink.sink
  def new(sink_id, layout \\ __MODULE__.default_layout) do
    :logi_sink_console.new sink_id, layout
  end

  @doc """
  Default layout.

  Returns `LogiStd.Layout.Default.new |> LogiStd.Layout.Limit.new |> LogiStd.Layout.Color.new |> LogiStd.Layout.Newline.new`.
  """
  @spec default_layout :: Logi.Layout.layout
  def default_layout do
    :logi_sink_console.default_layout
  end
end
