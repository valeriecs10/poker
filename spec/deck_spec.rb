
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

        it 'should shuffle the cards upon initializing'
    end
end