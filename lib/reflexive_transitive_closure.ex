defmodule ReflexiveTransitiveClosure do
  def add_edge(graph, edge) do
    {source, destination} = edge
    Map.get_and_update(graph, source, fn(edges) ->
      {edges, edges && edges |> MapSet.put(destination) || MapSet.new([destination])}
    end) |> elem(1)
  end

  def merge_edges(graph1, graph2) do
    Map.merge(graph1, graph2, fn _source, destinations_1, destinations_2 ->
      MapSet.union(destinations_1, destinations_2)
    end)
  end

  def edge_list_to_adjacency_map(edge_list) do
    Enum.reduce(edge_list, %{}, fn(x, acc) -> add_edge(acc, x) end)
  end

  def dfs(adjacency_map, already_visited \\ MapSet.new, solution \\ %{}) do
    vertices = MapSet.new(Map.keys(adjacency_map))
    not_visited = MapSet.difference(vertices, already_visited)
    case not_visited |> Enum.fetch(0) do
      {:ok, source} ->
        solution = Map.put(solution, source, dfs_from_vertex(adjacency_map, MapSet.new, source))
        dfs(adjacency_map, already_visited |> MapSet.put(source), solution)
      :error ->
        solution
    end
  end

  def dfs_from_vertex(adjacency_map, visited, source) do
    visited = visited |> MapSet.put(source)
    reachable = MapSet.difference(adjacency_map[source] || [], visited)
    case reachable |> Enum.fetch(0) do
      {:ok, neighbor} ->
        visited = dfs_from_vertex(adjacency_map, visited, neighbor)
        dfs_from_vertex(adjacency_map, visited, source)
      :error ->
        visited
    end
  end
end
