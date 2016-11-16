using NLPClass

class = NLPClass.Class()

@NLPClassify(class, rosen,
  begin
    obj = gen
    con = unc
  end)

listProblems(class)
