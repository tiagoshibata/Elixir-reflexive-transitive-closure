def adjacency_map_to_edge_list(adjacency_map) do
  Enum.reduce(adjacency_map, [], fn({vertex, destinations}, acc) ->
    Enum.map(destinations, &({vertex, &1})) ++ acc
  end)
end

def reflexive_transitive_closure(edge_list) do
  adjacency_map_to_edge_list(dfs(edge_list_to_adjacency_map(edge_list)))
end