include("./lib/core/eq-core.jl")
include("./lib/core/score-engine.jl")
include("./lib/core/dealer.jl")

using DelimitedFiles

function main(args)
    num_players = parse(Int, args[1])
    trials = parse(Int, args[2])
    range_equity::Array{Float64, 2} = zeros(Float64, 13, 13)
    for i in 1:13
        for j in 1:13
            pot::Float64 = trials
            for t in 1:trials
                pot -= 1
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
                predeal_shuffle!(deck)
                players::Vector{Player} = []
                for p in 2:num_players
                    push!(players, Player(2, Hole(2, Card(Ranks.NULL, Suits.NULL), Card(Ranks.NULL, Suits.NULL))))
                end
                deal!(deck, players...)
                players = vcat([player], players)
                board::Board = Board(Card(Ranks.NULL, Suits.NULL), Card(Ranks.NULL, Suits.NULL), Card(Ranks.NULL, Suits.NULL), Card(Ranks.NULL, Suits.NULL), Card(Ranks.NULL, Suits.NULL))
                flop!(deck, board)
                turn!(deck, board)
                river!(deck, board)
                hands::Vector{Hand} = []
                for p in 1:num_players
                    push!(hands, score(players[p], board))
                end
                best_hands::Vector{Hand} = compare_hands(hands...)
                for hand in best_hands
                    if hand.playerID == 1
                        pot += num_players / length(best_hands)
                    end
                end
            end
            equity = pot / (num_players * trials)
            range_equity[i, j] = round(equity, digits=2)
        end
    end
    writedlm("results.csv", range_equity, ",")
end

main(ARGS)

