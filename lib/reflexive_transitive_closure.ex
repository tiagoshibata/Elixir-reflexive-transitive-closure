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
end
