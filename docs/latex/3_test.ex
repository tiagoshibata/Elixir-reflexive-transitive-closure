test "does DFS" do
  assert ReflexiveTransitiveClosure.dfs(
    ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 1}, {1, 0}])) ==
    ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 0}, {0, 1}, {1, 0}, {1, 1}])
  assert ReflexiveTransitiveClosure.dfs(
    ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 1}, {1, 2}, {2, 0}])) ==
    ReflexiveTransitiveClosure.edge_list_to_adjacency_map([{0, 0}, {0, 1}, {0, 2}, {1, 0}, {1, 1}, {1, 2}, {2, 0}, {2, 1}, {2, 2}])
  # 3--->2--->5--->0
  # |    ^
  # |    |
  # |  /----->6<-\
  # \->1<-----/  |
  #    \-->7-----/
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