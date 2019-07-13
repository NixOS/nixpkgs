{ stdenv, buildPythonPackage, fetchFromGitHub, numpy, scipy, deap, scikitlearn, python, isPy3k }:

buildPythonPackage rec {
  pname = "sklearn-deap";
  version = "0.2.2";

  # No tests in Pypi
  src = fetchFromGitHub {
    owner = "rsteca";
    repo = pname;
    rev = "${version}";
    sha256 = "01ynmzxg181xhv2d7bs53zjvk9x2qpxix32sspq54mpigxh13ava";
  };

  propagatedBuildInputs = [ numpy scipy deap scikitlearn ];

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  meta = with stdenv.lib; {
    description = "Use evolutionary algorithms instead of gridsearch in scikit-learn";
    homepage = https://github.com/rsteca/sklearn-deap;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ psyanticy ];
    broken = isPy3k; # https://github.com/rsteca/sklearn-deap/issues/65
  };
}

