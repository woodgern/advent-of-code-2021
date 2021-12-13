defmodule AOC8 do
  def sort_string(str) do
    Enum.join(Enum.sort(String.graphemes(str)))
  end

  def contains_all?(str, l) do
    Enum.reduce(l, true, fn x, acc ->
      acc and String.contains?(str, x)
    end)
  end

  def decode_inputs(inputs) do
    decode_map_1_4_7_8 =
      Enum.reduce(inputs, %{}, fn input, map ->
        case String.length(input) do
          2 ->
            Map.put(map, "1", sort_string(input))

          3 ->
            Map.put(map, "7", sort_string(input))

          4 ->
            Map.put(map, "4", sort_string(input))

          7 ->
            Map.put(map, "8", sort_string(input))

          _ ->
            map
        end
      end)

    decode_map_0_1_4_6_7_8_9 =
      Enum.reduce(inputs, decode_map_1_4_7_8, fn input, map ->
        cond do
          String.length(input) == 6 and
              (!String.contains?(input, String.at(map["1"], 0)) or
                 !String.contains?(input, String.at(map["1"], 1))) ->
            Map.put(map, "6", sort_string(input))

          String.length(input) == 6 and contains_all?(input, String.graphemes(map["4"])) ->
            Map.put(map, "9", sort_string(input))

          String.length(input) == 6 ->
            Map.put(map, "0", sort_string(input))

          true ->
            map
        end
      end)

    decode_map_0_1_2_3_4_5_6_7_8_9 =
      Enum.reduce(inputs, decode_map_0_1_4_6_7_8_9, fn input, map ->
        cond do
          String.length(input) == 5 and contains_all?(map["6"], String.graphemes(input)) ->
            Map.put(map, "5", sort_string(input))

          String.length(input) == 5 and contains_all?(map["9"], String.graphemes(input)) ->
            Map.put(map, "3", sort_string(input))

          String.length(input) == 5 ->
            Map.put(map, "2", sort_string(input))

          true ->
            map
        end
      end)

    Map.new(decode_map_0_1_2_3_4_5_6_7_8_9, fn {key, val} -> {val, key} end)
  end
end

stream = File.stream!("aoc-8.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

displays =
  Enum.map(input, fn str ->
    Enum.map(String.split(str, " | "), fn x ->
      String.split(x, " ")
    end)
  end)

IO.puts(
  Enum.reduce(displays, 0, fn display, acc ->
    decode_map = AOC8.decode_inputs(hd(display))

    decoded_output =
      Enum.reduce(hd(tl(display)), "", fn output, acc ->
        Enum.join([acc, decode_map[AOC8.sort_string(output)]])
      end)

    acc + elem(Integer.parse(decoded_output), 0)
  end)
)
