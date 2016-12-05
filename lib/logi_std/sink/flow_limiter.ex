defmodule LogiStd.Sink.FlowLimiter do
  @moduledoc """
  A sink which limits message flow rate of underlying sink.

  ## Examples

  ```
  iex> base_sink = LogiStd.Sink.Console.new(:console)
  iex> sink = LogiStd.Sink.FlowLimiter.new(:limiter, base_sink, [write_rate_limits: [{1024, 1000}]])
  iex> {:ok, _} = Logi.Channel.install_sink(sink, :debug)

  iex> require Logi
  iex> Logi.notice "hello world"
  #OUTPUT# 2016-12-05 23:53:05.206 [notice] nonode@nohost <0.159.0> nil:nil:62 [] hello world

  iex> Enum.each 1..1000, fn (i) -> Logi.info("hello: ~p", [i]) end
  #OUTPUT# 2016-12-05 23:55:07.064 [info] nonode@nohost <0.159.0> nil:nil:64 [] hello: 1
  #OUTPUT# 2016-12-05 23:55:07.064 [info] nonode@nohost <0.159.0> nil:nil:64 [] hello: 2
  #OUTPUT# 2016-12-05 23:55:07.064 [info] nonode@nohost <0.159.0> nil:nil:64 [] hello: 3
  #OUTPUT# 2016-12-05 23:55:07.064 [info] nonode@nohost <0.159.0> nil:nil:64 [] hello: 4
  #OUTPUT# 2016-12-05 23:55:07.064 [info] nonode@nohost <0.159.0> nil:nil:64 [] hello: 5
  #OUTPUT# 2016-12-05 23:55:07.064 [info] nonode@nohost <0.159.0> nil:nil:64 [] hello: 6
  #OUTPUT# 2016-12-05 23:55:07.064 [info] nonode@nohost <0.159.0> nil:nil:64 [] hello: 7
  #OUTPUT# 2016-12-05 23:55:07.064 [info] nonode@nohost <0.159.0> nil:nil:64 [] hello: 8
  #OUTPUT# 2016-12-05 23:55:07.064 [info] nonode@nohost <0.159.0> nil:nil:64 [] hello: 9
  #OUTPUT# 2016-12-05 23:55:07.064 [info] nonode@nohost <0.159.0> nil:nil:64 [] hello: 10
  #OUTPUT# 2016-12-05 23:55:07.064 [info] nonode@nohost <0.159.0> nil:nil:64 [] hello: 11
  #OUTPUT# 2016-12-05 23:55:07.064 [info] nonode@nohost <0.159.0> nil:nil:64 [] hello: 12
  #OUTPUT# 2016-12-05 23:55:43.434 [warning] nonode@nohost <0.500.0> logi_sink_flow_limiter_writer:report_omissions:189 [] Over a period of 60 seconds, 988 info messages were omitted: channel=logi_default_log, reason=rate_exceeded (e.g. [{pid,module,line},{<0.159.0>,nil,64}])
  ```

  ## Memo (TODO: rewrite)

  At the time of log output, this sink makes the following judgment:
  - Whether the log destination process is alive
  - Whether the message queue of the process to which the log is written is not packed
  - Whether the output pace of the log is within the specified range

  If either condition is not satisfied, the log message is discarded.
  (If there are discarded messages, the report is output at once at regular intervals)

  When all the conditions are satisfied, the subsequent processing is delegated to
  the sink which is responsible for the actual log output processing.
  """

  @typedoc """
  Options for this sink.

  ### logger
  - The logger instance which is used to report internal events (e.g., message discarding) of the sink process
  - Default: `Logi.default_logger`

  ### max_message_queue_len
  - Maximum message queue length of the writee process of the underlying sink
  - While the queue length exceeds the value, messages will be discarded
  - Default: `256`

  ### write_rate_limits
  - Log messages write rate limit specification
  - If all `t:write_rate/0` are satisfied, new arrival message will be outputed
  - e.g., `[{10*1024*1024, 1000}, {500*1024*1024, 60*60*1000}]`: 10MB/seconds and 500MB/seconds
  - Default: `[]`
  """
  @type options :: [
    logger: Logi.logger,
    max_message_queue_len: non_neg_integer,
    write_rate_limits: [write_rate]
  ]

  @typedoc """
  Write rate limit specification.

  In `period` milliseconds, it is allowed to write messages of up to `bytes` bytes.
  """
  @type write_rate :: {bytes :: non_neg_integer, period :: pos_milliseconds}

  @typedoc "Positive milliseconds."
  @type pos_milliseconds :: pos_integer

  @doc "Creates a new sink."
  @spec new(Logi.Sink.id, Logi.Sink.sink, options) :: Logi.Sink.sink
  def new(sink_id, sink, options \\ []) do
    :logi_sink_flow_limiter.new sink_id, sink, options
  end
end
