defmodule IslandTest do
  use ExUnit.Case
  doctest IslandsEngine.Island

  alias IslandsEngine.{Island, Coordinate}

  describe "new/0" do
    test "creates a square island" do
      assert {:ok,
              %Island{
                coordinates:
                  MapSet.new([
                    %Coordinate{row: 1, col: 1},
                    %Coordinate{row: 1, col: 2},
                    %Coordinate{row: 2, col: 1},
                    %Coordinate{row: 2, col: 2}
                  ]),
                hit_coordinates: %MapSet{}
              }} == Island.new(:square, %Coordinate{row: 1, col: 1})
    end

    test "creates an atoll island" do
      assert {:ok,
              %Island{
                coordinates:
                  MapSet.new([
                    %Coordinate{row: 1, col: 1},
                    %Coordinate{row: 1, col: 2},
                    %Coordinate{row: 2, col: 2},
                    %Coordinate{row: 3, col: 1},
                    %Coordinate{row: 3, col: 2}
                  ]),
                hit_coordinates: %MapSet{}
              }} == Island.new(:atoll, %Coordinate{row: 1, col: 1})
    end

    test "creates a dot island" do
      assert {:ok,
              %Island{
                coordinates:
                  MapSet.new([
                    %Coordinate{row: 1, col: 1}
                  ]),
                hit_coordinates: %MapSet{}
              }} == Island.new(:dot, %Coordinate{row: 1, col: 1})
    end

    test "creates an l_shape island" do
      assert {:ok,
              %Island{
                coordinates:
                  MapSet.new([
                    %Coordinate{row: 1, col: 1},
                    %Coordinate{row: 2, col: 1},
                    %Coordinate{row: 3, col: 1},
                    %Coordinate{row: 3, col: 2}
                  ]),
                hit_coordinates: %MapSet{}
              }} == Island.new(:l_shape, %Coordinate{row: 1, col: 1})
    end

    test "creates an s_shape island" do
      assert {:ok,
              %Island{
                coordinates:
                  MapSet.new([
                    %Coordinate{row: 1, col: 2},
                    %Coordinate{row: 1, col: 3},
                    %Coordinate{row: 2, col: 1},
                    %Coordinate{row: 2, col: 2}
                  ]),
                hit_coordinates: %MapSet{}
              }} == Island.new(:s_shape, %Coordinate{row: 1, col: 1})
    end

    test "returns an error on invalid island type" do
      assert {:error, :invalid_island_type} == Island.new(:isthmus, %Coordinate{row: 1, col: 1})
    end

    test "returns an error when island coordinates are invalid" do
      assert {:error, :invalid_coordinate} == Island.new(:square, %Coordinate{row: 10, col: 10})
    end
  end
end
