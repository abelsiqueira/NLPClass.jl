export @NLPClassify, listProblems, queryProblems, open, getType

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
      v = arg.args[2]
      if isa(v, Union{Symbol,String})
        if k in [:open, :close, :model_type]
          v = string(v)
        else
          v = string(C.alias[v])
        end
      elseif isa(v, Expr)
        k = C.alias[arg.args[1]]
        if k == :open
          push!(kwargs.args, Expr(:kw, :open_args, v.args[2:end]))
          v = string(v.args[1])
        elseif k == :best_solution
          v = eval(v)
        else
          error("Unhandled Expr $v: $k is not :open")
        end
      elseif isa(v, Number)
        # Skip
      else
        error("Unhandled $v")
      end
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
      v = [string(C.alias[Symbol(v)])]
    else
      v = map(x->string(getfield(C.alias, Symbol(x))), v)
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

import Base.open
function open(class :: Class, problem :: String)
  f = Symbol(class.entries[problem].open)
  e = Expr(:call, f)
  append!(e.args, class.entries[problem].open_args)
  return e
end

import Base.get
function get(class :: Class, problem :: String, cat :: Union{String,Symbol})
  cat = isa(cat, String) ? C.alias[Symbol(cat)] : C.alias[cat]
  return getfield(class.entries[problem], cat)
end

# Do I really want camelCase?
function getType(class :: Class, problem :: String)
  return get(class, problem, :model_type)
end
