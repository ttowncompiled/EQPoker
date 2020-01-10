#!/bin/bash

julia EQPoker.jl 2 1000000 range/geq50-2.csv results/equity-geq50-2.csv
julia EQPoker.jl 2 1000000 range/geq45-2.csv results/equity-geq45-2.csv
julia EQPoker.jl 3 1000000 range/geq33-3.csv results/equity-geq33-3.csv
julia EQPoker.jl 3 1000000 range/geq30-3.csv results/equity-geq30-3.csv
julia EQPoker.jl 6 1000000 range/geq16-6.csv results/equity-geq16-6.csv
julia EQPoker.jl 6 1000000 range/geq15-6.csv results/equity-geq15-6.csv
julia EQPoker.jl 9 1000000 range/geq11-9.csv results/equity-geq11-9.csv
julia EQPoker.jl 9 1000000 range/geq10-9.csv results/equity-geq10-9.csv
zip -r results.zip results/

