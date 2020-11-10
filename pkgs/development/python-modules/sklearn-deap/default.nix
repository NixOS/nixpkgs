{ stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch, numpy, scipy, deap, scikitlearn, python }:

buildPythonPackage rec {
  pname = "sklearn-deap";
  version = "0.2.3";

  # No tests in Pypi
  src = fetchFromGitHub {
    owner = "rsteca";
    repo = pname;
    rev = version;
    sha256 = "1yqnmy8h08i2y6bb2s0a5nx9cwvyg45293whqh420c195gpzg1x3";
  };

  patches = [
    # Fix for newer versions of scikit-learn. See: https://github.com/rsteca/sklearn-deap/pull/62
    (fetchpatch {
      url = "https://github.com/rsteca/sklearn-deap/commit/3ae62990fc87f36b59382e7c4db3c74cf99ec3bf.patch";
      sha256 = "1na6wf4v0dcmyz3pz8aiqkmv76d1iz3hi4iyfq9kfnycgzpv1kxk";
    })
  ];

  propagatedBuildInputs = [ numpy scipy deap scikitlearn ];

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  meta = with stdenv.lib; {
    description = "Use evolutionary algorithms instead of gridsearch in scikit-learn";
    homepage = "https://github.com/rsteca/sklearn-deap";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ psyanticy ];
  };
}

