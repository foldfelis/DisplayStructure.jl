@testset "Util" begin

    @testset "util" begin
        str = "This is a 寬度不一的 Char array."
        str = DS.padding(str, 50)
        @test textwidth(str) == 50
    end

    @testset "font style" begin
        io = IOBuffer()

        str = "I am bolded, underlined, blinked red string"
        R, G, B = color = (255, 0, 0)

        DS.println_style(
            io,
            collect(str),
            [:bold, :underline, :blink],
            color
        )
        @test String(take!(io)) ==
            "\e[38;2;$(R);$(G);$(B)m" *
            "\e[1m\e[4m\e[5m" *
            str * "\n" *
            "\e[0m"

        DS.println_style(
            io,
            [str],
            [:bold, :underline, :blink],
            color
        )
        @test String(take!(io)) ==
            "\e[38;2;$(R);$(G);$(B)m" *
            "\e[1m\e[4m\e[5m" *
            str * "\n" *
            "\e[0m"

    end

end
