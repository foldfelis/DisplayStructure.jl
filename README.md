<h1 align="center">
    <img width="400" src="gallery/logo.png" alt="Display Structure">
    <br>
</h1>

| **Build Status**                                              |
|:-------------------------------------------------------------:|
| [![][travis-img]][travis-url] [![][codecov-img]][codecov-url] |

[travis-img]: https://travis-ci.com/foldfelis/DisplayStructure.jl.svg?branch=master

[travis-url]: https://travis-ci.com/github/foldfelis/DisplayStructure.jl

[codecov-img]: https://codecov.io/gh/foldfelis/DisplayStructure.jl/branch/master/graph/badge.svg

[codecov-url]: https://codecov.io/gh/foldfelis/DisplayStructure.jl

# Display Structure

DisplayArray provides arrays that index character in text width unit. And therefore maintains an immutable display size for terminal emulators.

## Quick start

The package can be installed with the Julia package manager.
From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```julia
pkg> add DisplayStructure
```

## Usage

1. Using package

```julia
julia> using DisplayStructure; const DS = DisplayStructure;
```

2. Declare an area

```julia
julia> area = DS.DisplayArray(DS.Rectangle(20, 100))
DisplayArray(size=(20, 100), background char=Char(32))
```

3. Declare a label

```julia
julia> str = "會動的字串"; width = textwidth(str); label = DS.DisplayRow(width)
DisplayRow(size=10, background char=Char(32))

julia> label[1:end] = str
"會動的字串"
```

4. Render area and label

```julia
julia> DS.render(area, pos=(1, 1)); DS.render(label, pos=(5, 5))
```

![](gallery/usage.png)

> **Hint: The result may be different from the picture showing above. One may need to integrate [Terming.jl](https://github.com/foldfelis/Terming.jl) to completely dominate terminal control.**

## Example

The [example](example/example.jl) demonstrates a minimum viable product
that shows a border and a string. Integrate with [keyboard key reading feature](https://gist.github.com/foldfelis/375dc13b2d3be792fdf029466d7761d0) (implemented under [Terming.jl](https://github.com/foldfelis/Terming.jl)), the movable string can be controlled by pressing `w`, `s`, `a` and `d`, press `ESC` to quit.

It is recommended that one use [Crayons.jl](https://github.com/KristofferC/Crayons.jl) to gain more decorations. A [example](example/logo.jl) shows how to integrate with Crayons.
