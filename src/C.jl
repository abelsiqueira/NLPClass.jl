module C

const alias = Dict(
    :obj            => :objective_type,
    :objective      => :objective_type,
    :objective_type => :objective_type,
    :con              => :constraints_type,
    :constraints      => :constraints_type,
    :constraints_type => :constraints_type
                  )
const valid_obj = ["none", "linear", "quadratic", "sum-of-squares", "general"]

const valid_con = ["unc", "bounds", "equality", "inequality", "general"]

end # module C

