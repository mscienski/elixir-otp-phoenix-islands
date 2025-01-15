defmodule CoordinateTest do
  use ExUnit.Case
  doctest IslandsEngine

  alias IslandsEngine.Coordinate

  test "creates a coordinate" do
    assert {:ok, %Coordinate{row: 1, col: 1}} = Coordinate.new(1, 1)
  end

  test "returns invalid coordinate when out of range" do
    assert {:error, :invalid_coordinate} = Coordinate.new(1, -1)
  end
end
