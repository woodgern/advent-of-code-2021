defmodule AOC2 do
  def enumerate_coordinates(directions, position) do
    if length(directions) == 0 do
      position
    else
      split = String.split(hd(directions), " ")
      direction = hd(split)
      scalar = elem(Integer.parse(hd(tl(split))), 0)

      case direction do
        "forward" ->
          enumerate_coordinates(tl(directions), [hd(position) + scalar, hd(tl(position))])

        "up" ->
          enumerate_coordinates(tl(directions), [hd(position), hd(tl(position)) - scalar])

        "down" ->
          enumerate_coordinates(tl(directions), [hd(position), hd(tl(position)) + scalar])
      end
    end
  end
end

stream = File.stream!("aoc-2.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

coords = AOC2.enumerate_coordinates(input, [0, 0])
IO.puts("(#{hd(coords)}, #{hd(tl(coords))})")
IO.puts(hd(coords) * hd(tl(coords)))
