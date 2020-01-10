#!/bin/bash

julia EQPoker.jl 2 1000000 range/preflop-raise.csv results/equity-preflop-raise-2.csv
julia EQPoker.jl 3 1000000 range/preflop-raise.csv results/equity-preflop-raise-3.csv
julia EQPoker.jl 6 1000000 range/preflop-raise.csv results/equity-preflop-raise-6.csv
julia EQPoker.jl 9 1000000 range/preflop-raise.csv results/equity-preflop-raise-9.csv
zip -r results.zip results/

