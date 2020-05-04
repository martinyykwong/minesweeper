require_relative './tile.rb'
require_relative "./minesweeper_game.rb"
require 'colorize'

class Board

    attr_reader :grid
    
    def initialize(rows, cols, fraction_of_bombs) #fraction in decimal,i.e. 0.2
        @grid = Array.new(rows) {|row| Array.new(cols)}
        @fraction_of_bombs = fraction_of_bombs
    end

    def [](position_array) #references to tile instance at specified position
        self.grid[position_array[0]][position_array[1]]
    end

    # def []=(grid_pos_array, value)
    #     # row, col = *grid_pos_array
    #     row = grid_pos_array[0]
    #     col = grid_pos_array[1]
    #     self.grid[row][col] = value
    # end

    def create_bomb_position_array
        rows = self.grid.length
        cols = self.grid[0].length

        bomb_positions_array = []
        until bomb_positions_array.length >= rows*cols * @fraction_of_bombs
            row_pos = rand(0...rows)
            col_pos = rand(0...cols)
            if !bomb_positions_array.include?([row_pos,col_pos])
                bomb_positions_array << [row_pos,col_pos]
            end
        end
        bomb_positions_array
    end

    def generate_bomb_tile_instances_in_grid(bomb_pos_array) #also passes board instance and board position info to each tile
        self.grid.each_with_index do |row, m|
            row.each_with_index do |col,n|
                if bomb_pos_array.include?([m,n])
                    self.grid[m][n] = Tile.new(:bomb, self, [m,n])
                else
                    self.grid[m][n] = Tile.new(:safe, self, [m,n])
                end
            end
        end
    end

    def reveal_all_tiles #for debugging to see positions of all bombs
        self.grid.map do |row|
            row.map do |col|
                if col.bomb
                    "*"
                # elsif col.flagged
                #     "F"
                else
                    "#{col.neighbor_bomb_count}"
                end
            end
        end
    end

    def all_revealed_tiles
        self.grid.map do |row|
            row.map do |col|
                if col.revealed && col.bomb #each col is a tile instance
                    "*"
                elsif col.revealed && !col.bomb
                    "#{col.neighbor_bomb_count}"
                elsif col.flagged
                    "F"
                else
                    " "
                end
            end
        end    
    end

    def render
        puts "  #{(0...self.grid[0].length).to_a.join(" ")}".yellow
        self.all_revealed_tiles.each_with_index do |row, m|
            puts "#{String(m).yellow+" "+row.join(" ")}"
        end
    end

    def render_all_tiles_after_loss
        puts "  #{(0...self.grid[0].length).to_a.join(" ")}".yellow
        self.reveal_all_tiles.each_with_index do |row, m|
            puts "#{String(m).yellow+" "+row.join(" ")}"
        end
    end

    def win?
        self.grid.flatten.all? {|tile| (tile.revealed && !tile.bomb) || (!tile.revealed && tile.bomb) }
    end

    def lose? #might not need this method if just use Board#win? as break loop condition
        #alternatively,
        # self.grid.flatten.any? {|tile| tile.bomb && tile.revealed}
        self.grid.each do |row|
            row.each do |col|
                if col.bomb && col.revealed
                    return true
                end
            end
        end
        false
    end

end

# if __FILE__ == $PROGRAM_NAME
#     board1 = Board.new(4,4,0.2)
#     y = board1.create_bomb_position_array
#     board1.generate_bomb_tile_instances_in_grid(y)
#     board1[[3,2]].explore_tile
#     board1.render
#     p board1.grid[3][3].neighbors_positions
# end