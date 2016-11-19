using Base.Test
using CUTEst
using JuMP
using NLPClass
using NLPModels

class = NLPClass.Class()

@NLPClassify(class, Rosenbrock,
  begin
    nvar = 2
    obj = sos
    con = unc
    open = rosen
    model_type = JuMPModel
    sol = [1.0; 1.0]
    fsol = 1.0
  end)
function rosen()
  nlp = Model()
  x0 = [-1.2; 1.0]
  @variable(nlp, x[i=1:2], start=x0[i])
  @NLobjective(nlp, Min, 1.0 + (x[1] - 1.0)^2 + 100.0 * (x[2] - x[1]^2)^2)

  return nlp
end

@NLPClassify(class, simple,
  begin
    nvar = 5
    obj = quadratic
    con = unc
    open = simple
    model_type = JuMPModel
    sol = collect(1.0:5)
  end)
function simple()
  nlp = Model()
  @variable(nlp, x[i=1:5])
  @NLobjective(nlp, Min, sum{i*(x[i] - i)^2, i = 1:5})

  return nlp
end

@NLPClassify(class, nlpexample,
  begin
    nvar = 2
    obj = linear
    con = equ
    open = nlpexample
    model_type = AbstractNLPModel
  end
)
function nlpexample()
  return ADNLPModel(x->x[1]+x[2], zeros(2), c=x->[x[1]^2 + x[2]^2 - 1], lcon=[0.0],
               ucon=[0.0])
end

@NLPClassify(class, ROSENBR,
  begin
    nvar = 2
    obj = sos
    con = unc
    open = CUTEstModel("ROSENBR")
    model_type = AbstractNLPModel
  end
)
# ROSENBR is defined at CUTEst

@NLPClassify(class, HS7,
  begin
    nvar = 2
    ncon = 1
    obj = gen
    con = equ
    open = CUTEstModel("HS7")
    model_type = AbstractNLPModel
  end
)
# HS7 is defined at CUTEst

listProblems(class)

@assert sort(queryProblems(class, obj="sos")) == ["ROSENBR", "Rosenbrock"]
@assert sort(queryProblems(class, obj="sos", con="unc")) == ["ROSENBR", "Rosenbrock"]
@assert queryProblems(class, obj="gen", con="equ") == ["HS7"]
@assert sort(queryProblems(class, con="unc")) == ["ROSENBR", "Rosenbrock", "simple"]

for problem in keys(class.entries)
  println("Opening problem $problem")
  t = getType(class, problem)
  nlp = eval(open(class, problem))
  if t == "JuMPModel"
    nlp = MathProgNLPModel(eval(open(class, problem)))
  elseif t != "AbstractNLPModel"
    error("Unexpected type $t")
  end
  println("  x0 = $(nlp.meta.x0)")
  println("  f(x0) = $(obj(nlp, nlp.meta.x0))")
  sol = get(class, problem, :sol)
  if sol != []
    println("  sol = $sol")
  end
  fbest = get(class, problem, :fbest)
  if fbest == Inf && sol != []
    fbest = obj(nlp, sol)
  end
  if fbest < Inf
    println("  fbest = $fbest")
  end
  finalize(nlp)
end
