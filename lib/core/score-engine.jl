function score(hole::Hole, board::Board)
    cards::Array{Card} = _assemble_cards(hole, board)
    _sort_cards!(cards)
    best_hand = _royal_flush_draw(cards)
    if best_hand != nothing
        return Hand(hole.playerID, Rankings.ROYAL, best_hand...)
    end
    best_hand = _straight_flush_draw(cards)
    if best_hand != nothing
        return Hand(hole.playerID, Rankings.SFLUSH, best_hand...)
    end
    best_hand = _quad_draw(cards)
    if best_hand != nothing
        return Hand(hole.playerID, Rankings.QUAD, best_hand...)
    end
    best_hand = _full_draw(cards)
    if best_hand != nothing
        return Hand(hole.playerID, Rankings.FULL, best_hand...)
    end
    best_hand = _flush_draw(cards)
    if best_hand != nothing
        return Hand(hole.playerID, Rankings.FLUSH, best_hand...)
    end
    best_hand = _straight_draw(cards)
    if best_hand != nothing
        return Hand(hole.playerID, Rankings.STRAIGHT, best_hand...)
    end
    best_hand = _trip_draw(cards)
    if best_hand != nothing
        return Hand(hole.playerID, Rankings.TRIP, best_hand...)
    end
    best_hand = _dubs_draw(cards)
    if best_hand != nothing
        return Hand(hole.playerID, Rankings.DUBS, best_hand...)
    end
    best_hand = _pair_draw(cards)
    if best_hand != nothing
        return Hand(hole.playerID, Rankings.PAIR, best_hand...)
    end
    best_hand = _high_draw(cards)
    if best_hand != nothing
        return Hand(hole.playerID, Rankings.HIGH, best_hand...)
    end
    return nothing
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
            if compare(cards[j], cards[j-1], true) > 0
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

function _royal_flush_draw(cards)
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

function _straight_flush_draw(cards)
    if length(cards) < 5
        return nothing
    end
    straight = _straight_draw(cards)
    if straight == nothing
        return nothing
    end
    return _flush_draw(straight)
end

function _quad_draw(cards)
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

function _full_draw(cards)
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

function _flush_draw(cards)
    if length(cards) < 5
        return nothing
    end
    i = 1
    while i+4 <= length(cards)
        if cards[i].suit == cards[i+1].suit && cards[i+1].suit == cards[i+2].suit && cards[i+2].suit == cards[i+3].suit && cards[i+3].suit == cards[i+4].suit
            return cards[i:(i+4)]
        end
        i += 1
    end
    return nothing
end

function _straight_draw(cards)
    if length(cards) < 5
        return nothing
    end
    i = 1
    while i+4 <= length(cards)
        if Int(cards[i].rank)-1 == Int(cards[i+1].rank) && Int(cards[i+1].rank)-1 == Int(cards[i+2].rank) && Int(cards[i+2].rank)-1 == Int(cards[i+3].rank) && Int(cards[i+3].rank)-1 == Int(cards[i+4].rank)
            return cards[i:(i+4)]
        end
        i += 1
    end
    return nothing
end

function _trip_draw(cards)
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

