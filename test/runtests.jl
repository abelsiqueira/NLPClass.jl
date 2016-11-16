using Base.Test
using NLPClass

class = NLPClass.Class()

@NLPClassify(class, rosen,
  begin
    obj = gen
    con = unc
  end)

@NLPClassify(class, simple,
  begin
    obj = quadratic
    con = unc
  end)

listProblems(class)

@assert queryProblems(class, obj="gen") == ["rosen"]
@assert queryProblems(class, obj="gen", con="unc") == ["rosen"]
@assert queryProblems(class, obj="gen", con="equ") == []
@assert sort(queryProblems(class, con="unc")) == ["rosen", "simple"]
