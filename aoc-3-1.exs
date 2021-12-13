stream = File.stream!("aoc-3.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

digit_map =
  Enum.reduce(
    input,
    List.duplicate(0, String.length(hd(input))),
    fn x, acc ->
      Enum.map(Enum.zip(String.graphemes(x), acc), fn y ->
        elem(Integer.parse(elem(y, 0)), 0) + elem(y, 1)
      end)
    end
  )

gamma_rate =
  elem(
    Integer.parse(
      Enum.join(
        Enum.map(digit_map, fn x -> if x > length(input) / 2, do: "1", else: "0" end),
        ""
      ),
      2
    ),
    0
  )

epsilon_rate =
  elem(
    Integer.parse(
      Enum.join(
        Enum.map(digit_map, fn x -> if x > length(input) / 2, do: "0", else: "1" end),
        ""
      ),
      2
    ),
    0
  )

IO.inspect(gamma_rate * epsilon_rate)
