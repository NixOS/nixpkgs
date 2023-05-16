{ lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildPythonPackage
, fetchFromGitHub
, blas
, lapack
, numpy
, scipy
  # check inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scs";
<<<<<<< HEAD
  version = "3.2.3";
=======
  version = "3.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bodono";
    repo = "scs-python";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-/5yGvZy3luGQkbYcsb/6TZLYou91lpA3UKONviMVpuM=";
=======
    hash = "sha256-7OgqCo21S0FDev8xv6/8iGFXg8naVi93zd8v1f9iaWw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  buildInputs = [
    lapack
    blas
  ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "scs" ];
<<<<<<< HEAD
  disabledTests = lib.lists.optional (stdenv.system == "x86_64-linux") [
    # `test/test_scs_rand.py` hang on "x86_64-linux" (https://github.com/NixOS/nixpkgs/pull/244532#pullrequestreview-1598095858)
    "test_feasible"
    "test_infeasibl"
    "test_unbounded"
  ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python interface for SCS: Splitting Conic Solver";
    longDescription = ''
      Solves convex cone programs via operator splitting.
      Can solve: linear programs (LPs), second-order cone programs (SOCPs), semidefinite programs (SDPs),
      exponential cone programs (ECPs), and power cone programs (PCPs), or problems with any combination of those cones.
    '';
    homepage = "https://github.com/cvxgrp/scs"; # upstream C package
    downloadPage = "https://github.com/bodono/scs-python";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
