# Return true if the number of row i and column j of the given board matches the rules of Sudoku.
def valid?(i, j, board)
  for n in 0..8
    # Check that n is not in the same row
    if board[i][n] == board[i][j] && n != j
      return false
    end
    # Check that n is not in the same column
    if board[n][j] == board[i][j] && n != i
      return false
    end
  end
  # Check that n is not in the same block
  for k in ((i / 3) * 3)..((i / 3) * 3 + 2)
    for l in ((j / 3) * 3)..((j / 3) * 3 + 2)
      if board[k][l] == board[i][j] && !(k == i && l == j)
        return false
      end
    end
  end
  return true
end

#  Solve about row i and column j of the board.
def solve(i, j, board)
  if i == 9 && j == 0
    # Keep a record of the time of complete.
    endTime = Time.now
    # Output board
    for k in 0..8
      for l in 0..8
        print board[k][l].to_s + " "
      end
      puts
    end
    puts "Time: " + (endTime - $startTime).to_s
    exit
  else
    # There is blank cell
    if board[i][j] == 0
      # If row i column j is blank
      for n in $candidate_list[i][j]
        board[i][j] = n
        if (valid?(i, j, board))
          if j < 8
            solve(i, j + 1, board)
          else
            solve(i + 1, 0, board)
          end
        end
      end
      board[i][j] = 0
    else
      if j < 8
        solve(i, j + 1, board)
      else
        solve(i + 1, 0, board)
      end
    end
  end
end

def candidate_list(_board)
  candidate_list = []
  for i in 0..8
    candidate_list[i] = []
    for j in 0..8
      candidate_list[i][j] = []
      if (_board[i][j] == 0)
        for n in 1..9
          _board[i][j] = n
          if (valid?(i, j, _board))
            candidate_list[i][j].push(n)
          end
          _board[i][j] = 0
        end
      end
    end
  end
  return candidate_list
end

board = []
board2 = []
File.foreach(ARGV[0]) { |line|
  board << line.chomp.split(", ").map { |item| item.to_i }
  board2 << line.chomp.split(", ").map { |item| item.to_i }
}

puts ARGV[0].slice(0, 8)
for k in 0..8
  for l in 0..8
    print board[k][l].to_s + " "
  end
  puts
end
puts "---------------------"
$startTime = Time.new
$candidate_list = candidate_list(board2)
solve(0, 0, board)
