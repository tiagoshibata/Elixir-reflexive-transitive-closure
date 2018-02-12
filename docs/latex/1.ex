def add_edge(graph, edge) do
  {source, destination} = edge
  Map.get_and_update(graph, source, fn(edges) ->
    {edges, edges && MapSet.put(edges, destination) || MapSet.new([destination])}
  end) |> elem(1) |> Map.put_new(destination, MapSet.new)
end

def edge_list_to_adjacency_map(edge_list) do
  Enum.reduce(edge_list, %{}, &(add_edge(&2, &1)))
end