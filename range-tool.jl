#!/bin/julia

using CSV
using DelimitedFiles

function main(args)
    input = args[1]
    output = args[2]
    k = parse(Float64, args[3])
    equity = CSV.read(input)
    range = zeros(Int, 13, 13)
    for i in 1:13
        for j in 1:13
            range[i, j] = if equity[i, j] >= k 1 else 0 end
        end
    end
    writedlm(output, ["A" "K" "Q" "J" "T" "9" "8" "7" "6" "5" "4" "3" "2"], ",")
    open(output, "a") do io
        writedlm(io, range, ",")
    end
end

main(ARGS)

