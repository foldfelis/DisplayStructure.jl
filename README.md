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

2. Declear an area

```julia
julia> area = DS.DisplayArray(DS.Rectangle(20, 100))
DisplayArray(size=(20, 100), background char=Char(32))

julia> a_color = (93, 173, 226); a_style = [:bold];
```

3. Declear a label

```julia
julia> str = "會動的字串"; width = textwidth(str); label = DS.DisplayRow(width)
DisplayRow(size=10, background char=Char(32))

julia> label[1:end] = str
"會動的字串"

julia> l_color = (82, 190, 128); l_style = Symbol[]; label_pos = (5, 5);
```

4. Declear a IO buffer for rendering

```julia
julia> buffer = IOBuffer();
```

5. Hide cursor

```julia
julia> DS.show_cursor(buffer, false)
```

6. Render area

```julia
julia> DS.set_style(buffer, a_style, a_color)

julia> DS.render(buffer, area, pos=(1, 1))

julia> DS.reset_style(buffer)
```

7. Render label

```julia
julia> DS.set_style(buffer, l_style, l_color)

julia> DS.render(buffer, label, pos=label_pos)

julia> DS.reset_style(buffer)
```

8. Reset cursor back to last line

```julia
julia> DS.move_cursor2last_line(buffer)
```

9. Show cursor

```julia
julia> DS.show_cursor(buffer, true)
```

10. Redirect IO from buffer to STDOUT

```julia
julia> write(stdout, take!(buffer))
```

![](gallery/usage.png)

## Example

The [example](example/example.jl) demostrates a minimum viable product
that shows a border and a label.
Integrate with
[keyboard key reading feature](https://gist.github.com/foldfelis/375dc13b2d3be792fdf029466d7761d0),
the movable label can be contraled by pressing `w` `s` `a` `d` .
Pressing `ESC` to quit loop.

The [style functions](src/util.jl#L43) defined under [util.jl](src/util.jl) provide a easy way to set font color and style.
It is recommended that one use [Crayons](https://github.com/KristofferC/Crayons.jl) to gain more decorations.
A [example](example/logo.jl) shows how to integrate with Crayons.
