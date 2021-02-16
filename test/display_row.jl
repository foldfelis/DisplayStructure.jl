@testset "DisplayRow" begin

    row = DS.DisplayRow(40, background='.')

    @test repr(row) == "DisplayRow(" *
        "size=40, " *
        "background char=Char(46)" *
    ")"

    @test lastindex(row) == length(row)
    @test textwidth(Base.join(row.content)) == length(row)
    DS.render(row)
    @test T.read_stream(T.out_stream)  ==
        "........................................"

    row[10] = '字'
    DS.render(row)
    @test T.read_stream(T.out_stream)  ==
        ".........字............................."

    @test DS.get_element_index(row, 10) == (i=10, pre=0, post=1)

    row[3:7] = "兩bit"
    DS.render(row)
    @test T.read_stream(T.out_stream)  ==
        "..兩bit..字............................."

    @test DS.get_element_index(row, 4) == (i=3, pre=1, post=0)
    @test textwidth(Base.join(row.content)) == length(row)

    row[16:20] = "很棒"
    DS.render(row, pos=(5, 6))
    @test T.read_stream(T.out_stream)  ==
        "\e[5;6H" *
        "..兩bit..字....很棒....................."

    @test DS.get_element_index(row, 17) == (i=14, pre=1, post=0)
    @test textwidth(Base.join(row.content)) == length(row)

    deleteat!(row, 5) # 'b'
    @test DS.get_element_index(row, 30) == (i=26, pre=0, post=0)
    @test textwidth(Base.join(row.content)) == length(row)
    DS.render(row)
    @test T.read_stream(T.out_stream)  ==
        "..兩.it..字....很棒....................."

    deleteat!(row, 4) # '兩'
    @test DS.get_element_index(row, 30) == (i=27, pre=0, post=0)
    @test textwidth(Base.join(row.content)) == length(row)
    DS.render(row)
    @test T.read_stream(T.out_stream)  ==
        ".....it..字....很棒....................."

    # pos
    DS.render(row, pos=(5, 6))
    @test T.read_stream(T.out_stream)  ==
        "\e[5;6H" *
        ".....it..字....很棒....................."

end
