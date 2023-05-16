<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, deap
, numpy
, scikit-learn
, scipy
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "sklearn-deap";
  version = "0.3.0";
  format = "setuptools";
=======
{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch, numpy, scipy, deap, scikit-learn, python }:

buildPythonPackage rec {
  pname = "sklearn-deap";
  version = "0.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # No tests in Pypi
  src = fetchFromGitHub {
    owner = "rsteca";
<<<<<<< HEAD
    repo = "sklearn-deap";
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
=======
    repo = pname;
    rev = version;
    sha256 = "1yqnmy8h08i2y6bb2s0a5nx9cwvyg45293whqh420c195gpzg1x3";
  };

  patches = [
    # Fix for scikit-learn v0.21.1. See: https://github.com/rsteca/sklearn-deap/pull/62
    (fetchpatch {
      url = "https://github.com/rsteca/sklearn-deap/commit/3ae62990fc87f36b59382e7c4db3c74cf99ec3bf.patch";
      sha256 = "1na6wf4v0dcmyz3pz8aiqkmv76d1iz3hi4iyfq9kfnycgzpv1kxk";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    })
  ];

  propagatedBuildInputs = [ numpy scipy deap scikit-learn ];

<<<<<<< HEAD
  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "evolutionary_search" ];
=======
  checkPhase = ''
    ${python.interpreter} test.py
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Use evolutionary algorithms instead of gridsearch in scikit-learn";
    homepage = "https://github.com/rsteca/sklearn-deap";
<<<<<<< HEAD
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
=======
    license = licenses.lgpl3;
    maintainers = with maintainers; [ psyanticy ];
    # broken by scikit-learn 0.24.1
    broken = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

