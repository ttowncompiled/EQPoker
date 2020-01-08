function score(player::Player, board::Board)
    cards::Array{Card} = _assemble_cards(player.hole, board)
    _sort_cards!(cards)
    best_hand = _royal_flush_draw(cards)
    if best_hand != nothing
        return Hand(player.playerID, Rankings.ROYAL, best_hand...)
    end
    best_hand = _straight_flush_draw(cards)
    if best_hand != nothing
        return Hand(player.playerID, Rankings.SFLUSH, best_hand...)
    end
    best_hand = _quad_draw(cards)
    if best_hand != nothing
        return Hand(player.playerID, Rankings.QUAD, best_hand...)
    end
    best_hand = _full_draw(cards)
    if best_hand != nothing
        return Hand(player.playerID, Rankings.FULL, best_hand...)
    end
    best_hand = _flush_draw(cards)
    if best_hand != nothing
        return Hand(player.playerID, Rankings.FLUSH, best_hand...)
    end
    best_hand = _straight_draw(cards)
    if best_hand != nothing
        return Hand(player.playerID, Rankings.STRAIGHT, best_hand...)
    end
    best_hand = _trip_draw(cards)
    if best_hand != nothing
        return Hand(player.playerID, Rankings.TRIP, best_hand...)
    end
    best_hand = _dubs_draw(cards)
    if best_hand != nothing
        return Hand(player.playerID, Rankings.DUBS, best_hand...)
    end
    best_hand = _pair_draw(cards)
    if best_hand != nothing
        return Hand(player.playerID, Rankings.PAIR, best_hand...)
    end
    best_hand = _high_draw(cards)
    if best_hand != nothing
        return Hand(player.playerID, Rankings.HIGH, best_hand...)
    end
    return nothing
end

function compare_hands(hands::Hand...)
    if length(hands) < 1
        return nothing
    end
    if length(hands) == 1
        return hands
    end
    best_hands::Vector{Hand} = [hands[1]]
    i = 2
    while i <= length(hands)
        k = compare(hands[i], best_hands[1])
        if k > 0
            best_hands = [hands[i]]
        elseif k == 0
            push!(best_hands, hands[i])
        end
        i += 1
    end
    return best_hands
end

function _assemble_cards(hole::Hole, board::Board)
    cards = [
        hole.card1,
        hole.card2,
        board.flop1,
        board.flop2,
        board.flop3,
        board.turn,
        board.river
    ]
    return cards
end

function _sort_cards!(cards::Array{Card})
    i = 2
    while i <= 7
        j = i
        while j > 1
            if compare(cards[j], cards[j-1], tie_break=true) > 0
                tmp = cards[j]
                cards[j] = cards[j-1]
                cards[j-1] = tmp
                j -= 1
            else
                break
            end
        end
        i += 1
    end
end

function _royal_flush_draw(cards::Array{Card})
    if length(cards) < 5
        return nothing
    end
    straight_flush = _straight_flush_draw(cards)
    if straight_flush == nothing
        return nothing
    end
    if straight_flush[1].rank == Ranks.ACE
        return straight_flush
    end
    return nothing
end

function _straight_flush_draw(cards::Array{Card})
    if length(cards) < 5
        return nothing
    end
    clubs::Array{Card} = []
    diamonds::Array{Card} = []
    hearts::Array{Card} = []
    spades::Array{Card} = []
    for card in cards
        if card.suit == Suits.CLUBS
            push!(clubs, card)
        elseif card.suit == Suits.DIAMONDS
            push!(diamonds, card)
        elseif card.suit == Suits.HEARTS
            push!(hearts, card)
        elseif card.suit == Suits.SPADES
            push!(spades, card)
        end
    end
    if length(spades) >= 5
        straight = _straight_draw(spades)
        if straight != nothing
            return straight
        end
    end
    if length(hearts) >= 5
        straight = _straight_draw(hearts)
        if straight != nothing
            return straight
        end
    end
    if length(diamonds) >= 5
        straight = _straight_draw(diamonds)
        if straight != nothing
            return straight
        end
    end
    if length(clubs) >= 5
        straight = _straight_draw(clubs)
        if straight != nothing
            return straight
        end
    end
    return nothing

end

