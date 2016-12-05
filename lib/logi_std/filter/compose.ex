defmodule LogiStd.Filter.Compose do
  @moduledoc """
  A `Logi.Filter` implementation filter which is composed of sub-filters combined by logical operators.
  """

  @typedoc """
  Logical operation expression which represents a composite filter.

  Expressions are evaluated in the short-circuit manner.
  """
  @type expression ::
  {:not, expression} |
  {:and, [expression]} |
  {:or, [expression]} |
  Logi.Filter.filter

  @doc "Creates a new filter instance."
  @spec new(expression) :: Logi.Filter.filter
  def new(expression) do
    :logi_filter_compose.new expression
  end
end
