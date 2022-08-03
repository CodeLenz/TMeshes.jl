
#
#     X----------------
#     |               |
#     |       Ω       | 
#  F  |               | 
# --> |----------------
#      ooooooooooooooo
#     ----------------- 
#
function Inverter2D(nx::Int64,ny::Int64,etype=:truss2D;   
                    Lx=1.0, Ly=0.5, force=1.0, A=1E-4 ,Ex=1E9,
                    νxy=0.0, density=7850.0,thickness=0.1,
                    limit_stress=1E6,
                    options = Dict{Symbol,Matrix{Float64}}())

    @assert etype==:truss2D || etype==:solid2D "Inverter2D::etype must be truss2D or solid2D"

    # Generate the mesh
    if etype==:truss2D
        bmesh = Bmesh_truss_2D(Lx,nx,Ly,ny)
    elseif etype==:solid2D
        bmesh = Bmesh_solid_2D(Lx,nx,Ly,ny)
    end

    # Generate the supports
    # Symmetry conditions at the bottom + hinge at top left
    nebc = nx+1 + 2
    ebc = Array{Float64}(undef,nebc,3)

    # Symmetry condition (botttom)
    node = 1
    pos = 0
    for i=1:nx+1
        pos += 1
        ebc[i,:] = [i 2 0.0]
    end

    # Upper left node 
    node = (nx+1)*(ny) + 1
    ebc[end-1,:] = [node 1 0.0]
    ebc[end,:]   = [node 2 0.0]
    
    # Generate the load information
    node = 1
    nbc = [node 1 force]

    # Material and geometry
    mat = [Material(Ex=Ex,density=density,νxy=νxy,limit_stress=limit_stress)]
    geom = [Geometry(A=A, thickness=thickness)]

    # Se o elemento for de elasticidade ligamos o IS_TOPO
    if etype==:solid2D
        options[:IS_TOPO]=ones(1,1)
    end

    # Generate the mesh
    Mesh2D(bmesh,mat,geom,ebc,nbc,options=options)

end
