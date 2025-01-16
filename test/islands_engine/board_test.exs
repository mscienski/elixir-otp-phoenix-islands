defmodule BoardTest do
  use ExUnit.Case
  doctest IslandsEngine.Board

  alias IslandsEngine.Board

  describe "new/0" do
    test "creates a board as an empty map" do
      assert %{} == Board.new()
    end
  end
end
