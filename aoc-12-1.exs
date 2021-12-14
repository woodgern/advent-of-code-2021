defmodule AOC12 do
  def find_paths(_rules, "end", _visited), do: 1
  def find_paths(rules, current, old_visited) do
    new_visited =
      if !(String.upcase(current) == current) do
        MapSet.put(old_visited, current)
      else
        old_visited
      end

    rules
    |> Map.get(current)
    |> Enum.reduce(0, fn node, total ->
      if MapSet.member?(old_visited, node) do
        total
      else
        total + find_paths(rules, node, new_visited)
      end
    end)
  end
end

input =
  File.stream!("aoc-12.txt")
  |> Stream.map(&String.trim/1)
  |> Enum.map(fn x-> x end)
  |> Enum.into([])

rules =
  input
  |> Enum.map(fn line -> String.split(line, "-") end)
  |> Enum.reduce(%{}, fn line, map ->
    [head, tail] = line

    map
    |> Map.update(head, [tail], fn existing_head -> [tail | existing_head] end)
    |> Map.update(tail, [head], fn existing_tail -> [head | existing_tail] end)
    # |> IO.inspect()
  end)

result = AOC12.find_paths(rules, "start", MapSet.new())

IO.puts(result)
