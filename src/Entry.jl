immutable Entry
  name :: String
  number_of_variables :: Int
  number_of_constraints :: Int
  objective_type :: String
  constraints_type :: String
  open :: String
  close :: String

  Entry(name;
      number_of_variables :: Int = 0,
      number_of_constraints :: Int = 0,
      objective_type :: String = "general",
      constraints_type :: String = "none",
      open :: String = "error",
      close :: String = "",
     ) = new(name, number_of_variables, number_of_constraints, objective_type,
             constraints_type, open, close)
end

import Base.show
function show(io :: IO, entry :: Entry)
  println("Problem $(entry.name)")
  println("  Number of variables: $(entry.number_of_variables)")
  println("  Objective function type: $(entry.objective_type)")
  println("  Constraints type: $(entry.constraints_type)")
end
