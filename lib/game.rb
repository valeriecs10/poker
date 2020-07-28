require_relative 'player'
require_relative 'deck'
require_relative 'poker_hands'

require 'byebug'

class Game
    INITIAL_BET = 2
    attr_reader :deck, :players, :active_players, :current_bets
    attr_accessor :active_players, :pot, :raise_amount, :folds

    def initialize(*players)
        @deck = Deck.new
        @players = players
        @active_players = []
        players.each { |player| active_players << player }
        @pot = 0 
        @raise_amount = 0
        @current_bets = Hash.new(0)
        @folds = []
    end

    def play
        until game_over?
            deal
            collect_bets
            discards
            collect_bets
            finish_round
        end
    end
    
    def current_player
        players[0]
    end
    
    def deal
        deck.shuffle
        5.times { players.each do |player| 
            deck.deal_card(player) unless player.pot == 0 
        end
        }
    end

    def game_over?
        active_players.length < 2
    end

    # private
    
    def collect_bets
        all_current = false
        
        until all_current
            all_current = true
            
            active_players.each do |player| 
                unless current_bets[player] == INITIAL_BET + raise_amount
                    raise = take_turn(player)
                    all_current = false if raise
                end
            end
            folds.each { |player| player_fold(player) }
            folds.clear
        end
    end

    def clear_bets
        raise_amount = 0
        current_bets.clear
    end
    
    def take_turn(player)
        begin
            choice = player.fold_see_raise
            case choice
            when false
                folds << player
                false
            when true
                make_remaining_bet(player)
                false
            else
                @raise_amount += choice
                make_remaining_bet(player)
                true
            end
        rescue RuntimeError => e
            puts e
            puts "You're broke, time to fold."
            retry
        end
    end
    
    def make_remaining_bet(player)
        remaining_bet = INITIAL_BET + raise_amount - current_bets[player]
        collect_from_bankroll(player,remaining_bet)
        add_to_pot(remaining_bet)
        current_bets[player] += remaining_bet
    end

    def add_to_pot(amount)
        @pot += amount
    end

    def collect_from_bankroll(player, amount)
        raise RuntimeError.new "Player doesn't have enough money left!" if amount > player.pot
        player.pot -= amount
    end
    
    def player_fold(player)
        return_hand(player)
        active_players.delete(player)
    end
    
    def discards 
        active_players.each do |player|
            collect_discarded(player)
            replace_discarded(player)
        end
    end

    def collect_discarded(player)
        discards = player.cards_to_discard
        discards.each { |card| deck.return_to_deck(card) } unless discards.nil?
    end
    
    def replace_discarded(player)
        cards_needed = 5 - player.num_cards
        cards_needed.times { deck.deal_card(player) }
    end

    def payout(player, amount)
        debugger if players.index(player).nil?
        puts "Player #{players.index(player) + 1} wins and receives #{amount} from the pot!"
        player.pot += amount
        subtract_from_pot(amount)
    end

    def subtract_from_pot(amount)
        @pot -= amount
    end

    def finish_round
        payout_amount = pot
        winner = PokerHands.winner(active_players)
        if winner.is_a?(Array)
            payout_amount = pot / winner.length
            winner.each { |winner| payout(winner, payout_amount) }
        else
            payout(winner, payout_amount)
        end
        collect_cards
        reset_players
    end

    def collect_cards
        active_players.each { |player| return_hand(player) }
    end

    def return_hand(player)
        player_cards = player.hand.cards
        until player_cards.empty?
            deck.return_to_deck(player_cards.delete(player_cards[-1]))
        end
    end

    def reset_players
        active_players.clear
        players.each { |player| active_players << player if player.pot > 0 }
    end

end