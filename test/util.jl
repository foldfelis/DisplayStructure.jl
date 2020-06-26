@testset "Util" begin

    @testset "cursors" begin
        io = IOBuffer()
        DS.clear(io)
        @test String(take!(io)) == "\e[2J"

        DS.show_cursor(io)
        @test String(take!(io)) == "\e[?25h"

        DS.show_cursor(io, false)
        @test String(take!(io)) == "\e[?25l"

        DS.move_cursor(io, 2, 3)
        @test String(take!(io)) == "\e[2;3H"

        DS.move_cursor_up(io, 5)
        @test String(take!(io)) == "\e[5A"

        DS.move_cursor_down(io, 5)
        @test String(take!(io)) == "\e[5B"

        DS.move_cursor_right(io, 5)
        @test String(take!(io)) == "\e[5C"

        DS.move_cursor_left(io, 5)
        @test String(take!(io)) == "\e[5D"

        DS.move_cursor2last_line(io)
        @test String(take!(io)) == "\e[$(TERM_SIZE[1]);1H"

        DS.save_cursor(io)
        @test String(take!(io)) == "\e[s"

        DS.restore_cursor(io)
        @test String(take!(io)) == "\e[u"

        @test DS.get_term_size() == TERM_SIZE .- (1, 0)

    end

    @testset "util" begin
        str = "This is a 寬度不一的 Char array."
        str = DS.padding(str, 50)
        @test textwidth(str) == 50
    end

    @testset "font style" begin
        io = IOBuffer()
        R, G, B = color = (255, 0, 0)
        style = [:bold, :underline, :blink]

        DS.@styled io style color begin
            join(io, ["Hi", "\n"])
            join(io, ['T', 'H', 'E', 'R', 'E'])
        end

        @test String(take!(io)) ==
            "\e[38;2;$(R);$(G);$(B)m" *
            "\e[1m\e[4m\e[5m" *
            "Hi\nTHERE" *
            "\e[0m"
    end

    @testset "cursor explored and resetted" begin
        io = IOBuffer()

        DS.@cursor_explored io begin
            join(io, ["Hi", "\n"])
            join(io, ['T', 'H', 'E', 'R', 'E'])
        end

        @test String(take!(io)) ==
            "\e[$(TERM_SIZE[1]);1H" *
            "Hi\nTHERE"

        DS.@cursor_resetted io begin
            join(io, ["Hi", "\n"])
            join(io, ['T', 'H', 'E', 'R', 'E'])
        end

        @test String(take!(io)) ==
            "Hi\nTHERE" *
            "\e[$(TERM_SIZE[1]);1H"

        # mix
        R, G, B = color = (255, 0, 0)
        style = [:bold, :underline, :blink]
        ans =
            "\e[$(TERM_SIZE[1]);1H" *
            "\e[38;2;$(R);$(G);$(B)m" *
            "\e[1m\e[4m\e[5m" *
            "Hi\nTHERE" *
            "\e[0m" *
            "\e[$(TERM_SIZE[1]);1H"

        DS.@cursor_resetted io begin
            DS.@cursor_explored io begin
                DS.@styled io style color begin
                    join(io, ["Hi", "\n"])
                    join(io, ['T', 'H', 'E', 'R', 'E'])
                end
            end
        end

        @test String(take!(io)) == ans

        DS.@cursor_explored io begin
            DS.@cursor_resetted io begin
                DS.@styled io style color begin
                    join(io, ["Hi", "\n"])
                    join(io, ['T', 'H', 'E', 'R', 'E'])
                end
            end
        end

        @test String(take!(io)) == ans

    end

end
