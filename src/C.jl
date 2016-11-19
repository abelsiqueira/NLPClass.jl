module C

const alias = Dict(
    # General purpose
    :gen => :general,
    :general => :general,
    :none => :none,
    # Attributes
    :obj            => :objective_type,
    :objective      => :objective_type,
    :objective_type => :objective_type,
    :con              => :constraints_type,
    :constraints      => :constraints_type,
    :constraints_type => :constraints_type,
    :n                   => :number_of_variables,
    :nvar                => :number_of_variables,
    :nvariables          => :number_of_variables,
    :number_of_variables => :number_of_variables,
    :m                     => :number_of_constraints,
    :ncon                  => :number_of_constraints,
    :nconstraints          => :number_of_constraints,
    :number_of_constraints => :number_of_constraints,
    :open => :open,
    :close => :close,
    :ptype => :model_type,
    :problem_type => :model_type,
    :mtype => :model_type,
    :model_type => :model_type,
    :sol => :best_solution,
    :solution => :best_solution,
    :best_solution => :best_solution,
    :fsol => :best_fsol,
    :fbest => :best_fsol,
    :best_fsol => :best_fsol,
    # Values
    ## Objective
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

const valid_obj = ["none", "linear", "quadratic", "sum_of_squares", "general"]

const valid_con = ["unconstrained", "bounds", "equality", "inequality", "general"]

end # module C

