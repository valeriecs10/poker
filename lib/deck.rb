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
        shuffle if shuffled
    end
    
    def num_cards
        cards.length
    end

    def shuffle
        cards.shuffle!
    end

    def return_to_deck(card)
        cards.unshift(card)
    end

    def deal_card(player)
        player.hand.cards << @cards.pop
    end

    private
    
    def new_deck
        deck = []
        SUITS.each { |suit| deck += new_set(suit) }
        deck
    end

    def new_set(suit)
        set = []

        (2..14).each do |i|
            set << Card.new(i, suit)
        end

        set
    end
end