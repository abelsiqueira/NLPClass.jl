using Base.Test
using NLPClass
using JuMP

class = NLPClass.Class()

@NLPClassify(class, Rosenbrock,
  begin
    nvar = 2
    obj = gen
    con = unc
    open = rosen
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
  end)
function simple()
  nlp = Model()
  @variable(nlp, x[i=1:5])
  @NLobjective(nlp, Min, sum{i*(x[i] - i)^2, i = 1:5})

  return nlp
end

listProblems(class)

@assert queryProblems(class, obj="gen") == ["Rosenbrock"]
@assert queryProblems(class, obj="gen", con="unc") == ["Rosenbrock"]
@assert queryProblems(class, obj="gen", con="equ") == []
@assert sort(queryProblems(class, con="unc")) == ["Rosenbrock", "simple"]

nlp = eval(open(class, "Rosenbrock"))
println(nlp)
