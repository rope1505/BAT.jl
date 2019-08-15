# This file is a part of BAT.jl, licensed under the MIT License (MIT).

using BAT
using Test

using Distributions, PDMats, ShapesOfVariables

@testset "named_prior" begin
    prior = NamedPrior(a = 5, b = Normal(), c = -4..5, d = MvNormal([1.2 0.5; 0.5 2.1]))

    @test (@inferred logpdf(prior, [0.2, -0.4, 0.3, -0.5])) == logpdf(Normal(), 0.2) + logpdf(Uniform(-4, 5), -0.4) + logpdf(MvNormal([1.2 0.5; 0.5 2.1]), [0.3, -0.5])

    @test all([rand(prior) in param_bounds(prior) for i in 1:10^4])

    @test (@inferred cov(prior)) ≈
        [1.0  0.0   0.0  0.0;
         0.0  6.75  0.0  0.0;
         0.0  0.0   1.2  0.5;
         0.0  0.0   0.5  2.1]

    # ToDo: Add more tests
end