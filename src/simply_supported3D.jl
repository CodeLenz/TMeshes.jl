#      z
#      |
#      ----------------                X-------------X ---->y
#      |              |                |             |
#      |      Ω       |                |      F      |
#      |              |                |             |
#    > ----------------< ----->y       X-------------X 
#      𝝙      ↓      𝝙                 | 
#             F                        x
#       Front View                         Top view 
#  
function Simply_supported3D(nx::Int64,ny::Int64,nz::Int64,etype=:truss3D;   
                          Lx=1.0, Ly=1.0, Lz=1.0, force=1.0, A=1E-4 ,Ex=1E9,
                          νxy=0.0,
                          density=7850.0,thickness=0.1,
                          limit_stress=1E6,
                          options = Dict{Symbol,Matrix{Float64}}())



    # nx and ny have to be even, since the load is exactly at the (bottom) center
    @assert iseven(nx)&&iseven(ny) "Simply_Supported3D::nx and ny must be even"

    @assert etype==:truss3D || etype==:solid3D "Simply_Supported3D:: $etype must be :truss3D or :solid3D"

    # Generate the mesh
    if etype==:truss3D
       bmesh = Bmesh_truss_3D(Lx,nx,Ly,ny,Lz,nz)
    else
      bmesh = Bmesh_solid_3D(Lx,nx,Ly,ny,Lz,nz)
    end

    # Generate the supports: one at each corner of
    # plane Z=0
    hebc = [1 1 ;
           1 2 ;
           1 3 ;
          nx+1 1 ;
          nx+1 2 ;
          nx+1 3 ;
          (nx+1)*ny+1 1 ; 
          (nx+1)*ny+1 2 ; 
          (nx+1)*ny+1 3  ;
          (nx+1)*(ny+1) 1  ;
          (nx+1)*(ny+1) 2  ;
          (nx+1)*(ny+1) 3  ]
                                      
                         
    # Generate the load information
    no_forca = (nx/2+1)  +  (nx+1)*(ny/2)
    nbc = [no_forca 3 -force]

    # Vamos definir Ex e A "fixos" -> valores muito "chutados"
    mat = [Material(Ex=Ex,density=density, νxy=νxy,limit_stress=limit_stress)]
    geom = [Geometry(A=A, thickness=thickness)]

    # Se o elemento for de elasticidade ligamos o IS_TOPO
    if etype==:solid3D
      options[:IS_TOPO]=ones(1,1)
      options[:INCOMPATIBLE]=ones(1,1)
    end

    # Gera a malha e devolve um tipo Mesh3D
    Mesh3D(bmesh,mat,geom,hebc,nbc,options=options)

end
