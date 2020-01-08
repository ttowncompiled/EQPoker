#!/bin/bash

julia EQPoker.jl 2 1000000 results/equity-heads-up.csv
julia EQPoker.jl 3 1000000 results/equity-three.csv
julia EQPoker.jl 4 1000000 results/equity-four.csv
julia EQPoker.jl 5 1000000 results/equity-five.csv
julia EQPoker.jl 6 1000000 results/equity-six.csv
julia EQPoker.jl 7 1000000 results/equity-seven.csv
julia EQPoker.jl 8 1000000 results/equity-eight.csv
julia EQPoker.jl 9 1000000 results/equity-nine.csv

