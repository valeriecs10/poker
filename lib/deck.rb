require_relative 'card'

class Deck
    SUITS = [
        :heart,
        :diamond,
        :club,
        :spade
    ]

    attr_reader :cards

    
    def initialize(shuffled = true)
        @cards = new_deck
        cards.shuffle! if shuffled
    end
    
    private
    
    def new_deck
        deck = []
        SUITS.each { |suit| deck += new_set(suit) }
        deck
    end

    def new_set(suit)
        set = []

        (1..13).each do |i|
            set << Card.new(i, suit)
        end

        set
    end
end