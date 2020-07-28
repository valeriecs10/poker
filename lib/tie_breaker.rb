class TieBreaker
    def self.break_tie(tied_players)
        tie_breaking_values = []
        tied_players.each do |player|
            tie_breaking_values << [tie_breaking_value(player), player]
        end
        tie_breaking_values.sort_by! { |set| set[0] }.reverse!
        
        true_ties = []
        tie_breaking_values.each { |set| true_ties << set if set[0] == tie_breaking_values[0][0] }
        return tie_breaking_values[0][1] if true_ties.length == 1

        true_ties.map { |set| set[1] }
    end

    def self.tie_breaking_value(player)
        hand = PokerHands.best_hand(player)
        case hand
        when :royal_flush
            15
        when :four_of_a_kind
            highest_of_set(player.hand, 4)
        when :three_of_a_kind
            highest_of_set(player.hand, 3)
        when :two_pair
            highest_of_two_pair(player.hand)
        when :one_pair
            highest_of_set(player.hand, 2)
        else
            highest_card(player.hand)
        end
    end

    def self.highest_card(hand)
        values = []
        hand.cards.each do |card|
            values << card.value
        end
        values.sort[-1]
    end

    def self.highest_of_set(hand, num)
        tally_cards(hand).each do |val, total|
            return val if total == num
        end
    end

    def self.highest_of_two_pair(hand)
        hand_dup = hand.dup
        tally_cards(hand).each do |val, total|
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