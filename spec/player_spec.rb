require 'rspec'
require 'player'

describe 'Player' do
    subject(:player) { Player.new(20) }

    describe '#hand' do
        it 'is a Hand' do
            expect(player.hand).to be_a(Hand)
        end
    end

    describe '#pot' do
        it 'is an Integer' do
            expect(player.pot).to be_an(Integer)
        end

        it 'starts at given amount' do
            expect(player.pot).to eq(20)
        end
    end
        
    describe '#cards_to_discard' do
        let(:card1) { double("card1") }
        let(:card2) { double("card1") }
        let(:card3) { double("card1") }
        let(:card4) { double("card1") }
        let(:card5) { double("card1") }
        
        before(:each) { player.hand.cards = [card1, card2, card3, card4, card5] }

        it 'calls #get_user_cards' do
            allow(player).to receive(:get_user_cards).and_return(0)
            expect(player).to receive(:get_user_cards)
            player.cards_to_discard
        end

        context 'no cards discarded' do
            it 'does not change hand' do
                allow(player).to receive(:get_user_cards).and_return([0])
                player.cards_to_discard
                expect(player.hand.cards.length).to eq(5)
            end
        end
        
        context 'cards discarded' do
            it 'removes correct number of cards from hand' do
                allow(player).to receive(:get_user_cards).and_return([2, 3])
                player.cards_to_discard
                expect(player.hand.cards.length).to eq(3)
            end
        end
    end
    
    describe '#fold_see_raise' do
        subject(:player) { Player.new(20) }

        context 'user wants to fold' do
            it 'returns false' do
                allow(player).to receive(:get_user_bet).and_return(:fold)
                expect(player.fold_see_raise).to eq(false)
            end
        end

        context 'user wants to see' do
            it 'returns true' do
                allow(player).to receive(:get_user_bet).and_return(:see)
                expect(player.fold_see_raise).to eq(true)
            end
        end

        context 'user wants to raise' do
            it 'calls #get_user_raise and returns an integer' do
                allow(player).to receive(:get_user_bet).and_return(:raise)
                allow(player).to receive(:get_user_raise).and_return(2)
                player.fold_see_raise
                
                expect(player).to receive(:get_user_raise)
                expect(player.fold_see_raise).to be_an(Integer)
            end
        end

    end

end