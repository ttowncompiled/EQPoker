#!/bin/bash

julia EQPoker.jl 2 1000000 range/all.csv results/equity-2.csv
julia EQPoker.jl 3 1000000 range/all.csv results/equity-3.csv
julia EQPoker.jl 4 1000000 range/all.csv results/equity-4.csv
julia EQPoker.jl 5 1000000 range/all.csv results/equity-5.csv
julia EQPoker.jl 6 1000000 range/all.csv results/equity-6.csv
julia EQPoker.jl 7 1000000 range/all.csv results/equity-7.csv
julia EQPoker.jl 8 1000000 range/all.csv results/equity-8.csv
julia EQPoker.jl 9 1000000 range/all.csv results/equity-9.csv
zip -r results.zip results/

