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
    cards = [
        Card(Ranks.ACE, Suits.SPADES),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.KING, Suits.DIAMONDS),
        Card(Ranks.KING, Suits.HEARTS),
        Card(Ranks.KING, Suits.SPADES),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.CLUBS),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.NINE, Suits.CLUBS)
    ]
    best_cards = [
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.CLUBS),
        Card(Ranks.NINE, Suits.CLUBS)
    ]
    straight_flush = _straight_flush_draw(cards)
    if ! expect(straight_flush, best_cards, desc="ERROR: match straight flush")
        failing += 1
    end
    player = Player(0, Hole(0, Card(Ranks.ACE, Suits.SPADES), Card(Ranks.TEN, Suits.CLUBS)))
    board = Board(Card(Ranks.KING, Suits.CLUBS), Card(Ranks.NINE, Suits.CLUBS), Card(Ranks.JACK, Suits.CLUBS), Card(Ranks.QUEEN, Suits.CLUBS), Card(Ranks.TEN, Suits.HEARTS))
    hand = score(player, board)
    best_hand = Hand(0, Rankings.SFLUSH, best_cards...)
    if ! expect(hand, best_hand, desc="ERROR: score straight flush")
        failing += 1
    end
    return failing
end

function test_four_of_a_kind()
    failing = 0
    cards = [
        Card(Ranks.ACE, Suits.SPADES),
        Card(Ranks.KING, Suits.SPADES),
        Card(Ranks.KING, Suits.HEARTS),
        Card(Ranks.KING, Suits.DIAMONDS),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.CLUBS),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.NINE, Suits.SPADES),
        Card(Ranks.TWO, Suits.CLUBS)
    ]
    best_cards = [
        Card(Ranks.KING, Suits.SPADES),
        Card(Ranks.KING, Suits.HEARTS),
        Card(Ranks.KING, Suits.DIAMONDS),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.ACE, Suits.SPADES)
    ]
    quad = _quad_draw(cards)
    if ! expect(quad, best_cards, desc="ERROR: match four-of-a-kind")
        failing += 1
    end
    player = Player(0, Hole(0, Card(Ranks.KING, Suits.SPADES), Card(Ranks.KING, Suits.HEARTS)))
    board = Board(Card(Ranks.KING, Suits.CLUBS), Card(Ranks.ACE, Suits.SPADES), Card(Ranks.JACK, Suits.CLUBS), Card(Ranks.QUEEN, Suits.CLUBS), Card(Ranks.KING, Suits.DIAMONDS))
    hand = score(player, board)
    best_hand = Hand(0, Rankings.QUAD, best_cards...)
    if ! expect(hand, best_hand, desc="ERROR: score four-of-a-kind")
        failing += 1
    end

    return failing
end

function test_full_house()
    failing = 0
    cards = [
        Card(Ranks.ACE, Suits.SPADES),
        Card(Ranks.KING, Suits.SPADES),
        Card(Ranks.KING, Suits.DIAMONDS),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.TEN, Suits.CLUBS),
        Card(Ranks.TWO, Suits.CLUBS),
        Card(Ranks.NINE, Suits.HEARTS)
    ]
    best_cards = [
        Card(Ranks.KING, Suits.SPADES),
        Card(Ranks.KING, Suits.DIAMONDS),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.TEN, Suits.CLUBS)
    ]
    full_house = _full_draw(cards)
    if ! expect(full_house, best_cards, desc="ERROR: match full house")
        failing += 1
    end
    player = Player(0, Hole(0, Card(Ranks.KING, Suits.SPADES), Card(Ranks.KING, Suits.CLUBS)))
    board = Board(Card(Ranks.KING, Suits.DIAMONDS), Card(Ranks.NINE, Suits.CLUBS), Card(Ranks.TEN, Suits.CLUBS), Card(Ranks.QUEEN, Suits.CLUBS), Card(Ranks.TEN, Suits.HEARTS))
    hand = score(player, board)
    best_hand = Hand(0, Rankings.FULL, best_cards...)
    if ! expect(hand, best_hand, desc="ERROR: score full house")
        failing += 1
    end
    return failing
end

