defmodule AOC4 do
  def mark_boards(boards, draw) do
    Enum.map(boards, fn board -> mark_board(board, draw) end)
  end

  def mark_board(board, draw) do
    Enum.map(board, fn row ->
      Enum.map(row, fn el ->
        if elem(el, 0) == draw do
          {draw, true}
        else
          el
        end
      end)
    end)
  end

  def is_winning_board(board) do
    has_winning_row =
      Enum.reduce(board, false, fn row, acc ->
        is_winner =
          Enum.reduce(row, true, fn el, acc ->
            acc and elem(el, 1)
          end)

        is_winner or acc
      end)

    col_length = length(hd(board))

    has_winning_col =
      Enum.reduce(Enum.to_list(0..(col_length - 1)), false, fn col_num, acc ->
        Enum.reduce(board, true, fn row, acc ->
          acc and elem(Enum.at(row, col_num), 1)
        end) or acc
      end)

    has_winning_col or has_winning_row
  end

  def find_winning_board(boards) do
    winner = Enum.filter(boards, fn board -> is_winning_board(board) end)

    if length(winner) != 0 do
      hd(winner)
    else
      nil
    end
  end

  def score(board, draw) do
    draw_int = elem(Integer.parse(draw), 0)

    Enum.reduce(board, 0, fn row, acc ->
      Enum.reduce(row, acc, fn el, t ->
        if !elem(el, 1) do
          t + elem(Integer.parse(elem(el, 0)), 0)
        else
          t
        end
      end)
    end) * draw_int
  end
end

stream = File.stream!("aoc-4.txt")

input =
  Enum.map(
    Enum.into(stream, []),
    fn x -> String.replace(x, "\n", "") end
  )

draws = String.split(hd(input), ",")

boards_input =
  Enum.filter(
    Enum.chunk_by(Enum.slice(input, 2..-1), fn x -> String.length(x) == 0 end),
    fn x -> String.length(hd(x)) != 0 end
  )

boards =
  Enum.map(
    boards_input,
    fn x ->
      b =
        Enum.map(x, fn y ->
          Enum.filter(String.split(y, " "), fn z -> String.length(z) != 0 end)
        end)

      Enum.map(b, fn y ->
        Enum.map(y, fn z -> {z, false} end)
      end)
    end
  )

IO.puts(
  Enum.reduce(draws, boards, fn draw, acc ->
    if is_list(acc) do
      marked_boards = AOC4.mark_boards(acc, draw)
      winning_board = AOC4.find_winning_board(marked_boards)

      if winning_board do
        AOC4.score(winning_board, draw)
      else
        marked_boards
      end
    else
      acc
    end
  end)
)
