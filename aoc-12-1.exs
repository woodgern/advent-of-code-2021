defmodule AOC12 do
  def find_paths(rules, current, visited) do
    if current == "end" do
      1
    else
      new_visited =
        if !(String.upcase(current) == current) do
          MapSet.put(visited, current)
        else
          visited
        end

      Enum.reduce(rules[current] || [], 0, fn node, total ->
        if MapSet.member?(new_visited, node) do
          total
        else
          total + find_paths(rules, node, new_visited)
        end
      end)
    end
  end
end

stream = File.stream!("aoc-12.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

rules =
  Enum.reduce(input, %{}, fn line, map ->
    split = String.split(line, "-")

    remapped =
      if Map.has_key?(map, hd(split)) do
        Map.put(map, hd(split), tl(split) ++ map[hd(split)])
      else
        Map.put(map, hd(split), tl(split))
      end

    if Map.has_key?(remapped, hd(tl(split))) do
      Map.put(remapped, hd(tl(split)), [hd(split) | remapped[hd(tl(split))]])
    else
      Map.put(remapped, hd(tl(split)), [hd(split)])
    end
  end)

IO.puts(AOC12.find_paths(rules, "start", MapSet.new()))
