defmodule AOC7 do
  def calc_fuel_usage(crabs, point) do
    Enum.reduce(crabs, 0, fn crab, acc ->
      distance = abs(crab - point)
      acc + trunc(distance * (distance + 1) / 2)
    end)
  end
end

stream = File.stream!("aoc-7.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

crabs =
  Enum.sort(
    Enum.map(String.split(hd(input), ","), fn str ->
      elem(Integer.parse(str), 0)
    end)
  )

l = length(crabs)

median =
  if rem(l, 2) == 0 do
    trunc(
      (Enum.at(crabs, trunc(length(crabs) / 2) - 1) + Enum.at(crabs, trunc(length(crabs) / 2))) /
        2
    )
  else
    Enum.at(crabs, trunc(length(crabs) / 2))
  end

IO.puts(
  Enum.min(
    Enum.map(hd(crabs)..List.last(crabs), fn point ->
      AOC7.calc_fuel_usage(crabs, point)
    end)
  )
)
