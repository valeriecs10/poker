require 'rspec'
require 'hand'

describe 'Hand' do
    subject(:hand) { Hand.new }

        describe '#cards' do
            it 'is an empty array' do
                expect(hand.cards).to be_empty
            end
        end
end