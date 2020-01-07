import Random

function generate_deck()
    cards::Vector{Card} = Card[]
    for i in 1:4
        for j in 2:14
            push!(cards, Card(Ranks.Rank(j), Suits.Suit(i)))
        end
    end
    return Deck(cards)
end

function predeal_shuffle!(deck::Deck)
    Random.shuffle!(deck.cards)
end

function deal!(deck::Deck, players::Player...)
    i = 1
    while i <= length(players)
        players[i].hole[1] = pop!(deck)
    end
    i = 1
    while i <= length(players)
        players[i].hole[2] = pop!(deck)
    end
end

function flop!(deck::Deck, board::Board)
    _burn!(deck)
    board.flop1 = pop!(deck)
    board.flop2 = pop!(deck)
    board.flop3 = pop!(deck)
end

function turn!(deck::Deck, board::Board)
    _burn!(deck)
    board.turn = pop!(deck)
end

function river!(deck::Deck, board::Board)
    _burn!(deck)
    board.river = pop!(deck)
end

