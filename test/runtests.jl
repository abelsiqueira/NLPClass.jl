using Base.Test
using NLPClass
using JuMP
using NLPModels

class = NLPClass.Class()

@NLPClassify(class, Rosenbrock,
  begin
    nvar = 2
    obj = gen
    con = unc
    open = rosen
    model_type = JuMPModel
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

listProblems(class)

@assert queryProblems(class, obj="gen") == ["Rosenbrock"]
@assert queryProblems(class, obj="gen", con="unc") == ["Rosenbrock"]
@assert queryProblems(class, obj="gen", con="equ") == []
@assert sort(queryProblems(class, con="unc")) == ["Rosenbrock", "simple"]

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
end
