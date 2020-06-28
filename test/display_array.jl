@testset "DisplayArray" begin

    io = IOBuffer()

    array = DS.DisplayArray(10, 40, background='.')

    @test repr(array) == "DisplayArray(" *
        "size=(10, 40), " *
        "background char=Char(46)" *
    ")"

    DS.render(io, array)
    @test String(take!(io)) ==
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B"

    array[6, 8] = '噢'
    DS.render(io, array)
    @test String(take!(io)) ==
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s.......噢...............................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B"

    array[4:6, 8:19] = "這是一段\n非常感性的\n字串"
    DS.render(io, array)
    @test String(take!(io)) ==
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s.......這是一段.........................\e[u\e[1B" *
        "\e[s.......非常感性的.......................\e[u\e[1B" *
        "\e[s.......字串.............................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B"

    # style
    R, G, B = color = (255, 0, 0)
    style = [:bold, :underline, :blink]

    DS.set_style(io, style, color)
    DS.render(io, array)
    DS.reset_style(io)

    @test String(take!(io)) ==
        "\e[38;2;$(R);$(G);$(B)m\e[1m\e[4m\e[5m" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s.......這是一段.........................\e[u\e[1B" *
        "\e[s.......非常感性的.......................\e[u\e[1B" *
        "\e[s.......字串.............................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[0m"

    # pos
    DS.render(io, array, pos=(5, 6))
    @test String(take!(io)) ==
        "\e[5;6H" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s.......這是一段.........................\e[u\e[1B" *
        "\e[s.......非常感性的.......................\e[u\e[1B" *
        "\e[s.......字串.............................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B"

    # last index
    array[2, end-1] = '哈'
    DS.render(io, array)
    @test String(take!(io)) ==
        "\e[s........................................\e[u\e[1B" *
        "\e[s......................................哈\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s.......這是一段.........................\e[u\e[1B" *
        "\e[s.......非常感性的.......................\e[u\e[1B" *
        "\e[s.......字串.............................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B"

end
