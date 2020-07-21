require 'rspec'
require 'game'

describe 'Game' do
    subject(:game) { Game.new(Player.new(10), Player.new(20), Player.new(10)) }

    describe '#deck' do
        it 'is a Deck' do
            expect(game.deck).to be_a(Deck)
        end
    end

    describe '#players' do
        it 'creates the right number of Players' do
            expect(game.players.length).to eq(3)
        end
    end

    describe '#pot' do
        it 'starts at 0' do
            expect(game.pot).to eq(0)
        end
    end

    describe '#current_player' do
        it 'returns first player in the players array' do
            expect(game.current_player).to eq(game.players[0])
        end
    end

    describe '#next_player' do
        it 'rotates the players array' do
            game.next_player
            expect(game.players[0].pot).to eq(20)
        end
    end

    describe '#deal' do
        it 'puts 5 cards in each players hand' do
            game.deal
            expect(game.players[0].num_cards).to eq(5)
            expect(game.players[1].num_cards).to eq(5)
            expect(game.players[2].num_cards).to eq(5)
        end

        it 'removes cards dealt from deck' do
            game.deal
            expect(game.deck.num_cards).to eq(37)
        end

        it 'does not deal to players with no money' do
            game.players[0].pot = 0
            game.deal
            expect(game.players[0].num_cards).to eq(0)
        end
    end

    describe '#add_to_pot' do
        it 'adds the correct amount to the pot' do
            expect { game.add_to_pot(20) }.to change { game.pot }.by(20)
        end
    end

    describe '#collect_from_bankroll' do
        let(:player1) { game.players[0] }
        it 'subtracts the correct amount from player bankroll' do
            expect { game.collect_from_bankroll(player1, 10) }.to change { player1.pot }.by(-10)
        end 
    end

    describe '#replace_discarded' do
        let(:player_hand) { double('hand', :cards => [:card1, :card2, :card3]) }
        let(:needs_cards) { double('player', :hand => player_hand) }
        
        it 'replaces discarded cards' do
            allow(needs_cards).to receive(:num_cards).and_return(needs_cards.hand.cards.length)
            game.replace_discarded(needs_cards)
            expect(needs_cards.hand.cards.length).to eq(5)
        end
    end

    describe '#game_over?' do
        it 'returns false when more than 1 player has money left' do
            expect(game.game_over?).to eq(false)
        end

        it 'returns true when only 1 player has money left' do
            game.collect_from_bankroll(game.players[0], 10)
            game.collect_from_bankroll(game.players[1], 20)
            expect(game.game_over?).to eq(true)
        end
    end

end