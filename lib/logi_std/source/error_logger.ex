defmodule LogiStd.Source.ErrorLogger do
  @moduledoc """
  A handler for the standard error_logger module to forward log messages.

  If `install/1` is invoked, then the messages issued via `:error_logger` module are forwarded to a logi channel.
  """

  @typedoc "A function which forwards log messages to a Logi channel."
  @type log_fun :: (error_logger_event, Logi.logger_instance -> Logi.logger_instance)

  @typedoc """
  The PID of a group leader.

  See Erlang official documentation of `:error_logger` for more information on "group leader".
  """
  @type group_leader :: pid

  @typedoc """
  An event which is send by `:error_logger`.

  The list is excerpted from [error_logger#Events](http://www.erlang.org/doc/man/error_logger.html#id115197).
  """
  @type error_logger_event ::
  {:error,          group_leader, {pid, :io.format, Logi.Layout.data}} |
  {:error_report,   group_leader, {pid, :std_error, report :: any}} |
  {:error_report,   group_leader, {pid, type :: any, report :: any}} |
  {:warning_msg,    group_leader, {pid, :io.format, Logi.Layout.data}} |
  {:warning_report, group_leader, {pid, :std_warning, report :: any}} |
  {:warning_report, group_leader, {pid, type :: any, report :: any}} |
  {:info_msg,       group_leader, {pid, :io.format, Logi.Layout.data}} |
  {:info_report,    group_leader, {pid, :std_info, report :: any}} |
  {:info_report,    group_leader, {pid, type :: any, report :: any}}

  @typedoc """
  Install options.

  ### logger
  - The logger instance which is used to report internal events of the handler
  - Default: `Logi.default_logger`

  ### forward_logger
  - The logger instance which is used to forward log messages issued via `:error_logger`
  - Default: `Logi.default_logger`

  ### max_message_queue_len
  - Maximum message queue length of the `:error_logger` process
  - While the length exceeds the value, new arrival messages will not be forwarded (i.e., discarded)
  - Default: `128`

  ### log_fun
  - Log messages forwarding function
  - Default: `&:logi_source_error_logger.default_log_fun/2`
  """
  @type options :: [
    {:logger, Logi.logger} |
    {:forward_logger, Logi.logger} |
    {:max_message_queue_len, non_neg_integer} |
    {:log_fun, log_fun}
  ]

  @doc "Installs the `:error_logger` handler."
  @spec install(options) :: :ok | {:error, any}
  def install(options \\ []) do
    :logi_source_error_logger.install options
  end

  @doc "Uninstalls the handler."
  @spec uninstall :: :ok | {:error, any}
  def uninstall do
    :logi_source_error_logger.uninstall
  end
end
