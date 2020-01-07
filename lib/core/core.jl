#!/bin/julia

module Core

    export struct Card
        value
        suit
    end

    export struct Hole
        playerID::Int
        card1
        card2
    end

end

