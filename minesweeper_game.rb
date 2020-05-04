require_relative "./board.rb"
require_relative "./player.rb"
require_relative "./tile.rb"

class MinesweeperGame

    attr_reader :board, :player

    def initialize(rows,cols,fraction_of_bombs, player_name)
        @board = Board.new(rows,cols,fraction_of_bombs)
        @player = Player.new(player_name, @board)
    end

    def play
        until self.board.grid.flatten.all? {|tile| tile.is_a?(Tile)}
            system("clear")
            self.board.render
            puts
            puts "Welcome to Martin's Minesweeper! For your fist turn, please choose a row & column position, separated by comma (e.g. 2,1):"
            begin
            first_turn_pos_input = player.get_input_position
            self.board[first_turn_pos_input] = Tile.new(:safe, self.board, first_turn_pos_input)
            bomb_pos_arr = self.board.create_bomb_position_array(first_turn_pos_input)
            self.board.generate_bomb_tile_instances_in_grid(bomb_pos_arr)
            self.board[first_turn_pos_input].explore_tile
            rescue
                system("clear")
                self.board.render
                puts
                puts "Invalid position. Please try again to initialize your game"
                sleep(3)
            end
        end

        until self.board.win?
            begin
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
            if action_input == "R"
                if self.board[pos_input].flagged
                    system("clear")
                    self.board.render
                    puts
                    puts "You cannot reveal a flagged location. Please unflag first"
                elsif self.board[pos_input].bomb
                    self.board[pos_input].reveal
                    system("clear")
                    self.board.render_all_tiles_after_loss
                    puts
                    puts "You hit a bomb at #{pos_input}! You lost!"
                    return
                else
                    if self.board[pos_input].revealed
                        system("clear")
                        self.board.render
                        puts
                        puts "This position was already revealed. Please choose another position"
                    else
                        self.board[pos_input].explore_tile
                        system("clear")
                        self.board.render
                        puts
                        puts "You are safe!"              
                    end
                end
            elsif action_input == "F"
                if !self.board[pos_input].revealed
                    self.board[pos_input].flag
                    system("clear")
                    self.board.render
                    puts
                    puts "Flag successfully toggled at #{pos_input}"
                else
                    system("clear")
                    self.board.render
                    puts
                    puts "You cannot place flag at #{pos_input} because it has already been revealed"                 
                end
            else
                system("clear")
                self.board.render
                puts
                puts "Invalid action command. No action was performed."
            end
            rescue
                system("clear")
                self.board.render
                puts
                puts "Invalid position. Please try again"
            end
            sleep(3)
        end
        puts "Congratuations #{self.player.name}! You won!"
    end

end


if __FILE__ == $PROGRAM_NAME
    game1 = MinesweeperGame.new(10,10,0.15,"Martin")
    game1.play
end