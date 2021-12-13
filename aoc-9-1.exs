defmodule AOC9 do
  def local_min?(floor, x, y, width, height) do
    (y == 0 or floor[y][x] < floor[y - 1][x]) and
      (y == height or floor[y][x] < floor[y + 1][x]) and
      (x == 0 or floor[y][x] < floor[y][x - 1]) and
      (x == width or floor[y][x] < floor[y][x + 1])
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

IO.puts(
  Enum.reduce(0..(width - 1), 0, fn x, acc ->
    Enum.reduce(0..(height - 1), acc, fn y, acc ->
      if AOC9.local_min?(floor, x, y, width, height) do
        acc + floor[y][x] + 1
      else
        acc
      end
    end)
  end)
)
