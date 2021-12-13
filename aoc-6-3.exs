defmodule AOC6 do
  def age_fish(fish) do
    num_babies =
      Enum.reduce(fish, 0, fn f, acc ->
        if elem(f, 0) == 0 do
          acc + elem(f, 1)
        else
          acc
        end
      end)

    [
      {8, num_babies}
      | Enum.map(fish, fn f ->
          if elem(f, 0) == 0 do
            {6, elem(f, 1)}
          else
            {elem(f, 0) - 1, elem(f, 1)}
          end
        end)
    ]
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
    {elem(Integer.parse(str), 0), 1}
  end)

final_school =
  Enum.reduce(1..256, [{0, 1}], fn day, fish ->
    power = :math.pow(2, trunc((day + 5) / 7))
    fishy = Enum.reduce(fish, 0, fn f, acc -> acc + elem(f, 1) end)

    if rem(day, 20) == 0 do
      IO.puts("(#{day}, #{fishy})")
    end

    AOC6.age_fish(fish)
  end)
