require_relative 'hand'

class Player
    attr_reader :hand
    attr_accessor :pot

    def initialize(pot)
        @hand = Hand.new
        @pot = pot
    end

    def cards_to_discard
        discards = []

        begin
            user_input = get_user_cards
        rescue ArgumentError => e
            puts e
            puts "Must enter valid card numbers separated by spaces"
            retry
        end

        return nil if user_input.nil?
        card_indexes = user_input.map { |i| i -= 1 }
        card_indexes.sort.reverse.each do |i|
            discards << hand.cards.delete(hand.cards[i])
        end
        discards
    end

    def fold_see_raise
        begin
            user_bet = get_user_bet
        rescue ArgumentError => e
            puts e
            puts "Must enter 'fold', 'see', or 'raise'"
            retry
        end
        case user_bet
        when :fold
            false
        when :see
            true
        when :raise
            begin 
                raise_amount = get_user_raise
            rescue ArgumentError => e
                puts e
                puts "Must be a positive integer"
                retry
            end
            raise_amount
        end
    end

    def num_cards
        hand.cards.length
    end

    private

    def get_user_cards
        print hand
        puts "Enter the numbers of the cards you'd like to exchange, or 'none'."
        cards = gets.chomp
        return nil if cards == 'none'
        cards = cards.split.uniq.map { |n| n.to_i }
        raise ArgumentError.new "You can only exchange up to 3 cards" if cards.length > 3
        raise ArgumentError.new "Invalid card number entered" if cards.any? { |n| n < 1 || n > 5 }
        cards
    end

    def get_user_bet
        print hand
        puts "Would you like to fold, see or raise?"
        user_bet = gets.chomp.downcase.to_sym
        raise ArgumentError.new 'Not a valid choice' unless 
            user_bet == :fold || user_bet == :see || user_bet == :raise
        user_bet
    end

    def get_user_raise
        print hand
        puts "How much would you like to raise?"
        user_raise = gets.chomp.to_i
        raise ArgumentError.new 'Not a valid raise amount' unless 
            user_raise.is_a?(Integer) && user_raise > 0
        user_raise
    end
end