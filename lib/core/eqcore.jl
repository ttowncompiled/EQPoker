#!/bin/julia

module EQCore

    export Ranks, Suits, Card, compare, Hole, Board

    module Ranks
        @enum Rank begin
            TWO=2
            THREE=3
            FOUR=4
            FIVE=5
            SIX=6
            SEVEN=7
            EIGHT=8
            NINE=9
            TEN=10
            JACK=11
            QUEEN=12
            KING=13
            ACE=14
        end
    end

    module Suits
        @enum Suit begin
            CLUBS=1
            DIAMONDS=2
            HEARTS=3
            SPADES=4
        end
    end

    struct Card
        rank::Ranks.Rank
        suit::Suits.Suit
    end

    function compare(c1::Card, c2::Card, tie_break=false)
        if c1.rank > c2.rank
            1
        elseif c1.rank < c2.rank
            -1
        elseif ! tie_break
            0
        elseif c1.suit > c2.suit
            1
        elseif c1.suit < c2.suit
            -1
        else
            0
        end
    end

    struct Hole
        playerID::Int
        card1::Card
        card2::Card
    end

    struct Board
        flop1::Card
        flop2::Card
        flop3::Card
        turn::Card
        river::Card
    end

end

