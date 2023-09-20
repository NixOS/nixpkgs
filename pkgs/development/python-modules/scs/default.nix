{ lib
, stdenv
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
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "bodono";
    repo = "scs-python";
    rev = version;
    hash = "sha256-/5yGvZy3luGQkbYcsb/6TZLYou91lpA3UKONviMVpuM=";
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
  disabledTests = lib.lists.optional (stdenv.system == "x86_64-linux") [
    # `test/test_scs_rand.py` hang on "x86_64-linux" (https://github.com/NixOS/nixpkgs/pull/244532#pullrequestreview-1598095858)
    "test_feasible"
    "test_infeasibl"
    "test_unbounded"
  ];

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
