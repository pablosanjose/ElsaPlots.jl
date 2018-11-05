function plot(bm::BrillouinMesh{T,2}; resolution = (1024, 1024), kw...) where {T}
    scene = Scene(resolution = resolution)
    cam3d!(scene)

    plot = plot!(scene, bm)

    return plot

end

function default_theme(scene::SceneLike, ::Type{<: Plot(BrillouinMesh)})
    Theme(
        wireframe = 0
        )
end

function AbstractPlotting.plot!(plot::Plot(BrillouinMesh))
    bm = to_value(plot[1])
    
    # for i in eachindex(bm.elements.indices)
    #     e = bm.elements.indices[i]
    #     sites = [Point3D(s) + Point3D(SVector(0,0,0.1*i)) for s in bm.mesh.sublats[1].sites]
    #     mesh!(plot, sites, [e[j] for j in 1:3], color = :white, strokewidth = 8)
    # end
    mesh!(plot, Point3D.(bm.mesh.sublats[1].sites), [e[j] for e in bm.elements.indices, j in 1:3], color = :white, strokewidth = 8)
    plot!(plot, bm.mesh)

    sites = bm.mesh.sublats[1].sites
    centers = [padright((sites[e[1]]+ sites[e[2]] + sites[e[3]])/3, Val(3)) for e in bm.elements.indices]
    normals = [cross(padright(sites[e[2]] - sites[e[1]], Val(3)), 
                     padright(sites[e[3]] - sites[e[1]], Val(3))) for e in bm.elements.indices]
    segments = [Point3D(c) => Point3D(c + 1 * n) for (c,n) in zip(centers, normals)]
    linesegments!(plot, segments, color = :blue, strokewidth = 8)

    return plot
 end



function plot(bs::Bandstructure{T,3,2,6}; resolution = (1024, 1024), kw...) where {T}
    scene = Scene(resolution = resolution)
    cam3d!(scene)

    plot = plot!(scene, bs)

    return plot

end

function default_theme(scene::SceneLike, ::Type{<: Plot(Bandstructure)})
    Theme(
        wireframe = 0
        )
end

function AbstractPlotting.plot!(plot::Plot(Bandstructure))
    bs = to_value(plot[1])
    
    sites = Point3D.(bs.mesh.lattice.sublats[1].sites)
    mesh!(plot, sites, [e[j] for e in bs.mesh.elements.intra, j in 1:3], color = :white, strokewidth = 8)
    plot!(plot, bs.mesh.lattice)

    # sites = bs.mesh.sublats[1].sites
    # centers = [(sites[e[1]]+ sites[e[2]] + sites[e[3]])/3 for e in bs.elements.indices]
    # normals = [cross(sites[e[2]] - sites[e[1]], sites[e[3]] - sites[e[1]]) for e in bs.elements.indices]
    # segments = [Point3D(c) => Point3D(c + 100 * n) for (c,n) in zip(centers, normals)]
    # linesegments!(plot, segments, color = :blue, strokewidth = 8)

    return plot
 end