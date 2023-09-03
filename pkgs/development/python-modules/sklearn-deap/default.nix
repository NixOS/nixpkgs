{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch, numpy, scipy, deap, scikit-learn, python }:

buildPythonPackage rec {
  pname = "sklearn-deap";
  version = "0.3.0";

  # No tests in Pypi
  src = fetchFromGitHub {
    owner = "rsteca";
    repo = pname;
    rev = version;
    hash = "sha256-bXBHlv1pIOyDLKCBeffyHaTZ7gNiZNl0soa73e8E4/M=";
  };

  patches = [
    # Fix for scikit-learn v1.1. See: https://github.com/rsteca/sklearn-deap/pull/80
    (fetchpatch {
      url = "https://github.com/rsteca/sklearn-deap/commit/3b84bd905796378dd845f99e083da17284c9ff6f.patch";
      hash = "sha256-YYLw0uzecyIbdNAy/CxxWDV67zJbZZhUMypnDm/zNGs=";
    })
    (fetchpatch {
      url = "https://github.com/rsteca/sklearn-deap/commit/2f60e215c834f60966b4e51df25e91939a72b952.patch";
      hash = "sha256-vn5nLPwwkjsQrp3q7C7Z230lkgRiyJN0TQxO8Apizg8=";
    })
  ];

  propagatedBuildInputs = [ numpy scipy deap scikit-learn ];

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  meta = with lib; {
    description = "Use evolutionary algorithms instead of gridsearch in scikit-learn";
    homepage = "https://github.com/rsteca/sklearn-deap";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ psyanticy ];
  };
}

