defmodule LogiStd.File.Rotator do
  @moduledoc """
  The interface of file rotators.
  """

  @doc "See `rotate/2`."
  @callback rotate(LogiStd.Sink.File.filepath, state) ::
  {:ok, LogiStd.Sink.File.filepath, state} | {:error, reason :: any}

  @doc "See `get_current_filepath/2`."
  @callback get_current_filepath(LogiStd.Sink.File.filepath, state) ::
  {:ok, LogiStd.Sink.File.filepath, state} | {:error, reason :: any}

  @doc "See `is_outdated/2`."
  @callback is_outdated(LogiStd.Sink.File.fiepath, state) ::
  {is_outdated :: boolean, next_check_time :: timeout, state}

  @typedoc "A rotator instance."
  @opaque rotator :: {callback_module, state}

  @typedoc "A module that implements the `LogiStd.File.Rotator` behaviour."
  @type callback_module :: module

  @typedoc "The state of an instance of a `LogiStd.File.Rotator` implementing module."
  @type state :: any

  @doc "Creates a new rotator instance."
  @spec new(callback_module, state) :: rotator
  def new(module, state \\ nil) do
    :logi_sink_file_rotator.new module, state
  end

  @doc "Returns `true` if `x` is a `t:rotator/0` instance, `false` otherwise."
  @spec rotator?(any) :: boolean
  def rotator?(x) do
    :logi_sink_file_rotator.is_rotator x
  end

  @doc """
  Rotates `filepath`.

  `rotated` is new file path after the rotation.
  It may be the same as `filepath`.

  A implementation module may not physically rotate the file (e.g., leaves the old file as it is).
  """
  @spec rotate(LogiStd.Sink.File.filepath, rotator) ::
  {:ok, rotated :: LogiStd.Sink.File.filepath, rotator} | {:error, reason :: any}
  def rotate(filepath, rotator) do
    :logi_sink_file_rotator.rotate filepath, rotator
  end

  @doc "Gets the current output file path."
  @spec get_current_filepath(LogiStd.Sink.File.filepath, rotator) ::
  {:ok, LogiStd.Sink.File.filepath, rotator} | {:error, reason :: any}
  def get_current_filepath(filepath, rotator) do
    :logi_sink_file_rotator.get_current_filepath filepath, rotator
  end

  @doc """
  Determines the given file path is outdated.

  If `is_outdated` is `false`, the caller process invokes `rotate/2` to rotate the old file.
  Then it will reopen a new file path which is the result of `get_current_filepath/2`.

  The function will be re-invoked after `next_check_time` milliseconds.
  """
  @spec is_outdated(LogiStd.Sink.File.filepath, rotator) ::
  {is_outdated :: boolean, next_check_time :: timeout, rotator}
  def is_outdated(filepath, rotator) do
    :logi_sink_file_rotator.is_outdated filepath, rotator
  end
end
