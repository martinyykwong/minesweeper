require_relative "./board.rb"
require_relative "./player.rb"
# require 'colorize'

class MinesweeperGame

    attr_reader :board, :player

    def initialize(rows,cols,fraction_of_bombs, player_name)
        @board = Board.new(rows,cols,fraction_of_bombs)
        @player = Player.new(player_name)
    end

    def play
        #add code to request player's first move
        bomb_pos_arr = self.board.create_bomb_position_array
        self.board.generate_bomb_tile_instances_in_grid(bomb_pos_arr)
        until self.board.win? || self.board.lose?
            system("clear")
            self.board.render
            puts
            puts "Please choose row & column position, separated by comma (e.g. 2,1):"
            pos_input = player.get_input_position
            system("clear")
            self.board.render
            puts
            puts "Please input F for flag, or R for reveal at #{pos_input}:"
            action_input = player.get_action
            # system("clear")
            if action_input == "R"
                # if self.board.grid.flatten.none? {|tile| tile.revealed} && (self.board[pos_input].bomb || self.board[pos_input].neighbor_bomb_count > 0)
                #     self.board.grid.each_with_index do |row,m|
                #         row.each_with_index do |col,n|
                #             if !col.bomb
                #                 self.board[pos_input],self.board[[m,n]] = self.board[[m,n]],self.board[pos_input] #in first turn, swap bomb tile with a safe tile if neccessary. Fishy
                #                 break
                #             end
                #         end
                #     end
                if self.board[pos_input].bomb
                    self.board[pos_input].reveal
                    system("clear")
                    self.board.render_all_tiles_after_loss
                    puts
                    puts "You hit a bomb! You lost!"
                    return
                else
                    if self.board[pos_input].revealed
                        system("clear")
                        self.board.render
                        puts
                        puts "This position was already revealed. Please choose another"
                        sleep(2)
                    else
                        self.board[pos_input].explore_tile
                        system("clear")
                        self.board.render
                        puts
                        puts "You are safe!"
                        sleep(2)
                    end
                end
            elsif action_input == "F" #maybe should be else instead of elsif?
                if !self.board[pos_input].revealed
                    self.board[pos_input].flag
                    system("clear")
                    self.board.render
                    puts
                    puts "Flag successfully placed at #{pos_input}"
                    sleep(2)
                else
                    system("clear")
                    self.board.render
                    puts "You cannot place flag at #{pos_input} because it has already been revealed"
                end
            end
        end
        puts "Congratuations #{self.player.name}! You won!"
    end

end


if __FILE__ == $PROGRAM_NAME
    game1 = MinesweeperGame.new(10,10,0.2,"Martin")
    game1.play
    # board1 = Board.new(4,4,0.2)
    # y = board1.create_bomb_position_array
    # board1.generate_bomb_tile_instances_in_grid(y)
    # board1[[3,2]].explore_tile
    # board1.render
    # p board1.grid[3][3].neighbors_positions
end