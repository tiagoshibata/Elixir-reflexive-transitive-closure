defmodule ReflexiveTransitiveClosureTest do
  use ExUnit.Case
  doctest ReflexiveTransitiveClosure

  test "adds edges to adjacency map" do
    assert ReflexiveTransitiveClosure.add_edge(%{}, {1, 2}) == %{1 => MapSet.new([2]), 2 => MapSet.new}
    assert ReflexiveTransitiveClosure.add_edge(%{2 => MapSet.new([3])}, {2, 3}) == %{2 => MapSet.new([3]), 3 => MapSet.new}
    assert ReflexiveTransitiveClosure.add_edge(%{4 => MapSet.new([6])}, {4, 5}) == %{4 => MapSet.new([5, 6]), 5 => MapSet.new}
  end

  test "merges adjacency maps" do
    assert ReflexiveTransitiveClosure.merge_edges(
      %{4 => MapSet.new([5, 6]), 5 => MapSet.new([6, 7])}, %{4 => MapSet.new([5, 8])}) ==
      %{4 => MapSet.new([5, 6, 8]), 5 => MapSet.new([6, 7])}
  end

  test "converts edge list to adjacency map" do
    assert ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 1}, {1, 2}, {2, 1}]) ==
        %{0 => MapSet.new([1]), 1 => MapSet.new([2]), 2 => MapSet.new([1])}
    assert ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 1}, {1, 2}, {1, 3}]) ==
        %{0 => MapSet.new([1]), 1 => MapSet.new([2, 3]), 2 => MapSet.new, 3 => MapSet.new}
  end

  def assert_lists_have_same_elements(a, b) do
    assert Enum.sort(a) == Enum.sort(b)
  end

  def to_edge_list(map) do
    ReflexiveTransitiveClosure.adjacency_map_to_edge_list(map)
  end

  test "converts adjacency map to edge list" do
    assert_lists_have_same_elements(
      to_edge_list(%{0 => MapSet.new([1]), 1 => MapSet.new([2]), 2 => MapSet.new([1])}),
      [{0, 1}, {1, 2}, {2, 1}])
    assert_lists_have_same_elements(
      to_edge_list(%{0 => MapSet.new([1]), 1 => MapSet.new([2, 3]), 2 => MapSet.new, 3 => MapSet.new}),
      [{0, 1}, {1, 2}, {1, 3}])
  end

  test "does DFS" do
    assert ReflexiveTransitiveClosure.dfs(
      ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 1}, {1, 0}])) ==
      ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 0}, {0, 1}, {1, 0}, {1, 1}])
    assert ReflexiveTransitiveClosure.dfs(
      ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 1}, {1, 2}, {2, 0}])) ==
      ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 0}, {0, 1}, {0, 2}, {1, 0}, {1, 1}, {1, 2}, {2, 0}, {2, 1}, {2, 2}])
    # 3───>2───>5───>0
    # │    ^
    # │    │
    # │  ┌─┴───>6<─┐
    # └─>1<─────┘  │
    #    └──>7─────┘
    input = [{1, 2}, {1, 6}, {1, 7}, {2, 5}, {3, 1}, {3, 2}, {5, 0}, {6, 1}, {7, 6}]
    output = ReflexiveTransitiveClosure.edge_list_to_adjacency_map([
      {0, 0},
      {1, 0}, {1, 1}, {1, 2}, {1, 5}, {1, 6}, {1, 7},
      {2, 0}, {2, 2}, {2, 5},
      {3, 0}, {3, 1}, {3, 2}, {3, 3}, {3, 5}, {3, 6}, {3, 7},
      {5, 0}, {5, 5},
      {6, 0}, {6, 1}, {6, 2}, {6, 5}, {6, 6}, {6, 7},
      {7, 0}, {7, 1}, {7, 2}, {7, 5}, {7, 6}, {7, 7}])
    assert ReflexiveTransitiveClosure.dfs(ReflexiveTransitiveClosure.edge_list_to_adjacency_map(input)) == output
    # Test in random order
    assert ReflexiveTransitiveClosure.dfs(ReflexiveTransitiveClosure.edge_list_to_adjacency_map(Enum.shuffle(input))) == output
  end


  test "generates reflexive transitive closure" do
    assert assert_lists_have_same_elements(ReflexiveTransitiveClosure.reflexive_transitive_closure(
      [{1, 2}, {1, 6}, {1, 7}, {2, 5}, {3, 1}, {3, 2}, {5, 0}, {6, 1}, {7, 6}]),
      [
        {0, 0},
        {1, 0}, {1, 1}, {1, 2}, {1, 5}, {1, 6}, {1, 7},
        {2, 0}, {2, 2}, {2, 5},
        {3, 0}, {3, 1}, {3, 2}, {3, 3}, {3, 5}, {3, 6}, {3, 7},
        {5, 0}, {5, 5},
        {6, 0}, {6, 1}, {6, 2}, {6, 5}, {6, 6}, {6, 7},
        {7, 0}, {7, 1}, {7, 2}, {7, 5}, {7, 6}, {7, 7}])
  end
end
