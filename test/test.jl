@testset "TMeshes" begin

    #################### Cantilever_beam_bottom2D ##########################
    # valid tests
    @test isa(Cantilever_beam_bottom2D(2,2), Mesh2D)
    @test isa(Cantilever_beam_bottom2D(2,2,:truss2D), Mesh2D)
    @test isa(Cantilever_beam_bottom2D(2,2,:solid2D), Mesh2D)


    # Should throw
    # @assert etype==:truss2D || etype==:solid2D "Cantilever_beam_bottom2D::etype must be truss2D or solid2D"
    @test_throws AssertionError Cantilever_beam_bottom2D(2,2,:bla)


    #################### Cantilever_beam_middle2D ##########################
    # valid tests
    @test isa(Cantilever_beam_middle2D(2,2), Mesh2D)
    @test isa(Cantilever_beam_middle2D(2,2,:truss2D), Mesh2D)
    @test isa(Cantilever_beam_middle2D(2,2,:solid2D), Mesh2D)


    # Should throw
    # @assert etype==:truss2D || etype==:solid2D "Cantilever_beam_middle2D::etype must be truss2D or solid2D"
    @test_throws AssertionError Cantilever_beam_middle2D(2,2,:bla)

    #@assert iseven(ny) "Cantilever_Beam_Middle2D::ny must be even"
    @test_throws AssertionError Cantilever_beam_middle2D(2,3)


    #################### Simply_supported2D ##########################
    # valid tests
    @test isa(Simply_supported2D(2,2), Mesh2D)
    @test isa(Simply_supported2D(2,2,:truss2D), Mesh2D)
    @test isa(Simply_supported2D(2,2,:solid2D), Mesh2D)


    # Should throw
    # @assert etype==:truss2D || etype==:solid2D "Simply_supported2D::etype must be truss2D or solid2D"
    @test_throws AssertionError Simply_supported2D(2,2,:bla)

    #@assert iseven(ny) "Simply_supported2D::nx must be even"
    @test_throws AssertionError Simply_supported2D(3,2)


    #################### Simply_supported3D ##########################
    # valid tests
    @test isa(Simply_supported3D(2,2,2), Mesh3D)
    @test isa(Simply_supported3D(2,2,2,:truss3D), Mesh3D)
    @test isa(Simply_supported3D(2,2,2,:solid3D), Mesh3D)


    # Should throw
    # @assert iseven(nx)&&iseven(ny) "Simply_Supported3D::nx and ny must be even"
    @test_throws AssertionError Simply_supported3D(3,2,2)
    @test_throws AssertionError Simply_supported3D(2,3,2)
    @test_throws AssertionError Simply_supported3D(3,3,2)
       

end
