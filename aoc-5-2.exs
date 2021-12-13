defmodule AOC5 do
  def calculate_area_dimensions(lines) do
    Enum.reduce(lines, {0, 0}, fn line, acc ->
      Enum.reduce(line, acc, fn coord, acc ->
        {Enum.max([elem(acc, 0), elem(coord, 0)]), Enum.max([elem(acc, 1), elem(coord, 1)])}
      end)
    end)
  end

  def is_horizontal(line) do
    elem(hd(line), 1) == elem(hd(tl(line)), 1)
  end

  def is_vertical(line) do
    elem(hd(line), 0) == elem(hd(tl(line)), 0)
  end

  def plot_line(area, line) do
    if !is_horizontal(line) and !is_vertical(line) do
      points_on_line =
        Enum.zip(
          elem(hd(line), 0)..elem(hd(tl(line)), 0),
          elem(hd(line), 1)..elem(hd(tl(line)), 1)
        )

      Enum.reduce(points_on_line, area, fn point, area ->
        x = elem(point, 0)
        y = elem(point, 1)
        cur_val = elem(elem(area, x), y)
        put_elem(area, x, put_elem(elem(area, x), y, cur_val + 1))
      end)
    else
      if is_horizontal(line) do
        y = elem(hd(line), 1)

        Enum.reduce(elem(hd(line), 0)..elem(hd(tl(line)), 0), area, fn x, area ->
          cur_val = elem(elem(area, x), y)
          put_elem(area, x, put_elem(elem(area, x), y, cur_val + 1))
        end)
      else
        x = elem(hd(line), 0)

        Enum.reduce(elem(hd(line), 1)..elem(hd(tl(line)), 1), area, fn y, area ->
          cur_val = elem(elem(area, x), y)
          put_elem(area, x, put_elem(elem(area, x), y, cur_val + 1))
        end)
      end
    end
  end

  def count_intersections(area) do
    Enum.reduce(Tuple.to_list(area), 0, fn column, acc ->
      Enum.reduce(Tuple.to_list(column), acc, fn space, acc ->
        if space > 1 do
          acc + 1
        else
          acc
        end
      end)
    end)
  end
end

stream = File.stream!("aoc-5.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

lines =
  Enum.map(input, fn x ->
    Enum.map(String.split(x, " -> "), fn y ->
      coords_str = String.split(y, ",")
      {elem(Integer.parse(hd(coords_str)), 0), elem(Integer.parse(hd(tl(coords_str))), 0)}
    end)
  end)

area_dimensions = AOC5.calculate_area_dimensions(lines)

area =
  Tuple.duplicate(Tuple.duplicate(0, elem(area_dimensions, 1) + 1), elem(area_dimensions, 0) + 1)

plotted_area =
  Enum.reduce(lines, area, fn line, area ->
    AOC5.plot_line(area, line)
  end)

IO.puts(AOC5.count_intersections(plotted_area))
