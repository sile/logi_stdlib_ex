defmodule LogiStd.Filter.Severity do
  @moduledoc """
  A `Logi.Filter` implementation which filters log messages by given severity condition.
  """

  @doc """
  Creates a new filter instance.

  If a log message does not match `severity_condition`, it is discarded by the filter.
  """
  @spec new(Logi.Condition.severity_condition) :: Logi.Filter.filter
  def new(severity_condition) do
    :logi_filter_severity.new severity_condition
  end
end
