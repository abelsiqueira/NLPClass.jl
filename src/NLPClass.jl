module NLPClass

export @NLPClassify, listProblems

using Base.Meta

module C

const alias = Dict(
    :obj            => :objective_type,
    :objective      => :objective_type,
    :objective_type => :objective_type,
    :con              => :constraints_type,
    :constraints      => :constraints_type,
    :constraints_type => :constraints_type
                  )

end # module C

immutable Entry
  objective_type :: String
  constraints_type :: String

  Entry(;
      objective_type :: String = "general",
      constraints_type :: String = "none"
     ) = new(objective_type, constraints_type)
end

"""Class

Class provides a classification of Nonlinear Programming
problems that can be used in any Julia repository of problems.
"""
type Class
  reference :: Dict{String,String}
  entries   :: Dict{String,Entry}

  Class() = new(Dict{String, String}(), Dict{String, Entry}())
end

macro NLPClassify(class, problem, block)
  attribution = []
  kwargs = Expr(:parameters)
  for arg in block.args
    if isexpr(arg, :line)
      # Skip
    elseif isexpr(arg, :(=))
      k = C.alias[arg.args[1]]
      v = string(arg.args[2])
      push!(kwargs.args, Expr(:kw, k, v))
    else
      error("Argument not handled: $arg")
    end
  end
  entry = eval(Expr(:call, Entry, kwargs))

  p = string(problem)
  esc(:($class.entries[$p] = $entry) )
end

function listProblems(class :: Class)
  for key in keys(class.entries)
    println("Problem $key:")
    println(class.entries[key])
  end
end

end
