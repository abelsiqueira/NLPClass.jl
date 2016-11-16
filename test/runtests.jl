using Base.Test
using NLPClass

class = NLPClass.Class()

@NLPClassify(class, rosen,
  begin
    nvar = 2
    obj = gen
    con = unc
  end)

@NLPClassify(class, simple,
  begin
    nvar = 5
    obj = quadratic
    con = unc
  end)

listProblems(class)

@assert queryProblems(class, obj="gen") == ["rosen"]
@assert queryProblems(class, obj="gen", con="unc") == ["rosen"]
@assert queryProblems(class, obj="gen", con="equ") == []
@assert sort(queryProblems(class, con="unc")) == ["rosen", "simple"]
