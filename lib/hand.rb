require_relative 'card'

class Hand
    attr_accessor :cards

    def initialize
        @cards = Array.new
    end

    def [](i)
        cards[i]
    end

    def []=(card)
        cards[i] = card
    end
end