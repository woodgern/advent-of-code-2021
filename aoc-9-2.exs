defmodule AOC9 do
  def basin(floor, x, y, width, height, basin_set) do
    if MapSet.member?(basin_set, {x, y}) or x < 0 or y < 0 or y == height or x == width or
         floor[y][x] == 9 do
      basin_set
    else
      b = MapSet.put(basin_set, {x, y})
      left_basin = basin(floor, x - 1, y, width, height, b)
      right_basin = basin(floor, x + 1, y, width, height, left_basin)
      up_basin = basin(floor, x, y - 1, width, height, right_basin)
      basin(floor, x, y + 1, width, height, up_basin)
    end
  end
end

stream = File.stream!("aoc-9.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

height = length(input)
width = String.length(hd(input))

floor =
  elem(
    Enum.reduce(input, {0, %{}}, fn line, acc ->
      inner_map =
        elem(
          Enum.reduce(String.graphemes(line), {0, %{}}, fn x, acc ->
            {elem(acc, 0) + 1, Map.put(elem(acc, 1), elem(acc, 0), elem(Integer.parse(x), 0))}
          end),
          1
        )

      {elem(acc, 0) + 1, Map.put(elem(acc, 1), elem(acc, 0), inner_map)}
    end),
    1
  )

basin_sizes =
  elem(
    Enum.reduce(0..(width - 1), {[], MapSet.new()}, fn x, acc ->
      Enum.reduce(0..(height - 1), acc, fn y, acc ->
        if !MapSet.member?(elem(acc, 1), {x, y}) do
          basin = AOC9.basin(floor, x, y, height, width, MapSet.new())
          {[MapSet.size(basin) | elem(acc, 0)], MapSet.union(basin, elem(acc, 1))}
        else
          acc
        end
      end)
    end),
    0
  )

IO.puts(
  Enum.reduce(Enum.slice(Enum.sort(basin_sizes), -3..-1), 1, fn basin, product ->
    basin * product
  end)
)
