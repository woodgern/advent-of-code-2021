stream = File.stream!("aoc-10.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

score_map = %{
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}

brace_map = %{
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">"
}

opening_chars = MapSet.new(["(", "[", "{", "<"])

IO.puts(
  Enum.reduce(input, 0, fn line, score ->
    result =
      Enum.reduce(String.graphemes(line), [], fn c, stack ->
        if is_list(stack) do
          if MapSet.member?(opening_chars, c) do
            [c | stack]
          else
            top = hd(stack)

            if brace_map[top] != c do
              score_map[c]
            else
              tl(stack)
            end
          end
        else
          stack
        end
      end)

    if is_list(result) do
      score
    else
      score + result
    end
  end)
)
