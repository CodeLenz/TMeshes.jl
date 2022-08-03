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
function Lshape3D(nxh::Int64,nyh::Int64,nzh::Int64,
                  nxv::Int64,nyv::Int64,nzv::Int64,
    etype=:truss3D;   
Lxh=1.0, Lyh=0.5, Lzh=0.5,
Lxv=0.5, Lyv=0.5, Lzv=0.5,
force=1.0, A=1E-4 ,Ex=1E9,
νxy=0.0,
density=7850.0,thickness=0.1,
options = Dict{Symbol,Matrix{Float64}}())

    @assert etype==:truss3D || etype==:solid3D "Lshape3D::etype must be truss2D or solid2D"


    # We must keep the same proportions
    ratio_x_h = Lxh/nxh
    ratio_y_h = Lyh/nyh
    ratio_z_h = Lzh/nzh

    ratio_x_v = Lxv/nxv
    ratio_y_v = Lyv/nyv
    ratio_z_v = Lzv/nzv

    @assert isapprox(ratio_x_h,ratio_x_v) "Lshape3D::check ratios in x"
    @assert isapprox(ratio_z_h,ratio_z_v) "Lshape3D::check ratios in z"


    # Generate horizontal mesh
    if etype==:truss3D       
        b1 = Bmesh_truss_3D(Lxh,nxh,Lyh,nyh,Lzh,nzh)
    elseif etype==:solid3D
        b1 = Bmesh_solid_3D(Lxh,nxh,Lyh,nyh,Lzh,nzh)
    end

    # Generate vertical mesh
    origin = (0.0,Lyh,0.0)
    if etype==:truss3D       
        b2 = Bmesh_truss_3D(Lxv,nxv,Lyv,nyv,Lzv,nzv,origin=origin)
    elseif etype==:solid3D
        b2 = Bmesh_solid_3D(Lxv,nxv,Lyv,nyv,Lzv,nzv,origin=origin)
    end

    # Merge 
    bm = Merge(b1,b2)

    # Nodes to apply the force
    nf = Find_nodes_in_box(bm,Lxh-1E-6,Lyh-1E-6,0.0, Lxh+1E-6,Lyh+1E-6,Lzh)
    @assert !isempty(nf) "Lshape2D::no nodes to use in nbc"
    nnbc = length(nf)

    @assert nnbc >= 2

    nbc = zeros(nnbc,3)

    # The inner nodes must have twice  the value of the boundary nodes
    inner_nodes = nnbc-2
    f_node = force/(inner_nodes+1)

    # Boudary nodes
    nbc[1,1] = nf[1]; nbc[1,2] = 2; nbc[1,3] = -f_node/2
    nbc[end,1] = nf[end]; nbc[end,2] = 2; nbc[end,3] = -f_node/2

    # Inner nodes
    for i=2:nnbc-1
        nbc[i,1] = nf[i]; nbc[i,2] = 2; nbc[i,3] = -f_node
    end


    # Nodes to clamp
    nodes = Find_nodes_in_box(bm,0.0,Lyh+Lyv-1E-6,0.0,
                                Lxv,Lyh+Lyv+1E-6,Lzh)

    @assert !isempty(nodes) "Lshapee3D::no nodes to use in ebc"

    nebc = length(nodes)
    ebc = zeros(3*nebc,3)
    pos = 1
    for i=1:nebc
        ebc[pos,1] = nodes[i]; ebc[pos,2] = 1; pos+=1;
        ebc[pos,1] = nodes[i]; ebc[pos,2] = 2; pos+=1;
        ebc[pos,1] = nodes[i]; ebc[pos,2] = 3; pos+=1;
    end

    # Vamos definir Ex e A "fixos" -> valores muito "chutados"
    mat = [Material(Ex=Ex,density=density,νxy=νxy)]
    geom = [Geometry(A=A, thickness=thickness)]

    # Se o elemento for de elasticidade ligamos o IS_TOPO
    if etype==:solid3D
        options[:IS_TOPO]=ones(1,1)
    end

    # Gera a malha e devolve um tipo Mesh2D
    Mesh3D(bm,mat,geom,ebc,nbc,options=options)

end
