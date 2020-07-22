require_relative 'hand'

class Player
    attr_reader :hand
    attr_accessor :pot

    def initialize(pot)
        @hand = Hand.new
        @pot = pot
    end

    def cards_to_discard
        user_input = get_user_cards
        return 0 if user_input[0] == 0
        card_indexes = user_input.map { |i| i -= 1 }
        card_indexes.sort!.reverse!
        card_indexes.each do |i|
            hand.cards.delete_at(i)
        end
        card_indexes.length
    end

    def fold_see_raise
        user_bet = get_user_bet
        case user_bet
        when :fold
            false
        when :see
            true
        when :raise
            get_user_raise
        end
    end

    def num_cards
        hand.cards.length
    end

    private

    def get_user_cards
        puts "Enter the numbers of the cards you'd like to exchange, or 0 for none."
        gets.chomp.split.map { |n| n.to_i }
    end

    def get_user_bet
        puts "Would you like to fold, see or raise?"
        gets.chomp.downcase.to_sym
    end

    def get_user_raise
        puts "How much would you like to raise?"
        gets.chomp.to_i
    end
end