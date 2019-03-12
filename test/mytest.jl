push!(LOAD_PATH, "../src/")
using NearestNeighbors
using StaticArrays
using LinearAlgebra

data = randn(3, 10^5)*20
k = 3
point = [randn(3), randn(3)]

kdtree = KDTree(data)
r = 10
idx, dist = inrange(kdtree, point, 1, false)

eps = 1e-3
for i = 1:length(idx)
    dist_ = norm(data[:, idx[i]] - point)
    error = abs(dist_ - dist[i])
    println(error)
end
