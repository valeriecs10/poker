
require 'rspec'
require 'deck'

describe 'Deck' do
    subject(:deck) { Deck.new }

    describe '#cards' do
        it 'should be an array' do
            expect(deck.cards).to be_an(Array)
        end

        it 'should contain 52 elements' do
            expect(deck.cards.length).to eq(52)
        end
        
        it 'should contain all Cards' do
            expect(deck.cards).to all(be_a(Card))
        end
    end

    describe '#shuffle' do
    let!(:first_card) { deck.cards[0] }

        it 'should shuffle the cards' do
            deck.shuffle
            expect(deck.cards[0]).to_not eq(first_card)
        end
    end

    describe '#deal_card' do
        it 'returns a card' do
            expect(deck.deal_card).to be_a(Card)
        end

        it 'removes a card from the deck' do
            expect { deck.deal_card }.to change { deck.cards.length }.by(-1)
        end
    end

    describe '#return_to_deck' do
        let(:card) { deck.deal_card }
        
        it 'adds the passed card to the deck' do
            expect(deck.cards.include?(card)).to eq(false)
            deck.return_to_deck(card)
            expect(deck.cards.include?(card)).to eq(true)
        end
    end

end