defmodule GuessesTest do
  use ExUnit.Case
  doctest IslandsEngine.Guesses

  alias IslandsEngine.{Coordinate, Guesses}

  describe "new/0" do
    test "creates a guesses struct" do
      assert %Guesses{hits: %MapSet{}, misses: %MapSet{}} == Guesses.new()
    end
  end

  describe "add/1" do
    test "adds a coordinate to hits" do
      assert %Guesses{hits: MapSet.new([%Coordinate{row: 1, col: 1}]), misses: %MapSet{}} ==
               Guesses.add(Guesses.new(), :hit, %Coordinate{row: 1, col: 1})
    end

    test "adds a coordinate to misses" do
      assert %Guesses{hits: %MapSet{}, misses: MapSet.new([%Coordinate{row: 5, col: 5}])} ==
               Guesses.add(Guesses.new(), :miss, %Coordinate{row: 5, col: 5})
    end
  end
end
