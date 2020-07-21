@testset "Util" begin

    str = "This is a 寬度不一的 Char array."
    str = DS.padding(str, 50)
    @test textwidth(str) == 50

end
