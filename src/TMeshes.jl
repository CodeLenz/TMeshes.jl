module TMeshes

using BMesh, LMesh

include("simply_supported2D.jl")
include("simply_supported3D.jl")
include("cantilever_beam_bottom2D.jl")
include("cantilever_beam_middle2D.jl")
include("inverter2D.jl")

export Simply_supported2D, Simply_supported3D
export Cantilever_beam_bottom2D
export Cantilever_beam_middle2D
export Inverter2D

end # module
