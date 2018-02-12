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