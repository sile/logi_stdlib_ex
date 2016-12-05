defmodule LogiStd.File.Rotator.Daily do
  @moduledoc """
  A `LogiStd.File.Rotator` implementation which rotates files by day.

  ## Examples

  ```
  iex> rotator = LogiStd.File.Rotator.Daily.new
  iex> sink = LogiStd.Sink.File.new(:foo, "{YYYY}-{MM}-{DD}-sample.log", [rotator: rotator])
  iex> {:ok, _} = Logi.Channel.install_sink(sink, :debug)

  iex> require Logi
  iex> Logi.info "hello world"
  iex> :file.read_file "2016-12-05-sample.log"
  {:ok, "2016-12-05 23:31:47.953 [info] nonode@nohost <0.159.0> nil:nil:74 [] hello world\\n"}
  ```

  ## Memo (TODO: rewrite)

  The file path passed in the second argument of `LogiStd.Sink.File.new/3` is
  expanded according to the following rules:
  - The string `{YY}` in the path is replaced by the last two digits of the current year
  - The string `{YYYY}` in the path is replaced with the current year (padding with `0` if it is not enough for 4 digits)
  - The string `{MM}` in the path is replaced with the current month (padded with `0` if it is not enough)
  - The string `{DD}` in the path is replaced by the current day (padding with `0` if it is not enough for two digits)
  """

  @doc "Creates a new rotator instance."
  @spec new(LogiStd.File.Rotator.rotate) :: LogiStd.File.Rotator.rotator
  def new(base_rotator \\ LogiStd.File.Rotator.Noop.new) do
    :logi_sink_file_rotator_daily.new base_rotator
  end
end
