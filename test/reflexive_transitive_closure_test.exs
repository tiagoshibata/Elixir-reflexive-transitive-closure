defmodule ReflexiveTransitiveClosureTest do
  use ExUnit.Case
  doctest ReflexiveTransitiveClosure

  test "adds edges to adjacency map" do
    assert ReflexiveTransitiveClosure.add_edge(%{}, {1, 2}) == %{1 => MapSet.new([2])}
    assert ReflexiveTransitiveClosure.add_edge(%{2 => MapSet.new([3])}, {2, 3}) == %{2 => MapSet.new([3])}
    assert ReflexiveTransitiveClosure.add_edge(%{4 => MapSet.new([6])}, {4, 5}) == %{4 => MapSet.new([5, 6])}
  end

  test "merges adjacency maps" do
    assert ReflexiveTransitiveClosure.merge_edges(
      %{4 => MapSet.new([5, 6]), 5 => MapSet.new([6, 7])}, %{4 => MapSet.new([5, 8])}) ==
      %{4 => MapSet.new([5, 6, 8]), 5 => MapSet.new([6, 7])}
  end

  test "converts edge list to adjacency map" do
    assert ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 1}, {1, 2}, {1, 3}]) ==
        %{0 => MapSet.new([1]), 1 => MapSet.new([2, 3])}
  end

  test "does DFS" do
    assert ReflexiveTransitiveClosure.dfs(
      ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 1}, {1, 0}])) ==
      ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 0}, {0, 1}, {1, 0}, {1, 1}])
    assert ReflexiveTransitiveClosure.dfs(
      ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 1}, {1, 2}, {2, 0}])) ==
      ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 0}, {0, 1}, {0, 2}, {1, 0}, {1, 1}, {1, 2}, {2, 0}, {2, 1}, {2, 2}])
  end
end
