
#
#      ----------------
#      |              |
#      |      Ω       |
#      |              |
#    > ----------------<
#      𝝙      ↓      𝝙
#             F
#
function Simply_supported2D(nx::Int64,ny::Int64,etype=:truss2D;   
                          Lx=1.0, Ly=1.0, force=1.0, A=1E-4 ,Ex=1E9,
                          νxy=0.0,
                          density=7850.0,thickness=0.1,
                          options = Dict{Symbol,Matrix{Float64}}())



    # Nx has to be even, since the load is exactly at the (bottom) center
    @assert iseven(nx) "Simply_Supported2D::nx must be even"

    @assert etype==:truss2D || etype==:solid2D "Simply_Supported2D::etype must be truss2D or solid2D"

    # Generate the mesh
    if etype==:truss2D
       bmesh = Bmesh_truss_2D(Lx,nx,Ly,ny)
    elseif etype==:solid2D
       bmesh = Bmesh_solid_2D(Lx,nx,Ly,ny)
    end

    # Generate the supports
    ebc = [1 1 0.0;
           1 2 0.0;
          nx+1 1 0.0;
          nx+1 2 0.0]

    # Generate the load information
    no_forca = (nx/2)+1
    nbc = [no_forca 2 -force]

    # Vamos definir Ex e A "fixos" -> valores muito "chutados"
    mat = [Material(Ex=Ex,density=density,νxy=νxy)]
    geom = [Geometry(A=A, thickness=thickness)]

   # Se o elemento for de elasticidade ligamos o IS_TOPO
   if etype==:solid2D
      options[:IS_TOPO]=ones(1,1)
   end

    # Gera a malha e devolve um tipo Mesh2D
    Mesh2D(bmesh,mat,geom,ebc,nbc,options=options)

end
