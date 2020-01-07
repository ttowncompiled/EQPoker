#!/bin/julia

module EQCore

    @enum Value two=2 three=3 four=4 five=5 six=6 seven=7 eight=8 nine=9 ten=10 jack=11 queen=12 king=13 ace=14

    @enum Suit clubs=1 diamonds=2 hearts=3 spades=4

    struct Card
        value::Value
        suit::Suit
    end

    struct Hole
        playerID::Int
        card1::Card
        card2::Card
    end

end

