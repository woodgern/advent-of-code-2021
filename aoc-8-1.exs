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
    outputs = hd(tl(display))

    Enum.reduce(outputs, acc, fn output, acc ->
      if String.length(output) == 2 or String.length(output) == 3 or String.length(output) == 4 or
           String.length(output) == 7 do
        acc + 1
      else
        acc
      end
    end)
  end)
)
