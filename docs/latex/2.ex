def dfs_from_vertex(adjacency_map, visited, source) do
  visited = visited |> MapSet.put(source)
  reachable = MapSet.difference(adjacency_map[source], visited)
  case Enum.fetch(reachable, 0) do
    {:ok, neighbor} ->
      visited = dfs_from_vertex(adjacency_map, visited, neighbor)
      dfs_from_vertex(adjacency_map, visited, source)
    :error ->
      visited
  end
end