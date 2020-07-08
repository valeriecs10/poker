require 'rspec'
require 'card'

describe 'Card' do
    subject(:card) { Card.new(1, :heart) }
    
    it 'has a value' do
        expect(card.value).to be_an(Integer)
    end

    it 'has a suit' do
        expect(card.suit).to be_a(Symbol)
    end
end

