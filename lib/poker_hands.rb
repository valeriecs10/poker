require_relative 'tie_breaker'

require 'byebug'   

class PokerHands
    HAND_RANKINGS = {
        royal_flush: 10,
        straight_flush: 9,
        four_of_a_kind: 8,
        full_house: 7,
        flush: 6,
        straight: 5,
        three_of_a_kind: 4,
        two_pair: 3,
        one_pair: 2,
        high_card: 1
    }

    def self.winner(players)
        return players[0] if players.length == 1
        player_best_hands = []
        # build array of players and their highest rank
        players.each do |player|
            player_best_hands << [HAND_RANKINGS[best_hand(player)], player]
        end
        player_best_hands.sort_by! { |arr| arr[0] }.reverse!

        # return player with top ranking hand, unless there is a tie
        return player_best_hands[0][1] unless player_best_hands[0][0] == player_best_hands[1][0]

        TieBreaker.break_tie(players)
    end

    def self.best_hand(player)
        hand = player.hand
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

    def self.royal_flush?(hand)
        return false unless flush?(hand)
        sorted_values(hand) == (10..14).to_a ? true : false
    end

    def self.straight_flush?(hand)
        flush?(hand) && straight?(hand)
    end

    def self.four_of_a_kind?(hand)
        matches(hand, 4)
    end

    def self.full_house?(hand)
        sorted_hand = sorted_values(hand)
        return true if ordered_full_house?(sorted_hand)
        return true if ordered_full_house?(sorted_hand.reverse)
        false
    end

    def self.ordered_full_house?(sorted_hand)
        return true if sorted_hand[0] == sorted_hand[1] &&
            (sorted_hand[3] == sorted_hand[2] && sorted_hand[4] == sorted_hand[2])
        false
    end

    def self.flush?(hand)
        return false if !hand.cards.all? { |card| card.suit == hand.cards[0].suit }
        true
    end

    def self.straight?(hand)
        values = sorted_values(hand)
        values.each_with_index do |val, i|
            next if i == 0
            return false if val != values[i - 1] + 1
        end
    end

    def self.three_of_a_kind?(hand)
        matches(hand, 3)
    end

    def self.two_pair?(hand)
        # removing duplicates from array of values should leave 3 if there are two pair
        sorted_values(hand).uniq.length == 3
    end

    def self.one_pair?(hand)
        matches(hand, 2)
    end

    def self.sorted_values(hand)
        values = []

        hand.cards.each do |card|
            values << card.value
        end

        values.sort
    end

    def self.matches(hand, num)
        matches = 0
        (0..5 - num).each do |i|
            hand.cards.each { |card| matches += 1 if card.value == hand.cards[i].value }
            return true if matches == num
            matches = 0
        end
        false
    end

end