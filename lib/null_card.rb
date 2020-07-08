require_relative 'card'
require 'singleton'

class NullCard < Card
    include Singleton

    def initialize

    end

end 