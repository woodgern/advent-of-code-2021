defmodule AOC10 do
  def score_stack(stack, score_map) do
    Enum.reduce(stack, 0, fn brace, score ->
      5 * score + score_map[brace]
    end)
  end
end

stream = File.stream!("aoc-10.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

score_map = %{
  "(" => 1,
  "[" => 2,
  "{" => 3,
  "<" => 4
}

brace_map = %{
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">"
}

opening_chars = MapSet.new(["(", "[", "{", "<"])

scored_lines =
  Enum.map(input, fn line ->
    result =
      Enum.reduce(String.graphemes(line), [], fn c, stack ->
        if is_list(stack) do
          if MapSet.member?(opening_chars, c) do
            [c | stack]
          else
            top = hd(stack)

            if brace_map[top] != c do
              0
            else
              tl(stack)
            end
          end
        else
          stack
        end
      end)

    if is_list(result) do
      AOC10.score_stack(result, score_map)
    else
      -1
    end
  end)

scores =
  Enum.filter(scored_lines, fn x ->
    x != -1
  end)

IO.puts(Enum.at(Enum.sort(scores), trunc(length(scores) / 2)))
