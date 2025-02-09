module TestAqua

using Aqua
using Setfield
using Test
using Transducers

# https://github.com/JuliaCollections/DataStructures.jl/pull/511
to_exclude = [Base.get, Setfield.set, Setfield.modify, map!]

# These are needed because of a potential ambiguity with ChainRulesCore's mapfoldl on a Thunk.
if isdefined(Core, :kwcall)
    push!(to_exclude, Core.kwcall)

    Aqua.test_all(
        Transducers;
        ambiguities = (; exclude = to_exclude),
        unbound_args = false,  # TODO: make it work
        project_toml_formatting = false,  # this fails every single time a valid change is made to Project which is infuriating
    )

    @testset "Compare test/Project.toml and test/environments/main/Project.toml" begin
        @test Text(read(joinpath(@__DIR__, "Project.toml"), String)) ==
            Text(read(joinpath(@__DIR__, "environments", "main", "Project.toml"), String))
    end
else
    nothing
    # Let's just skip this for now on old versions that don't have kwcall, it's too annoying to deal with.
end



end  # module
