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
        player_hands = {}
        players.each |player| do {
            player_hands[player] = best_hand(player.hand)
        }
        # needs to order the player_hands hash by hand ranking, then returns the 
        # key(player) associated with the highest value, or calls on TieBreaker
        # class if needed
    end

    private

    def best_hand(hand)
        # returns type as symbol, for comparison with HAND_RANKINGS hash
    end

    def search_for_combos
        combos = []
        combos << :royal_flush if royal_flush?
        combos << :straight_flush if straight_flush?
        combos << :four_of_a_kind if four_of_a_kind?
        combos << 
    end

    def royal_flush?(hand)

    end

    def straight_flush?
    end

    def four_of_a_kind?
    end

    def full_house?
    end

    def flush?
    end

    def straight?
    end

    def three_of_a_kind?
    end

    def two_pair?
    end

    def one_pair?
    end

    def high_card?
    end


end