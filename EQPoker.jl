#!/bin/julia

include("./lib/core/eq-core.jl")
include("./lib/core/score-engine.jl")
include("./lib/core/dealer.jl")

using CSV
using DelimitedFiles

chan = Channel(256)

function main(args)
    num_players = parse(Int, args[1])
    trials = parse(Int, args[2])
    player_range = CSV.read(args[3])
    output = args[4]
    range_equity::Array{Float64, 2} = zeros(Float64, 13, 13)
    for i in 1:13
        for j in 1:13
            start(num_players, trials, player_range, i, j)
        end
    end
    for _ in 1:13
        for _ in 1:13
            i, j, equity = take!(chan)
            range_equity[i, j] = round(equity, digits=4)
        end
    end
    writedlm(output, ["A" "K" "Q" "J" "T" "9" "8" "7" "6" "5" "4" "3" "2"], ",")
    open(output, "a") do io
        writedlm(io, range_equity, ",")
    end

end

function start(num_players::Int, trials::Int, player_range, i::Int, j::Int)
    pot::Float64 = trials
    deck::Deck = generate_deck()
    k_i = length(deck.cards)-i+1
    k_j = if j <= i
            length(deck.cards)-13-j+1
        else
            length(deck.cards)-j+1
        end
    player::Player = Player(1, Hole(1, deck.cards[k_i], deck.cards[k_j]))
    if k_i < k_j
        deleteat!(deck.cards, k_j)
        deleteat!(deck.cards, k_i)
    else
        deleteat!(deck.cards, k_i)
        deleteat!(deck.cards, k_j)
    end
    players::Vector{Player} = []
    for p in 2:num_players
        push!(players, Player(p, Hole(p, Card(Ranks.NULL, Suits.NULL), Card(Ranks.NULL, Suits.NULL))))
    end
    board::Board = Board(Card(Ranks.NULL, Suits.NULL), Card(Ranks.NULL, Suits.NULL), Card(Ranks.NULL, Suits.NULL), Card(Ranks.NULL, Suits.NULL), Card(Ranks.NULL, Suits.NULL))
    predeal_shuffle!(deck)
    for t in 1:trials
        pot -= 1
        deal!(deck, players...)
        flop!(deck, board)
        turn!(deck, board)
        river!(deck, board)
        hands::Vector{Hand} = []
        push!(hands, score(player, board))
        for p in players
            p_i, p_j = 0, 0
            if compare(p.hole.card1, p.hole.card2) >= 0
                if p.hole.card1.suit == p.hole.card2.suit
                    p_i = 15-Int(p.hole.card1.rank)
                    p_j = 15-Int(p.hole.card2.rank)
                else
                    p_i = 15-Int(p.hole.card2.rank)
                    p_j = 15-Int(p.hole.card1.rank)
                end
            else
                if p.hole.card1.suit == p.hole.card2.suit
                    p_i = 15-Int(p.hole.card2.rank)
                    p_j = 15-Int(p.hole.card1.rank)
                else
                    p_i = 15-Int(p.hole.card1.rank)
                    p_j = 15-Int(p.hole.card2.rank)
                end
            end
            if player_range[p_i, p_j] == 0
                continue
            end
            push!(hands, score(p, board))
        end
        if length(hands) == 1
            pot += 1
            reshuffle!(deck)
            continue
        end
        best_hands::Vector{Hand} = compare_hands(hands...)
        for hand in best_hands
            if hand.playerID == 1
                pot += num_players / length(best_hands)
            end
        end
        reshuffle!(deck)
    end
    equity = pot / (num_players * trials)
    put!(chan, (i, j, equity))
end

@time main(ARGS)

