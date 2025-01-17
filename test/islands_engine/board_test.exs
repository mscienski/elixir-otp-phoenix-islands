defmodule BoardTest do
  use ExUnit.Case
  doctest IslandsEngine.Board

  alias IslandsEngine.{Board, Coordinate, Island}

  describe "new/0" do
    test "creates a board as an empty map" do
      assert %{} == Board.new()
    end
  end

  describe "position_island/3" do
    test "puts an island on the board" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})
      board = Board.new()

      assert %{square: square_island} ==
               Board.position_island(board, :square, square_island)
    end

    test "positions multiple islands" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})
      {:ok, dot_island} = Island.new(:dot, %Coordinate{row: 9, col: 9})
      {:ok, l_shape_island} = Island.new(:l_shape, %Coordinate{row: 5, col: 5})

      assert %{square: square_island, dot: dot_island, l_shape: l_shape_island} ==
               Board.new()
               |> Board.position_island(:square, square_island)
               |> Board.position_island(:dot, dot_island)
               |> Board.position_island(:l_shape, l_shape_island)
    end

    test "returns error when islands overlap" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})
      {:ok, dot_island} = Island.new(:dot, %Coordinate{row: 1, col: 1})
      board = Board.new() |> Board.position_island(:dot, dot_island)

      assert {:error, :overlapping_island} ==
               Board.position_island(board, :square, square_island)
    end
  end

  describe "all_islands_positioned?/1" do
    test "returns false when board does not have all islands" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})

      refute Board.new()
             |> Board.position_island(:square, square_island)
             |> Board.all_islands_positioned?()
    end

    test "returns true when board has all islands positioned" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})
      {:ok, dot_island} = Island.new(:dot, %Coordinate{row: 9, col: 9})
      {:ok, l_shape_island} = Island.new(:l_shape, %Coordinate{row: 5, col: 5})
      {:ok, atoll_island} = Island.new(:atoll, %Coordinate{row: 5, col: 1})
      {:ok, s_shape_island} = Island.new(:s_shape, %Coordinate{row: 9, col: 1})

      board =
        Board.new()
        |> Board.position_island(:square, square_island)
        |> Board.position_island(:dot, dot_island)
        |> Board.position_island(:l_shape, l_shape_island)
        |> Board.position_island(:atoll, atoll_island)
        |> Board.position_island(:s_shape, s_shape_island)

      assert Board.all_islands_positioned?(board)
    end
  end

  describe "guess/2" do
    test "applies a missed guess to islands on the board and returns the no win result" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})
      {:ok, dot_island} = Island.new(:dot, %Coordinate{row: 9, col: 9})
      {:ok, l_shape_island} = Island.new(:l_shape, %Coordinate{row: 5, col: 5})
      {:ok, atoll_island} = Island.new(:atoll, %Coordinate{row: 5, col: 1})
      {:ok, s_shape_island} = Island.new(:s_shape, %Coordinate{row: 9, col: 1})

      board =
        Board.new()
        |> Board.position_island(:square, square_island)
        |> Board.position_island(:dot, dot_island)
        |> Board.position_island(:l_shape, l_shape_island)
        |> Board.position_island(:atoll, atoll_island)
        |> Board.position_island(:s_shape, s_shape_island)

      assert {:miss, :none, :no_win, board} == Board.guess(board, %Coordinate{row: 7, col: 8})
    end

    test "applies a hit guess to islands on the board and returns the no win result" do
      {:ok, square_island} = Island.new(:square, %Coordinate{row: 1, col: 1})
      {:ok, dot_island} = Island.new(:dot, %Coordinate{row: 9, col: 9})
      {:ok, l_shape_island} = Island.new(:l_shape, %Coordinate{row: 5, col: 5})
      {:ok, atoll_island} = Island.new(:atoll, %Coordinate{row: 5, col: 1})
      {:ok, s_shape_island} = Island.new(:s_shape, %Coordinate{row: 9, col: 1})

      board =
        Board.new()
        |> Board.position_island(:square, square_island)
        |> Board.position_island(:dot, dot_island)
        |> Board.position_island(:l_shape, l_shape_island)
        |> Board.position_island(:atoll, atoll_island)
        |> Board.position_island(:s_shape, s_shape_island)

      {:hit, hit_square_island} = Island.guess(square_island, %Coordinate{row: 1, col: 1})

      assert {:hit, :none, :no_win, %{board | square: hit_square_island}} ==
               Board.guess(board, %Coordinate{row: 1, col: 1})
    end

    test "returns a hit and no win when island is hit but not forested" do
      square_island = %Island{
        coordinates:
          MapSet.new([
            %Coordinate{row: 1, col: 1},
            %Coordinate{row: 1, col: 2},
            %Coordinate{row: 2, col: 1},
            %Coordinate{row: 2, col: 2}
          ]),
        hit_coordinates: %MapSet{}
      }

      board =
        Board.new()
        |> Board.position_island(:square, square_island)

      {:hit, hit_square_island} = Island.guess(square_island, %Coordinate{row: 2, col: 2})

      assert {:hit, :none, :no_win, %{board | square: hit_square_island}} ==
               Board.guess(board, %Coordinate{row: 2, col: 2})
    end

    test "returns a hit with forested island but no win when some but not all islands are forested" do
      square_island = %Island{
        coordinates:
          MapSet.new([
            %Coordinate{row: 1, col: 1},
            %Coordinate{row: 1, col: 2},
            %Coordinate{row: 2, col: 1},
            %Coordinate{row: 2, col: 2}
          ]),
        hit_coordinates:
          MapSet.new([
            %Coordinate{row: 1, col: 1},
            %Coordinate{row: 1, col: 2},
            %Coordinate{row: 2, col: 1},
            %Coordinate{row: 2, col: 2}
          ])
      }

      {:ok, dot_island} = Island.new(:dot, %Coordinate{row: 9, col: 9})
      {:ok, l_shape_island} = Island.new(:l_shape, %Coordinate{row: 5, col: 5})

      board =
        Board.new()
        |> Board.position_island(:square, square_island)
        |> Board.position_island(:dot, dot_island)
        |> Board.position_island(:l_shape, l_shape_island)

      {:hit, forested_dot_island} = Island.guess(dot_island, %Coordinate{row: 9, col: 9})

      assert {:hit, :dot, :no_win, %{board | dot: forested_dot_island}} ==
               Board.guess(board, %Coordinate{row: 9, col: 9})
    end

    test "returns a win result when all islands are forested" do
      square_island = %Island{
        coordinates:
          MapSet.new([
            %Coordinate{row: 1, col: 1},
            %Coordinate{row: 1, col: 2},
            %Coordinate{row: 2, col: 1},
            %Coordinate{row: 2, col: 2}
          ]),
        hit_coordinates:
          MapSet.new([
            %Coordinate{row: 1, col: 1},
            %Coordinate{row: 1, col: 2},
            %Coordinate{row: 2, col: 1}
          ])
      }

      board =
        Board.new()
        |> Board.position_island(:square, square_island)

      {:hit, forested_square_island} = Island.guess(square_island, %Coordinate{row: 2, col: 2})

      assert {:hit, :square, :win, %{board | square: forested_square_island}} ==
               Board.guess(board, %Coordinate{row: 2, col: 2})
    end
  end
end
