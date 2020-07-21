require 'rspec'
require 'game'

describe 'Game' do
    subject(:game) { Game.new(Player.new(10), Player.new(10), Player.new(10)) }

    describe '#deck' do
        it 'is a Deck' do
            expect(game.deck).to be_a(Deck)
        end
    end

    describe '#players' do
        it 'creates the right number of Players' do
            expect(game.players.length).to eq(3)
            expect(game.players).to all(be_a(Player))
        end
    end

    describe '#pot' do
        it 'starts at 0' do
            expect(game.pot).to eq(0)
        end
    end
    
    describe '#take_bets' do
    end

    describe '#pot' do
        it 'increments correctly after bets'
    end

    describe '#current_player' do
        it 'returns first player in the players array' do
            expect(game.current_player).to eq(game.players[0])
        end
    end

    describe '#next_player' do
        let(:player2_id) { game.players[1].object_id }
        
        it 'rotates the players array' do
            game.next_player
            expect(game.players[0].object_id).to eq(player2_id)
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

    describe ''

    describe '#play' do
        it 'deals the cards' do
            expect(game).to receive(:deal)
            game.play
        end

        it 'takes bets from all players' do
            expect(game.players).to all(receive(:fold_see_raise))
            game.play
        end

        it 'allows each player to discard cards' do
            expect(game.players).to all(receive(:cards_to_discard))
            game.play
        end

        it 'replaces discarded cards' do
            expect(game).to receive(:replace_discarded).with(game.players[0])
            expect(game).to receive(:replace_discarded).with(game.players[1])
            expect(game).to receive(:replace_discarded).with(game.players[2])
            game.play
        end

    end
end