module C

const alias = Dict(
    # General
    :gen => :general,
    :general => :general,
    # Attributes
    :obj            => :objective_type,
    :objective      => :objective_type,
    :objective_type => :objective_type,
    :con              => :constraints_type,
    :constraints      => :constraints_type,
    :constraints_type => :constraints_type,
    # Values
    ## Objective
    :none => :none,
    :lin => :linear,
    :linear => :linear,
    :quad => :quadratic,
    :quadratic => :quadratic,
    :sos => :sum_of_squares,
    :sum_of_squares => :sum_of_squares,
    ## Constraints
    :unc => :unconstrained,
    :unconstrained => :unconstrained,
    :free => :unconstrained,
    :bounds => :bounds,
    :equ => :equality,
    :equality => :equality,
    :ineq => :inequality,
    :inequality => :inequality
    )

const valid_obj = ["none", "linear", "quadratic", "sum-of-squares", "general"]

const valid_con = ["unconstrained", "bounds", "equality", "inequality", "general"]

end # module C

