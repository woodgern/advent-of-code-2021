defmodule AOC11 do
  def count_neighbours_flashed(x, y, flashed) do
    Enum.reduce(MapSet.to_list(flashed), 0, fn {x2, y2}, acc ->
      if !(x == x2 and y == y2) and abs(x - x2) <= 1 and abs(y - y2) <= 1 do
        acc + 1
      else
        acc
      end
    end)
  end

  def flash(octopusses, flashed_this_step) do
    {flashed_octopusses, flashed} =
      Enum.reduce(0..9, {octopusses, MapSet.new()}, fn y, o ->
        row = elem(o, 0)[y]

        {octos, total} =
          Enum.reduce(0..9, {row, elem(o, 1)}, fn x, o ->
            if elem(o, 0)[x] > 9 and !MapSet.member?(flashed_this_step, {x, y}) do
              {Map.put(elem(o, 0), x, 0), MapSet.put(elem(o, 1), {x, y})}
            else
              o
            end
          end)

        {Map.put(elem(o, 0), y, octos), total}
      end)

    if MapSet.size(flashed) == 0 do
      {flashed_octopusses, MapSet.size(flashed) + MapSet.size(flashed_this_step)}
    else
      flash(
        Enum.reduce(0..9, flashed_octopusses, fn y, o ->
          row = o[y]

          Map.put(
            o,
            y,
            Enum.reduce(0..9, row, fn x, o ->
              if !MapSet.member?(flashed_this_step, {x, y}) and !MapSet.member?(flashed, {x, y}) do
                num_neighbours_flashed = count_neighbours_flashed(x, y, flashed)
                Map.put(o, x, o[x] + num_neighbours_flashed)
              else
                o
              end
            end)
          )
        end),
        MapSet.union(flashed_this_step, flashed)
      )
    end
  end

  def engergize(octopusses) do
    daily_dosed =
      Enum.reduce(0..9, octopusses, fn y, o ->
        row = o[y]

        Map.put(
          o,
          y,
          Enum.reduce(0..9, row, fn x, o ->
            Map.put(o, x, o[x] + 1)
          end)
        )
      end)

    flash(daily_dosed, MapSet.new())
  end
end

stream = File.stream!("aoc-11.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

octopusses =
  Enum.reduce(Enum.zip(input, 0..(length(input) - 1)), %{}, fn t, map ->
    line = elem(t, 0)
    index = elem(t, 1)

    inner_map =
      Enum.reduce(Enum.zip(String.graphemes(line), 0..(String.length(line) - 1)), %{}, fn c,
                                                                                          map ->
        Map.put(map, elem(c, 1), elem(Integer.parse(elem(c, 0)), 0))
      end)

    Map.put(map, index, inner_map)
  end)

IO.puts(
  elem(
    Enum.reduce(1..100, {octopusses, 0}, fn _, acc ->
      {octopusses, flashes} = AOC11.engergize(elem(acc, 0))
      {octopusses, flashes + elem(acc, 1)}
    end),
    1
  )
)