function test_flush()
    failing = 0
    cards = [
        Card(Ranks.ACE, Suits.SPADES),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.TEN, Suits.CLUBS),
        Card(Ranks.TEN, Suits.SPADES),
        Card(Ranks.TWO, Suits.CLUBS),
        Card(Ranks.NINE, Suits.HEARTS)
    ]
    best_cards = [
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.CLUBS),
        Card(Ranks.TWO, Suits.CLUBS)
    ]
    flush = _flush_draw(cards)
    if ! expect(flush, best_cards, desc="ERROR: match flush")
        failing += 1
    end
    player = Player(0, Hole(0, Card(Ranks.TWO, Suits.CLUBS), Card(Ranks.KING, Suits.CLUBS)))
    board = Board(Card(Ranks.KING, Suits.DIAMONDS), Card(Ranks.NINE, Suits.HEARTS), Card(Ranks.TEN, Suits.CLUBS), Card(Ranks.QUEEN, Suits.CLUBS), Card(Ranks.JACK, Suits.CLUBS))
    hand = score(player, board)
    best_hand = Hand(0, Rankings.FLUSH, best_cards...)
    if ! expect(hand, best_hand, desc="ERROR: score flush")
        failing += 1
    end
    return failing
end

function test_straight()
    failing = 0
    cards = [
        Card(Ranks.ACE, Suits.SPADES),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.SPADES),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.TEN, Suits.CLUBS),
        Card(Ranks.NINE, Suits.HEARTS)
    ]
    best_cards = [
        Card(Ranks.ACE, Suits.SPADES),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.SPADES),
    ]
    straight = _straight_draw(cards)
    if ! expect(straight, best_cards, desc="ERROR: match straight")
        failing += 1
    end
    player = Player(0, Hole(0, Card(Ranks.ACE, Suits.SPADES), Card(Ranks.KING, Suits.CLUBS)))
    board = Board(Card(Ranks.TEN, Suits.SPADES), Card(Ranks.NINE, Suits.HEARTS), Card(Ranks.TEN, Suits.SPADES), Card(Ranks.QUEEN, Suits.CLUBS), Card(Ranks.JACK, Suits.CLUBS))
    hand = score(player, board)
    best_hand = Hand(0, Rankings.STRAIGHT, best_cards...)
    if ! expect(hand, best_hand, desc="ERROR: score straight")
        failing += 1
    end
    return failing
end

function test_three_of_a_kind()
    failing = 0
    cards = [
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.SPADES),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.TEN, Suits.CLUBS),
        Card(Ranks.TWO, Suits.HEARTS)
    ]
    best_cards = [
        Card(Ranks.TEN, Suits.SPADES),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.TEN, Suits.CLUBS),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.QUEEN, Suits.CLUBS),
    ]
    trip = _trip_draw(cards)
    if ! expect(trip, best_cards, desc="ERROR: match three-of-a-kind")
        failing += 1
    end
    player = Player(0, Hole(0, Card(Ranks.TEN, Suits.CLUBS), Card(Ranks.KING, Suits.CLUBS)))
    board = Board(Card(Ranks.TEN, Suits.SPADES), Card(Ranks.TWO, Suits.HEARTS), Card(Ranks.TEN, Suits.HEARTS), Card(Ranks.QUEEN, Suits.CLUBS), Card(Ranks.JACK, Suits.CLUBS))
    hand = score(player, board)
    best_hand = Hand(0, Rankings.TRIP, best_cards...)
    if ! expect(hand, best_hand, desc="ERROR: score three-of-a-kind")
        failing += 1
    end
    return failing
end

function test_two_pair()
    failing = 0
    cards = [
        Card(Ranks.KING, Suits.SPADES),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.SPADES),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.TWO, Suits.HEARTS)
    ]
    best_cards = [
        Card(Ranks.KING, Suits.SPADES),
        Card(Ranks.KING, Suits.CLUBS),
        Card(Ranks.TEN, Suits.SPADES),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.QUEEN, Suits.CLUBS),
    ]
    dubs = _dubs_draw(cards)
    if ! expect(dubs, best_cards, desc="ERROR: match two-pair")
        failing += 1
    end
    player = Player(0, Hole(0, Card(Ranks.KING, Suits.SPADES), Card(Ranks.KING, Suits.CLUBS)))
    board = Board(Card(Ranks.TEN, Suits.SPADES), Card(Ranks.TWO, Suits.HEARTS), Card(Ranks.TEN, Suits.HEARTS), Card(Ranks.QUEEN, Suits.CLUBS), Card(Ranks.JACK, Suits.CLUBS))
    hand = score(player, board)
    best_hand = Hand(0, Rankings.DUBS, best_cards...)
    if ! expect(hand, best_hand, desc="ERROR: score two-pair")
        failing += 1
    end
    return failing
