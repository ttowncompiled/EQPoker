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
        players[i].hole.card1 = _pop_deck!(deck)
        i += 1
    end
    i = 1
    while i <= length(players)
        players[i].hole.card2 = _pop_deck!(deck)
        i += 1
    end
end

function flop!(deck::Deck, board::Board)
    _burn!(deck)
    board.flop1 = _pop_deck!(deck)
    board.flop2 = _pop_deck!(deck)
    board.flop3 = _pop_deck!(deck)
end

function turn!(deck::Deck, board::Board)
    _burn!(deck)
    board.turn = _pop_deck!(deck)
end

function river!(deck::Deck, board::Board)
    _burn!(deck)
    board.river = _pop_deck!(deck)
end

function _burn!(deck::Deck)
    _pop_deck!(deck)
end

function _pop_deck!(deck::Deck)
    pop!(deck.cards)
end

