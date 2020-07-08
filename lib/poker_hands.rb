class PokerHands
    HAND_RANKINGS = {
        royal_flush: 10
        straight_flush: 9
        four_of_a_kind: 8
        full_house: 7
        flush: 6
        straight: 5
        three_of_a_kind: 4
        two_pair: 3
        one_pair: 2
        high_card: 1
    }

    def self.winner(players)
        player_best_hands = []

        # build array of players and their highest rank
        players.each |player| do {
            player_hands << [HAND_RANKINGS[player.best_hand], player]
        }

        # return player with top ranking hand, unless there is a tie
        return player_hands[0][1] unless player_hands[0][0] == player_hands[1][0]

        TieBreaker.break_tie(players)
    end

    private

    def best_hand(hand)
        return :royal_flush if royal_flush?(hand)
        return :straight_flush if straight_flush?(hand)
        return :four_of_a_kind if four_of_a_kind?(hand)
        return :full_house if full_house?(hand)
        return :flush if flush?(hand)
        return :straight if straight?(hand)
        return :three_of_a_kind if three_of_a_kind?(hand)
        return :two_pair if two_pair?(hand)
        return :one_pair if one_pair?(hand)
        return :high_card
    end

    def royal_flush?(hand)
        return false unless flush?
        (sorted_values == [1] + (10..13).to_a) ? true : false
    end

    def straight_flush?(hand)
        flush?(hand) && straight?(hand)
    end

    def four_of_a_kind?(hand)
        matches(hand, 4)
    end

    def full_house?(hand)
        sorted_hand = sorted_values(hand)
        return true if ordered_full_house?(sorted_hand)
        return true if ordered_full_house?(sorted_hand.reverse)
        false
    end

    def ordered_full_house?(sorted_hand)
        return true if sorted_hand[0] == sorted_hand[1] &&
            sorted_hand[2] == sorted_hand[3] == sorted_hand[4]
        false
    end

    def flush?
        return false if !hand.all? { |card| card.suit == hand.cards[0].suit }
        true
    end

    def straight?
        values = sorted_values
        values.each_with_index do |val, i|
            next if i == 0
            return false if val != values[i - 1]
        end
    end

    def three_of_a_kind?(hand)
        matches(hand, 3)
    end

    def two_pair?(hand)
        # removing duplicates from array of values should leave 3 if there are two pair
        sorted_values.uniq.length == 3
    end

    def one_pair?(hand)
        matches(hand, 2)
    end

    def sorted_values(hand)
        values = []

        hand.each do |card|
            values << card.value
        end

        values.sort
    end

    def matches(hand, num)
        matches = 0
        (0..5 - num).each do |i|
            hand.each { |card| matches += 1 if card.value == cards[i].value }
            return true if matches == num
            matches = 0
        end
        false
    end

end