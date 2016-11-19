immutable Entry
  name :: String
  number_of_variables :: Int
  number_of_constraints :: Int
  objective_type :: String
  constraints_type :: String
  open :: Union{String,Expr}
  open_args :: Array
  close :: String
  model_type :: String
  best_solution :: Vector
  best_fsol :: Real
end

function Entry(name;
      number_of_variables :: Int = 0,
      number_of_constraints :: Int = 0,
      objective_type :: String = "general",
      constraints_type :: String = "none",
      open :: Union{String,Expr} = "error",
      open_args :: Array = [],
      close :: String = "",
      model_type :: String = "Any",
      best_solution :: Vector = [],
      best_fsol :: Real = Inf,
     )

  if best_fsol == Inf && best_solution != []
    println("Warning: best_solution given, but best_fsol not given.")
    println("  Please submit best_fsol too")
  end

  return Entry(name, number_of_variables, number_of_constraints, objective_type,
             constraints_type, open, open_args, close, model_type,
             best_solution, best_fsol)
end

import Base.show
function show(io :: IO, entry :: Entry)
  println("Problem $(entry.name)")
  if entry.model_type != "Any"
    println("  Type: $(entry.model_type)")
  end
  println("  Number of variables: $(entry.number_of_variables)")
  if entry.number_of_constraints > 0
    println("  Number of constraints: $(entry.number_of_constraints)")
  end
  println("  Objective function type: $(entry.objective_type)")
  println("  Constraints type: $(entry.constraints_type)")
  if entry.best_fsol < Inf
    println("  Best known objective value: $(entry.best_fsol)")
  end
end