end

function test_pair()
    failing = 0
    cards = [
        Card(Ranks.KING, Suits.SPADES),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.SPADES),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.FOUR, Suits.DIAMONDS),
        Card(Ranks.TWO, Suits.HEARTS)
    ]
    best_cards = [
        Card(Ranks.TEN, Suits.SPADES),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.KING, Suits.SPADES),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS)
    ]
    pair = _pair_draw(cards)
    if ! expect(pair, best_cards, desc="ERROR: match pair")
        failing += 1
    end
    player = Player(0, Hole(0, Card(Ranks.KING, Suits.SPADES), Card(Ranks.FOUR, Suits.DIAMONDS)))
    board = Board(Card(Ranks.TEN, Suits.SPADES), Card(Ranks.TWO, Suits.HEARTS), Card(Ranks.TEN, Suits.HEARTS), Card(Ranks.QUEEN, Suits.CLUBS), Card(Ranks.JACK, Suits.CLUBS))
    hand = score(player, board)
    best_hand = Hand(0, Rankings.PAIR, best_cards...)
    if ! expect(hand, best_hand, desc="ERROR: score pair")
        failing += 1
    end
    return failing
end

function test_high_card()
    failing = 0
    cards = [
        Card(Ranks.KING, Suits.SPADES),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.SEVEN, Suits.HEARTS),
        Card(Ranks.FOUR, Suits.DIAMONDS),
        Card(Ranks.TWO, Suits.HEARTS)
    ]
    best_cards = [
        Card(Ranks.KING, Suits.SPADES),
        Card(Ranks.QUEEN, Suits.CLUBS),
        Card(Ranks.JACK, Suits.CLUBS),
        Card(Ranks.TEN, Suits.HEARTS),
        Card(Ranks.SEVEN, Suits.HEARTS)
    ]
    high = _high_draw(cards)
    if ! expect(high, best_cards, desc="ERROR: match high card")
        failing += 1
    end
    player = Player(0, Hole(0, Card(Ranks.KING, Suits.SPADES), Card(Ranks.FOUR, Suits.DIAMONDS)))
    board = Board(Card(Ranks.SEVEN, Suits.HEARTS), Card(Ranks.TWO, Suits.HEARTS), Card(Ranks.TEN, Suits.HEARTS), Card(Ranks.QUEEN, Suits.CLUBS), Card(Ranks.JACK, Suits.CLUBS))
    hand = score(player, board)
    best_hand = Hand(0, Rankings.HIGH, best_cards...)
    if ! expect(hand, best_hand, desc="ERROR: score high card")
        failing += 1
    end

    return failing
end

