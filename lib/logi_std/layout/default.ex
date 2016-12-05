defmodule LogiStd.Layout.Default do
  @moduledoc """
  A `Logi.Layout` implementation which is used as the default layout in this application.

  This module layouts a log message by the following format:

  ```text
  {yyyy}-{MM}-{dd} {HH}:{mm}:{ss}.{SSS} [{SEVERITY}] {NODE} {PID} {MODULE}:{FUNCTION}:{LINE} [{HEADER(KEY=VALUE)}*] {MESSAGE}
  ```
  """

  @doc "Creates a new layout instance."
  @spec new :: Logi.Layout.layout
  def new do
    :logi_layout_default.new
  end
end
