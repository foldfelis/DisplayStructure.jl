@testset "DisplayRow" begin

    io = IOBuffer()

    row = DS.DisplayRow(40, background='.')
    @test lastindex(row) == length(row)
    @test textwidth(join(row.content)) == length(row)
    DS.render(io, row)
    @test String(take!(io)) ==
        "........................................\n" *
        "\e[0m"

    row[10] = '字'
    DS.render(io, row)
    @test String(take!(io)) ==
        ".........字.............................\n" *
        "\e[0m"

    @test DS.get_element_index(row, 10) == (i=10, pre=0, post=1)


    row[3:7] = "兩bit"
    DS.render(io, row)
    @test String(take!(io)) ==
        "..兩bit..字.............................\n" *
        "\e[0m"

    @test DS.get_element_index(row, 4) == (i=3, pre=1, post=0)
    @test textwidth(join(row.content)) == length(row)

    deleteat!(row, 5) # 'b'
    @test DS.get_element_index(row, 30) == (i=28, pre=0, post=0)
    @test textwidth(join(row.content)) == length(row)
    DS.render(io, row)
    @test String(take!(io)) ==
        "..兩.it..字.............................\n" *
        "\e[0m"

    deleteat!(row, 4) # '兩'
    @test DS.get_element_index(row, 30) == (i=29, pre=0, post=0)
    @test textwidth(join(row.content)) == length(row)
    DS.render(io, row)
    @test String(take!(io)) ==
        ".....it..字.............................\n" *
        "\e[0m"

    # style
    R, G, B = color = (255, 0, 0)
    style = [:bold, :underline, :blink]
    DS.render(io, row, style=style, color=color)
    @test String(take!(io)) ==
        "\e[38;2;$(R);$(G);$(B)m" *
        "\e[1m\e[4m\e[5m" *
        ".....it..字.............................\n" *
        "\e[0m"

end
