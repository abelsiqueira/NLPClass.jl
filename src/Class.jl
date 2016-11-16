export @NLPClassify, listProblems, queryProblems

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
  p = string(problem)
  entry = eval(Expr(:call, Entry, kwargs, p))
  esc(:($class.entries[$p] = $entry) )
end

function listProblems(class :: Class)
  for key in keys(class.entries)
    show(class.entries[key])
  end
end

function queryProblems(class :: Class; kwargs...)
  pairs = []
  for (k,v) in kwargs
    kk = C.alias[k]
    if isa(v, Union{String,Symbol})
      v = [v]
    end
    push!(pairs, (kk,v))
  end

  problems = String[]
  for (p,entry) in class.entries
    select = true
    for (k,v) in pairs
      if !(getfield(entry, k) in v)
        select = false
        break
      end
    end
    select && push!(problems, p)
  end

  return problems
end