function test_compare_hands()
    failing = 0
    board = Board(Card(Ranks.KING, Suits.HEARTS), Card(Ranks.QUEEN, Suits.HEARTS), Card(Ranks.JACK, Suits.HEARTS), Card(Ranks.TEN, Suits.HEARTS), Card(Ranks.TEN, Suits.CLUBS))
    p1 = Player(1, Hole(1, Card(Ranks.ACE, Suits.HEARTS), Card(Ranks.TWO, Suits.CLUBS)))
    p2 = Player(2, Hole(2, Card(Ranks.NINE, Suits.HEARTS), Card(Ranks.TWO, Suits.DIAMONDS)))
    p3 = Player(3, Hole(3, Card(Ranks.TEN, Suits.DIAMONDS), Card(Ranks.TEN, Suits.SPADES)))
    p4 = Player(4, Hole(4, Card(Ranks.KING, Suits.CLUBS), Card(Ranks.KING, Suits.SPADES)))
    p5 = Player(5, Hole(5, Card(Ranks.TWO, Suits.HEARTS), Card(Ranks.THREE, Suits.CLUBS)))
    p6 = Player(6, Hole(6, Card(Ranks.ACE, Suits.SPADES), Card(Ranks.THREE, Suits.SPADES)))
    p7 = Player(7, Hole(7, Card(Ranks.TEN, Suits.SPADES), Card(Ranks.FOUR, Suits.SPADES)))
    p8 = Player(8, Hole(8, Card(Ranks.JACK, Suits.SPADES), Card(Ranks.FOUR, Suits.CLUBS)))
    p9 = Player(9, Hole(9, Card(Ranks.EIGHT, Suits.CLUBS), Card(Ranks.SEVEN, Suits.CLUBS)))
    p10 = Player(10, Hole(10, Card(Ranks.FIVE, Suits.CLUBS), Card(Ranks.SIX, Suits.SPADES)))
    p1_hand = score(p1, board)
    p2_hand = score(p2, board)
    p3_hand = score(p3, board)
    p4_hand = score(p4, board)
    p5_hand = score(p5, board)
    p6_hand = score(p6, board)
    p7_hand = score(p7, board)
    p8_hand = score(p8, board)
    p9_hand = score(p9, board)
    p10_hand = score(p10, board)
    begin
        best_hands = compare_hands(p1_hand, p2_hand, p3_hand, p4_hand, p5_hand, p6_hand, p7_hand, p8_hand, p9_hand, p10_hand)
        if ! expect(best_hands, [p1_hand], desc="ERROR: royal flush is best hand")
            failing += 1
        end
    end
    begin
        best_hands = compare_hands(p2_hand, p3_hand, p4_hand, p5_hand, p6_hand, p7_hand, p8_hand, p9_hand, p10_hand)
        if ! expect(best_hands, [p2_hand], desc="ERROR: straight flush is best hand")
            failing += 1
        end
    end
    begin
        best_hands = compare_hands(p3_hand, p4_hand, p5_hand, p6_hand, p7_hand, p8_hand, p9_hand, p10_hand)
        if ! expect(best_hands, [p3_hand], desc="ERROR: four-of-a-kind is best hand")
            failing += 1
        end
    end
    begin
        best_hands = compare_hands(p4_hand, p5_hand, p6_hand, p7_hand, p8_hand, p9_hand, p10_hand)
        if ! expect(best_hands, [p4_hand], desc="ERROR: full-house is best hand")
            failing += 1
        end
    end
    begin
        best_hands = compare_hands(p5_hand, p6_hand, p7_hand, p8_hand, p9_hand, p10_hand)
        if ! expect(best_hands, [p5_hand], desc="ERROR: flush is best hand")
            failing += 1
        end
    end
    begin
        best_hands = compare_hands(p6_hand, p7_hand, p8_hand, p9_hand, p10_hand)
        if ! expect(best_hands, [p6_hand], desc="ERROR: straight is best hand")
            failing += 1
        end
    end
    begin
        best_hands = compare_hands(p7_hand, p8_hand, p9_hand, p10_hand)
        if ! expect(best_hands, [p7_hand], desc="ERROR: three-of-a-kind is best hand")
            failing += 1
        end
    end
    begin
        best_hands = compare_hands(p8_hand, p9_hand, p10_hand)
        if ! expect(best_hands, [p8_hand], desc="ERROR: two-pair is best hand")
            failing += 1
        end
    end
    begin
        best_hands = compare_hands(p9_hand, p10_hand)
        if ! expect(best_hands, [p9_hand, p10_hand], desc="ERROR: tie hands")
            failing += 1
        end
    end
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

function expect(best_hands::Array{Hand}, exp::Array{Hand}; desc="")
    if length(best_hands) != length(exp)
        println(desc)
        return false
    end
    for i in 1:length(best_hands)
        if best_hands[i].playerID != exp[i].playerID
            println(desc)
            return false
        end
    end
    return true
end

function match(c1::Card, c2::Card)
    return c1.rank == c2.rank && c1.suit == c2.suit
end

function run_tests()
    failing = 0
    failing += test_royal_flush()
    failing += test_straight_flush()
    failing += test_four_of_a_kind()
    failing += test_full_house()
    failing += test_flush()
    failing += test_straight()
    failing += test_three_of_a_kind()
    failing += test_two_pair()
    failing += test_pair()
    failing += test_high_card()
    failing += test_compare_hands()
    println("Done!")
    if failing == 0
        println("All tests passing!")
    else
        println("$(failing) test faililng!")
    end
end

run_tests()

