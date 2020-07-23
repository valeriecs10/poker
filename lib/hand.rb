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

    def num_cards
        @cards.length
    end

    def to_s
        cards.each { |card| print card }
        puts
        cards.each_with_index { |card, i| print "   #{i + 1}    " }
        puts
    end
end