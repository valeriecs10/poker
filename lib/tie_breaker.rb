class TieBreaker
    def self.break_tie(tied_players)
        tie_breaking_values = []
        tied_players.each do |player|
            tie_breaking_values << [tie_breaking_value(player), player]
        end
        tie_breaking_values.sort!
        # IF TIE BREAKING VALUE TIES TOO, SPLIT THE POT
    end

    def self.tie_breaking_value(player)
        case PokerHands.best_hand(player.hand)
        when :royal_flush
            # NO BREAKER, SPLIT THE POT
        when :straight_flush || :full_house || 
                :flush || :straight || :high_card
            high_card(player.hand)
        when :four_of_a_kind
            highest_of_set(player.hand, 4)
        when :three_of_a_kind
            highest_of_set(player.hand, 3)
        when :two_pair
            highest_of_two_pair(player.hand)
        when :one_pair
            highest_of_set(player.hand, 2)
        end
    end

    def high_card(hand)
        values = []
        hand.each do |card|
            values << card.value
        end
        values.sort[0]
    end

    def self.highest_of_set(hand, num)
        value_tallies(hand).each do |val, total|
            return val if total == num
        end
    end

    def self.highest_of_two_pair(hand)
        hand_dup = hand.dup
        value_tallies(hand).each do |val, total|
            if total == 1
                hand_dup.cards.each do |card|
                    hand_dup.delete(card) if card.value == val
                end
            end
        end
        high_card(hand_dup)
    end

    def self.tally_cards(hand)
        value_tallies = Hash.new(0)
        hand.cards.each do |card|
            value_tallies[card.value] += 1
        end
        value_tallies
    end
end