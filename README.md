# Display Structure

| **Build Status**                                              |
|:-------------------------------------------------------------:|
| [![][travis-img]][travis-url] [![][codecov-img]][codecov-url] |

[travis-img]: https://travis-ci.com/foldfelis/DisplayStructure.jl.svg?branch=master

[travis-url]: https://travis-ci.com/github/foldfelis/DisplayStructure.jl

[codecov-img]: https://codecov.io/gh/foldfelis/DisplayStructure.jl/branch/master/graph/badge.svg

[codecov-url]: https://codecov.io/gh/foldfelis/DisplayStructure.jl

DisplayArray provides arrays that index charector in text width unit. And therefore maintains an immutable display size for terminal emulators.

## Quick start

The package can be installed with the Julia package manager.
From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```julia-repl
pkg> add https://github.com/foldfelis/DisplayStructure.jl
```

## Usage

```julia-repl
julia> using DisplayStructure
julia> array = DisplayArray(10, 40, background='.');
julia> render(stdout, array)
........................................
........................................
........................................
........................................
........................................
........................................
........................................
........................................
........................................
........................................
```
