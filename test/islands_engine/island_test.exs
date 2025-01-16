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

  describe "overlaps?/2" do
    test "returns true when islands overlap" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})
      {:ok, l_shape_island} = Island.new(:l_shape, %Coordinate{row: 1, col: 1})

      assert Island.overlaps?(square_island, l_shape_island)
    end

    test "returns false when islands do not overlap" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})
      {:ok, l_shape_island} = Island.new(:l_shape, %Coordinate{row: 6, col: 1})

      refute Island.overlaps?(square_island, l_shape_island)
    end
  end

  describe "guess/2" do
    test "adds a hit coordinate to island when island is hit" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})

      expected_hit_coordinates = MapSet.new([%Coordinate{row: 2, col: 2}])

      assert {:hit, %Island{coordinates: _, hit_coordinates: ^expected_hit_coordinates}} =
               Island.guess(square_island, %Coordinate{row: 2, col: 2})
    end

    test "returns :miss when guess is not on island" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})

      assert :miss == Island.guess(square_island, %Coordinate{row: 5, col: 5})
    end
  end

  describe "forested?/1" do
    test "returns true when all island coordinates are hit" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})
      square_island = %Island{square_island | hit_coordinates: square_island.coordinates}

      assert Island.forested?(square_island)
    end

    test "returns false when island coordinates are not all hit" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})

      square_island = %Island{
        square_island
        | hit_coordinates:
            MapSet.new([
              %Coordinate{row: 1, col: 1},
              %Coordinate{row: 1, col: 2},
              %Coordinate{row: 2, col: 1}
            ])
      }

      refute Island.forested?(square_island)
    end
  end

  describe "types/0" do
    test "returns a list of island types" do
      assert [:atoll, :dot, :l_shape, :s_shape, :square] == Island.types()
    end
  end
end
