defmodule AOC6 do
  def age_fish(fish) do
    num_babies = Enum.count(fish, fn f -> f == 0 end)

    Enum.map(fish, fn f ->
      if f == 0 do
        6
      else
        f - 1
      end
    end) ++ List.duplicate(8, num_babies)
  end
end

stream = File.stream!("aoc-6.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

fish =
  Enum.map(String.split(hd(input), ","), fn str ->
    elem(Integer.parse(str), 0)
  end)

IO.puts(
  length(
    Enum.reduce(1..80, fish, fn day, fish ->
      AOC6.age_fish(fish)
    end)
  )
)