function _quad_draw(cards::Array{Card})
    if length(cards) < 5
        return nothing
    end
    i = 1
    while i+3 <= length(cards)
        if cards[i].rank == cards[i+1].rank && cards[i+1].rank == cards[i+2].rank && cards[i+2].rank == cards[i+3].rank
            if i == 1
                return cards[1:5]
            else
                return vcat(cards[i:(i+3)], cards[1:1])
            end
        end
        i += 1
    end
    return nothing
end

function _full_draw(cards::Array{Card})
    if length(cards) < 5
        return nothing
    end
    i = 1
    while i+2 <= length(cards)
        if cards[i].rank == cards[i+1].rank && cards[i+1].rank == cards[i+2].rank
            j = 1
            while j+1 < i
                if cards[j].rank == cards[j+1].rank
                    return vcat(cards[i:(i+2)], cards[j:(j+1)])
                end
                j += 1
            end
            j = i+3
            while j+1 <= length(cards)
                if cards[j].rank == cards[j+1].rank
                    return vcat(cards[i:(i+2)], cards[j:(j+1)])
                end
                j += 1
            end
        end
        i += 1
    end
    return nothing
end

function _flush_draw(cards::Array{Card})
    if length(cards) < 5
        return nothing
    end
    clubs::Array{Card} = []
    diamonds::Array{Card} = []
    hearts::Array{Card} = []
    spades::Array{Card} = []
    for card in cards
        if card.suit == Suits.CLUBS
            push!(clubs, card)
        elseif card.suit == Suits.DIAMONDS
            push!(diamonds, card)
        elseif card.suit == Suits.HEARTS
            push!(hearts, card)
        elseif card.suit == Suits.SPADES
            push!(spades, card)
        end
    end
    if length(spades) >= 5
        return spades[1:5]
    end
    if length(hearts) >= 5
        return hearts[1:5]
    end
    if length(diamonds) >= 5
        return diamonds[1:5]
    end
    if length(clubs) >= 5
        return clubs[1:5]
    end
    return nothing
end

function _straight_draw(cards::Array{Card})
    if length(cards) < 5
        return nothing
    end
    i = 1
    while i+4 <= length(cards)
        straight::Array{Card} = [cards[i]]
        j = i+1
        while length(straight) < 5 && j <= length(cards)
            if Int(straight[length(straight)].rank)-1 == Int(cards[j].rank)
                push!(straight, cards[j])
            end
            j += 1
        end
        if length(straight) >= 5
            return straight[1:5]
        end
        i += 1
    end
    return nothing
end

function _trip_draw(cards::Array{Card})
    if length(cards) < 5
        return nothing
    end
    i = 1
    while i+2 <= length(cards)
        if cards[i].rank == cards[i+1].rank && cards[i+1].rank == cards[i+2].rank
            if i == 1
                return cards[1:5]
            elseif i == 2
                return vcat(cards[2:4], cards[1:1], cards[5:5])
            else
                return vcat(cards[i:(i+2)], cards[1:2])
            end
        end
        i += 1
    end
    return nothing
end

function _dubs_draw(cards::Array{Card})
    if length(cards) < 5
        return nothing
    end
    i = 1
    while i+1 <= length(cards)
        if cards[i].rank == cards[i+1].rank
            j = i+2
            while j+1 <= length(cards)
                if cards[j].rank == cards[j+1].rank
                    if i == 1
                        if j == 3
                            return cards[1:5]
                        else
                            return vcat(cards[1:2], cards[j:(j+1)], cards[3:3])
                        end
                    else
                        return vcat(cards[i:(i+1)], cards[j:(j+1)], cards[1:1])
                    end
                end
                j += 1
            end
        end
        i += 1
    end
    return nothing
end

function _pair_draw(cards::Array{Card})
    if length(cards) < 5
        return nothing
    end
    i = 1
    while i+1 <= length(cards)
        if cards[i].rank == cards[i+1].rank
            if i == 1
                return cards[1:5]
            elseif i == 2
                return vcat(cards[2:3], cards[1:1], cards[4:5])
            elseif i == 3
                return vcat(cards[3:4], cards[1:2], cards[5:5])
            else
                return vcat(cards[i:(i+1)], cards[1:3])
            end
        end
        i += 1
    end
    return nothing
end

function _high_draw(cards::Array{Card})
    if length(cards) < 5
        return nothing
    end
    return cards[1:5]
end

