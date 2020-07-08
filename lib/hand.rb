require_relative 'card'
require_relative 'null_card'

class Hand
    attr_accessor :cards

    def initialize
        @cards = Array.new(5) { NullCard.instance }
    end

end