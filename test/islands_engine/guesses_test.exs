defmodule GuessesTest do
  use ExUnit.Case
  doctest IslandsEngine.Guesses

  alias IslandsEngine.Guesses

  describe "new/0" do
    test "creates a guesses struct" do
      assert %Guesses{hits: %MapSet{}, misses: %MapSet{}} == Guesses.new()
    end
  end
end
