require_relative 'player'
require_relative 'deck'

class Game
    INITIAL_BET = 2
    attr_reader :deck, :players, :active_players, :pot, :raise_amount, :current_bets
    attr_accessor :active_players

    def initialize(*players)
        @deck = Deck.new
        @players = players
        @active_players = players.dup
        @pot = 0 
        @raise_amount = 0
        @current_bets = Hash.new(0)
    end

    def play
        until game_over?
            deal
            collect_bets
            discards
            collect_bets
            determine_winner
            payout
            reset_players
        end
    end
    
    def current_player
        players[0]
    end
    
    def next_player
        players.rotate!
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
            
            players.each do |player| 
                if active_players.include?(player)
                    raise = take_turn(player)
                    all_current = false if raise
                end
            end
            
        end
        
    end
    
    def take_turn(player)
        choice = player.fold_see_raise
        case choice
        when false
            player_fold(player)
            false
        when true
            make_remaining_bet(player)
            false
        else
            raise_amount += choice
            make_remaining_bet(player)
            true
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
        player.pot -= amount
    end
    
    def player_fold(player)
        active_players.delete(player)
    end
    
    def discards 
        players.each do |player|
            collect_discarded(player)
            replace_discarded(player)
        end
    end

    def collect_discarded(player)
        discards = player.cards_to_discard
        discards.each { |card| deck.return_to_deck(card) }
    end
    
    def replace_discarded(player)
        cards_needed = 5 - player.num_cards
        cards_needed.times { deck.deal_card(player) }
    end

    def reset_players
        active_players.clear
        players.each { |player| active_players << player.dup if player.pot > 0 }
    end

end