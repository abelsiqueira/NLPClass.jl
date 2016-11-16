immutable Entry
  name :: String
  objective_type :: String
  constraints_type :: String

  Entry(name;
      objective_type :: String = "general",
      constraints_type :: String = "none"
     ) = new(name, objective_type, constraints_type)
end

import Base.show
function show(io :: IO, entry :: Entry)
  println("Problem $(entry.name)")
  println("  Objective function type: $(entry.objective_type)")
  println("  Constraints type: $(entry.constraints_type)")
end
