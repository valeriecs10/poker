require 'rspec'
require 'hand'

describe 'Hand' do
    subject(:hand) { Hand.new }

        describe '#cards' do
            it 'is an array' do
                expect(hand.cards).to be_an(Array)
            end
            
            it 'has 5 elements' do
                expect(hand.cards.length).to eq(5)
            end

            it 'contains all cards' do
                expect(hand.cards).to all(be_a(Card))
            end
        end

end