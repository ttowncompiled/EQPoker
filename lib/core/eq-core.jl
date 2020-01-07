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

module Rankings
    @enum Ranking begin
        HIGH=1
        PAIR=2
        DUBS=3
        TRIP=4
        STRAIGHT=5
        FLUSH=6
        FULL=7
        QUAD=8
        SFLUSH=9
        ROYAL=10
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

struct Deck
    cards::Vector{Card}
end

struct Hole
    playerID::Int
    card1::Card
    card2::Card
end

struct Player
    playerID::Int
    hole::Hole
end

struct Board
    flop1::Card
    flop2::Card
    flop3::Card
    turn::Card
    river::Card
end

struct Hand
    playerID::Int
    ranking::Rankings.Ranking
    card1::Card
    card2::Card
    card3::Card
    card4::Card
    card5::Card
end

function compare(h1::Hand, h2::Hand, tie_break=false)
    if h1.ranking > h2.ranking
        1
    elseif h1.ranking < h2.ranking
        -1
    elseif compare(h1.card1, h2.card1) != 0
        compare(h1.card1, h2.card1)
    elseif compare(h1.card2, h2.card2) != 0
        compare(h1.card2, h2.card2)
    elseif compare(h1.card3, h2.card3) != 0
        compare(h1.card3, h2.card3)
    elseif compare(h1.card4, h2.card4) != 0
        compare(h1.card4, h2.card4)
    elseif compare(h1.card5, h2.card5) != 0
        compare(h1.card5, h2.card5)
    else
        0
    end
end

