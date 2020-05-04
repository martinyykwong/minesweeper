require_relative "./board.rb"

class Player

    attr_reader :name, :board
    def initialize(name, board_instance)
        @name = name
        @board = board_instance
    end

    def get_input_position
        input = gets.chomp.split(",").map(&:to_i)
    end

    def get_action
        input = gets.chomp.upcase
    end

end
