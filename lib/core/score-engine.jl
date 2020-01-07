module ScoreEngine

    include("eq-core.jl")

    export _assemble_cards, _sort_cards!

    function score(hole::EQCore.Hole, board::EQCore.Board)
        cards::Array{EQCore.Card, 7} = _assemble_cards(hole, board)
        _sort_cards!(cards)
    end

    function _assemble_cards(hole::EQCore.Hole, board::EQCore.Board)
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

    function _sort_cards!(cards::Array{EQCore.Card, 7})
        i = 2
        while i <= 7
            j = i
            while j > 1
                if EQCore.compare(cards[j], cards[j-1], true) > 0
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

    function _straight_draw(cards)
        i = 1
        while i+4 <= length(cards)
            if Int(cards[i].rank)-1 == Int(cards[i+1].rank) && Int(cards[i+1].rank)-1 == Int(cards[i+2].rank) && Int(cards[i+2].rank)-1 == Int(cards[i+3].rank) && Int(cards[i+3].rank)-1 == Int(cards[i+4].rank)
                return cards[i:(i+4)]
            end
            i += 1
        end
        return nothing
    end

end
