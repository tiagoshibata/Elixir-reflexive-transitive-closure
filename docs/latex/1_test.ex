test "adds edges to adjacency map" do
  assert ReflexiveTransitiveClosure.add_edge(%{}, {1, 2}) == %{1 => MapSet.new([2]), 2 => MapSet.new}
  assert ReflexiveTransitiveClosure.add_edge(%{2 => MapSet.new([3])}, {2, 3}) == %{2 => MapSet.new([3]), 3 => MapSet.new}
  assert ReflexiveTransitiveClosure.add_edge(%{4 => MapSet.new([6])}, {4, 5}) == %{4 => MapSet.new([5, 6]), 5 => MapSet.new}
end

test "converts edge list to adjacency map" do
  assert ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 1}, {1, 2}, {2, 1}]) ==
      %{0 => MapSet.new([1]), 1 => MapSet.new([2]), 2 => MapSet.new([1])}
  assert ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 1}, {1, 2}, {1, 3}]) ==
      %{0 => MapSet.new([1]), 1 => MapSet.new([2, 3]), 2 => MapSet.new, 3 => MapSet.new}
end