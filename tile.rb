require_relative "./board.rb"

class Tile

    attr_accessor :revealed
    attr_reader :bomb, :board, :board_position ,:adjacent_bomb_count, :flagged

    def initialize(content, board, board_position)
        @flagged = false
        @revealed = false
        if content == :bomb
            @bomb = true
        else
            @bomb = false
        end
        @board = board #board instance
        @board_position = board_position #[m,n] format
        
        @adjacent_bomb_count = nil
    end

    def reveal
        self.revealed = true
    end

    def flag
        if !self.flagged
            @flagged = true
        else
            @flagged = false
        end
    end

    def neighbors_positions #return an array of all neighbor positions
        m,n = self.board_position
        neighbor_positions_arr = []
        (m-1..m+1).each do |row_pos|
            (n-1..n+1).each do |col_pos|
                if [row_pos,col_pos] != self.board_position && row_pos >= 0 && col_pos >= 0 && row_pos < self.board.grid.length && col_pos < self.board.grid[0].length
                    neighbor_positions_arr << [row_pos,col_pos]
                end
            end
        end
        neighbor_positions_arr #[[0,1],[1,0],[1,1]] format
    end

    def neighbor_bomb_count #return an integer number to denote # of adjacent bombs
        bomb_counts = 0
        self.neighbors_positions.each do |row,col|
            if self.board.grid[row][col].bomb
                bomb_counts+=1
            end
        end
        bomb_counts
    end

    def explore_tile #self is tile instance   
        if self.revealed || self.flagged #if tile has been revealed before, no need to explore it again
            return self
        elsif self.neighbor_bomb_count > 0 && !self.bomb
            @adjacent_bomb_count = self.neighbor_bomb_count
            return self.revealed = true
        elsif !self.revealed && !self.bomb
            @adjacent_bomb_count = self.neighbor_bomb_count
            self.revealed = true
        end

        self.neighbors_positions.each do |pos_arr|
            if  !self.board[pos_arr].bomb && !self.board[pos_arr].revealed && !self.board[pos_arr].flagged #"if tile is not a bomb, if tile has not been revealed, and if tile is not flagged"
                self.board[pos_arr].revealed = true
                if self.board[pos_arr].neighbor_bomb_count > 0
                    next
                else
                    neighboar_arr_of_pos_arr_tile = self.board[pos_arr].neighbors_positions #gives an array of neighbor positions to pos_arr tile
                    neighboar_arr_of_pos_arr_tile.each do |neighbor_pos_arr|
                        self.board[neighbor_pos_arr].explore_tile
                    end
                end
            end
        end
    end

end