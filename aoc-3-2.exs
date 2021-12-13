defmodule AOC3 do
  def count_digits(bins) do
    Enum.reduce(
      bins,
      List.duplicate(0, String.length(hd(bins))),
      fn x, acc ->
        Enum.map(Enum.zip(String.graphemes(x), acc), fn y ->
          elem(Integer.parse(elem(y, 0)), 0) + elem(y, 1)
        end)
      end
    )
  end

  def oxygen_matcher(bins) do
    digit_count = count_digits(bins)
    Enum.map(digit_count, fn x -> if x >= length(bins) / 2, do: "1", else: "0" end)
  end

  def co_matcher(bins) do
    digit_count = count_digits(bins)
    Enum.map(digit_count, fn x -> if x >= length(bins) / 2, do: "0", else: "1" end)
  end

  def find_rating(digit, bins, matcher) do
    if length(bins) == 1 do
      hd(bins)
    else
      rating_matcher = matcher.(bins)

      find_rating(
        digit + 1,
        Enum.filter(
          bins,
          fn x ->
            Enum.at(rating_matcher, digit) == String.at(x, digit)
          end
        ),
        matcher
      )
    end
  end
end

stream = File.stream!("aoc-3.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

ox_rating = elem(Integer.parse(AOC3.find_rating(0, input, &AOC3.oxygen_matcher/1), 2), 0)
co_rating = elem(Integer.parse(AOC3.find_rating(0, input, &AOC3.co_matcher/1), 2), 0)

IO.puts(ox_rating * co_rating)
