include("../core/eq-core.jl")
include("../core/score-engine.jl")

function test_royal_flush()
    failing = 0
    cards = [
        Card(Ranks.ACE, Suits.CLUBS),
        Card(Ranks.ACE, Suits.DIAMONDS),
        Card(Ranks.ACE, Suits.HEARTS),
        Card(Ranks.ACE, Suits.SPADES),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.CLUBS),
        Card(Ranks.TEN, Suits.HEARTS)
    ]
    best_cards = [
        Card(Ranks.ACE, Suits.CLUBS),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.CLUBS),
    ]
    royal_flush = _royal_flush_draw(cards)
    if ! expect(royal_flush, best_cards, desc="ERROR: match royal flush")
        failing += 1
    end
    player = Player(0, Hole(0, Card(Ranks.ACE, Suits.CLUBS), Card(Ranks.TEN, Suits.HEARTS)))
    board = Board(Card(Ranks.KING, Suits.CLUBS), Card(Ranks.ACE, Suits.HEARTS), Card(Ranks.JACK, Suits.CLUBS), Card(Ranks.QUEEN, Suits.CLUBS), Card(Ranks.TEN, Suits.CLUBS))
    hand = score(player, board)
    best_hand = Hand(0, Rankings.ROYAL, best_cards...)
    if ! expect(hand, best_hand, desc="ERROR: score royal flush")
        failing += 1
    end
    return failing
end

function test_straight_flush()
    failing = 0
    return failing
end

function test_four_of_a_kind()
    failing = 0
    return failing
end

function test_full_house()
    failing = 0
    return failing
end

function test_flush()
    failing = 0
    return failing
end

function test_straight()
    failing = 0
    return failing
end

function test_three_of_a_kind()
    failing = 0
    return failing
end

function test_two_pair()
    failing = 0
    return failing
end

function test_pair()
    failing = 0
    return failing
end

function test_high_card()
    failing = 0
    return failing
end

function expect(cards::Array{Card}, exp::Array{Card}; desc="")
    if length(cards) != length(exp)
        println(desc)
        return false
    end
    for i in 1:length(cards)
        if ! match(cards[i], exp[i])
            println(desc)
            return false
        end
    end
    return true
end

function expect(cards::Nothing, exp::Array{Card}; desc="")
    println(desc)
    return false
end

function expect(hand::Hand, exp::Hand; desc="")
    if hand.playerID != exp.playerID
        println(desc)
        return false
    end
    if hand.ranking != exp.ranking
        println(desc)
        return false
    end
    if ! match(hand.card1, exp.card1)
        println(desc)
        return false
    end
    if ! match(hand.card2, exp.card2)
        println(desc)
        return false
    end
    if ! match(hand.card3, exp.card3)
        println(desc)
        return false
    end
    if ! match(hand.card4, exp.card4)
        println(desc)
        return false
    end
    if ! match(hand.card5, exp.card5)
        println(desc)
        return false
    end
    return true
end

function expect(hand::Nothing, exp::Hand; desc="")
    println(desc)
    return false
end

function match(c1::Card, c2::Card)
    return c1.rank == c2.rank && c1.suit == c2.suit
end

function run_tests()
    failing = 0
    failing += test_royal_flush()
    println("Done!")
    if failing == 0
        println("All tests passing!")
    else
        println("$(failing) test faililng!")
    end
end

run_tests()

