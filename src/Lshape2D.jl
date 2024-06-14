#
# Example to show the use of BMesh.Merge and 
# selection tools
#

#
#    
#   XXXX-
#  | Lxv |            | Force
#  |     | Lyv       \/
#  |----------------|
#  |                | Lyh
#  -----------------|
#         Lxh
#
function Lshape2D(nxh::Int64,nyh::Int64,
                  nxv::Int64,nyv::Int64,
                  etype=:truss2D;   
    Lxh=1.0, Lyh=0.5, 
    Lxv=0.5, Lyv=0.5,
    force=1.0, A=1E-4 ,Ex=1E9,
    νxy=0.0,
    density=7850.0,thickness=0.1,
    limit_stress=1E6,
    options = Dict{Symbol,Matrix{Float64}}())

    @assert etype==:truss2D || etype==:solid2D "Lshape2D::etype must be truss2D or solid2D"


    # We must keep the same proportions
    ratio_x_h = Lxh/nxh
    ratio_y_h = Lyh/nyh
    ratio_x_v = Lxv/nxv
    ratio_y_v = Lyv/nyv

    @assert isapprox(ratio_x_h,ratio_x_v) "Lshape2D::check ratios"

    # Generate horizontal mesh
    if etype==:truss2D   
        b1 = Bmesh_truss_2D(Lxh,nxh,Lyh,nyh)
    elseif etype==:solid2D
        b1 = Bmesh_solid_2D(Lxh,nxh,Lyh,nyh)
    end

    # Generate vertical mesh
    origin = (0.0,Lyh)
    if etype==:truss2D   
        b2 = Bmesh_truss_2D(Lxv,nxv,Lyv,nyv,origin=origin)
    elseif etype==:solid2D
        b2 = Bmesh_solid_2D(Lxv,nxv,Lyv,nyv,origin=origin)
    end

    # Merge 
    bm = Merge(b1,b2)

    # Node to apply the force
    nf = Find_node(bm,Lxh,Lyh)

    # Generate the load information
    nbc = [nf 2 -force]

    # Nodes to clamp
    nodes = Find_nodes_in_rectangle(bm,0.0,Lyh+Lyv-1E-6,Lxv,Lyh+Lyv+1E-6)

    @assert !isempty(nodes) "Lshape2D::no nodes to use in ebc"

    nhebc = length(nodes)
    hebc = zeros(Int64,2*nhebc,2)
    pos = 1
    for i=1:nebc
        hebc[pos,1] = nodes[i]; hebc[pos,2] = 1; pos+=1;
        hebc[pos,1] = nodes[i]; hebc[pos,2] = 2; pos+=1;
    end

    # Vamos definir Ex e A "fixos" -> valores muito "chutados"
    mat = [Material(Ex=Ex,density=density,νxy=νxy,limit_stress=limit_stress)]
    geom = [Geometry(A=A, thickness=thickness)]

    # Se o elemento for de elasticidade ligamos o IS_TOPO
    if etype==:solid2D
        options[:IS_TOPO]=ones(1,1)
        options[:INCOMPATIBLE]=ones(1,1)
    end

    # Gera a malha e devolve um tipo Mesh2D
    Mesh2D(bm,mat,geom,hebc,nbc,options=options)

end
