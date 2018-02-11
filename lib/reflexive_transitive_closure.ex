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

  def visit(adjacency_map, already_visited, edge) do
    adjacency_map = add_edge(adjacency_map, {edge, edge})  # reflexive
    already_visited = already_visited |> MapSet.put(edge)
    {adjacency_map, already_visited}
  end

  def dfs(adjacency_map, already_visited \\ MapSet.new) do
    vertices = MapSet.new(Map.keys(adjacency_map))
    not_visited = MapSet.difference(vertices, already_visited)
    case not_visited |> Enum.fetch(0) do
      {:ok, source} ->
        {adjacency_map, _} = dfs(adjacency_map, MapSet.new, source)
        dfs(adjacency_map, already_visited |> MapSet.put(source))
      :error ->
        adjacency_map
    end
  end

  def dfs(adjacency_map, already_visited, source) do
    {adjacency_map, already_visited} = visit(adjacency_map, already_visited, source)
    reachable = MapSet.difference(adjacency_map[source] || [], already_visited)
    case reachable |> Enum.fetch(0) do
      {:ok, neighbor} ->
        {adjacency_map, already_visited} = dfs(adjacency_map, already_visited, neighbor)
        adjacency_map = merge_edges(adjacency_map, %{source => adjacency_map[neighbor] || MapSet.new})
        dfs(adjacency_map, already_visited, source)
      :error ->
        {adjacency_map, already_visited}
    end
  end
end
