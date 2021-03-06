class Card
    attr_reader :value, :suit

    def initialize(value, suit)
        @value = value
        @suit = suit
    end

    def to_s
        "| #{printed_val} #{printed_suit} | "
    end

    private

    def printed_val
        case value
        when 2..10
            value.to_s
        when 11
            'J'
        when 12
            'Q'
        when 13
            'K'
        when 14
            'A'
        end
    end

    def printed_suit
        case suit
        when :heart
            '♥'
        when :spade
            '♠'
        when :diamond
            '♦'
        when :club
            '♣'
        end
    end
end