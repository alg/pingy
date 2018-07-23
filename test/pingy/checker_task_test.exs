defmodule CheckerTaskTest do
  use ExUnit.Case, async: true

  alias Pingy.CheckerTask, as: T

  test "parse_output/1" do
    assert T.parse_output(valid_res()) == {:ok, 151664}
  end
  
  defp valid_res() do
    "              total        used        free      shared  buff/cache   available
    Mem:        1017868      260740      151664       34092      605464      550340
    Swap:             0           0           0"
  end
end
