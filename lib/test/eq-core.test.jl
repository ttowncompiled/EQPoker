include("../core/eq-core.jl")

function test_compare()
    failing = 0
    if ! expect(Card(Ranks.ACE, Suits.CLUBS), Card(Ranks.KING, Suits.CLUBS), 1, 1, desc="ERROR: higher rank of same suit beats lower rank")
        failing += 1
    end
    if ! expect(Card(Ranks.ACE, Suits.HEARTS), Card(Ranks.KING, Suits.CLUBS), 1, 1, desc="ERROR: higher rank of better suit beats lower rank")
        failing += 1
    end
    if ! expect(Card(Ranks.ACE, Suits.CLUBS), Card(Ranks.KING, Suits.HEARTS), 1, 1, desc="ERROR: higher rank of worse suit beats lower rank")
        failing += 1
    end
    if ! expect(Card(Ranks.ACE, Suits.CLUBS), Card(Ranks.ACE, Suits.CLUBS), 0, 0, desc="ERROR: same rank of same suit is equal")
        failing += 1
    end
    if ! expect(Card(Ranks.ACE, Suits.HEARTS), Card(Ranks.ACE, Suits.CLUBS), 0, 1, desc="ERROR: same rank of better suit is equal (tie_break=false) or beats worse suit")
        failing += 1
    end
    if ! expect(Card(Ranks.ACE, Suits.CLUBS), Card(Ranks.KING, Suits.CLUBS), 1, 1, desc="ERROR: ACE beats KING")
        failing += 1
    end
    if ! expect(Card(Ranks.KING, Suits.CLUBS), Card(Ranks.QUEEN, Suits.CLUBS), 1, 1, desc="ERROR: KING beats QUEEN")
        failing += 1
    end
    if ! expect(Card(Ranks.QUEEN, Suits.CLUBS), Card(Ranks.JACK, Suits.CLUBS), 1, 1, desc="ERROR: QUEEN beats JACK")
        failing += 1
    end
    if ! expect(Card(Ranks.JACK, Suits.CLUBS), Card(Ranks.TEN, Suits.CLUBS), 1, 1, desc="ERROR: JACK beats TEN")
        failing += 1
    end
    if ! expect(Card(Ranks.TEN, Suits.CLUBS), Card(Ranks.NINE, Suits.CLUBS), 1, 1, desc="ERROR: TEN beats NINE")
        failing += 1
    end
    if ! expect(Card(Ranks.NINE, Suits.CLUBS), Card(Ranks.EIGHT, Suits.CLUBS), 1, 1, desc="ERROR: NINE beats EIGHT")
        failing += 1
    end
    if ! expect(Card(Ranks.EIGHT, Suits.CLUBS), Card(Ranks.SEVEN, Suits.CLUBS), 1, 1, desc="ERROR: EIGHT beats SEVEN")
        failing += 1
    end
    if ! expect(Card(Ranks.SEVEN, Suits.CLUBS), Card(Ranks.SIX, Suits.CLUBS), 1, 1, desc="ERROR: SEVEN beats SIX")
        failing += 1
    end
    if ! expect(Card(Ranks.SIX, Suits.CLUBS), Card(Ranks.FIVE, Suits.CLUBS), 1, 1, desc="ERROR: SIX beats FIVE")
        failing += 1
    end
    if ! expect(Card(Ranks.FIVE, Suits.CLUBS), Card(Ranks.FOUR, Suits.CLUBS), 1, 1, desc="ERROR: FIVE beats FOUR")
        failing += 1
    end
    if ! expect(Card(Ranks.FOUR, Suits.CLUBS), Card(Ranks.THREE, Suits.CLUBS), 1, 1, desc="ERROR: FOUR beats THREE")
        failing += 1
    end
    if ! expect(Card(Ranks.THREE, Suits.CLUBS), Card(Ranks.TWO, Suits.CLUBS), 1, 1, desc="THREE beats TWO")
        failing += 1
    end
    return failing
end

function expect(c1::Card, c2::Card, v1::Int, v2::Int; desc="")
    if ! (compare(c1, c2, tie_break=false) == v1 && compare(c1, c2, tie_break=true) == v2)
        println(desc)
        return false
    end
    if ! (compare(c2, c1, tie_break=false) == v1*-1 && compare(c2, c1, tie_break=true) == v2*-1)
        println(desc)
        return false
    end
    return true
end

function run_tests()
    failing = 0
    failing += test_compare()
    println("Done!")
    if failing == 0
        println("All tests passing!")
    else
        println("$(failing) tests failing")
    end
end

run_tests()

