# TMeshes
Some common meshes for topology optimization problems

Some examples

```julia

# Simply supported problem with 2D trusses: 6 x 6 grid
Simply_supported2D(6,6)

# Simply supported problem with 2D solid: 6 x 6 grid
Simply_supported2D(6,6,:solid2D)

# Simply supported problem with 2D trusses: 6 x 6 grid and a 2 x 2 m domain
Simply_supported2D(6,6; Lx=2.0, Ly=2.0)


```


Simply supported 2D

```julia
#      ----------------
#      |              |
#      |      Ω       |
#      |              |
#    > ----------------<
#      𝝙      ↓      𝝙
#             F

Simply_supported2D(nx::Int64,ny::Int64,etype=:truss2D;   
                   Lx=1.0, Ly=1.0, force=1.0, A=1E-4 ,Ex=1E9,
                   thickness=0.1)



```

Cantilever beam with bottom load 2D

```julia
#
#     \----------------
#     \               |
#     \       Ω       |
#     \               |
#     \----------------
#                     ↓
#                      F
#
function Cantilever_beam_bottom2D(nx::Int64,ny::Int64,etype=:truss2D;   
                                  Lx=8.0, Ly=5.0, force=1.0, A=1E-4, Ex=1E9,
                                  thickness=0.1)
                                  
```                                  

Cantilever beam with central load 2D

```julia
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
                                  thickness=0.1)
                                  
```                                  

