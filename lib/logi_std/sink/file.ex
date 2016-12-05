defmodule LogiStd.Sink.File do
  @moduledoc """
  A sink which writes log messages to a file.

  ## Note

  The sink has no overload protections,
  so it is recommended to use it together with (for example) `Logi.Sink.Flowlimiter`
  in a production environment.
  (See also `LogiStd.Sink.Ha`)

  ## Examples

  ```
  iex> sink = LogiStd.Sink.File.new(:sample_file, "sample.log")
  iex> {:ok, _} = Logi.Channel.install_sink(sink, :info)

  iex> reuire Logi
  iex> Logi.info "hello world"
  iex> :file.read_file "sample.log"
  {:ok, "2016-12-05 23:30:39.810 [info] nonode@nohost <0.159.0> nil:nil:49 [] hello world\\n"}
  ```

  ## Memo (TODO: rewrite)

  As for the rotation of the log file, the implementation module of `Logi.File.Rotator` is in charge.
  (e.g., rotation in units of dates and sizes, deletion of old log files, compression when rotated etc)

  The writer process periodically checks the output destination path, and if the log file does not exist,
  it is opened again.
  However, if the path is the same even if the file (i.e., i-node in the case of unix) has changed,
  as in the case of being overwritten,
  Care should be taken because the change is not detected.
  (Log messages will continue to be written to files that do not already exist)

  If the log file can not be opened or written due to disk full or authorization error etc.,
  An error of `alert` level is reported using the logger specified when starting writer.
  (See also `LogiStd.Sink.Ha`)
  """

  @typedoc "A log file path."
  @type filepath :: binary

  @typedoc """
  Options for this sink.

  ### layout
  - The layout instance used by the sink
  - Default: `LogiStd.Sink.File.default_layout`

  ### logger
  - The logger instance which is used to report internal events of the sink process
  - Default: `Logi.default_logger`

  ### rotator
  - The rotator instance used by the sink
  - Default: `LogiStd.File.Rotator.Noop.new`

  ### open_opt
  - Log file open options (i.e., the second argument of `:file:open/2`)
  - Default: `[:append, :raw, :delayed_write]`
  """
  @type options :: [
    layout: Logi.Layout.layout,
    logger: Logi.logger,
    rotator: LogiStd.Sink.FileRotator.rotator,
    open_opt: open_options
  ]

  @typedoc """
  Log file open options.

  See [file:mode/0](http://www.erlang.org/doc/man/file.html#type-mode) for more details.
  """
  @type open_options :: list

  @doc "Creates a new sink."
  @spec new(Logi.Sink.id, :file.name_all, options) :: Logi.Sink.sink
  def new(sink_id, filepath, options \\ []) do
    :logi_sink_file.new sink_id, filepath, options
  end

  @doc """
  Default layout.

  Returns `LogiStd.Layout.Default.new |> LogiStd.Layout.Limit.new |> LogiStd.Layout.Newline.new`.
  """
  @spec default_layout :: Logi.Layout.layout
  def default_layout do
    :logi_sink_file.default_layout
  end
end
