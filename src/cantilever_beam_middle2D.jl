
#
#     \----------------
#     \               |
#     \       Ω       | ↓ F
#     \               |
#     \----------------
#
#
#

function Cantilever_beam_middle2D(nx::Int64,ny::Int64,etype=:truss2D;   
                                  Lx=8.0, Ly=5.0, force=1.0, A=1E-4, Ex=1E9,
                                  νxy=0.0,
                                  density=7850.0, thickness=0.1,limit_stress=1E6,
                                  options = Dict{Symbol,Matrix{Float64}}())


    @assert etype==:truss2D || etype==:solid2D "Cantilever_Beam_Middle2D::etype must be truss2D or solid2D"
    @assert iseven(ny) "Cantilever_Beam_Middle2D::ny must be even"
  
  
    # Generate the mesh
    if etype==:truss2D
        bmesh = Bmesh_truss_2D(Lx,nx,Ly,ny)
    elseif etype==:solid2D
        bmesh = Bmesh_solid_2D(Lx,nx,Ly,ny)
    end
     
    nhebc = 2*(ny+1)
    hebc = Array{Int64}(undef,nhebc,2)
    node = 1
    pos = 0
    for i=1:(ny+1)
        pos += 1
        hebc[pos,:] = [node 1]
        pos += 1
        hebc[pos,:] = [node 2]
        node += (nx+1)
    end

    # Generate the load information
    no_forca = (ny/2+1)*(nx+1)
    nbc = [no_forca 2 -force]

    # Vamos definir Ex e A "fixos" -> valores muito "chutados"
    mat = [Material(Ex=Ex,density=density,νxy=νxy,limit_stress=limit_stress)]
    geom = [Geometry(A=A, thickness=thickness)]

    # Se o elemento for de elasticidade ligamos o IS_TOPO
    if etype==:solid2D
        options[:IS_TOPO]=ones(1,1)
        options[:INCOMPATIBLE]=ones(1,1)
    end

    # Gera a malha e devolve um tipo Mesh2D
    Mesh2D(bmesh,mat,geom,hebc,nbc,options=options)

end

