def dfs(adjacency_map, already_visited \\ MapSet.new, solution \\ %{}) do
  vertices = MapSet.new(Map.keys(adjacency_map))
  not_visited = MapSet.difference(vertices, already_visited)
  case Enum.fetch(not_visited, 0) do
    {:ok, source} ->
      solution = Map.put(solution, source, dfs_from_vertex(adjacency_map, MapSet.new, source))
      dfs(adjacency_map, MapSet.put(already_visited, source), solution)
    :error ->
      solution
  end
end