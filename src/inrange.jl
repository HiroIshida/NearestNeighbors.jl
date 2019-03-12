check_radius(r) = r < 0 && throw(ArgumentError("the query radius r must be ≧ 0"))

"""
    inrange(tree::NNTree, points, radius [, sortres=false]) -> indices

Find all the points in the tree which is closer than `radius` to `points`. If
`sortres = true` the resulting indices are sorted.
"""
function inrange(tree::NNTree,
                 points::Vector{T},
                 radius::Number,
                 sortres=false) where {T <: AbstractVector}

    println("multi queries")
    error("under construction")
    println("1")
    check_input(tree, points)
    check_radius(radius)

    idxs = [Vector{Int}() for _ in 1:length(points)]
    dists = [Vector{Float64}() for _ in 1:length(points)]

    for i in 1:length(points)
        inrange_point!(tree, points[i], radius, sortres, idxs[i], dists[i])
    end
    return idxs
end

function inrange_point!(tree, point, radius, sortres, idx, dists)
    _inrange(tree, point, radius, idx, dists)
    if tree.reordered
        @inbounds for j in 1:length(idx)
            idx[j] = tree.indices[idx[j]]
            # note
        end
    end
    sortres && sort!(idx)
    return
end

function inrange(tree::NNTree{V}, point::AbstractVector{T}, radius::Number, sortres=false) where {V, T <: Number}
    println("single query")
    if sortres
        error("ishida: sortres case is under construction")
    end
    check_input(tree, point)
    check_radius(radius)
    idx = Int[]
    dist = Float64[]
    inrange_point!(tree, point, radius, sortres, idx, dist)
    return idx, dist
end

function inrange(tree::NNTree{V}, point::AbstractMatrix{T}, radius::Number, sortres=false) where {V, T <: Number}
    error("under construction")
    dim = size(point, 1)
    npoints = size(point, 2)
    if isbitstype(T)
        new_data = copy_svec(T, point, Val(dim))
    else
        new_data = SVector{dim,T}[SVector{dim,T}(point[:, i]) for i in 1:npoints]
    end
    inrange(tree, new_data, radius, sortres)
end
