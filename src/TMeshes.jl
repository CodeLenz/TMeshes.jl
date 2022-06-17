################################################################################
# Generates the proper mesh and boundary conditions
# for some common examples
#
# nx -> number of cells in x direction
# ny -> number of cells in y direction
# nz -> number of cells in z direction
################################################################################


module TMeshes

using BMesh, LMesh

include("simply_supported2D.jl")
include("cantilever_beam_bottom2D.jl")
include("cantilever_beam_middle2D.jl")

export Simply_supported2D,Cantilever_beam_bottom2D, Cantilever_beam_middle2D

end # module
